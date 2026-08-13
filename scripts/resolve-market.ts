import { ethers } from "hardhat";

async function main() {
  const marketAddress = process.env.MARKET_ADDRESS;
  const winningOutcome = parseInt(process.env.WINNING_OUTCOME || "0", 10);

  if (!marketAddress) {
    console.error("Set MARKET_ADDRESS and WINNING_OUTCOME (0/1/2)");
    process.exit(1);
  }

  const [, resolver] = await ethers.getSigners();
  const market = await ethers.getContractAt("BettingMarket", marketAddress);

  await market.connect(resolver).lockMarket();
  await market.connect(resolver).resolveMarket(winningOutcome);

  console.log(`Market resolved. Winner: outcome ${winningOutcome}`);
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
