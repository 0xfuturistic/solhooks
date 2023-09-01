// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";
import {Handler} from "./handlers/Handler.sol";

contract HooksInvariants is Test {
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

    function invariant_staticHookSuccess() public {
        if (handler.ghost_funAddress_fail() == address(0)) return;
        (bool success,) = handler.ghost_funAddress_success().staticcall{gas: handler.ghost_gas_success()}(
            abi.encodeWithSelector(handler.ghost_funSelector_success(), handler.ghost_input_success())
        );
        assertTrue(success);
    }

    function invariant_staticHookFail() public {
        if (handler.ghost_funAddress_fail() == address(0)) return;
        (bool success,) = handler.ghost_funAddress_fail().staticcall{gas: handler.ghost_gas_fail()}(
            abi.encodeWithSelector(handler.ghost_funSelector_fail(), handler.ghost_input_fail())
        );
        assertFalse(success);
    }

    function invariant_callSummary() public view {
        handler.callSummary();
    }
}
