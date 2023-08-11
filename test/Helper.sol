// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Hooks} from "../src/Hooks.sol";

contract Helper is Hooks {
    event SafePreHook(address target, string signature, bytes callData);

    event SafePostHook(address target, string signature, bytes callData);

    function _preHooks(address target, string memory signature, bytes memory callData)
        internal
        preHook(target, signature, callData)
    {
        // cannot emit event here bc it would modify the stack and make test fail
    }

    function _postHooks(address target, string memory signature, bytes memory callData)
        internal
        postHook(target, signature, callData)
    {
        // cannot emit event here bc it would modify the stack and make test fail
    }

    function _safePreHooks(address target, string memory signature, bytes memory callData)
        internal
        safePreHook(target, signature, callData)
    {
        emit SafePreHook(target, signature, callData);
    }

    function _safePostHooks(address target, string memory signature, bytes memory callData)
        internal
        safePostHook(target, signature, callData)
    {
        emit SafePostHook(target, signature, callData);
    }
}
