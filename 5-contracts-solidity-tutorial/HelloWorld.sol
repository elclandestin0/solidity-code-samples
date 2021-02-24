// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract HelloWorld {
    
    // for a function to return a type it must use the `returns()` keyword along with the type inside the brackets
    function hello() pure public returns(string memory) {
        return 'Hello World!';
    }
}