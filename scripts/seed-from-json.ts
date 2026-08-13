import { ethers } from "hardhat";
import fs from "fs";
import path from "path";
import { time } from "@nomicfoundation/hardhat-network-helpers";

async function main() {
  const sport = process.argv[2] || "football";
  const factoryAddress = process.env.FACTORY_ADDRESS;

  if (!factoryAddress) {
    console.error("Set FACTORY_ADDRESS env var");
    process.exit(1);
  }

  const dataPath = path.join(__dirname, "..", "data", "markets", `${sport}.json`);
  const events = JSON.parse(fs.readFileSync(dataPath, "utf-8"));
  const factory = await ethers.getContractAt("BettingFactory", factoryAddress);
  const now = await time.latest();

  for (const key of Object.keys(events)) {
    const e = events[key];
    const tx = await factory.createMarket(
      e.eventName,
      e.homeTeam,
      e.awayTeam,
      now + e.lockOffsetSeconds,
      now + e.resolveOffsetSeconds
    );
    await tx.wait();
    console.log(`Created: ${e.eventName}`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
