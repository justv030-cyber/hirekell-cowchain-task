import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("FeeConfig (via tester)", function () {
  async function deployFeeConfigTester() {
    const Factory = await ethers.getContractFactory("FeeConfigTester");
    return Factory.deploy();
  }

  it("computes fee correctly", async function () {
    const tester = await loadFixture(deployFeeConfigTester);
    expect(await tester.computeFee(1000, 250)).to.equal(25n);
  });

  it("rejects fee above max", async function () {
    const tester = await loadFixture(deployFeeConfigTester);
    await expect(tester.validateFeeRate(1001)).to.be.revertedWithCustomError(tester, "FeeTooHigh");
  });
});
