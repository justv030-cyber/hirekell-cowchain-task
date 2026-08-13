import { ethers } from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";

/**
 * Seeds sample sports betting markets for local development.
 * Run after deploy.ts on a local Hardhat node.
 */
async function main() {
  const [deployer, resolver, bettor1, bettor2] = await ethers.getSigners();

  const usdcAddress = process.env.USDC_ADDRESS;
  const factoryAddress = process.env.FACTORY_ADDRESS;

  if (!usdcAddress || !factoryAddress) {
    console.error("Set USDC_ADDRESS and FACTORY_ADDRESS env vars from deploy output.");
    process.exit(1);
  }

  const usdc = await ethers.getContractAt("MockUSDC", usdcAddress);
  const factory = await ethers.getContractAt("BettingFactory", factoryAddress);

  const now = await time.latest();

  const events = [
    {
      name: "Champions League — Semi-Final",
      home: "Real Madrid",
      away: "Bayern Munich",
      lock: now + 86400,
      resolve: now + 90000,
    },
    {
      name: "NBA — Lakers vs Warriors",
      home: "Los Angeles Lakers",
      away: "Golden State Warriors",
      lock: now + 43200,
      resolve: now + 46800,
    },
    {
      name: "ATP Madrid Open — Final",
      home: "Carlos Alcaraz",
      away: "Novak Djokovic",
      lock: now + 172800,
      resolve: now + 176400,
    },
  ];

  for (const event of events) {
    const tx = await factory.createMarket(
      event.name,
      event.home,
      event.away,
      event.lock,
      event.resolve
    );
    const receipt = await tx.wait();
    console.log(`Created market: ${event.name} (tx: ${receipt?.hash})`);
  }

  // Fund sample bettors
  const fund = ethers.parseUnits("5000", 6);
  await usdc.transfer(bettor1.address, fund);
  await usdc.transfer(bettor2.address, fund);

  console.log(`\nSeeded ${events.length} markets. Funded bettors ${bettor1.address}, ${bettor2.address}`);
  console.log(`Resolver account: ${resolver.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
