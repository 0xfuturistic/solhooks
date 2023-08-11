// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";

contract HooksTest is Test, Hooks {
    function setUp() public {}

    function test_preHooks() public {
        preHooks(address(0), bytes4(0), abi.encode(0));

        vm.expectRevert();
        preHooks(
            address(this),
            bytes4(keccak256("assertFail()")),
            abi.encode(0)
        );
    }

    function assertFail() public pure returns (bool) {
        assert(1 == 0);
        return false;
    }

    function preHooks(
        address target,
        bytes4 selector,
        bytes memory callData
    ) public preHook(target, selector, callData) {
        // pass
    }
}
