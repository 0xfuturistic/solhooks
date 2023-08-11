// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Hooks} from "../src/Hooks.sol";

contract HooksImplementer is Hooks {
    event PreHook(address target, string signature, bytes callData);

    event PostHook(address target, string signature, bytes callData);

    event PreStaticHook(address target, string signature, bytes callData);

    event PostStaticHook(address target, string signature, bytes callData);

    function preHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) external preHook(target, signature, callData) {
        emit PreHook(target, signature, callData);
    }

    function postHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) external postHook(target, signature, callData) {
        emit PostHook(target, signature, callData);
    }

    function preStaticHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) external preStaticHook(target, signature, callData) {
        emit PreStaticHook(target, signature, callData);
    }

    function postStaticHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) external postStaticHook(target, signature, callData) {
        emit PostStaticHook(target, signature, callData);
    }
}
