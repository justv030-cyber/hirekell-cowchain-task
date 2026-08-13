export { OUTCOME_HOME, OUTCOME_DRAW, OUTCOME_AWAY, BET_AMOUNT, FEE_BPS, SPORTS, SAMPLE_EVENTS, USDC_DECIMALS, ONE_USDC } from "./constants";

export const OUTCOME_LABELS = ["Home Win", "Draw", "Away Win"] as const;

export function formatUsdc(amount: bigint): string {
  return `${Number(amount) / 1e6} USDC`;
}
