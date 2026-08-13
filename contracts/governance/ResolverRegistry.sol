// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IResolverRegistry} from "../interfaces/IResolverRegistry.sol";

contract ResolverRegistry is IResolverRegistry, Ownable {
    mapping(string => address[]) private _resolversByLeague;
    mapping(address => mapping(string => bool)) private _isResolver;

    constructor(address owner) Ownable(owner) {}

    function addResolver(address resolver, string calldata league) external onlyOwner {
        require(resolver != address(0), "Zero address");
        if (!_isResolver[resolver][league]) {
            _resolversByLeague[league].push(resolver);
            _isResolver[resolver][league] = true;
            emit ResolverAdded(resolver, league);
        }
    }

    function removeResolver(address resolver, string calldata league) external onlyOwner {
        if (_isResolver[resolver][league]) {
            _isResolver[resolver][league] = false;
            emit ResolverRemoved(resolver, league);
        }
    }

    function isResolverForLeague(address resolver, string calldata league) external view returns (bool) {
        return _isResolver[resolver][league];
    }

    function getResolvers(string calldata league) external view returns (address[] memory) {
        return _resolversByLeague[league];
    }
}
