// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import "./Helper.sol";

contract HooksTest is Test, Helper {
    function test_preHooks(address target, string memory signature, bytes memory callData) public {
        /// @dev call can update the state in its own right! so state may be different after the call (fix)
        if (!_call(target, signature, callData)) {
            vm.expectRevert();
        }
        _preHooks(target, signature, callData);
    }

    function test_postHooks(address target, string memory signature, bytes memory callData) public {
        /// @dev call can update the state in its own right! so state may be different after the call (fix)
        if (!_call(target, signature, callData)) {
            vm.expectRevert();
        }
        _postHooks(target, signature, callData);
    }

    function test_safePreHooks(address target, string memory signature, bytes memory callData) public {
        if (!_safecall(target, signature, callData)) {
            vm.expectRevert();
        }
        _safePreHooks(target, signature, callData);
    }

    function test_safePostHooks(address target, string memory signature, bytes memory callData) public {
        if (!_safecall(target, signature, callData)) {
            vm.expectRevert();
        }
        _safePostHooks(target, signature, callData);
    }
}
