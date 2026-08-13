import { task } from "hardhat/config";

task("markets", "List all betting markets from factory")
  .addOptionalParam("factory", "BettingFactory address")
  .setAction(async ({ factory }, hre) => {
    const factoryAddress =
      factory || process.env.FACTORY_ADDRESS || (() => { throw new Error("Provide --factory or FACTORY_ADDRESS"); })();

    const bettingFactory = await hre.ethers.getContractAt("BettingFactory", factoryAddress);
    const markets = await bettingFactory.getAllMarkets();

    console.log(`Total markets: ${markets.length}`);
    for (const addr of markets) {
      const market = await hre.ethers.getContractAt("BettingMarket", addr);
      const info = await market.getMarketInfo();
      console.log(`- ${info.eventName} (${info.homeTeam} vs ${info.awayTeam}) @ ${addr}`);
    }
  });
