import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("OddsMath", function () {
  async function deployOddsMathTester() {
    const Factory = await ethers.getContractFactory("OddsMathTester");
    return Factory.deploy();
  }

  it("calculates proportional payout correctly", async function () {
    const tester = await loadFixture(deployOddsMathTester);
    const payout = await tester.calculatePayout(100, 1000, 300);
    expect(payout).to.equal(333n);
  });

  it("reverts on zero winning pool", async function () {
    const tester = await loadFixture(deployOddsMathTester);
    await expect(tester.calculatePayout(100, 1000, 0)).to.be.revertedWithCustomError(
      tester,
      "DivisionByZero"
    );
  });

  it("reverts when bet exceeds winning pool", async function () {
    const tester = await loadFixture(deployOddsMathTester);
    await expect(tester.calculatePayout(500, 1000, 300)).to.be.revertedWithCustomError(
      tester,
      "InsufficientPool"
    );
  });

  it("applies fee correctly", async function () {
    const tester = await loadFixture(deployOddsMathTester);
    const [net, fee] = await tester.applyFee(1000, 250);
    expect(fee).to.equal(25n);
    expect(net).to.equal(975n);
  });
});
