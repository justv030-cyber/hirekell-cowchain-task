import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployProtocol } from "../helpers/fixtures";

describe("ProtocolConfig", function () {
  it("stores min and max bet", async function () {
    const ProtocolConfig = await ethers.getContractFactory("ProtocolConfig");
    const [owner] = await ethers.getSigners();
    const config = await ProtocolConfig.deploy(
      ethers.parseUnits("10", 6),
      ethers.parseUnits("1000", 6),
      owner.address
    );
    expect(await config.minBet()).to.equal(ethers.parseUnits("10", 6));
    expect(await config.maxBet()).to.equal(ethers.parseUnits("1000", 6));
  });

  it("allows owner to pause", async function () {
    const ProtocolConfig = await ethers.getContractFactory("ProtocolConfig");
    const [owner] = await ethers.getSigners();
    const config = await ProtocolConfig.deploy(0, 0, owner.address);
    await config.connect(owner).pause();
    expect(await config.paused()).to.be.true;
  });
});

describe("ResolverRegistry", function () {
  it("registers resolver for league", async function () {
    const [owner, resolver] = await ethers.getSigners();
    const Registry = await ethers.getContractFactory("ResolverRegistry");
    const registry = await Registry.deploy(owner.address);
    await registry.connect(owner).addResolver(resolver.address, "Premier League");
    expect(await registry.isResolverForLeague(resolver.address, "Premier League")).to.be.true;
  });
});

describe("MarketViews", function () {
  it("returns pool distribution", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const now = (await ethers.provider.getBlock("latest"))!.timestamp;
    await factory.createMarket("Test", "A", "B", now + 3600, now + 7200);
    const markets = await factory.getAllMarkets();
    const market = await ethers.getContractAt("BettingMarket", markets[0]);
    const Views = await ethers.getContractFactory("MarketViews");
    const views = await Views.deploy();
    const [home, draw, away] = await views.getPoolDistribution(market);
    expect(home).to.equal(0);
    expect(draw).to.equal(0);
    expect(away).to.equal(0);
  });
});

describe("SportsOracle", function () {
  it("allows authorized reporter to submit results", async function () {
    const { oracle, deployer } = await loadFixture(deployProtocol);
    const marketId = ethers.id("test-market");
    await oracle.connect(deployer).reportResult(marketId, 0);
    const result = await oracle.getResult(marketId);
    expect(result.reported).to.be.true;
  });
});

describe("BettingFactory", function () {
  it("deploys a new market", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const now = (await ethers.provider.getBlock("latest"))!.timestamp;
    const tx = await factory.createMarket("NBA Finals", "Celtics", "Lakers", now + 3600, now + 7200);
    await expect(tx).to.emit(factory, "MarketCreated");
    expect(await factory.getMarketCount()).to.equal(1);
  });
});
