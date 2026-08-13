// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IResolverRegistry {
    event ResolverAdded(address indexed resolver, string league);
    event ResolverRemoved(address indexed resolver, string league);

    function addResolver(address resolver, string calldata league) external;
    function removeResolver(address resolver, string calldata league) external;
    function isResolverForLeague(address resolver, string calldata league) external view returns (bool);
    function getResolvers(string calldata league) external view returns (address[] memory);
}
