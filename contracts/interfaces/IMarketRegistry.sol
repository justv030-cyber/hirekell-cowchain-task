// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MarketRegistry} from "../MarketRegistry.sol";

interface IMarketRegistry {
    event EventRegistered(bytes32 indexed eventId, address market, MarketRegistry.SportCategory category, string league);
    event EventDeactivated(bytes32 indexed eventId);

    function registerEvent(
        bytes32 eventId,
        address market,
        MarketRegistry.SportCategory category,
        string calldata league
    ) external;

    function deactivateEvent(bytes32 eventId) external;
    function getEventsByCategory(MarketRegistry.SportCategory category) external view returns (bytes32[] memory);
    function getAllEventIds() external view returns (bytes32[] memory);
    function getEventCount() external view returns (uint256);
}
