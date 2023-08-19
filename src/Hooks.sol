// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Hooks
/// @notice A contract that provides pre and post hooks to arbitrary functions
contract Hooks {
    modifier preHook(function (bytes calldata) external f, bytes calldata input) {
        f(input);
        _;
    }

    modifier postHook(function (bytes calldata) external f, bytes calldata input) {
        _;
        f(input);
    }

    modifier staticPreHook(function (bytes calldata) external f, bytes calldata input) {
        (bool success,) = f.address.staticcall(abi.encodeWithSelector(f.selector, input));
        require(success);
        _;
    }

    modifier staticPostHook(function (bytes calldata) external f, bytes calldata input) {
        _;
        (bool success,) = f.address.staticcall(abi.encodeWithSelector(f.selector, input));
        require(success);
    }

    modifier payablePreHook(function (bytes calldata) payable external f, bytes calldata input) {
        f(input);
        _;
    }

    modifier payablePostHook(function (bytes calldata) payable external f, bytes calldata input) {
        _;
        f(input);
    }
}
