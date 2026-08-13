// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OddsMath} from "../libraries/OddsMath.sol";

/**
 * @title OddsMathTester
 * @notice Thin wrapper to test OddsMath library functions in Hardhat.
 */
contract OddsMathTester {
    function calculatePayout(
        uint256 betAmount,
        uint256 totalPool,
        uint256 winningPool
    ) external pure returns (uint256) {
        return OddsMath.calculatePayout(betAmount, totalPool, winningPool);
    }

    function applyFee(
        uint256 grossPayout,
        uint256 feeRateBps
    ) external pure returns (uint256 netPayout, uint256 feeAmount) {
        return OddsMath.applyFee(grossPayout, feeRateBps);
    }

    function impliedOdds(
        uint256 outcomePool,
        uint256 totalPool
    ) external pure returns (uint256) {
        return OddsMath.impliedOdds(outcomePool, totalPool);
    }
}
