// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library MarketIds {
    function computeMarketId(
        string memory eventName,
        string memory homeTeam,
        string memory awayTeam,
        uint256 lockTime,
        uint256 nonce
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(eventName, homeTeam, awayTeam, lockTime, nonce));
    }

    function computeEventId(bytes32 marketId, string memory league) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(marketId, league));
    }
}
