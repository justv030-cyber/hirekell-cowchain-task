# Getting Started

## Prerequisites

- Node.js 18+
- npm 8+
- Basic Solidity and Hardhat familiarity

## Setup

```bash
npm install
npm run compile
npm test
```

## Project Layout

| Directory | Purpose |
|-----------|---------|
| `contracts/` | Solidity source (your TODOs are here) |
| `test/` | Hardhat test suites |
| `scripts/` | Deployment and interaction scripts |
| `data/` | Sample sports events (JSON) |
| `docs/` | Specifications and guides |
| `tasks/` | Hardhat CLI tasks |

## First Steps

1. Read `README.md` and `docs/SPEC.md`
2. Open `contracts/libraries/OddsMath.sol` — start with the simplest TODO
3. Run `npx hardhat test test/unit/OddsMath.test.ts` after each change
4. Work through remaining TODOs in `BettingMarket.sol` and `Treasury.sol`
5. Run full suite: `npm test`

## Useful Commands

```bash
npx hardhat test test/BettingMarket.test.ts   # single file
npx hardhat accounts                          # list test accounts
npm run deploy:all                            # full local deploy
```
