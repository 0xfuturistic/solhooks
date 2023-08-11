// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @dev Error for when a safe hook fails.
/// @param source The address of the contract that initiated the hook.
/// @param target The address of the contract that was the target of the hook.
/// @param signature The signature of the function that was called as part of the hook.
/// @param callData The calldata that was passed to the function as part of the hook.
error SafeHookFailed(address source, address target, string signature, bytes callData);

/// @dev Error for when an unsafe hook fails.
/// @param source The address of the contract that initiated the hook.
/// @param target The address of the contract that was the target of the hook.
/// @param signature The signature of the function that was called as part of the hook.
/// @param callData The calldata that was passed to the function as part of the hook.
error UnsafeHookFailed(address source, address target, string signature, bytes callData);

/**
 * /// @title Hooks
 * /// @notice A contract that provides pre and post hooks for function calls to other contracts.
 */

contract Hooks {
    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Modifier that executes an unsafe hook before the function call.
    /// If the hook fails, the function call is reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    modifier preHook(address target, string memory signature, bytes memory callData) {
        _unsafeHook(target, signature, callData);
        _;
    }

    /// @notice Modifier that executes an unsafe hook after the function call.
    /// If the hook fails, the function call is still successful.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    modifier postHook(address target, string memory signature, bytes memory callData) {
        _;
        _unsafeHook(target, signature, callData);
    }

    /// @notice Modifier that executes a safe hook before the function call.
    /// If the hook fails, the function call is reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    modifier safePreHook(address target, string memory signature, bytes memory callData) {
        _safeHook(target, signature, callData);
        _;
    }

    /// @notice Modifier that executes a safe hook after the function call.
    /// If the hook fails, the function call is still successful.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    modifier safePostHook(address target, string memory signature, bytes memory callData) {
        _;
        _safeHook(target, signature, callData);
    }

    /*//////////////////////////////////////////////////////////////
                              HOOKS LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Executes an unsafe hook before the function call.
    /// If the hook fails, the function call is reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    function _unsafeHook(address target, string memory signature, bytes memory callData) internal {
        if (!_call(target, signature, callData)) {
            revert UnsafeHookFailed(address(this), target, signature, callData);
        }
    }

    /// @notice Executes a safe hook before the function call.
    /// If the hook fails, the function call is reverted.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    function _safeHook(address target, string memory signature, bytes memory callData) internal view {
        if (!_safecall(target, signature, callData)) {
            revert SafeHookFailed(address(this), target, signature, callData);
        }
    }

    /*//////////////////////////////////////////////////////////////
                              CALLS LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Executes a function call to another contract.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    /// @return success A boolean indicating whether the function call was successful.
    function _call(address target, string memory signature, bytes memory callData) internal returns (bool success) {
        (success,) = target.call(abi.encodeWithSignature(signature, callData));
    }

    /// @notice Executes a function call to another contract in a read-only context.
    /// @param target The address of the contract to call.
    /// @param signature The function signature to call.
    /// @param callData The encoded function arguments to call.
    /// @return success A boolean indicating whether the function call was successful.
    function _safecall(address target, string memory signature, bytes memory callData)
        internal
        view
        returns (bool success)
    {
        (success,) = target.staticcall(abi.encodeWithSignature(signature, callData));
    }
}
