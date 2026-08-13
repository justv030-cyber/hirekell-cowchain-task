# Security Considerations

## Threat Model (Simplified)

| Threat | Mitigation |
|--------|------------|
| Reentrancy on claim | `nonReentrant` modifier |
| Unauthorized resolution | `onlyResolver` modifier |
| Double claim | `claimed` flag per bet |
| Unsafe token transfers | `SafeERC20` |
| Fee manipulation | Fee rate capped at 10% |
| Zero-address payouts | Validate recipients |

## Checklist for Your Implementation

- [ ] All external calls follow checks-effects-interactions
- [ ] State updated before external transfers
- [ ] Custom errors used consistently
- [ ] No unchecked ERC20 `transfer` calls
- [ ] Access control on Treasury fee collection
- [ ] Market status validated before each action

## Known Limitations (Out of Scope)

- Resolver is a trusted role (not decentralized)
- No oracle-driven auto-resolution
- No upgradeability
- No cross-chain support
- Cancelled market refunds not required (bonus only)

## Audit Notes

In production, Cowchain would additionally require:
- Formal verification of payout math
- Multi-sig resolver governance
- Timelock on fee changes
- Emergency pause integration with `ProtocolConfig`
