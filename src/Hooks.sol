// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

error SafeHookFailed(address target, string signature, bytes callData);

error UnsafeHookFailed(address target, string signature, bytes callData);

contract Hooks {
    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier preHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        _unsafeHook(target, signature, callData);
        _;
    }

    modifier postHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        _;
        _unsafeHook(target, signature, callData);
    }

    modifier safePreHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        _safeHook(target, signature, callData);
        _;
    }

    modifier safePostHook(
        address target,
        string memory signature,
        bytes memory callData
    ) {
        _;
        _safeHook(target, signature, callData);
    }

    /*//////////////////////////////////////////////////////////////
                              HOOKS LOGIC
    //////////////////////////////////////////////////////////////*/
    function _unsafeHook(
        address target,
        string memory signature,
        bytes memory callData
    ) internal {
        if (!_call(target, signature, callData)) {
            revert UnsafeHookFailed(target, signature, callData);
        }
    }

    function _safeHook(
        address target,
        string memory signature,
        bytes memory callData
    ) internal view {
        if (!_safecall(target, signature, callData)) {
            revert SafeHookFailed(target, signature, callData);
        }
    }

    /*//////////////////////////////////////////////////////////////
                              CALLS LOGIC
    //////////////////////////////////////////////////////////////*/

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
