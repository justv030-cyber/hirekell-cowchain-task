import { BettingFactory } from "../../typechain-types";
import { time } from "@nomicfoundation/hardhat-network-helpers";

export interface MarketParams {
  eventName: string;
  homeTeam: string;
  awayTeam: string;
  lockOffset?: number;
  resolveOffset?: number;
}

export async function buildMarket(factory: BettingFactory, params: MarketParams) {
  const now = await time.latest();
  const lock = now + (params.lockOffset ?? 3600);
  const resolve = now + (params.resolveOffset ?? 7200);

  const tx = await factory.createMarket(
    params.eventName,
    params.homeTeam,
    params.awayTeam,
    lock,
    resolve
  );
  return tx.wait();
}
