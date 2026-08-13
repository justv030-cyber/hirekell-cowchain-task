import { ethers } from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import {
  MockUSDC,
  Treasury,
  BettingFactory,
  BettingMarket,
  SportsOracle,
} from "../typechain-types";

export const OUTCOME_HOME = 0;
export const OUTCOME_DRAW = 1;
export const OUTCOME_AWAY = 2;

export const BET_AMOUNT = ethers.parseUnits("100", 6);
export const FEE_BPS = 250; // 2.5%

export interface DeployedProtocol {
  usdc: MockUSDC;
  treasury: Treasury;
  factory: BettingFactory;
  oracle: SportsOracle;
  deployer: Awaited<ReturnType<typeof ethers.getSigners>>[0];
  resolver: Awaited<ReturnType<typeof ethers.getSigners>>[1];
  bettor1: Awaited<ReturnType<typeof ethers.getSigners>>[2];
  bettor2: Awaited<ReturnType<typeof ethers.getSigners>>[3];
}

export async function deployProtocol(): Promise<DeployedProtocol> {
  const [deployer, resolver, bettor1, bettor2] = await ethers.getSigners();

  const MockUSDC = await ethers.getContractFactory("MockUSDC");
  const usdc = await MockUSDC.deploy();

  const Treasury = await ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy(await usdc.getAddress(), FEE_BPS, deployer.address);

  const SportsOracle = await ethers.getContractFactory("SportsOracle");
  const oracle = await SportsOracle.deploy(deployer.address);

  const BettingFactory = await ethers.getContractFactory("BettingFactory");
  const factory = await BettingFactory.deploy(
    await usdc.getAddress(),
    await treasury.getAddress(),
    resolver.address,
    deployer.address
  );

  // Fund bettors
  const fundAmount = ethers.parseUnits("10000", 6);
  await usdc.transfer(bettor1.address, fundAmount);
  await usdc.transfer(bettor2.address, fundAmount);

  return { usdc, treasury, factory, oracle, deployer, resolver, bettor1, bettor2 };
}

export async function createSampleMarket(
  factory: BettingFactory,
  lockOffsetSeconds = 3600,
  resolveOffsetSeconds = 7200
): Promise<BettingMarket> {
  const now = await time.latest();
  const lockTime = now + lockOffsetSeconds;
  const resolveTime = now + resolveOffsetSeconds;

  const tx = await factory.createMarket(
    "Premier League — Matchday 12",
    "Manchester United",
    "Liverpool FC",
    lockTime,
    resolveTime
  );
  const receipt = await tx.wait();
  const event = receipt?.logs
    .map((log) => {
      try {
        return factory.interface.parseLog({ topics: [...log.topics], data: log.data });
      } catch {
        return null;
      }
    })
    .find((e) => e?.name === "MarketCreated");

  const marketAddress = event?.args?.market as string;
  return ethers.getContractAt("BettingMarket", marketAddress);
}

export async function approveAndBet(
  usdc: MockUSDC,
  market: BettingMarket,
  bettor: Awaited<ReturnType<typeof ethers.getSigners>>[0],
  outcome: number,
  amount = BET_AMOUNT
) {
  await usdc.connect(bettor).approve(await market.getAddress(), amount);
  await market.connect(bettor).placeBet(outcome, amount);
}
