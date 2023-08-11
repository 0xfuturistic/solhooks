// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Hooks} from "../src/Hooks.sol";

contract HooksHelper is Hooks {
    event PreHook(address target, string signature, bytes callData);

    event PostHook(address target, string signature, bytes callData);

    event PreStaticHook(address target, string signature, bytes callData);

    event PostStaticHook(address target, string signature, bytes callData);

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

    function _preStaticHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal preStaticHook(target, signature, callData) {
        emit PreStaticHook(target, signature, callData);
    }

    function _postStaticHooks(
        address target,
        string memory signature,
        bytes memory callData
    ) internal postStaticHook(target, signature, callData) {
        emit PostStaticHook(target, signature, callData);
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
