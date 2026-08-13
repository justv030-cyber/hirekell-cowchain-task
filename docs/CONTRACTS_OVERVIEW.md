# Contracts Overview

## Core (Candidate Tasks)

| Contract | File | Status |
|----------|------|--------|
| BettingMarket | `contracts/BettingMarket.sol` | Partial — 3 TODOs |
| Treasury | `contracts/Treasury.sol` | Partial — 1 TODO |
| OddsMath | `contracts/libraries/OddsMath.sol` | Partial — 1 TODO |

## Supporting (Complete)

| Contract | File | Role |
|----------|------|------|
| BettingFactory | `contracts/BettingFactory.sol` | Market deployer |
| SportsOracle | `contracts/SportsOracle.sol` | Result reporter |
| MarketRegistry | `contracts/MarketRegistry.sol` | Event index |
| ProtocolConfig | `contracts/config/ProtocolConfig.sol` | Min/max bet, pause |
| ResolverRegistry | `contracts/governance/ResolverRegistry.sol` | League resolvers |
| BetValidator | `contracts/modules/BetValidator.sol` | Bet validation helper |
| MarketViews | `contracts/modules/MarketViews.sol` | Read-only analytics |
| FeeCollector | `contracts/modules/FeeCollector.sol` | Alternative fee sink |
| BettingToken | `contracts/tokens/BettingToken.sol` | Production-style token |
| MockUSDC | `contracts/mocks/MockUSDC.sol` | Test token |

## Libraries

| Library | Purpose |
|---------|---------|
| BetTypes | Outcome constants (0/1/2) |
| OddsMath | Parimutuel payout math |
| FeeConfig | Fee calculation helpers |
| TimeUtils | Lock/resolve time checks |
| ValidationLib | Amount and outcome validation |
| MarketIds | Deterministic ID generation |
| PayoutCalculator | Combined payout + fee |

## Interfaces

Located in `contracts/interfaces/` — do not modify function signatures.
