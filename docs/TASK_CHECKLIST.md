# Task Checklist — For Candidates

Use this checklist to track your progress.

## Setup

- [ ] `npm install` completes without errors
- [ ] `npm run compile` succeeds
- [ ] Read `README.md` and `docs/SPEC.md`

## Core Tasks

- [ ] **OddsMath** — `calculatePayout()` implemented
- [ ] **BettingMarket** — `placeBet()` implemented
- [ ] **BettingMarket** — `resolveMarket()` implemented
- [ ] **BettingMarket** — `claimWinnings()` implemented
- [ ] **Treasury** — `collectFee()` with access control

## Verification

- [ ] `npm test` — all tests pass
- [ ] No compiler warnings in your changed files
- [ ] `SOLUTION.md` written (use `docs/SOLUTION_TEMPLATE.md`)

## Bonus (Optional)

- [ ] `refundBets()` for cancelled markets
- [ ] Extra test for unequal three-outcome pools
- [ ] Gas optimization notes in SOLUTION.md

## Pre-Submission Review

- [ ] Used SafeERC20 for all token transfers
- [ ] No double-claim possible
- [ ] Reentrancy guarded on external calls
- [ ] Did not modify existing test assertions
- [ ] Signed declaration in `SOLUTION.md` (no AI tools used)
- [ ] Private repo ready to share
