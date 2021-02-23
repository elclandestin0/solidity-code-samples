// SPDX-License-Identifier: 1.11
pragma solidity ^0.7.4;
import "./Math.sol";

contract MyContract {
    // DRY - DO NOT REPEAT YOURSELF
    uint256 public value;

    function calculate(uint _value1, uint _value2) public {
        value = Math.divide(_value1, _value2);
    }
}
