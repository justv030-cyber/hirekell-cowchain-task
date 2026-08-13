import { ethers } from "hardhat";
import fs from "fs";
import path from "path";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { deployAndSave } from "./utils/deployHelpers";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying full protocol with:", deployer.address);

  const deployed = await deployAndSave("default");

  console.log("MockUSDC:", await deployed.usdc.getAddress());
  console.log("Treasury:", await deployed.treasury.getAddress());
  console.log("SportsOracle:", await deployed.oracle.getAddress());
  console.log("BettingFactory:", await deployed.factory.getAddress());
  console.log("MarketRegistry:", await deployed.registry.getAddress());
  console.log("ProtocolConfig:", await deployed.protocolConfig.getAddress());
  console.log("ResolverRegistry:", await deployed.resolverRegistry.getAddress());
  console.log("MarketViews:", await deployed.marketViews.getAddress());

  const dataDir = path.join(__dirname, "..", "data", "markets");
  const football = JSON.parse(fs.readFileSync(path.join(dataDir, "football.json"), "utf-8"));

  const now = await time.latest();
  const first = football.premierLeague;

  await deployed.factory.createMarket(
    first.eventName,
    first.homeTeam,
    first.awayTeam,
    now + first.lockOffsetSeconds,
    now + first.resolveOffsetSeconds
  );

  console.log("\nSample market created:", first.eventName);
  console.log("Deployment complete.");
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
