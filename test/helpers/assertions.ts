import { expect } from "chai";

export function expectUsdcClose(actual: bigint, expected: bigint, tolerance = 1n) {
  const diff = actual > expected ? actual - expected : expected - actual;
  expect(diff).to.be.lte(tolerance);
}
