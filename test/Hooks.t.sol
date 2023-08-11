// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";

contract HooksTest is Test, Hooks {
    function setUp() public {}

    function test_preHooks(
        address target,
        bytes4 selector,
        bytes memory callData
    ) public {
        preHooks(target, selector, callData);
    }

    function testFail_preHooks(bytes memory callData) public {
        preHooks(address(this), bytes4(keccak256("assertFail()")), callData);
    }

    function test_postHooks(
        address target,
        bytes4 selector,
        bytes memory callData
    ) public {
        postHooks(target, selector, callData);
    }

    function testFail_postHooks(bytes memory callData) public {
        postHooks(address(this), bytes4(keccak256("assertFail()")), callData);
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

    function postHooks(
        address target,
        bytes4 selector,
        bytes memory callData
    ) public postHook(target, selector, callData) {
        // pass
    }
}
