// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Bank
/// @author Memo Khoury
/// @dev add info here when you can

contract Bank {
    uint256 private _clientCount;
    mapping(address => uint256) private _balances;
    address private _owner;

    event LogDepositMade(address indexed owner, uint256 indexed amount);

    constructor() payable {
        require(
            msg.value > 10 ether,
            "The bank needs at least 10 ethereum to open."
        );
        _owner = msg.sender;
    }

    function register() public payable {
        require(
            msg.value >= 1 ether,
            "Must have at least 1 ether or more to register in this bank!"
        );
        // the following 3 lines of code may seem redundant, but it actually saves us some gas!
        uint256 count = _clientCount;
        count = count + 1;
        _clientCount = count;

        // add a new customer with a balance of the msg.value
        _balances[msg.sender] = msg.value;
    }

    function deposit() public payable {
        require(
            msg.value > 0.01 ether,
            "A minimum of 0.01 ether is required to deposit to this bank!"
        );
        uint256 value = _balances[msg.sender] + msg.value;
        _balances[msg.sender] = value;
        emit LogDepositMade((msg.sender), value);
    }

    function withdraw(uint256 withdrawAmount_) public returns (uint256) {
        require(
            withdrawAmount_ < _balances[msg.sender],
            "Cannot withdraw amount that's greater than the balance of the address"
        );
        if (withdrawAmount_ < _balances[msg.sender]) {
            uint256 finalBalance = _balances[msg.sender] - withdrawAmount_;
            _balances[msg.sender] = finalBalance;
            payable(msg.sender).transfer(withdrawAmount_);
        }
        return _balances[msg.sender];
    }

    // add to bank fund 
    function addToBankFund() public payable {
        require(
            msg.value > 1 ether,
            "A minimum of 1 ether is required to deposit to this bank!"
        );
    }

    // get the fund of the bank, aka the amount of ethers in this contract
    function bankFund() public view returns (uint256) {
        return address(this).balance;
    }

    // All the getters of the state variables
    function balances(address user_) public view returns (uint256) {
        return _balances[user_];
    }

    function clientCount() public view returns (uint256) {
        return _clientCount;
    }

    function owner() public view returns (address) {
        return _owner;
    }
}
