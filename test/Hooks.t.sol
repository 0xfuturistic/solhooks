// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import "./Helper.sol";

contract HooksTest is Test, Helper {
    function test_preHooks(address addr, bytes4 selector, bytes calldata input) public pure {
        function (bytes calldata) external pure f;
        assembly {
            f.address := addr
            f.selector := selector
        }

        assert(f.address == addr);
        assert(f.selector == selector);

        //(bool success,) = f.address.staticcall(abi.encodeWithSelector(f.selector, input));

        // if (!success) {
        //vm.expectRevert();
        //}

        //_preHook(f, input);
    }

    function _preHook(function (bytes calldata) external f, bytes calldata input) internal preHook(f, input) {}
}
