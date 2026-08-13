import { ethers } from "hardhat";

async function main() {
  const [deployer, resolver] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const MockUSDC = await ethers.getContractFactory("MockUSDC");
  const usdc = await MockUSDC.deploy();
  await usdc.waitForDeployment();
  console.log("MockUSDC:", await usdc.getAddress());

  const Treasury = await ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy(await usdc.getAddress(), 250, deployer.address);
  await treasury.waitForDeployment();
  console.log("Treasury:", await treasury.getAddress());

  const SportsOracle = await ethers.getContractFactory("SportsOracle");
  const oracle = await SportsOracle.deploy(deployer.address);
  await oracle.waitForDeployment();
  console.log("SportsOracle:", await oracle.getAddress());

  const BettingFactory = await ethers.getContractFactory("BettingFactory");
  const factory = await BettingFactory.deploy(
    await usdc.getAddress(),
    await treasury.getAddress(),
    resolver.address,
    deployer.address
  );
  await factory.waitForDeployment();
  console.log("BettingFactory:", await factory.getAddress());

  const MarketRegistry = await ethers.getContractFactory("MarketRegistry");
  const registry = await MarketRegistry.deploy();
  await registry.waitForDeployment();
  console.log("MarketRegistry:", await registry.getAddress());

  console.log("\nDeployment complete.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
