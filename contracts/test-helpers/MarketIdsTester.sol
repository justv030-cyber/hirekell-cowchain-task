// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MarketIds} from "../libraries/MarketIds.sol";

contract MarketIdsTester {
    function computeMarketId(
        string calldata eventName,
        string calldata homeTeam,
        string calldata awayTeam,
        uint256 lockTime,
        uint256 nonce
    ) external pure returns (bytes32) {
        return MarketIds.computeMarketId(eventName, homeTeam, awayTeam, lockTime, nonce);
    }
}
