// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OddsMath} from "./OddsMath.sol";
import {FeeConfig} from "./FeeConfig.sol";

library PayoutCalculator {
    function grossPayout(
        uint256 betAmount,
        uint256 totalPool,
        uint256 winningPool
    ) internal pure returns (uint256) {
        return OddsMath.calculatePayout(betAmount, totalPool, winningPool);
    }

    function netPayout(
        uint256 betAmount,
        uint256 totalPool,
        uint256 winningPool,
        uint256 feeBps
    ) internal pure returns (uint256 net, uint256 fee) {
        uint256 gross = grossPayout(betAmount, totalPool, winningPool);
        (net, fee) = FeeConfig.netAfterFee(gross, feeBps);
    }
}
