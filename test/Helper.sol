// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Hooks} from "../src/Hooks.sol";

contract Helper is Hooks {
    function mockFunction(bytes calldata input) external pure {
        assert(keccak256(input) != keccak256(""));
    }
}
