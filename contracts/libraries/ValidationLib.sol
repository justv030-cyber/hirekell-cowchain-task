// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BetTypes} from "./BetTypes.sol";

library ValidationLib {
    using BetTypes for uint8;

    error ZeroAmount();
    error AmountBelowMinimum(uint256 amount, uint256 minBet);
    error AmountAboveMaximum(uint256 amount, uint256 maxBet);

    function validateBetAmount(uint256 amount, uint256 minBet, uint256 maxBet) internal pure {
        if (amount == 0) revert ZeroAmount();
        if (amount < minBet) revert AmountBelowMinimum(amount, minBet);
        if (maxBet > 0 && amount > maxBet) revert AmountAboveMaximum(amount, maxBet);
    }

    function validateOutcome(uint8 outcome) internal pure {
        outcome.validateOutcome();
    }
}
