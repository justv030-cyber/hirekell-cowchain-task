# Troubleshooting

## `npm install` fails

- Ensure Node.js 18+: `node -v`
- Delete `node_modules` and retry

## Compilation errors

```bash
npm run clean
npm run compile
```

## Tests fail with "Not implemented"

Expected before completing TODOs. Implement the marked functions.

## `HH404: File not found`

Check import paths in Solidity — use relative paths from contract location.

## `invalid BigNumberish value`

USDC uses 6 decimals. Use `ethers.parseUnits("100", 6)` not `100`.

## Deployment script can't find addresses

Run `npm run deploy:all` first. Check `scripts/deployments/latest.json`.

## `BettingClosed` revert on placeBet

Market past `lockTime`. Create a new market with future lock time or use fixtures with longer offsets.

## TypeChain errors

```bash
rm -rf typechain-types
npm run compile
```

## Still stuck?

Contact your Cowchain recruiter with:
- Error message
- Command you ran
- Node.js version
