import { ethers } from "hardhat";
import { loadConfig, parseUsdc } from "./loadConfig";
import { saveDeployment } from "./saveDeployment";

export async function deployCoreProtocol(configName = "default") {
  const config = loadConfig(configName);
  const [deployer, resolver] = await ethers.getSigners();

  const MockUSDC = await ethers.getContractFactory("MockUSDC");
  const usdc = await MockUSDC.deploy();

  const Treasury = await ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy(await usdc.getAddress(), config.feeRateBps, deployer.address);

  const SportsOracle = await ethers.getContractFactory("SportsOracle");
  const oracle = await SportsOracle.deploy(deployer.address);

  const BettingFactory = await ethers.getContractFactory("BettingFactory");
  const factory = await BettingFactory.deploy(
    await usdc.getAddress(),
    await treasury.getAddress(),
    resolver.address,
    deployer.address
  );

  const MarketRegistry = await ethers.getContractFactory("MarketRegistry");
  const registry = await MarketRegistry.deploy();

  const ProtocolConfig = await ethers.getContractFactory("ProtocolConfig");
  const protocolConfig = await ProtocolConfig.deploy(
    parseUsdc(config.minBetUsdc),
    parseUsdc(config.maxBetUsdc),
    deployer.address
  );

  const ResolverRegistry = await ethers.getContractFactory("ResolverRegistry");
  const resolverRegistry = await ResolverRegistry.deploy(deployer.address);

  const MarketViews = await ethers.getContractFactory("MarketViews");
  const marketViews = await MarketViews.deploy();

  return {
    usdc,
    treasury,
    oracle,
    factory,
    registry,
    protocolConfig,
    resolverRegistry,
    marketViews,
    deployer,
    resolver,
    config,
  };
}

export async function deployAndSave(configName = "default") {
  const deployed = await deployCoreProtocol(configName);
  const { config } = deployed;

  saveDeployment({
    usdc: await deployed.usdc.getAddress(),
    treasury: await deployed.treasury.getAddress(),
    factory: await deployed.factory.getAddress(),
    oracle: await deployed.oracle.getAddress(),
    registry: await deployed.registry.getAddress(),
    protocolConfig: await deployed.protocolConfig.getAddress(),
    resolverRegistry: await deployed.resolverRegistry.getAddress(),
    marketViews: await deployed.marketViews.getAddress(),
    deployedAt: new Date().toISOString(),
    network: config.network,
  });

  return deployed;
}
