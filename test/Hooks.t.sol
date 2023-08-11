// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";

contract HooksTest is Test, Hooks {
    function setUp() public {}

    function test_preHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) public {
        if (!_staticcall(target, signature, callData)) {
            vm.expectRevert();
        }
        _preHooks(target, signature, callData);
    }

    function test_postHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) public {
        if (!_staticcall(target, signature, callData)) {
            vm.expectRevert();
        }
        _postHooks(target, signature, callData);
    }

    /*//////////////////////////////////////////////////////////////
                                 INTERNAL
    //////////////////////////////////////////////////////////////*/

    function _preHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal preStaticHook(target, signature, callData) {
        // pass
    }

    function _postHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal preStaticHook(target, signature, callData) {
        // pass
    }

    function _call(
        address target,
        string memory signature,
        bytes memory callData
    ) internal returns (bool success) {
        (success, ) = target.call(abi.encodeWithSignature(signature, callData));
    }

    function _staticcall(
        address target,
        string memory signature,
        bytes memory callData
    ) internal view returns (bool success) {
        (success, ) = target.staticcall(
            abi.encodeWithSignature(signature, callData)
        );
    }
}
