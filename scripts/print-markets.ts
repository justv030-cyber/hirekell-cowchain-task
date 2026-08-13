import { ethers } from "hardhat";
import { loadDeployment } from "./utils/saveDeployment";

async function main() {
  const deployment = loadDeployment();
  const factory = await ethers.getContractAt("BettingFactory", deployment.factory);

  const count = await factory.getMarketCount();
  console.log(`Markets deployed: ${count}`);

  for (let i = 0; i < count; i++) {
    const markets = await factory.getAllMarkets();
    const market = await ethers.getContractAt("BettingMarket", markets[i]);
    const info = await market.getMarketInfo();
    console.log(`\n[${i}] ${info.eventName}`);
    console.log(`    ${info.homeTeam} vs ${info.awayTeam}`);
    console.log(`    Pool: ${ethers.formatUnits(info.totalPool, 6)} USDC`);
    console.log(`    Status: ${info.status}`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
