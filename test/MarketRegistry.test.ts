import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployProtocol, createSampleMarket } from "./helpers/fixtures";

describe("MarketRegistry", function () {
  it("registers a market event", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const market = await createSampleMarket(factory);
    const marketId = await market.marketId();

    const Registry = await ethers.getContractFactory("MarketRegistry");
    const registry = await Registry.deploy();

    await registry.registerEvent(marketId, await market.getAddress(), 0, "Premier League");

    const record = await registry.events(marketId);
    expect(record.market).to.equal(await market.getAddress());
    expect(record.active).to.be.true;
  });

  it("prevents duplicate registration", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const market = await createSampleMarket(factory);
    const marketId = await market.marketId();

    const Registry = await ethers.getContractFactory("MarketRegistry");
    const registry = await Registry.deploy();

    await registry.registerEvent(marketId, await market.getAddress(), 0, "Premier League");
    await expect(
      registry.registerEvent(marketId, await market.getAddress(), 0, "Premier League")
    ).to.be.revertedWith("Already registered");
  });

  it("deactivates an event", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const market = await createSampleMarket(factory);
    const marketId = await market.marketId();

    const Registry = await ethers.getContractFactory("MarketRegistry");
    const registry = await Registry.deploy();

    await registry.registerEvent(marketId, await market.getAddress(), 1, "NBA");
    await registry.deactivateEvent(marketId);

    const record = await registry.events(marketId);
    expect(record.active).to.be.false;
  });
});
