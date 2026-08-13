// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IOracle} from "../interfaces/IOracle.sol";

/**
 * @title MockOracle
 * @notice Simplified oracle for unit testing without AccessControl.
 */
contract MockOracle is IOracle {
    mapping(bytes32 => Result) private _results;
    mapping(address => bool) private _authorized;

    constructor(address admin) {
        _authorized[admin] = true;
    }

    function reportResult(bytes32 marketId, uint8 winningOutcome) external {
        require(_authorized[msg.sender], "Not authorized");
        require(!_results[marketId].reported, "Already reported");

        _results[marketId] = Result({
            winningOutcome: winningOutcome,
            reported: true,
            reportedAt: block.timestamp
        });

        emit ResultReported(marketId, winningOutcome);
    }

    function getResult(bytes32 marketId) external view returns (Result memory) {
        return _results[marketId];
    }

    function isAuthorized(address reporter) external view returns (bool) {
        return _authorized[reporter];
    }

    function setAuthorized(address reporter, bool status) external {
        _authorized[reporter] = true;
        if (!status) delete _authorized[reporter];
    }
}
