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

    modifier countCall(bytes32 key) {
        calls[key]++;
        _;
    }

    constructor(Hooks hooks_) {
        hooks = hooks_;
    }

    function handlerPreHook(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("preHook")
        preHook(funAddress, funSelector, input, gas)
    {}

    function callSummary() external view {
        console.log("Call summary:");
        console.log("-------------------");
        console.log("preHook", calls["preHook"]);
        console.log("-------------------");
    }
}
