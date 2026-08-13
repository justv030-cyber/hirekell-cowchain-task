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
        // TODO: Implement bet placement
        // Requirements:
        //   1. Market must be Open and block.timestamp < lockTime
        //   2. amount > 0
        //   3. outcome must be valid — revert InvalidOutcome if outcome >= 3
        //   4. Transfer `amount` of bettingToken from msg.sender to this contract
        //   5. Create a new Bet struct and store it
        //   6. Update _outcomePools[outcome] and marketInfo.totalPool
        //   7. Track bet in _bettorBetIds[msg.sender]
        //   8. Emit BetPlaced event
        //
        // Hint: Use _betIds.length as the new bet ID before pushing.

        revert("Not implemented");
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
        // TODO: Implement market resolution
        // Requirements:
        //   1. Market must be Locked (or Open past lockTime — auto-lock allowed)
        //   2. block.timestamp >= resolveTime
        //   3. winningOutcome must be valid
        //   4. Set marketInfo.status to Resolved, winningOutcome, emit event
        //
        // If market is still Open but past lockTime, transition to Locked first.

        revert("Not implemented");
    }

    /// @inheritdoc IBettingMarket
    function claimWinnings() external nonReentrant {
        // TODO: Implement winnings claim
        // Requirements:
        //   1. Market must be Resolved
        //   2. Iterate over msg.sender's bets in _bettorBetIds
        //   3. For each unclaimed bet on the winning outcome:
        //      a. Calculate gross payout via OddsMath.calculatePayout
        //      b. Apply fee via OddsMath.applyFee using treasury.getFeeRate()
        //      c. Transfer net payout to msg.sender
        //      d. Call treasury.collectFee(feeAmount) — approve first if needed
        //      e. Mark bet as claimed
        //   4. Emit WinningsClaimed for total payout
        //
        // Hint: A bettor may have multiple winning bets — sum them up.

        revert("Not implemented");
    }

    /// @inheritdoc IBettingMarket
    function cancelMarket(string calldata reason) external onlyResolver {
        if (marketInfo.status == MarketStatus.Resolved) revert MarketAlreadyResolved();
        marketInfo.status = MarketStatus.Cancelled;
        emit MarketCancelled(reason);
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
