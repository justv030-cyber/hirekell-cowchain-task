import football from "../../data/markets/football.json";
import basketball from "../../data/markets/basketball.json";
import tennis from "../../data/markets/tennis.json";
import mma from "../../data/markets/mma.json";

export const marketFixtures = { football, basketball, tennis, mma };

export type MarketFixture = (typeof football)[keyof typeof football];
