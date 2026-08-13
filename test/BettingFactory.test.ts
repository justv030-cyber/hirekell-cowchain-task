import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployProtocol } from "./helpers/fixtures";

describe("BettingFactory", function () {
  it("deploys a new market", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const now = (await ethers.provider.getBlock("latest"))!.timestamp;

    const tx = await factory.createMarket(
      "NBA Finals Game 7",
      "Boston Celtics",
      "Los Angeles Lakers",
      now + 3600,
      now + 7200
    );

    await expect(tx).to.emit(factory, "MarketCreated");
    expect(await factory.getMarketCount()).to.equal(1);
  });

  it("rejects invalid time windows", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const now = (await ethers.provider.getBlock("latest"))!.timestamp;

    await expect(
      factory.createMarket("Test", "Team A", "Team B", now - 100, now + 3600)
    ).to.be.revertedWith("Lock time must be future");

    await expect(
      factory.createMarket("Test", "Team A", "Team B", now + 3600, now + 100)
    ).to.be.revertedWith("Resolve after lock");
  });

  it("indexes market by id", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const now = (await ethers.provider.getBlock("latest"))!.timestamp;
    await factory.createMarket("Test Event", "Home", "Away", now + 3600, now + 7200);
    const markets = await factory.getAllMarkets();
    const market = await ethers.getContractAt("BettingMarket", markets[0]);
    const marketId = await market.marketId();
    expect(await factory.getMarket(marketId)).to.equal(markets[0]);
  });
});
