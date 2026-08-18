// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title OddsMath
 * @notice Fixed-point math utilities for parimutuel payout calculations.
 * @dev Uses 1e18 precision for ratios.
 */
library OddsMath {
    uint256 internal constant PRECISION = 1e18;

    error DivisionByZero();
    error InsufficientPool();

    /**
     * @dev Calculates parimutuel payout for a winning bet.
     * Formula: payout = (betAmount * totalPool) / winningOutcomePool
     *
     * @param betAmount Amount wagered on the winning outcome
     * @param totalPool Total amount across all outcomes
     * @param winningPool Total amount on the winning outcome
     * @return payout Gross payout before fees
     */
    function calculatePayout(
        uint256 betAmount,
        uint256 totalPool,
        uint256 winningPool
    ) internal pure returns (uint256 payout) {
        if (winningPool == 0) revert DivisionByZero();
        if (betAmount > winningPool) revert InsufficientPool();

        payout = (betAmount * totalPool) / winningPool;
    }

    /**
     * @dev Applies protocol fee to a gross payout.
     * @param grossPayout Payout before fee deduction
     * @param feeRateBps Fee rate in basis points (100 = 1%)
     * @return netPayout Payout after fee
     * @return feeAmount Fee amount deducted
     */
    function applyFee(
        uint256 grossPayout,
        uint256 feeRateBps
    ) internal pure returns (uint256 netPayout, uint256 feeAmount) {
        feeAmount = (grossPayout * feeRateBps) / 10_000;
        netPayout = grossPayout - feeAmount;
    }

    /**
     * @dev Returns implied decimal odds for display (off-chain reference).
     * @param outcomePool Pool size for a specific outcome
     * @param totalPool Total pool across all outcomes
     * @return odds Implied odds with 1e18 precision (e.g. 2e18 = 2.0x)
     */
    function impliedOdds(
        uint256 outcomePool,
        uint256 totalPool
    ) internal pure returns (uint256 odds) {
        if (outcomePool == 0) return 0;
        odds = (totalPool * PRECISION) / outcomePool;
    }
}
