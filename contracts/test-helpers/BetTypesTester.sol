// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BetTypes} from "../libraries/BetTypes.sol";

contract BetTypesTester {
    function validateOutcome(uint8 outcome) external pure {
        BetTypes.validateOutcome(outcome);
    }
}
