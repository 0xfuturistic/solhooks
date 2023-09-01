// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Hooks} from "../src/Hooks.sol";
import {Handler} from "./handlers/Handler.sol";

contract CommitmentManagerTest is Test {
    Hooks public hooks;
    Handler public handler;

    function setUp() public {
        hooks = new Hooks();
        handler = new Handler(hooks);

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = handler.handlerPreHook.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));

        targetContract(address(handler));
    }

    function invariant_commitmentValidity() public view {}

    function invariant_callSummary() public view {
        handler.callSummary();
    }
}
