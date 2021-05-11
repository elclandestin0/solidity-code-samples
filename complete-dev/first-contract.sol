// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Inbox {
    string public message;
    
    
    constructor(string memory initialMessage) {
        message = initialMessage;
    }
    
    // function name(arguments) + function type + return types
    function setMessage(string memory _message) public {
        message = _message;
    }

    // function name() + function type + return types
    function getMessage() public view returns (string memory){
        return message;
    }
}