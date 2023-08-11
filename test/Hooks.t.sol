// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";

import "./Helper.sol";

contract HooksTest is Test, Hooks {
    HooksImplementer hooksImpl;

    function setUp() public {
        hooksImpl = new HooksImplementer();
    }

    function test_preHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) public {
        if (!_call(target, signature, callData)) {
            vm.expectRevert();
        }
        hooksImpl.preHooks(target, signature, callData);
    }

    function test_postHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) public {
        if (!_call(target, signature, callData)) {
            vm.expectRevert();
        }
        hooksImpl.postHooks(target, signature, callData);
    }

    function test_preStaticHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) public {
        if (!_staticcall(target, signature, callData)) {
            vm.expectRevert();
        }
        hooksImpl.preStaticHooks(target, signature, callData);
    }

    function test_postStaticHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) public {
        if (!_staticcall(target, signature, callData)) {
            vm.expectRevert();
        }
        hooksImpl.postStaticHooks(target, signature, callData);
    }

    /*//////////////////////////////////////////////////////////////
                                 INTERNAL
    //////////////////////////////////////////////////////////////*/

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
