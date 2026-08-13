// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library FeeConfig {
    uint256 internal constant BPS_DENOMINATOR = 10_000;
    uint256 internal constant MAX_FEE_BPS = 1000;

    error FeeTooHigh(uint256 feeBps);

    function validateFeeRate(uint256 feeBps) internal pure {
        if (feeBps > MAX_FEE_BPS) revert FeeTooHigh(feeBps);
    }

    function computeFee(uint256 amount, uint256 feeBps) internal pure returns (uint256) {
        return (amount * feeBps) / BPS_DENOMINATOR;
    }

    function netAfterFee(uint256 gross, uint256 feeBps) internal pure returns (uint256 net, uint256 fee) {
        fee = computeFee(gross, feeBps);
        net = gross - fee;
    }
}
