// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @dev Contract that reverts on receive — useful for testing failed payouts.
contract MaliciousReceiver {
    function claimAndRevert(address token) external {
        uint256 bal = IERC20(token).balanceOf(address(this));
        require(bal > 0, "No balance");
        revert("Always reverts");
    }
}
