// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hooks {
    modifier preHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        if (!_call(target, signature, callData)) {
            revert("preHook failed");
        }
        _;
    }

    modifier postHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        _;
        if (!_call(target, signature, callData)) {
            revert("postHook failed");
        }
    }

    modifier safePreHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        if (!_safecall(target, signature, callData)) {
            revert("preStaticHook failed");
        }
        _;
    }

    modifier safePostHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        _;
        if (!_safecall(target, signature, callData)) {
            revert("postStaticHook failed");
        }
    }

    function _call(
        address target,
        string memory signature,
        bytes memory callData
    ) internal returns (bool success) {
        (success, ) = target.call(abi.encodeWithSignature(signature, callData));
    }

    function _safecall(
        address target,
        string memory signature,
        bytes memory callData
    ) internal view returns (bool success) {
        (success, ) = target.staticcall(
            abi.encodeWithSignature(signature, callData)
        );
    }
}
