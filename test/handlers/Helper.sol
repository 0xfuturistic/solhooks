// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Hooks} from "../../src/Hooks.sol";

contract Helper is Hooks {
    function mockPreHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        preHook(funAddress, funSelector, input, gas)
    {}

    function mockPostHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        postHook(funAddress, funSelector, input, gas)
    {}

    function mockPreHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        preHookStatic(funAddress, funSelector, input, gas)
    {}

    function mockPostHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        postHookStatic(funAddress, funSelector, input, gas)
    {}

    function mockPass() public pure {}

    function mockFail() public pure {
        revert("mock fail");
    }
}
