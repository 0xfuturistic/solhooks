// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Hooks {
    modifier preStaticHook(
        address addr,
        bytes4 selector,
        bytes memory data
    ) {
        (bool success, ) = addr.staticcall(
            abi.encodeWithSelector(selector, data)
        );
        if (!success) {
            revert("preStaticHook failed");
        }
        _;
    }

    modifier postStaticHook(
        address addr,
        bytes4 selector,
        bytes memory data
    ) {
        _;
        (bool success, ) = addr.staticcall(
            abi.encodeWithSelector(selector, data)
        );
        if (!success) {
            revert("postStaticHook failed");
        }
    }

    modifier preHook(
        address addr,
        bytes4 selector,
        bytes memory data
    ) {
        (bool success, ) = addr.call(abi.encodeWithSelector(selector, data));
        if (!success) {
            revert("preHook failed");
        }
        _;
    }

    modifier postHook(
        address addr,
        bytes4 selector,
        bytes memory data
    ) {
        _;
        (bool success, ) = addr.call(abi.encodeWithSelector(selector, data));
        if (!success) {
            revert("postHook failed");
        }
    }
}
