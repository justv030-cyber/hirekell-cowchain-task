# Cowchain — Blockchain Developer Home Task

## SportsBet Protocol

Welcome to the Cowchain technical assessment. You will complete a **parimutuel sports betting protocol** on Ethereum-compatible chains.

**Estimated time:** 3–5 hours  
**Difficulty:** Intermediate (slightly on the easier side)  
**Stack:** Solidity 0.8.24 · Hardhat · TypeScript · OpenZeppelin

---

## Background

Cowchain is building decentralized infrastructure for on-chain sports wagering. This exercise mirrors a simplified version of our internal betting market contracts.

You receive a **partially implemented codebase**. Your job is to finish the core betting logic so that all tests pass.

---

## Getting Started

```bash
npm install
npm run compile
npm test
```

Most tests will **fail initially** — that is expected. Your goal is to make them pass.

---

## Your Tasks

Complete the `TODO` sections in these files:

| # | File | What to implement |
|---|------|-------------------|
| 1 | `contracts/libraries/OddsMath.sol` | `calculatePayout()` — parimutuel math |
| 2 | `contracts/BettingMarket.sol` | `placeBet()` — accept wagers |
| 3 | `contracts/BettingMarket.sol` | `resolveMarket()` — finalize outcome |
| 4 | `contracts/BettingMarket.sol` | `claimWinnings()` — distribute payouts |
| 5 | `contracts/Treasury.sol` | `collectFee()` — fee collection with access control |

Read the inline comments in each file for detailed requirements.

### Bonus (optional)

- Add a `refundBets()` function to `BettingMarket` for cancelled markets
- Write an additional test for a three-outcome scenario with unequal pools
- Gas-optimize `claimWinnings` for bettors with many bets

---

## Domain Overview

### Market lifecycle

```
Open → Locked → Resolved
              ↘ Cancelled
```

1. **Open** — Bettors place wagers on Home Win (0), Draw (1), or Away Win (2)
2. **Locked** — Betting closes at `lockTime` (set by resolver)
3. **Resolved** — Resolver sets `winningOutcome` after `resolveTime`
4. **Cancelled** — Market voided; refunds expected (bonus task)

### Payout model (parimutuel)

Winners share the total pool proportionally:

```
payout = (betAmount × totalPool) / winningOutcomePool
netPayout = payout - protocolFee
```

### Actors

| Role | Description |
|------|-------------|
| Factory | Deploys new markets per sports event |
| Resolver | Locks and resolves markets (trusted role) |
| Bettor | Places bets and claims winnings |
| Treasury | Collects protocol fees (2.5% default) |

---

## Project Structure

```
contracts/
  interfaces/         # 9 interface files
  libraries/          # 7 library files
  mocks/              # Test doubles
  modules/            # BetValidator, MarketViews, FeeCollector
  config/             # ProtocolConfig
  governance/         # ResolverRegistry
  tokens/             # BettingToken
  abstracts/          # Authorized base
  errors/             # ProtocolErrors
  test-helpers/       # Library test wrappers
  BettingMarket.sol   # ← main work (3 TODOs)
  Treasury.sol        # ← main work (1 TODO)
  BettingFactory.sol
  SportsOracle.sol
  MarketRegistry.sol
test/
  unit/               # Library & component tests
  integration/        # End-to-end flows
  helpers/            # Fixtures, builders, formatters
  fixtures/           # JSON market imports
  BettingMarket.test.ts
  BettingFactory.test.ts
  Treasury.test.ts
  MarketRegistry.test.ts
scripts/
  utils/              # Deploy helpers, config loader
  config/             # default.json, local.json
  deployments/        # Saved deployment addresses
  deploy.ts, deploy-all.ts, seed-*.ts, place-bet.ts, ...
data/
  markets/            # football, basketball, tennis, mma
  teams/              # Team & player reference data
  leagues.json
tasks/                # Hardhat CLI tasks
docs/                 # 15+ documentation files
```

---

## Submission

1. Fork or clone this repository into a **private** repo
2. Complete the TODO items
3. Ensure `npm test` passes
4. Write a brief `SOLUTION.md` explaining:
   - Your approach to each TODO
   - Any trade-offs or assumptions
   - What you would improve with more time
5. Share the repo link with your Cowchain recruiter

**Do not publish your solution publicly.**

---

## Rules

- You may use OpenZeppelin, Hardhat, and standard Solidity patterns
- Do **not** change test files (unless adding bonus tests)
- Do **not** modify function signatures in interfaces
- Do **not** use AI tools (ChatGPT, Copilot, Cursor, Claude, etc.) — this is an individual assessment of your own skills
- Ask clarifying questions via your recruiter if blocked

Good luck!
