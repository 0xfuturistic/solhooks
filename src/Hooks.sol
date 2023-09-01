// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Hooks {
    error HookFailed();

    modifier PreHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) {
        (bool success,) = funAddress.call{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) {
            revert HookFailed();
        }
        _;
    }

    modifier PostHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) {
        _;
        (bool success,) = funAddress.call{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) {
            revert HookFailed();
        }
    }

    modifier PreHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) {
        (bool success,) = funAddress.staticcall{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) {
            revert HookFailed();
        }
        _;
    }

    modifier PostHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) {
        _;
        (bool success,) = funAddress.staticcall{gas: gas}(abi.encodeWithSelector(funSelector, input));
        if (!success) {
            revert HookFailed();
        }
    }
}
