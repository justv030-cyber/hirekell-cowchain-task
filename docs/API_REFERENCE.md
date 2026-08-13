# API Reference — Core Contracts

## BettingFactory

| Function | Description |
|----------|-------------|
| `createMarket(...)` | Deploy new market for a sports event |
| `getMarket(marketId)` | Lookup market address by ID |
| `getAllMarkets()` | List all market addresses |
| `getMarketCount()` | Total markets created |
| `setResolver(address)` | Update resolver (owner only) |

## BettingMarket

| Function | Description |
|----------|-------------|
| `placeBet(outcome, amount)` | **TODO** — Place wager |
| `lockMarket()` | Close betting (resolver) |
| `resolveMarket(outcome)` | **TODO** — Set winner (resolver) |
| `claimWinnings()` | **TODO** — Claim payout |
| `cancelMarket(reason)` | Void market (resolver) |
| `getMarketInfo()` | Event details and status |
| `getBet(betId)` | Bet struct by ID |
| `getOutcomePool(outcome)` | Pool size per outcome |
| `calculatePayout(betId)` | Preview net payout |

## Treasury

| Function | Description |
|----------|-------------|
| `collectFee(amount)` | **TODO** — Receive protocol fee |
| `withdrawFees(to, amount)` | Owner withdraws fees |
| `setFeeRate(bps)` | Update fee (max 10%) |
| `getFeeRate()` | Current fee in basis points |

## SportsOracle

| Function | Description |
|----------|-------------|
| `reportResult(marketId, outcome)` | Submit match result |
| `getResult(marketId)` | Read reported result |
| `addReporter(address)` | Grant reporter role |

## MarketRegistry

| Function | Description |
|----------|-------------|
| `registerEvent(...)` | Index market by sport/league |
| `deactivateEvent(eventId)` | Mark event inactive |
| `getEventsByCategory(cat)` | Filter by sport |
