// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Hooks} from "../src/Hooks.sol";

contract HooksHelper is Hooks {
    function _preHooks(address target, string memory signature, bytes memory callData)
        internal
        preHook(target, signature, callData)
    {
        // pass
    }

    function _postHooks(address target, string memory signature, bytes memory callData)
        internal
        postHook(target, signature, callData)
    {
        // pass
    }

    function _safePreHooks(address target, string memory signature, bytes memory callData)
        internal
        safePreHook(target, signature, callData)
    {
        // pass
    }

    function _safePostHooks(address target, string memory signature, bytes memory callData)
        internal
        safePostHook(target, signature, callData)
    {
        // pass
    }
}
