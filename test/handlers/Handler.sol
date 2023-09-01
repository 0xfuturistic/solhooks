// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {console} from "forge-std/console.sol";
import {Hooks} from "../../src/Hooks.sol";

contract Handler is Hooks, CommonBase, StdCheats, StdUtils {
    Hooks public hooks;

    mapping(bytes32 => uint256) public calls;

    address public ghost_funAddress_success;
    bytes4 public ghost_funSelector_success;
    bytes public ghost_input_success;
    uint256 public ghost_gas_success;

    modifier countCall(bytes32 key) {
        calls[key]++;
        _;
    }

    constructor(Hooks hooks_) {
        hooks = hooks_;
    }

    function preHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("preHookStatic")
        PreHookStatic(funAddress, funSelector, input, gas)
    {
        _setGhostSuccess(funAddress, funSelector, input, gas);
    }

    function postHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("postHook")
        PostHookStatic(funAddress, funSelector, input, gas)
    {
        _setGhostSuccess(funAddress, funSelector, input, gas);
    }

    function callSummary() external view {
        console.log("Call summary:");
        console.log("-------------------");
        console.log("preHookStatic", calls["preHookStatic"]);
        console.log("postHookStatic", calls["postHookStatic"]);
        console.log("-------------------");
    }

    function _setGhostSuccess(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) internal {
        ghost_funAddress_success = funAddress;
        ghost_funSelector_success = funSelector;
        ghost_input_success = input;
        ghost_gas_success = gas;
    }
}
