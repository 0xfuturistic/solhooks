// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hooks {
    modifier preStaticHook(
        address target,
        bytes4 selector,
        bytes memory data
    ) {
        (bool success, ) = target.staticcall(
            abi.encodeWithSelector(selector, data)
        );
        if (!success) {
            revert("preStaticHook failed");
        }
        _;
    }

    modifier postStaticHook(
        address target,
        bytes4 selector,
        bytes memory data
    ) {
        _;
        (bool success, ) = target.staticcall(
            abi.encodeWithSelector(selector, data)
        );
        if (!success) {
            revert("postStaticHook failed");
        }
    }

    modifier preHook(
        address target,
        bytes4 selector,
        bytes memory data
    ) {
        (bool success, ) = target.call(abi.encodeWithSelector(selector, data));
        if (!success) {
            revert("preHook failed");
        }
        _;
    }

    modifier postHook(
        address target,
        bytes4 selector,
        bytes memory data
    ) {
        _;
        (bool success, ) = target.call(abi.encodeWithSelector(selector, data));
        if (!success) {
            revert("postHook failed");
        }
    }
}
