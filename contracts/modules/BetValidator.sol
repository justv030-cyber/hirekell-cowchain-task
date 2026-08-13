// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IProtocolConfig} from "../interfaces/IProtocolConfig.sol";
import {IBetValidator} from "../interfaces/IBetValidator.sol";
import {ValidationLib} from "../libraries/ValidationLib.sol";
import {TimeUtils} from "../libraries/TimeUtils.sol";

contract BetValidator is IBetValidator {
    IProtocolConfig public immutable config;

    constructor(address _config) {
        config = IProtocolConfig(_config);
    }

    function validateBet(uint8 outcome, uint256 amount, uint256 lockTime) external view {
        if (config.paused()) revert("Protocol paused");
        ValidationLib.validateOutcome(outcome);
        ValidationLib.validateBetAmount(amount, config.minBet(), config.maxBet());
        if (!TimeUtils.isBettingOpen(lockTime)) revert("Betting closed");
    }

    function minBetAmount() external view returns (uint256) {
        return config.minBet();
    }

    function maxBetAmount() external view returns (uint256) {
        return config.maxBet();
    }
}
