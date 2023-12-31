// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";
import {Handler} from "./handlers/Handler.sol";

contract HooksTest is Test {
    Hooks public hooks;
    Handler public handler;

    function setUp() public {
        hooks = new Hooks();
        handler = new Handler(hooks);

        bytes4[] memory selectors = new bytes4[](4);
        selectors[0] = handler.preHook.selector;
        selectors[1] = handler.postHook.selector;
        selectors[2] = handler.preHookStatic.selector;
        selectors[3] = handler.postHookStatic.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    /// NON-STATIC HOOKS
    function test_preHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        vm.mockCall(funAddress, abi.encodeWithSelector(funSelector, input), abi.encode(""));
        vm.expectCall(funAddress, abi.encodeWithSelector(funSelector, input));
        hooks.preHook(funAddress, funSelector, input, gas);
    }

    function test_postHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        vm.mockCall(funAddress, abi.encodeWithSelector(funSelector, input), abi.encode(""));
        vm.expectCall(funAddress, abi.encodeWithSelector(funSelector, input));
        hooks.postHook(funAddress, funSelector, input, gas);
    }

    function testFail_preHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        vm.mockCallRevert(funAddress, abi.encodeWithSelector(funSelector, input), "");
        vm.expectCall(funAddress, abi.encodeWithSelector(funSelector, input));
        hooks.preHook(funAddress, funSelector, input, gas);
    }

    function testFail_postHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        vm.mockCallRevert(funAddress, abi.encodeWithSelector(funSelector, input), "");
        vm.expectCall(funAddress, abi.encodeWithSelector(funSelector, input));
        hooks.postHook(funAddress, funSelector, input, gas);
    }

    /// STATIC HOOKS
    function test_preHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        (bool success,) = funAddress.staticcall{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) vm.expectRevert();
        hooks.preHookStatic(funAddress, funSelector, input, gas);
    }

    function test_postHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        (bool success,) = funAddress.staticcall{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) vm.expectRevert();
        hooks.preHookStatic(funAddress, funSelector, input, gas);
    }

    function invariant_staticHooks() public {
        if (handler.ghost_funAddress() == address(0)) return;
        (bool success,) = handler.ghost_funAddress().staticcall{gas: handler.ghost_gas()}(
            abi.encodeWithSelector(handler.ghost_funSelector(), handler.ghost_input())
        );
        if (handler.ghost_success()) {
            assertTrue(success);
        } else {
            assertFalse(success);
        }
    }

    function invariant_callSummary() public view {
        handler.callSummary();
    }
}
