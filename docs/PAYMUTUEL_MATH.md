# Parimutuel Math

## Concept

In parimutuel betting, all wagers go into a shared pool. Winners divide the pool proportionally — odds are not fixed at bet time.

## Formula

```
grossPayout = (betAmount × totalPool) / winningOutcomePool
fee         = grossPayout × feeRateBps / 10_000
netPayout   = grossPayout - fee
```

## Example: Football 1X2

**Match:** Manchester United vs Liverpool

| Bettor | Pick | Amount |
|--------|------|--------|
| Alice | Home (0) | 200 USDC |
| Bob | Draw (1) | 50 USDC |
| Carol | Away (2) | 150 USDC |

- **Total pool:** 400 USDC
- **Result:** Home wins

Alice's gross payout:
```
(200 × 400) / 200 = 400 USDC
```

With 2.5% fee:
```
fee = 400 × 250 / 10000 = 10 USDC
net = 390 USDC
```

Bob and Carol receive nothing.

## Implied Odds

Before resolution, implied odds for an outcome:
```
odds = totalPool / outcomePool
```

If Home pool = 200 and total = 400, implied odds = 2.0x.

## Edge Cases

| Case | Handling |
|------|----------|
| winningPool = 0 | Revert (no winners) |
| betAmount > winningPool | Revert (invalid) |
| Integer rounding | Standard Solidity integer division |
| Multiple bets by same user | Sum payouts across all winning bets |
