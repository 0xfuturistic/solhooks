// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Hooks
/// @notice A contract that provides pre and post hooks to arbitrary functions
contract Hooks {
    modifier preHook(function (bytes memory) external f, bytes memory input) {
        f(input);
        _;
    }

    modifier postHook(function (bytes memory) external f, bytes memory input) {
        _;
        f(input);
    }

    modifier staticPreHook(function (bytes memory) external f, bytes memory input) {
        (bool success,) = f.address.staticcall(abi.encodeWithSelector(f.selector, input));
        require(success);
        _;
    }

    modifier staticPostHook(function (bytes memory) external f, bytes memory input) {
        _;
        (bool success,) = f.address.staticcall(abi.encodeWithSelector(f.selector, input));
        require(success);
    }

    modifier payablePreHook(function (bytes memory) payable external f, bytes memory input) {
        f(input);
        _;
    }

    modifier payablePostHook(function (bytes memory) payable external f, bytes memory input) {
        _;
        f(input);
    }
}
