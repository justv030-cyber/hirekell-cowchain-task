// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IProtocolConfig {
    event MinBetUpdated(uint256 oldMin, uint256 newMin);
    event MaxBetUpdated(uint256 oldMax, uint256 newMax);
    event ProtocolPaused();
    event ProtocolUnpaused();

    function minBet() external view returns (uint256);
    function maxBet() external view returns (uint256);
    function paused() external view returns (bool);
    function setMinBet(uint256 amount) external;
    function setMaxBet(uint256 amount) external;
    function pause() external;
    function unpause() external;
}
