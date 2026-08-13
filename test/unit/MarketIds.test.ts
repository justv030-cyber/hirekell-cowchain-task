import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("MarketIds (via tester)", function () {
  async function deployMarketIdsTester() {
    const Factory = await ethers.getContractFactory("MarketIdsTester");
    return Factory.deploy();
  }

  it("produces deterministic market ids", async function () {
    const tester = await loadFixture(deployMarketIdsTester);
    const id1 = await tester.computeMarketId("Event", "Home", "Away", 1000, 0);
    const id2 = await tester.computeMarketId("Event", "Home", "Away", 1000, 0);
    expect(id1).to.equal(id2);
  });

  it("changes id when nonce differs", async function () {
    const tester = await loadFixture(deployMarketIdsTester);
    const id1 = await tester.computeMarketId("Event", "Home", "Away", 1000, 0);
    const id2 = await tester.computeMarketId("Event", "Home", "Away", 1000, 1);
    expect(id1).to.not.equal(id2);
  });
});
