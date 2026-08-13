// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title IBettingMarket
 * @notice Interface for a single sports event betting market.
 */
interface IBettingMarket {
    enum MarketStatus {
        Open,
        Locked,
        Resolved,
        Cancelled
    }

    struct MarketInfo {
        string eventName;
        string homeTeam;
        string awayTeam;
        uint256 lockTime;
        uint256 resolveTime;
        MarketStatus status;
        uint8 winningOutcome;
        uint256 totalPool;
    }

    struct Bet {
        address bettor;
        uint8 outcome;
        uint256 amount;
        bool claimed;
    }

    event BetPlaced(address indexed bettor, uint8 outcome, uint256 amount);
    event MarketLocked(uint256 lockTime);
    event MarketResolved(uint8 winningOutcome, uint256 totalPool);
    event WinningsClaimed(address indexed bettor, uint256 payout);
    event MarketCancelled(string reason);

    function placeBet(uint8 outcome, uint256 amount) external;
    function lockMarket() external;
    function resolveMarket(uint8 winningOutcome) external;
    function claimWinnings() external;
    function cancelMarket(string calldata reason) external;

    function getMarketInfo() external view returns (MarketInfo memory);
    function getBet(uint256 betId) external view returns (Bet memory);
    function getOutcomePool(uint8 outcome) external view returns (uint256);
    function getBetCount() external view returns (uint256);
    function calculatePayout(uint256 betId) external view returns (uint256);
}
