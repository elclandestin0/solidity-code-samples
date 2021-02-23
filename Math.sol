// SPDX-License-Identifier: 1.11
pragma solidity ^0.7.4;

library Math {
    // internal means private in OOP while pure functions ensure that they neither read nor modify the state
    function divide(uint256 a, uint256 b) internal pure returns(uint256) {
        // since this isn't a modifier, we don't need to add _; after require();
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
}
