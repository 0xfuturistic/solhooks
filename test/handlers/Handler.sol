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

    address public ghost_funAddress_success;
    bytes4 public ghost_funSelector_success;
    bytes public ghost_input_success;
    uint256 public ghost_gas_success;

    address public ghost_funAddress_fail;
    bytes4 public ghost_funSelector_fail;
    bytes public ghost_input_fail;
    uint256 public ghost_gas_fail;

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
        console.log("preHookStatic", calls["preHookStatic"]);
        console.log("postHookStatic", calls["postHookStatic"]);
        console.log("-------------------");
    }

    function preHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("preHookStatic")
    {
        try hooks.preHookStatic(funAddress, funSelector, input, gas) {
            _setGhostSuccess(funAddress, funSelector, input, gas);
        } catch {
            _setGhostFail(funAddress, funSelector, input, gas);
        }
    }

    function postHookStatic(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas)
        public
        countCall("postHookStatic")
    {
        try hooks.postHookStatic(funAddress, funSelector, input, gas) {
            _setGhostSuccess(funAddress, funSelector, input, gas);
        } catch {
            _setGhostFail(funAddress, funSelector, input, gas);
        }
    }

    function _setGhostSuccess(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) internal {
        ghost_funAddress_success = funAddress;
        ghost_funSelector_success = funSelector;
        ghost_input_success = input;
        ghost_gas_success = gas;
    }

    function _setGhostFail(address funAddress, bytes4 funSelector, bytes memory input, uint256 gas) internal {
        ghost_funAddress_fail = funAddress;
        ghost_funSelector_fail = funSelector;
        ghost_input_fail = input;
        ghost_gas_fail = gas;
    }
}
