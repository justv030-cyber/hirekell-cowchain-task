# Events Reference

Quick reference for all protocol events. Useful when building indexers or debugging.

## IBettingMarket

```solidity
event BetPlaced(address indexed bettor, uint8 outcome, uint256 amount);
event MarketLocked(uint256 lockTime);
event MarketResolved(uint8 winningOutcome, uint256 totalPool);
event WinningsClaimed(address indexed bettor, uint256 payout);
event MarketCancelled(string reason);
```

## IBettingFactory

```solidity
event MarketCreated(
    address indexed market,
    bytes32 indexed marketId,
    string eventName,
    address creator
);
```

## ITreasury

```solidity
event FeeCollected(address indexed from, uint256 amount);
event FeeWithdrawn(address indexed to, uint256 amount);
event FeeRateUpdated(uint256 oldRate, uint256 newRate);
```

## IOracle

```solidity
event ResultReported(bytes32 indexed marketId, uint8 winningOutcome);
event OracleUpdated(address indexed newOracle);
```

## MarketRegistry

```solidity
event EventRegistered(bytes32 indexed eventId, address market, SportCategory category, string league);
event EventDeactivated(bytes32 indexed eventId);
```

## Indexing Tips

1. Subscribe to `MarketCreated` on Factory to discover new markets
2. Track `BetPlaced` per market address for live odds display
3. On `MarketResolved`, prompt users to claim
4. Aggregate `FeeCollected` on Treasury for protocol revenue dashboards
