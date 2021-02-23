// SPDX-License-Identifier: 1.10
pragma solidity 0.7.4;

contract FirstContract { 
    // solidity structure goes like this ... start with data-type, then add a keyword modifier. public, in this case, ensures `peopleCount` always has a getter
    uint256 public peopleCount = 0;

    // opening time now in epoch time
    uint256 openingTime = 1614006678;

    // mapping emulates a hash table, except the values are never set. the key data is stored in a keccak256 hash used to look up its value
    // Keytypes are limited from mapping, dynamically sized array, a contract, an enumerator and a struct. Value types can be anything
    mapping(uint => Person) public people;

    // the address of ETH wallets on the Blockchain. regular address holds 20 byte value size. Address payable holds additional members transfer and send.
    address owner;

    // modifier that only allows the owner of this smart contract to make changes
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // modifier that only allows functions to pass while the contract is open b/w a certain time
    modifier onlyWhileOpen() {
        require(block.timestamp >= openingTime);
        _;
    }

    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }

    // In this function we skip incrementing the stateVariable right away and opt for creating a local variable in the function first, assigning to state, incrementing
    // then reassigning back to the state. This saves us a good amount of gas.
    function incrementCount() 
        public {
            uint256 _peopleCount;
            _peopleCount = peopleCount;
            _peopleCount += 1;
            peopleCount = _peopleCount;
    }

    function addPerson(
    string memory _firstName, 
    string memory _lastName
    ) 
    public 
    onlyOwner
    onlyWhileOpen {
        incrementCount();
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
    }
}
