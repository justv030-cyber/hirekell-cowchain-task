import { ethers } from "hardhat";
import fs from "fs";
import path from "path";

export interface DeployConfig {
  feeRateBps: number;
  minBetUsdc: string;
  maxBetUsdc: string;
  network: string;
  chainId: number;
  rpcUrl?: string;
}

export function loadConfig(name = "default"): DeployConfig {
  const configPath = path.join(__dirname, "..", "config", `${name}.json`);
  return JSON.parse(fs.readFileSync(configPath, "utf-8"));
}

export function parseUsdc(amount: string): bigint {
  return ethers.parseUnits(amount, 6);
}

export function getDeployer() {
  return ethers.getSigners().then(([deployer]) => deployer);
}
