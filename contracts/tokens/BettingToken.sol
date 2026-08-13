// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IBettingToken} from "../interfaces/IBettingToken.sol";

contract BettingToken is IBettingToken, ERC20, Ownable {
    uint8 private constant _DECIMALS = 6;

    constructor(address owner) ERC20("Cowchain Betting USDC", "cbUSDC") Ownable(owner) {
        _mint(owner, 10_000_000 * 10 ** _DECIMALS);
    }

    function decimals() public pure override(ERC20, IBettingToken) returns (uint8) {
        return _DECIMALS;
    }

    function mint(address to, uint256 amount) external override onlyOwner {
        _mint(to, amount);
    }
}
