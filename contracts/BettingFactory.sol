// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IBettingFactory} from "./interfaces/IBettingFactory.sol";
import {IBettingMarket} from "./interfaces/IBettingMarket.sol";
import {BettingMarket} from "./BettingMarket.sol";

/**
 * @title BettingFactory
 * @notice Deploys and indexes BettingMarket instances for sports events.
 */
contract BettingFactory is IBettingFactory, Ownable {
    address public immutable bettingToken;
    address public immutable treasury;
    address public resolver;

    address[] private _markets;
    mapping(bytes32 => address) private _marketById;
    mapping(address => bool) private _isMarket;

    event ResolverUpdated(address indexed oldResolver, address indexed newResolver);

    constructor(address _bettingToken, address _treasury, address _resolver, address owner) Ownable(owner) {
        bettingToken = _bettingToken;
        treasury = _treasury;
        resolver = _resolver;
    }

    /// @inheritdoc IBettingFactory
    function createMarket(
        string calldata eventName,
        string calldata homeTeam,
        string calldata awayTeam,
        uint256 lockTime,
        uint256 resolveTime
    ) external returns (address market, bytes32 marketId) {
        require(lockTime > block.timestamp, "Lock time must be future");
        require(resolveTime > lockTime, "Resolve after lock");

        marketId = keccak256(abi.encodePacked(eventName, homeTeam, awayTeam, lockTime, _markets.length));

        BettingMarket newMarket = new BettingMarket(
            bettingToken,
            treasury,
            resolver,
            eventName,
            homeTeam,
            awayTeam,
            lockTime,
            resolveTime,
            marketId
        );

        market = address(newMarket);
        newMarket.initialize(address(this));

        _markets.push(market);
        _marketById[marketId] = market;
        _isMarket[market] = true;

        emit MarketCreated(market, marketId, eventName, msg.sender);
    }

    /// @inheritdoc IBettingFactory
    function getMarket(bytes32 marketId) external view returns (address) {
        return _marketById[marketId];
    }

    /// @inheritdoc IBettingFactory
    function getAllMarkets() external view returns (address[] memory) {
        return _markets;
    }

    /// @inheritdoc IBettingFactory
    function getMarketCount() external view returns (uint256) {
        return _markets.length;
    }

    /// @inheritdoc IBettingFactory
    function isMarket(address market) external view returns (bool) {
        return _isMarket[market];
    }

    function setResolver(address newResolver) external onlyOwner {
        address old = resolver;
        resolver = newResolver;
        emit ResolverUpdated(old, newResolver);
    }
}
