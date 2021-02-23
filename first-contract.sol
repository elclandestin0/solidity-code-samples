// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract FirstToken {
    address public minter;

    // hash tables with address keys and uint balances
    mapping (address => uint) public balances;

    // Event that gets triggered when an address sends another address some cash
    event Sent(address from, address to, uint amount);

    // Constructor whose code is run only when the contract is created
    constructor() {
        minter = msg.sender;
    }

    // creating a coin for the minter (whoever deploys the contract first)
    function mint(address receiver, uint amount) public {
        if (msg.sender != minter) return;
        balances[receiver] += amount;
    }

    // If the balance of the sender is lesser than the amount intended to send, don't send
    // else, subtract amount from msg.sender and add the amount to the receiver. Then emit the event!
    function send(address receiver, uint amount) public {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}