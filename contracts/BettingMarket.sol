// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IBettingMarket} from "./interfaces/IBettingMarket.sol";
import {ITreasury} from "./interfaces/ITreasury.sol";
import {BetTypes} from "./libraries/BetTypes.sol";
import {OddsMath} from "./libraries/OddsMath.sol";

/**
 * @title BettingMarket
 * @notice Parimutuel betting market for a single sports event (Home / Draw / Away).
 */
contract BettingMarket is IBettingMarket, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using BetTypes for uint8;

    IERC20 public immutable bettingToken;
    ITreasury public immutable treasury;

    MarketInfo public marketInfo;
    bytes32 public marketId;

    uint256[] private _betIds;
    mapping(uint256 => Bet) private _bets;
    mapping(uint8 => uint256) private _outcomePools;
    mapping(address => uint256[]) private _bettorBetIds;

    address public factory;
    address public resolver;

    error MarketNotOpen();
    error MarketAlreadyLocked();
    error MarketNotResolved();
    error MarketAlreadyResolved();
    error BettingClosed();
    error InvalidAmount();
    error NotAuthorized();
    error AlreadyClaimed();
    error NotWinner();
    error MarketNotCancelled();
    error NoRefundAvailable();
    error BetNotFound();
    error InvalidOutcome(uint8 outcome);

    modifier onlyFactory() {
        if (msg.sender != factory) revert NotAuthorized();
        _;
    }

    modifier onlyResolver() {
        if (msg.sender != resolver) revert NotAuthorized();
        _;
    }

    constructor(
        address _bettingToken,
        address _treasury,
        address _resolver,
        string memory eventName,
        string memory homeTeam,
        string memory awayTeam,
        uint256 lockTime,
        uint256 resolveTime,
        bytes32 _marketId
    ) {
        bettingToken = IERC20(_bettingToken);
        treasury = ITreasury(_treasury);
        resolver = _resolver;
        marketId = _marketId;

        marketInfo = MarketInfo({
            eventName: eventName,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            lockTime: lockTime,
            resolveTime: resolveTime,
            status: MarketStatus.Open,
            winningOutcome: 0,
            totalPool: 0
        });
    }

    function initialize(address _factory) external {
        require(factory == address(0), "Already initialized");
        factory = _factory;
    }

    /// @inheritdoc IBettingMarket
    function placeBet(uint8 outcome, uint256 amount) external nonReentrant {
        if (marketInfo.status != MarketStatus.Open) revert MarketNotOpen();
        if (block.timestamp >= marketInfo.lockTime) revert BettingClosed();
        if (amount == 0) revert InvalidAmount();
        if (outcome >= BetTypes.MAX_OUTCOMES) revert InvalidOutcome(outcome);

        bettingToken.safeTransferFrom(msg.sender, address(this), amount);

        uint256 betId = _betIds.length;
        _bets[betId] = Bet({
            bettor: msg.sender,
            outcome: outcome,
            amount: amount,
            claimed: false
        });
        _betIds.push(betId);
        _outcomePools[outcome] += amount;
        marketInfo.totalPool += amount;
        _bettorBetIds[msg.sender].push(betId);

        emit BetPlaced(msg.sender, outcome, amount);
    }

    /// @inheritdoc IBettingMarket
    function lockMarket() external onlyResolver {
        if (marketInfo.status != MarketStatus.Open) revert MarketNotOpen();
        if (block.timestamp < marketInfo.lockTime) revert BettingClosed();

        marketInfo.status = MarketStatus.Locked;
        emit MarketLocked(marketInfo.lockTime);
    }

    /// @inheritdoc IBettingMarket
    function resolveMarket(uint8 winningOutcome) external onlyResolver nonReentrant {
        if (marketInfo.status == MarketStatus.Open) {
            if (block.timestamp < marketInfo.lockTime) revert BettingClosed();
            marketInfo.status = MarketStatus.Locked;
            emit MarketLocked(marketInfo.lockTime);
        }
        if (marketInfo.status != MarketStatus.Locked) revert MarketNotOpen();
        if (block.timestamp < marketInfo.resolveTime) revert BettingClosed();
        if (winningOutcome >= BetTypes.MAX_OUTCOMES) revert InvalidOutcome(winningOutcome);

        marketInfo.status = MarketStatus.Resolved;
        marketInfo.winningOutcome = winningOutcome;

        emit MarketResolved(winningOutcome, marketInfo.totalPool);
    }

    /// @inheritdoc IBettingMarket
    function claimWinnings() external nonReentrant {
        if (marketInfo.status != MarketStatus.Resolved) revert MarketNotResolved();

        uint256 totalPayout;
        uint256 totalFee;
        bool hasWinningBet;
        bool hasUnclaimedWinningBet;
        uint256[] storage bettorBetIds = _bettorBetIds[msg.sender];
        uint256 betIdsLength = bettorBetIds.length;
        uint8 winningOutcome = marketInfo.winningOutcome;
        uint256 totalPool = marketInfo.totalPool;
        uint256 winningPool = _outcomePools[winningOutcome];
        uint256 feeRateBps = treasury.getFeeRate();

        for (uint256 i; i < betIdsLength; ) {
            Bet storage bet = _bets[bettorBetIds[i]];
            if (bet.outcome == winningOutcome) {
                hasWinningBet = true;
                if (!bet.claimed) {
                    hasUnclaimedWinningBet = true;
                    uint256 grossPayout = OddsMath.calculatePayout(
                        bet.amount,
                        totalPool,
                        winningPool
                    );
                    (uint256 netPayout, uint256 feeAmount) = OddsMath.applyFee(grossPayout, feeRateBps);

                    bet.claimed = true;
                    totalPayout += netPayout;
                    totalFee += feeAmount;
                }
            }

            unchecked {
                ++i;
            }
        }

        if (!hasWinningBet) revert NotWinner();
        if (!hasUnclaimedWinningBet) revert AlreadyClaimed();

        bettingToken.safeTransfer(msg.sender, totalPayout);
        if (totalFee > 0) {
            bettingToken.forceApprove(address(treasury), totalFee);
            treasury.collectFee(totalFee);
        }

        emit WinningsClaimed(msg.sender, totalPayout);
    }

    /// @inheritdoc IBettingMarket
    function cancelMarket(string calldata reason) external onlyResolver {
        if (marketInfo.status == MarketStatus.Resolved) revert MarketAlreadyResolved();
        marketInfo.status = MarketStatus.Cancelled;
        emit MarketCancelled(reason);
    }

    /// @inheritdoc IBettingMarket
    function refundBets() external nonReentrant {
        if (marketInfo.status != MarketStatus.Cancelled) revert MarketNotCancelled();

        uint256 totalRefund;
        uint256[] storage bettorBetIds = _bettorBetIds[msg.sender];
        for (uint256 i; i < bettorBetIds.length; ++i) {
            Bet storage bet = _bets[bettorBetIds[i]];
            if (bet.claimed) continue;

            bet.claimed = true;
            totalRefund += bet.amount;
        }

        if (totalRefund == 0) revert NoRefundAvailable();

        bettingToken.safeTransfer(msg.sender, totalRefund);
        emit BetsRefunded(msg.sender, totalRefund);
    }

    /// @inheritdoc IBettingMarket
    function getMarketInfo() external view returns (MarketInfo memory) {
        return marketInfo;
    }

    /// @inheritdoc IBettingMarket
    function getBet(uint256 betId) external view returns (Bet memory) {
        if (betId >= _betIds.length) revert BetNotFound();
        return _bets[betId];
    }

    /// @inheritdoc IBettingMarket
    function getOutcomePool(uint8 outcome) external view returns (uint256) {
        return _outcomePools[outcome];
    }

    /// @inheritdoc IBettingMarket
    function getBetCount() external view returns (uint256) {
        return _betIds.length;
    }

    /// @inheritdoc IBettingMarket
    function calculatePayout(uint256 betId) external view returns (uint256) {
        if (marketInfo.status != MarketStatus.Resolved) revert MarketNotResolved();
        Bet memory bet = _bets[betId];
        if (bet.outcome != marketInfo.winningOutcome) return 0;

        uint256 gross = OddsMath.calculatePayout(
            bet.amount,
            marketInfo.totalPool,
            _outcomePools[marketInfo.winningOutcome]
        );

        (uint256 net, ) = OddsMath.applyFee(gross, treasury.getFeeRate());
        return net;
    }

    function getBettorBets(address bettor) external view returns (uint256[] memory) {
        return _bettorBetIds[bettor];
    }
}
