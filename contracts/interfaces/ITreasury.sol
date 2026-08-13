// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ITreasury
 * @notice Interface for protocol fee collection and distribution.
 */
interface ITreasury {
    event FeeCollected(address indexed from, uint256 amount);
    event FeeWithdrawn(address indexed to, uint256 amount);
    event FeeRateUpdated(uint256 oldRate, uint256 newRate);

    function collectFee(uint256 amount) external;
    function withdrawFees(address to, uint256 amount) external;
    function setFeeRate(uint256 newRateBps) external;
    function getFeeRate() external view returns (uint256);
    function getBalance() external view returns (uint256);
}
