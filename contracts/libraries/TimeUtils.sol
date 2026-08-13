// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library TimeUtils {
    error InvalidTimeWindow();
    error BettingNotYetClosed();
    error TooEarlyToResolve();

    function validateMarketTimes(uint256 lockTime, uint256 resolveTime) internal view {
        if (lockTime <= block.timestamp) revert InvalidTimeWindow();
        if (resolveTime <= lockTime) revert InvalidTimeWindow();
    }

    function isBettingOpen(uint256 lockTime) internal view returns (bool) {
        return block.timestamp < lockTime;
    }

    function requirePastLock(uint256 lockTime) internal view {
        if (block.timestamp < lockTime) revert BettingNotYetClosed();
    }

    function requirePastResolve(uint256 resolveTime) internal view {
        if (block.timestamp < resolveTime) revert TooEarlyToResolve();
    }
}
