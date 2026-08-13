// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ITreasury} from "./interfaces/ITreasury.sol";

/**
 * @title Treasury
 * @notice Collects protocol fees from resolved betting markets.
 */
contract Treasury is ITreasury, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable bettingToken;
    uint256 public feeRateBps;
    uint256 public totalCollected;

    uint256 public constant MAX_FEE_BPS = 1000; // 10% cap

    constructor(address token, uint256 initialFeeRateBps, address owner) Ownable(owner) {
        require(initialFeeRateBps <= MAX_FEE_BPS, "Fee too high");
        bettingToken = IERC20(token);
        feeRateBps = initialFeeRateBps;
    }

    /// @inheritdoc ITreasury
    function collectFee(uint256 amount) external {
        // TODO: Implement fee collection
        // Requirements:
        //   - Only callable by the owner OR an approved collector (use a simple mapping)
        //   - Transfer `amount` of bettingToken from msg.sender to this contract
        //   - Increment totalCollected
        //   - Emit FeeCollected event
        //
        // Hint: Add `mapping(address => bool) public approvedCollectors` and an
        //       `approveCollector(address)` function callable by owner.

        revert("Not implemented");
    }

    /// @inheritdoc ITreasury
    function withdrawFees(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Zero address");
        bettingToken.safeTransfer(to, amount);
        emit FeeWithdrawn(to, amount);
    }

    /// @inheritdoc ITreasury
    function setFeeRate(uint256 newRateBps) external onlyOwner {
        require(newRateBps <= MAX_FEE_BPS, "Fee too high");
        uint256 oldRate = feeRateBps;
        feeRateBps = newRateBps;
        emit FeeRateUpdated(oldRate, newRateBps);
    }

    /// @inheritdoc ITreasury
    function getFeeRate() external view returns (uint256) {
        return feeRateBps;
    }

    /// @inheritdoc ITreasury
    function getBalance() external view returns (uint256) {
        return bettingToken.balanceOf(address(this));
    }
}
