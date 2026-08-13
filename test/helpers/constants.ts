/**
 * Shared test constants for sports betting scenarios.
 */

export const SPORTS = {
  FOOTBALL: 0,
  BASKETBALL: 1,
  TENNIS: 2,
  MMA: 3,
} as const;

export const SAMPLE_EVENTS = [
  {
    name: "Premier League — Matchday 12",
    home: "Manchester United",
    away: "Liverpool FC",
    league: "Premier League",
  },
  {
    name: "NBA Finals — Game 7",
    home: "Boston Celtics",
    away: "Los Angeles Lakers",
    league: "NBA",
  },
  {
    name: "UFC 300 — Main Card",
    home: "Alex Pereira",
    away: "Jamahal Hill",
    league: "UFC",
  },
] as const;

export const USDC_DECIMALS = 6;
export const ONE_USDC = 10n ** BigInt(USDC_DECIMALS);
