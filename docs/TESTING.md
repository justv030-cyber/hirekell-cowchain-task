# Testing Guide

## Test Structure

```
test/
  unit/           # Library and component tests
  integration/    # Multi-contract flows
  helpers/        # Shared fixtures and builders
  fixtures/       # JSON market data imports
  BettingMarket.test.ts   # Main task tests (must pass)
  BettingFactory.test.ts
  Treasury.test.ts
  MarketRegistry.test.ts
```

## Running Tests

```bash
npm test                              # all tests
npx hardhat test test/unit/           # unit only
npx hardhat test test/integration/    # integration only
npm run test:coverage                 # coverage report
```

## Expected Initial State

Before completing TODOs:
- Unit tests for **OddsMath** fail (candidate task #1)
- **BettingMarket** and **Treasury** tests fail (tasks #2–5)
- Factory, registry, config tests pass

After completing all TODOs: **all tests pass**.

## Writing Bonus Tests

Place additional tests in `test/` with descriptive names. Do not modify existing assertions.

## Fixtures

Use `deployProtocol()` from `test/helpers/fixtures.ts` for standard setup:
- Deployed USDC, Treasury, Factory, Oracle
- Funded bettor accounts
- Resolver account for lock/resolve
