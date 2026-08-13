// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IProtocolConfig} from "../interfaces/IProtocolConfig.sol";

contract ProtocolConfig is IProtocolConfig, Ownable {
    uint256 public minBet;
    uint256 public maxBet;
    bool public paused;

    constructor(uint256 _minBet, uint256 _maxBet, address owner) Ownable(owner) {
        minBet = _minBet;
        maxBet = _maxBet;
    }

    function setMinBet(uint256 amount) external onlyOwner {
        uint256 old = minBet;
        minBet = amount;
        emit MinBetUpdated(old, amount);
    }

    function setMaxBet(uint256 amount) external onlyOwner {
        uint256 old = maxBet;
        maxBet = amount;
        emit MaxBetUpdated(old, amount);
    }

    function pause() external onlyOwner {
        paused = true;
        emit ProtocolPaused();
    }

    function unpause() external onlyOwner {
        paused = false;
        emit ProtocolUnpaused();
    }
}
