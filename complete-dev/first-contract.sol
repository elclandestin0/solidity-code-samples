// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Inbox {
    string public message;
    
    
    function inbox(string memory initialMessage) public {
        message = initialMessage;
    }

    function setMessage(string memory _message) public {
        message = _message;
    }

    function getMessage() public view returns (string memory){
        return message;
    }
}