// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {FeeConfig} from "../libraries/FeeConfig.sol";

contract FeeConfigTester {
    function computeFee(uint256 amount, uint256 feeBps) external pure returns (uint256) {
        return FeeConfig.computeFee(amount, feeBps);
    }

    function validateFeeRate(uint256 feeBps) external pure {
        FeeConfig.validateFeeRate(feeBps);
    }
}
