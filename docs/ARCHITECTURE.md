# Architecture — SportsBet Protocol

## System Diagram

```
┌─────────────┐     creates      ┌──────────────────┐
│ BettingFactory │ ──────────────▶ │  BettingMarket   │
└─────────────┘                   │  (per event)     │
       │                          └────────┬─────────┘
       │                                   │
       │                          places bets / claims
       │                                   │
       ▼                                   ▼
┌─────────────┐     fees          ┌──────────────────┐
│ MarketRegistry│                │     Bettor       │
└─────────────┘                   └──────────────────┘
                                           │
                                    USDC transfers
                                           │
                                           ▼
                                  ┌──────────────────┐
                                  │     Treasury     │
                                  └──────────────────┘

┌─────────────┐     reports       ┌──────────────────┐
│ SportsOracle │ ───────────────▶ │  Off-chain index │
└─────────────┘                   └──────────────────┘
```

## Contract Responsibilities

### BettingFactory
- Singleton deployer for market contracts
- Stores resolver address and shared config (token, treasury)
- Emits `MarketCreated` for indexing

### BettingMarket
- One instance per sports event
- Holds USDC escrow for all bets on that event
- Parimutuel pool: three outcomes (Home / Draw / Away)
- Resolver-controlled lifecycle (lock → resolve)

### Treasury
- Protocol fee sink (default 2.5%)
- Fee applied at claim time, not at bet time
- Owner can withdraw accumulated fees

### SportsOracle
- AccessControl-based result reporter
- Separate from market resolution in this exercise
- Provided as reference implementation

### MarketRegistry
- Optional index by sport category
- Not required for core task completion
- Used in deployment scripts for demo data

## Data Flow — Happy Path

1. Factory deploys `BettingMarket` for "Man United vs Liverpool"
2. Bettor A approves USDC and calls `placeBet(0, 200e6)` — Home Win
3. Bettor B calls `placeBet(2, 100e6)` — Away Win
4. Resolver calls `lockMarket()` after kickoff
5. Resolver calls `resolveMarket(0)` after final whistle — Home wins
6. Bettor A calls `claimWinnings()` — receives proportional share minus fee
7. Treasury receives fee via `collectFee()`

## Security Considerations

| Risk | Mitigation |
|------|------------|
| Reentrancy on claim | `nonReentrant` modifier |
| Unauthorized resolution | `onlyResolver` modifier |
| Double claim | `claimed` flag per bet |
| Fee manipulation | Fee rate capped at 10% |
| Token bugs | SafeERC20 wrappers |

## Out of Scope (for this task)

- Chainlink oracle integration
- Liquidity pools / AMM odds
- Cross-chain bridges
- Upgradeable proxies
- Frontend dApp
