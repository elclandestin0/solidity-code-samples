// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract SimpleStorage {
    // setting data as public will automatically spawn a getter() for data
    string public data = 'mydata';
    
    // setter() function for data executes as a transaction
    function set(string memory _data) public {
        data = _data;
    }
    
    // view function keyword allows us to peek into the storage state
    // view function also executes as a call()
    function get() view public returns (string memory) {
        return data;
    }
}