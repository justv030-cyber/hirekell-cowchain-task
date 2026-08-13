import { expect } from "chai";
import { ethers } from "hardhat";
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import {
  deployProtocol,
  createSampleMarket,
  approveAndBet,
  OUTCOME_HOME,
  OUTCOME_AWAY,
} from "../helpers/fixtures";

describe("Integration: full betting flow", function () {
  it("creates market, accepts bets, resolves, and claims", async function () {
    const { usdc, factory, resolver, bettor1, bettor2 } = await loadFixture(deployProtocol);
    const market = await createSampleMarket(factory, 60, 120);

    await approveAndBet(usdc, market, bettor1, OUTCOME_HOME, ethers.parseUnits("200", 6));
    await approveAndBet(usdc, market, bettor2, OUTCOME_AWAY, ethers.parseUnits("100", 6));

    await time.increase(70);
    await market.connect(resolver).lockMarket();
    await time.increase(60);
    await market.connect(resolver).resolveMarket(OUTCOME_HOME);

    const before = await usdc.balanceOf(bettor1.address);
    await market.connect(bettor1).claimWinnings();
    const after = await usdc.balanceOf(bettor1.address);

    expect(after).to.be.gt(before);
  });
});

describe("Integration: oracle reporting", function () {
  it("reports result to oracle independently of market", async function () {
    const { oracle, deployer, factory } = await loadFixture(deployProtocol);
    const market = await createSampleMarket(factory);
    const marketId = await market.marketId();
    await oracle.connect(deployer).reportResult(marketId, OUTCOME_AWAY);
    const result = await oracle.getResult(marketId);
    expect(result.winningOutcome).to.equal(OUTCOME_AWAY);
  });
});
