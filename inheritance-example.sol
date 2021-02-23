// SPDX-License-Identifier: 1.11
pragma solidity ^0.7.4;

// Seperate token to be referenced by FirstNationChain
contract ERC20Token {
    string public name;
    mapping(address => uint256) public balances;

    constructor(string memory _name) public {
        name = _name;
    }

    function mint() public {
        // gas cost?
        // the below is a caveat of Solidity. Although this can initially work and is valid,
        // it only records the ADDRESS of the sender from the other contract .. not the TX.origin 
        // balances[msg.sender]++;
        balances[tx.origin]++;
    }
}

// 'is' identifier is used for inheritance
contract MyToken is ERC20Token {
    string public symbol;
    address[] public owners;
    uint256 ownerCount;
    
    constructor(
        string memory _name, 
        string memory _symbol
        ) 
        ERC20Token(_name) 
        public {
            symbol = _symbol;
    }

    function mint() public override {
        super.mint();
        // this process saves gas
        uint256 _ownerCount;
        _ownerCount = ownerCount;
        _ownerCount++;
        ownerCount = _ownerCount;
        //
        owners.push(msg.sender);
    }
}


/*
contract FirstNationChain {

    // state variable of wallet so that we can send funds to this wallet
    // payable is an extra modifier that identifies a payable wallet
    address payable wallet;
    address token;

    constructor(address payable _wallet) public {
        wallet = _wallet;
        token = _token;
    }

    // external can only be called outside the smart contract
    function() external payable {
        buyToken();
    }

    // buy token and send ether to the wallet
    function buyToken() public payable {
        // When a smartToken is being initialized from another contract, make sure to use the keyword
        // `tx.origin` as the BC needs to recognize where the tx came from rather than the sender of the person
        // calling the Token's function 
        ERC20TOoken _token = ERC20Token(address(token));
        _token.mint(); 
        wallet.transfer(msg.value);
    }
}
*/