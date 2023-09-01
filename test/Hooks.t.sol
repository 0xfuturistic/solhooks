// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";
import {Handler} from "./handlers/Handler.sol";

contract HooksTest is Test {
    Hooks public hooks;
    Handler public handler;

    function setUp() public {
        hooks = new Hooks();
        handler = new Handler(hooks);

        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = handler.preHookStatic.selector;
        selectors[1] = handler.postHookStatic.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    function invariant_success() public {
        (bool success,) = handler.ghost_funAddress_success().staticcall{gas: handler.ghost_gas_success()}(
            abi.encodeWithSelector(handler.ghost_funSelector_success(), handler.ghost_input_success())
        );

        assertTrue(success);
    }

    function test_preHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        (bool success,) = funAddress.staticcall{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) vm.expectRevert();
        handler.preHookStatic(funAddress, funSelector, input, gas);
    }

    function invariant_callSummary() public view {
        handler.callSummary();
    }
}
