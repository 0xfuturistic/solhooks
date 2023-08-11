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
