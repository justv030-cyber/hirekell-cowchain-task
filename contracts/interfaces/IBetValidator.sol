// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IBetValidator {
    function validateBet(uint8 outcome, uint256 amount, uint256 lockTime) external view;
    function minBetAmount() external view returns (uint256);
    function maxBetAmount() external view returns (uint256);
}
