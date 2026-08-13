// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

abstract contract Authorized {
    error NotAuthorized();

    modifier onlyAddress(address expected) {
        if (msg.sender != expected) revert NotAuthorized();
        _;
    }
}
