// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract FeeCollector is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    mapping(address => bool) public approvedMarkets;
    uint256 public totalCollected;

    event MarketApproved(address indexed market);
    event FeeReceived(address indexed from, uint256 amount);

    constructor(address _token, address owner) Ownable(owner) {
        token = IERC20(_token);
    }

    function approveMarket(address market) external onlyOwner {
        approvedMarkets[market] = true;
        emit MarketApproved(market);
    }

    function collectFrom(address from, uint256 amount) external {
        require(approvedMarkets[msg.sender], "Not approved market");
        token.safeTransferFrom(from, address(this), amount);
        totalCollected += amount;
        emit FeeReceived(from, amount);
    }

    function withdraw(address to, uint256 amount) external onlyOwner {
        token.safeTransfer(to, amount);
    }
}
