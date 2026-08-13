// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {IOracle} from "./interfaces/IOracle.sol";

/**
 * @title SportsOracle
 * @notice Authorized reporters submit final match results for betting markets.
 */
contract SportsOracle is IOracle, AccessControl {
    bytes32 public constant REPORTER_ROLE = keccak256("REPORTER_ROLE");

    mapping(bytes32 => Result) private _results;

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(REPORTER_ROLE, admin);
    }

    /// @inheritdoc IOracle
    function reportResult(bytes32 marketId, uint8 winningOutcome) external onlyRole(REPORTER_ROLE) {
        require(!_results[marketId].reported, "Already reported");
        require(winningOutcome < 3, "Invalid outcome");

        _results[marketId] = Result({
            winningOutcome: winningOutcome,
            reported: true,
            reportedAt: block.timestamp
        });

        emit ResultReported(marketId, winningOutcome);
    }

    /// @inheritdoc IOracle
    function getResult(bytes32 marketId) external view returns (Result memory) {
        return _results[marketId];
    }

    /// @inheritdoc IOracle
    function isAuthorized(address reporter) external view returns (bool) {
        return hasRole(REPORTER_ROLE, reporter);
    }

    function addReporter(address reporter) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(REPORTER_ROLE, reporter);
    }

    function removeReporter(address reporter) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(REPORTER_ROLE, reporter);
    }
}
