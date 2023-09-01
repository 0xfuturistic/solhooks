// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {console} from "forge-std/console.sol";
import {Hooks} from "../../src/Hooks.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
    Hooks public hooks;

    mapping(bytes32 => uint256) public calls;

    bool public ghost_success;
    address public ghost_funAddress;
    bytes4 public ghost_funSelector;
    bytes public ghost_input;
    uint256 public ghost_gas;

    modifier countCall(bytes32 key) {
        calls[key]++;
        _;
    }

    constructor(Hooks hooks_) {
        hooks = hooks_;
    }

    function callSummary() external view {
        console.log("Call summary:");
        console.log("-------------------");
        console.log("preHook", calls["preHook"]);
        console.log("postHook", calls["postHook"]);
        console.log("preHookStatic", calls["preHookStatic"]);
        console.log("postHookStatic", calls["postHookStatic"]);
        console.log("-------------------");
    }

    function preHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("preHook")
    {
        hooks.preHook(funAddress, funSelector, input, gas);
    }

    function postHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("postHook")
    {
        hooks.postHook(funAddress, funSelector, input, gas);
    }

    function preHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("preHookStatic")
    {
        try hooks.preHookStatic(funAddress, funSelector, input, gas) {
            _setGhost(true, funAddress, funSelector, input, gas);
        } catch {
            _setGhost(false, funAddress, funSelector, input, gas);
        }
    }

    function postHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("postHookStatic")
    {
        try hooks.postHookStatic(funAddress, funSelector, input, gas) {
            _setGhost(true, funAddress, funSelector, input, gas);
        } catch {
            _setGhost(false, funAddress, funSelector, input, gas);
        }
    }

    function _setGhost(bool success, address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        internal
    {
        ghost_success = success;
        ghost_funAddress = funAddress;
        ghost_funSelector = funSelector;
        ghost_input = input;
        ghost_gas = gas;
    }
}
