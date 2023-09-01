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

    function test_preHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        _setup_vm_static(funAddress, funSelector, input, gas);
        handler.preHookStatic(funAddress, funSelector, input, gas);
    }

    function test_postHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) public {
        _setup_vm_static(funAddress, funSelector, input, gas);
        handler.postHookStatic(funAddress, funSelector, input, gas);
    }

    function invariant_staticHookSuccess() public {
        (bool success,) = handler.ghost_funAddress_success().staticcall{gas: handler.ghost_gas_success()}(
            abi.encodeWithSelector(handler.ghost_funSelector_success(), handler.ghost_input_success())
        );

        assertTrue(success);
    }

    function invariant_callSummary() public view {
        handler.callSummary();
    }

    function _setup_vm_static(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) internal {
        (bool success,) = funAddress.staticcall{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) vm.expectRevert();
    }
}
