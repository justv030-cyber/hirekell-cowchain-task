// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title IBettingFactory
 * @notice Interface for creating and managing betting markets.
 */
interface IBettingFactory {
    event MarketCreated(
        address indexed market,
        bytes32 indexed marketId,
        string eventName,
        address creator
    );

    function createMarket(
        string calldata eventName,
        string calldata homeTeam,
        string calldata awayTeam,
        uint256 lockTime,
        uint256 resolveTime
    ) external returns (address market, bytes32 marketId);

    function getMarket(bytes32 marketId) external view returns (address);
    function getAllMarkets() external view returns (address[] memory);
    function getMarketCount() external view returns (uint256);
    function isMarket(address market) external view returns (bool);
}
