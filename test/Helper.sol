// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Hooks} from "../src/Hooks.sol";

contract HooksHelper is Hooks {
    event PreHook(address target, string signature, bytes callData);

    event PostHook(address target, string signature, bytes callData);

    event SafePreHook(address target, string signature, bytes callData);

    event SafePostHook(address target, string signature, bytes callData);

    function _preHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal preHook(target, signature, callData) {
        emit PreHook(target, signature, callData);
    }

    function _postHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal postHook(target, signature, callData) {
        emit PostHook(target, signature, callData);
    }

    function _safePreHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal safePreHook(target, signature, callData) {
        emit SafePreHook(target, signature, callData);
    }

    function _safePostHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal safePostHook(target, signature, callData) {
        emit SafePostHook(target, signature, callData);
    }
}
