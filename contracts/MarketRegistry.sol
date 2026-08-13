// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title MarketRegistry
 * @notice On-chain index of active sports events grouped by sport category.
 */
contract MarketRegistry {
    enum SportCategory {
        Football,
        Basketball,
        Tennis,
        MMA,
        Other
    }

    struct EventRecord {
        address market;
        SportCategory category;
        string league;
        uint256 createdAt;
        bool active;
    }

    mapping(bytes32 => EventRecord) public events;
    mapping(SportCategory => bytes32[]) private _eventsByCategory;
    bytes32[] private _allEventIds;

    event EventRegistered(bytes32 indexed eventId, address market, SportCategory category, string league);
    event EventDeactivated(bytes32 indexed eventId);

    function registerEvent(
        bytes32 eventId,
        address market,
        SportCategory category,
        string calldata league
    ) external {
        require(events[eventId].market == address(0), "Already registered");
        require(market != address(0), "Invalid market");

        events[eventId] = EventRecord({
            market: market,
            category: category,
            league: league,
            createdAt: block.timestamp,
            active: true
        });

        _eventsByCategory[category].push(eventId);
        _allEventIds.push(eventId);

        emit EventRegistered(eventId, market, category, league);
    }

    function deactivateEvent(bytes32 eventId) external {
        require(events[eventId].active, "Not active");
        events[eventId].active = false;
        emit EventDeactivated(eventId);
    }

    function getEventsByCategory(SportCategory category) external view returns (bytes32[] memory) {
        return _eventsByCategory[category];
    }

    function getAllEventIds() external view returns (bytes32[] memory) {
        return _allEventIds;
    }

    function getEventCount() external view returns (uint256) {
        return _allEventIds.length;
    }
}
