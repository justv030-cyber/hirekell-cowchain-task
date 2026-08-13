import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployProtocol, createSampleMarket } from "../helpers/fixtures";

describe("Integration: multi-market factory", function () {
  it("tracks multiple sports events", async function () {
    const { factory } = await loadFixture(deployProtocol);

    await createSampleMarket(factory);
    await createSampleMarket(factory);
    await createSampleMarket(factory);

    expect(await factory.getMarketCount()).to.equal(3);
    const markets = await factory.getAllMarkets();
    expect(markets.length).to.equal(3);
  });

  it("validates each address as market", async function () {
    const { factory } = await loadFixture(deployProtocol);
    const market = await createSampleMarket(factory);
    expect(await factory.isMarket(await market.getAddress())).to.be.true;
  });
});
