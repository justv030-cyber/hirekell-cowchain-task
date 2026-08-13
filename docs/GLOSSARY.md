# Glossary — Sports Betting & Blockchain Terms

## Sports Betting

| Term | Definition |
|------|------------|
| **Parimutuel** | Pool betting system where winners split the total pool proportionally. Odds are not fixed at bet time. |
| **Home team** | Team playing at their home venue (listed first). |
| **Away team** | Visiting team (listed second). |
| **1X2 market** | Three-way market: Home win (1), Draw (X), Away win (2). |
| **Lock time** | Moment betting closes — typically match kickoff. |
| **Settlement** | Process of determining winners and paying out. |
| **Handle** | Total amount wagered across all outcomes. |
| **Edge / vig** | House advantage; here implemented as protocol fee. |

## Blockchain

| Term | Definition |
|------|------------|
| **Basis points (bps)** | 1 bps = 0.01%. 250 bps = 2.5%. |
| **Escrow** | Tokens held by contract until conditions met. |
| **Resolver** | Trusted address that triggers market state transitions. |
| **Factory pattern** | Deployer contract that creates child contract instances. |
| **SafeERC20** | OpenZeppelin wrapper for safe token transfers. |
| **Reentrancy** | Attack where external call re-enters contract before state update. |
| **Custom error** | Solidity 0.8+ gas-efficient alternative to revert strings. |

## Cowchain Context

| Term | Definition |
|------|------------|
| **Market** | One `BettingMarket` contract instance for a single sports event. |
| **Protocol fee** | Percentage taken from winnings, not from losing bets. |
| **mUSDC** | Mock USDC used in local/test environments. |
