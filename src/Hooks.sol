// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Hooks
/// @notice A contract that provides pre and post hooks to arbitrary functions
contract Hooks {
    error HookFailed();

    modifier preHook(function (bytes memory) external f, bytes memory input, uint256 gasLimit) {
        (bool success,) = f.address.call{gas: gasLimit}(abi.encodeWithSelector(f.selector, input));
        if (!success) {
            revert HookFailed();
        }
        _;
    }

    modifier postHook(function (bytes memory) external f, bytes memory input, uint256 gasLimit) {
        _;
        (bool success,) = f.address.call{gas: gasLimit}(abi.encodeWithSelector(f.selector, input));
        if (!success) {
            revert HookFailed();
        }
    }

    modifier staticPreHook(function (bytes memory) external f, bytes memory input, uint256 gasLimit) {
        (bool success,) = f.address.staticcall{gas: gasLimit}(abi.encodeWithSelector(f.selector, input));
        if (!success) {
            revert HookFailed();
        }
        _;
    }

    modifier staticPostHook(function (bytes memory) external f, bytes memory input, uint256 gasLimit) {
        _;
        (bool success,) = f.address.staticcall{gas: gasLimit}(abi.encodeWithSelector(f.selector, input));
        if (!success) {
            revert HookFailed();
        }
    }

    modifier payablePreHook(function (bytes memory) payable external f, bytes memory input, uint256 gasLimit) {
        f(input);
        _;
    }

    modifier payablePostHook(function (bytes memory) payable external f, bytes memory input, uint256 gasLimit) {
        _;
        f(input);
    }
}
