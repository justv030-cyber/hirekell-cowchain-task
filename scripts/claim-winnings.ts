import { ethers } from "hardhat";

async function main() {
  const marketAddress = process.env.MARKET_ADDRESS;
  if (!marketAddress) {
    console.error("Set MARKET_ADDRESS");
    process.exit(1);
  }

  const [bettor] = await ethers.getSigners();
  const market = await ethers.getContractAt("BettingMarket", marketAddress);
  const tokenAddress = await market.bettingToken();
  const usdc = await ethers.getContractAt("MockUSDC", tokenAddress);

  const before = await usdc.balanceOf(bettor.address);
  await market.claimWinnings();
  const after = await usdc.balanceOf(bettor.address);

  console.log(`Claimed: ${ethers.formatUnits(after - before, 6)} USDC`);
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
