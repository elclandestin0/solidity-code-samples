// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ReceiverPays {
    // Whoever created this contract is the owner of it.
    // In this case, the owner is Bob.
    address owner = msg.sender;

    // The nonce  are there to keep track of how many 
    // transactions have been sent out of this contract.
    // This protects against a replay attack.
    mapping(uint256 => bool) usedNonces;

    constructor() payable {}

    /// builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
    
    /// destroy the contract and reclaim the leftover funds.
    function shutdown() public {
        require(msg.sender == owner);
        selfdestruct(payable(msg.sender));
    }

    function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) public {
        // Has this nonce already been used?
        require(!usedNonces[nonce]);

        // Assign this nonce as already used
        usedNonces[nonce] = true;
        
        // this recereates the message that was signed on the client
        bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));

        // transfer the amount to this contract to Bob
        payable(msg.sender).transfer(amount);
    }

    
}