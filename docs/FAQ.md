# Frequently Asked Questions — Candidate Edition

## General

**Q: How long should this take?**  
A: 3–5 hours for an intermediate developer.

**Q: Can I use AI tools?**  
A: No. This is an individual assessment. Do not use ChatGPT, Copilot, Cursor, Claude, or any other AI-assisted coding tools.

**Q: Can I modify tests?**  
A: Only for bonus tests. Do not change existing test assertions.

## Technical

**Q: Why parimutuel instead of fixed odds?**  
A: Simpler on-chain math, no oracle for odds feeds. Cowchain uses both models in production; this task focuses on pool betting.

**Q: What if no one bets on the winning outcome?**  
A: Out of scope — assume at least one winning bet exists. You may note this edge case in SOLUTION.md.

**Q: Should I use `transfer` or `safeTransfer`?**  
A: Always `SafeERC20` in this codebase.

**Q: The Treasury `collectFee` isn't called from anywhere yet — should I wire it up?**  
A: Yes, call it from `claimWinnings` when deducting protocol fees.

**Q: Do I need to implement MarketRegistry?**  
A: No. It's provided for context and optional exploration.

**Q: What about cancelled market refunds?**  
A: Bonus only. If implemented, refund original bet amounts (no fee).

## Submission

**Q: What if I can't finish everything?**  
A: Submit partial work with clear notes. Partial credit is possible.

**Q: How do I run a single test file?**  
A: `npx hardhat test test/BettingMarket.test.ts`

## Environment

**Q: Node version?**  
A: Node 18+ recommended.

**Q: Tests fail immediately — is that normal?**  
A: Yes. Implement the TODOs to make them pass.
