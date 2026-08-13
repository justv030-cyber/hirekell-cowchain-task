# Technical Specification — SportsBet Protocol

## Token

- **Betting token:** MockUSDC (6 decimals) in tests; represents USDC in production
- All amounts are in token base units (e.g. `100 USDC = 100_000_000`)

## Outcomes

| Index | Label | Description |
|-------|-------|-------------|
| 0 | Home Win | Home team wins |
| 1 | Draw | Match ends in tie |
| 2 | Away Win | Away team wins |

## Market Parameters

| Field | Type | Description |
|-------|------|-------------|
| eventName | string | Display name, e.g. "Premier League — Matchday 12" |
| homeTeam | string | Home side name |
| awayTeam | string | Away side name |
| lockTime | uint256 | Unix timestamp — betting closes |
| resolveTime | uint256 | Unix timestamp — earliest resolution allowed |

**Constraint:** `resolveTime > lockTime > block.timestamp` at creation.

## Market Status Enum

```solidity
enum MarketStatus { Open, Locked, Resolved, Cancelled }
```

| Status | Value | Betting allowed | Claims allowed |
|--------|-------|-----------------|----------------|
| Open | 0 | Yes (before lockTime) | No |
| Locked | 1 | No | No |
| Resolved | 2 | No | Yes (winners) |
| Cancelled | 3 | No | Refund (bonus) |

## Bet Struct

```solidity
struct Bet {
    address bettor;
    uint8 outcome;
    uint256 amount;
    bool claimed;
}
```

## Payout Formula

Given:
- `betAmount` — user's wager on the winning outcome
- `totalPool` — sum of all bets across all outcomes
- `winningPool` — sum of bets on the winning outcome
- `feeRateBps` — protocol fee in basis points

```
grossPayout = (betAmount × totalPool) / winningPool
feeAmount   = (grossPayout × feeRateBps) / 10_000
netPayout   = grossPayout - feeAmount
```

### Worked Example

| Bettor | Outcome | Amount |
|--------|---------|--------|
| Alice | Home (0) | 200 USDC |
| Bob | Away (2) | 100 USDC |

- Total pool: 300 USDC
- Winning outcome: Home (0)
- Winning pool: 200 USDC
- Alice gross: `(200 × 300) / 200 = 300 USDC`
- Fee (2.5%): `7.5 USDC`
- Alice net: `292.5 USDC`

## Access Control

| Function | Caller |
|----------|--------|
| createMarket | Anyone |
| placeBet | Anyone (Open market) |
| lockMarket | Resolver |
| resolveMarket | Resolver |
| cancelMarket | Resolver |
| claimWinnings | Bet owner |
| collectFee | Owner or approved collector |
| setFeeRate | Treasury owner |

## Events (indexing)

All state changes emit events per interface definitions. Indexers should track:
- `MarketCreated` → new market address
- `BetPlaced` → pool size updates
- `MarketResolved` → enable claim UI
- `WinningsClaimed` → user history

## Error Handling

Prefer custom errors (gas-efficient) where the starter code uses them. For new checks, either custom errors or require strings are acceptable.

## Constants

| Constant | Value |
|----------|-------|
| MAX_FEE_BPS | 1000 (10%) |
| Default fee | 250 (2.5%) |
| MAX_OUTCOMES | 3 |
