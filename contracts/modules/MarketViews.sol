// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IBettingMarket} from "../interfaces/IBettingMarket.sol";
import {PayoutCalculator} from "../libraries/PayoutCalculator.sol";
import {OddsMath} from "../libraries/OddsMath.sol";

contract MarketViews {
    function getImpliedOdds(
        IBettingMarket market,
        uint8 outcome
    ) external view returns (uint256) {
        IBettingMarket.MarketInfo memory info = market.getMarketInfo();
        uint256 outcomePool = market.getOutcomePool(outcome);
        return OddsMath.impliedOdds(outcomePool, info.totalPool);
    }

    function previewPayout(
        IBettingMarket market,
        uint256 betId,
        uint256 feeBps
    ) external view returns (uint256 net, uint256 fee) {
        IBettingMarket.MarketInfo memory info = market.getMarketInfo();
        IBettingMarket.Bet memory bet = market.getBet(betId);
        if (bet.outcome != info.winningOutcome) return (0, 0);

        uint256 winningPool = market.getOutcomePool(info.winningOutcome);
        (net, fee) = PayoutCalculator.netPayout(bet.amount, info.totalPool, winningPool, feeBps);
    }

    function getPoolDistribution(
        IBettingMarket market
    ) external view returns (uint256 home, uint256 draw, uint256 away) {
        home = market.getOutcomePool(0);
        draw = market.getOutcomePool(1);
        away = market.getOutcomePool(2);
    }
}
