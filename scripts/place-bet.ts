import { ethers } from "hardhat";

async function main() {
  const marketAddress = process.env.MARKET_ADDRESS;
  const outcome = parseInt(process.env.OUTCOME || "0", 10);
  const amount = process.env.AMOUNT || "100";

  if (!marketAddress) {
    console.error("Set MARKET_ADDRESS, optional OUTCOME (0/1/2), AMOUNT (USDC)");
    process.exit(1);
  }

  const [bettor] = await ethers.getSigners();
  const market = await ethers.getContractAt("BettingMarket", marketAddress);
  const tokenAddress = await market.bettingToken();
  const usdc = await ethers.getContractAt("MockUSDC", tokenAddress);

  const parsed = ethers.parseUnits(amount, 6);
  await usdc.approve(marketAddress, parsed);
  await market.placeBet(outcome, parsed);

  console.log(`Bet placed: ${amount} USDC on outcome ${outcome}`);
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
