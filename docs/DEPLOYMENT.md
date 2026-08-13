# Deployment Guide

## Local Hardhat Network

Terminal 1 — start node:
```bash
npx hardhat node
```

Terminal 2 — deploy:
```bash
npm run deploy:all
```

Deployment addresses are saved to `scripts/deployments/latest.json`.

## Seed Sample Markets

From JSON data files:
```bash
FACTORY_ADDRESS=0x... npm run seed:json -- football
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `FACTORY_ADDRESS` | BettingFactory contract |
| `USDC_ADDRESS` | MockUSDC token |
| `MARKET_ADDRESS` | Single market for bet/claim scripts |
| `OUTCOME` | 0=Home, 1=Draw, 2=Away |
| `AMOUNT` | Bet amount in USDC |
| `WINNING_OUTCOME` | Outcome index for resolution |

## Interaction Scripts

```bash
MARKET_ADDRESS=0x... OUTCOME=0 AMOUNT=100 npx hardhat run scripts/place-bet.ts
MARKET_ADDRESS=0x... WINNING_OUTCOME=0 npx hardhat run scripts/resolve-market.ts
MARKET_ADDRESS=0x... npx hardhat run scripts/claim-winnings.ts
```

## Verify Deployment

```bash
npx hardhat run scripts/verify-deployment.ts
```
