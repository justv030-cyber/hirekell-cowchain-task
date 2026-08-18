import { expect } from "chai";
import { ethers } from "hardhat";
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import {
  deployProtocol,
  createSampleMarket,
  approveAndBet,
  OUTCOME_HOME,
  OUTCOME_DRAW,
  OUTCOME_AWAY,
  BET_AMOUNT,
} from "./helpers/fixtures";

describe("BettingMarket", function () {
  describe("placeBet", function () {
    it("accepts a valid bet and updates pools", async function () {
      const { usdc, factory, bettor1 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory);

      await approveAndBet(usdc, market, bettor1, OUTCOME_HOME);

      expect(await market.getBetCount()).to.equal(1);
      expect(await market.getOutcomePool(OUTCOME_HOME)).to.equal(BET_AMOUNT);

      const info = await market.getMarketInfo();
      expect(info.totalPool).to.equal(BET_AMOUNT);
    });

    it("rejects bets after lock time", async function () {
      const { usdc, factory, bettor1 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory, 60, 3600);

      await time.increase(120);
      await usdc.connect(bettor1).approve(await market.getAddress(), BET_AMOUNT);

      await expect(
        market.connect(bettor1).placeBet(OUTCOME_HOME, BET_AMOUNT)
      ).to.be.revertedWithCustomError(market, "BettingClosed");
    });

    it("rejects zero-amount bets", async function () {
      const { usdc, factory, bettor1 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory);

      await usdc.connect(bettor1).approve(await market.getAddress(), BET_AMOUNT);
      await expect(market.connect(bettor1).placeBet(OUTCOME_HOME, 0)).to.be.revertedWithCustomError(
        market,
        "InvalidAmount"
      );
    });

    it("rejects invalid outcome index", async function () {
      const { usdc, factory, bettor1 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory);

      await usdc.connect(bettor1).approve(await market.getAddress(), BET_AMOUNT);
      await expect(market.connect(bettor1).placeBet(3, BET_AMOUNT)).to.be.revertedWithCustomError(
        market,
        "InvalidOutcome"
      );
    });
  });

  describe("resolveMarket", function () {
    it("resolves with correct winning outcome", async function () {
      const { usdc, factory, resolver, bettor1, bettor2 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory, 60, 120);

      await approveAndBet(usdc, market, bettor1, OUTCOME_HOME);
      await approveAndBet(usdc, market, bettor2, OUTCOME_AWAY);

      await time.increase(70);
      await market.connect(resolver).lockMarket();

      await time.increase(60);
      await market.connect(resolver).resolveMarket(OUTCOME_HOME);

      const info = await market.getMarketInfo();
      expect(info.status).to.equal(2); // Resolved
      expect(info.winningOutcome).to.equal(OUTCOME_HOME);
    });
  });

  describe("claimWinnings", function () {
      it("pays winners proportionally minus protocol fee", async function () {
        const { usdc, factory, resolver, bettor1, bettor2 } = await loadFixture(deployProtocol);
        const market = await createSampleMarket(factory, 60, 120);

        await approveAndBet(usdc, market, bettor1, OUTCOME_HOME, ethers.parseUnits("200", 6));
        await approveAndBet(usdc, market, bettor2, OUTCOME_AWAY, ethers.parseUnits("100", 6));

        await time.increase(70);
        await market.connect(resolver).lockMarket();
        await time.increase(60);
        await market.connect(resolver).resolveMarket(OUTCOME_HOME);

        const balanceBefore = await usdc.balanceOf(bettor1.address);
        await market.connect(bettor1).claimWinnings();
        const balanceAfter = await usdc.balanceOf(bettor1.address);

        // Gross: 200 * 300 / 200 = 300, fee 2.5% = 7.5 → net 292.5
        const expectedNet = ethers.parseUnits("292.5", 6);
        expect(balanceAfter - balanceBefore).to.equal(expectedNet);
      });

      it("pays the correct amount with three unequal outcome pools", async function () {
        const { usdc, factory, resolver, bettor1, bettor2 } = await loadFixture(deployProtocol);
        const market = await createSampleMarket(factory, 60, 120);
        const homeBet = ethers.parseUnits("200", 6);
        const drawBet = ethers.parseUnits("100", 6);
        const awayBet = ethers.parseUnits("50", 6);

        await approveAndBet(usdc, market, bettor1, OUTCOME_HOME, homeBet);
        await approveAndBet(usdc, market, bettor2, OUTCOME_DRAW, drawBet);
        await approveAndBet(usdc, market, bettor1, OUTCOME_AWAY, awayBet);

        await time.increase(70);
        await market.connect(resolver).lockMarket();
        await time.increase(60);
        await market.connect(resolver).resolveMarket(OUTCOME_HOME);

        expect(await market.getOutcomePool(OUTCOME_HOME)).to.equal(homeBet);
        expect(await market.getOutcomePool(OUTCOME_DRAW)).to.equal(drawBet);
        expect(await market.getOutcomePool(OUTCOME_AWAY)).to.equal(awayBet);

        const balanceBefore = await usdc.balanceOf(bettor1.address);
        await market.connect(bettor1).claimWinnings();

        // Gross: 200 * 350 / 200 = 350; fee 2.5% = 8.75; net = 341.25.
        expect(await usdc.balanceOf(bettor1.address)).to.equal(
          balanceBefore + ethers.parseUnits("341.25", 6)
        );
      });

      it("reverts for losing bettor", async function () {
      const { usdc, factory, resolver, bettor1, bettor2 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory, 60, 120);
      await approveAndBet(usdc, market, bettor1, OUTCOME_HOME);
      await approveAndBet(usdc, market, bettor2, OUTCOME_AWAY);

      await time.increase(70);
      await market.connect(resolver).lockMarket();
      await time.increase(60);
      await market.connect(resolver).resolveMarket(OUTCOME_HOME);

      await expect(market.connect(bettor2).claimWinnings()).to.be.revertedWithCustomError(
        market,
        "NotWinner"
      );
    });
  });

  describe("refundBets", function () {
    it("refunds every unclaimed bet in a cancelled market without a fee", async function () {
      const { usdc, factory, resolver, bettor1 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory);
      const secondBet = ethers.parseUnits("25", 6);

      await approveAndBet(usdc, market, bettor1, OUTCOME_HOME);
      await usdc.connect(bettor1).approve(await market.getAddress(), secondBet);
      await market.connect(bettor1).placeBet(OUTCOME_DRAW, secondBet);
      await market.connect(resolver).cancelMarket("Event cancelled");

      const balanceBefore = await usdc.balanceOf(bettor1.address);
      await expect(market.connect(bettor1).refundBets())
        .to.emit(market, "BetsRefunded")
        .withArgs(bettor1.address, BET_AMOUNT + secondBet);
      expect(await usdc.balanceOf(bettor1.address)).to.equal(
        balanceBefore + BET_AMOUNT + secondBet
      );

      await expect(market.connect(bettor1).refundBets()).to.be.revertedWithCustomError(
        market,
        "NoRefundAvailable"
      );
    });

    it("only allows refunds after cancellation", async function () {
      const { usdc, factory, bettor1 } = await loadFixture(deployProtocol);
      const market = await createSampleMarket(factory);
      await approveAndBet(usdc, market, bettor1, OUTCOME_HOME);

      await expect(market.connect(bettor1).refundBets()).to.be.revertedWithCustomError(
        market,
        "MarketNotCancelled"
      );
    });
  });
});
