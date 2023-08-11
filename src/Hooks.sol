// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Types.sol";

/// @title Hooks
/// @notice A contract that provides pre and post hooks for function calls to other contracts.
contract Hooks {
    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Modifier that executes an UNSAFE hook BEFORE the function call.
    /// If the hook fails, the function call is reverted.
    /// If state is modified by the hook, the function call isn't necessarily reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    modifier preHook(address target, string memory signature, bytes memory callData) {
        _unsafeHook(target, signature, callData);
        _;
    }

    /// @notice Modifier that executes an UNSAFE hook AFTER the function call.
    /// If the hook's execution fails, the function call is reverted.
    /// If state is modified by the hook, the function call isn't necessarily reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    modifier postHook(address target, string memory signature, bytes memory callData) {
        _;
        _unsafeHook(target, signature, callData);
    }

    /// @notice Modifier that executes a SAFE hook BEFORE the function call.
    /// If the hook's execution fails, the function call is reverted.
    /// If the state is modified by the hook, the function call is reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    modifier safePreHook(address target, string memory signature, bytes memory callData) {
        _safeHook(target, signature, callData);
        _;
    }

    /// @notice Modifier that executes a SAFE hook AFTER the function call.
    /// If the hook's execution fails, the function call is reverted.
    /// If the state is modified by the hook, the function call is reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    modifier safePostHook(address target, string memory signature, bytes memory callData) {
        _;
        _safeHook(target, signature, callData);
    }

    /*//////////////////////////////////////////////////////////////
                              HOOKS LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Executes an unsafe hook.
    /// If execution fails, a revert occurs.
    /// If state is modified by the hook, the function call isn't necessarily reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    function _unsafeHook(address target, string memory signature, bytes memory callData) internal {
        if (!_call(target, signature, callData)) {
            revert UnsafeHookFailed(address(this), target, signature, callData);
        }
    }

    /// @notice Executes a safe hook.
    /// If execution fails, a revert occurs.
    /// If the state is modified by the hook, the function call is reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    function _safeHook(address target, string memory signature, bytes memory callData) internal view {
        if (!_safecall(target, signature, callData)) {
            revert SafeHookFailed(address(this), target, signature, callData);
        }
    }

    /*//////////////////////////////////////////////////////////////
                              CALLS LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Executes a call to a contract.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    /// @return success A boolean indicating whether the call was successful or not.
    function _call(address target, string memory signature, bytes memory callData) internal returns (bool success) {
        (success,) = target.call(abi.encodeWithSignature(signature, callData));
    }

    /// @notice Executes a static call to a contract.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to pass to the call.
    /// @return success A boolean indicating whether the call was successful or not.
    function _safecall(address target, string memory signature, bytes memory callData)
        internal
        view
        returns (bool success)
    {
        (success,) = target.staticcall(abi.encodeWithSignature(signature, callData));
    }
}
