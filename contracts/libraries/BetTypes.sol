// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title BetTypes
 * @notice Constants and helpers for sports betting outcome types.
 */
library BetTypes {
    uint8 public constant OUTCOME_HOME_WIN = 0;
    uint8 public constant OUTCOME_DRAW = 1;
    uint8 public constant OUTCOME_AWAY_WIN = 2;
    uint8 public constant MAX_OUTCOMES = 3;

    error InvalidOutcome(uint8 outcome);

    /**
     * @dev Validates that an outcome index is within the allowed range.
     */
    function validateOutcome(uint8 outcome) internal pure {
        if (outcome >= MAX_OUTCOMES) {
            revert InvalidOutcome(outcome);
        }
    }

    /**
     * @dev Returns a human-readable label for an outcome (off-chain reference).
     */
    function outcomeLabel(uint8 outcome) internal pure returns (string memory) {
        if (outcome == OUTCOME_HOME_WIN) return "Home Win";
        if (outcome == OUTCOME_DRAW) return "Draw";
        if (outcome == OUTCOME_AWAY_WIN) return "Away Win";
        return "Unknown";
    }
}
