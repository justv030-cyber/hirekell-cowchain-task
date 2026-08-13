// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ITreasury} from "../interfaces/ITreasury.sol";

contract MockTreasury is ITreasury {
    uint256 public feeRateBps;
    uint256 public totalCollected;
    uint256 public balance;

    constructor(uint256 _feeRateBps) {
        feeRateBps = _feeRateBps;
    }

    function collectFee(uint256 amount) external {
        totalCollected += amount;
        balance += amount;
        emit FeeCollected(msg.sender, amount);
    }

    function withdrawFees(address to, uint256 amount) external {
        balance -= amount;
        emit FeeWithdrawn(to, amount);
    }

    function setFeeRate(uint256 newRateBps) external {
        uint256 old = feeRateBps;
        feeRateBps = newRateBps;
        emit FeeRateUpdated(old, newRateBps);
    }

    function getFeeRate() external view returns (uint256) {
        return feeRateBps;
    }

    function getBalance() external view returns (uint256) {
        return balance;
    }
}
