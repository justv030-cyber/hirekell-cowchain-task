// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ProtocolErrors
 * @notice Shared custom errors across the SportsBet protocol.
 */
interface ProtocolErrors {
    error MarketNotOpen();
    error MarketAlreadyLocked();
    error MarketNotResolved();
    error MarketAlreadyResolved();
    error BettingClosed();
    error InvalidAmount();
    error NotAuthorized();
    error AlreadyClaimed();
    error NotWinner();
    error BetNotFound();
    error InvalidOutcome(uint8 outcome);
    error DivisionByZero();
    error InsufficientPool();
    error CollectorNotApproved();
}
