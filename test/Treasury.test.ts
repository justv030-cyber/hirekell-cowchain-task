import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployProtocol, FEE_BPS } from "./helpers/fixtures";

describe("Treasury", function () {
  it("stores initial fee rate", async function () {
    const { treasury } = await loadFixture(deployProtocol);
    expect(await treasury.getFeeRate()).to.equal(FEE_BPS);
  });

  it("allows owner to update fee rate", async function () {
    const { treasury, deployer } = await loadFixture(deployProtocol);
    await treasury.connect(deployer).setFeeRate(500);
    expect(await treasury.getFeeRate()).to.equal(500);
  });

  it("rejects fee rate above cap", async function () {
    const { treasury, deployer } = await loadFixture(deployProtocol);
    await expect(treasury.connect(deployer).setFeeRate(1001)).to.be.revertedWith("Fee too high");
  });

  it("collects fees from approved collector", async function () {
    const { treasury, usdc, deployer } = await loadFixture(deployProtocol);
    const amount = ethers.parseUnits("50", 6);

    await usdc.approve(await treasury.getAddress(), amount);
    await treasury.connect(deployer).collectFee(amount);

    expect(await treasury.getBalance()).to.equal(amount);
    expect(await treasury.totalCollected()).to.equal(amount);
  });

  it("allows owner to withdraw fees", async function () {
    const { treasury, usdc, deployer } = await loadFixture(deployProtocol);
    const amount = ethers.parseUnits("100", 6);

    await usdc.approve(await treasury.getAddress(), amount);
    await treasury.connect(deployer).collectFee(amount);

    const before = await usdc.balanceOf(deployer.address);
    await treasury.connect(deployer).withdrawFees(deployer.address, amount);
    const after = await usdc.balanceOf(deployer.address);

    expect(after - before).to.equal(amount);
  });
});
