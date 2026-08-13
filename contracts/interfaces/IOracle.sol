// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title IOracle
 * @notice Interface for sports result oracle.
 */
interface IOracle {
    struct Result {
        uint8 winningOutcome;
        bool reported;
        uint256 reportedAt;
    }

    event ResultReported(bytes32 indexed marketId, uint8 winningOutcome);
    event OracleUpdated(address indexed newOracle);

    function reportResult(bytes32 marketId, uint8 winningOutcome) external;
    function getResult(bytes32 marketId) external view returns (Result memory);
    function isAuthorized(address reporter) external view returns (bool);
}
