import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("BetTypes", function () {
  async function deployBetTypesTester() {
    const Factory = await ethers.getContractFactory("BetTypesTester");
    return Factory.deploy();
  }

  it("validates valid outcomes", async function () {
    const tester = await loadFixture(deployBetTypesTester);
    await expect(tester.validateOutcome(0)).to.not.be.reverted;
    await expect(tester.validateOutcome(2)).to.not.be.reverted;
  });

  it("rejects invalid outcome", async function () {
    const tester = await loadFixture(deployBetTypesTester);
    await expect(tester.validateOutcome(3)).to.be.revertedWithCustomError(tester, "InvalidOutcome");
  });
});
