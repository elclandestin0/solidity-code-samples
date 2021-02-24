// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract AdvancedStorage {
    /*
        The Ethereum Virtual Machine has three areas where it can store items.
        The first is “storage”, where all the contract state variables reside. 
        The second is “memory”, this is used to hold temporary values. 
        The third one is the stack, which is used to hold small local variables.
        For almost all types, you cannot specify where they should be stored, because they are copied everytime they are used.
    */
    
    uint[] public ids;
    
    function add(uint id) public {
        ids.push(id);
    }
    
    function 
        get(uint position)
        view public 
        returns (uint) {
            require(position <= ids.length - 1);
            return ids[position];
    }
    
    // we specify the memory location here because this is a complex type and we have to specify the memory type.
    function getAll() view public returns (uint[] memory) {
        return ids;
    }
    
    function length() view public returns (uint) {
        return ids.length;
    }
}