// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ReceiverPays {
    // Whoever created this contract is the owner of it.
    address owner = msg.sender;

    // The nonce  are there to keep track of how many 
    // transactions have been sent out of this contract.
    // This protects against a replay attack.
    mapping(uint256 => bool) usedNonces;

    constructor() payable {}

        
    function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) public {
        // Has this nonce already been used?
        require(!usedNonces[nonce]);

        // Assign this nonce as already used
        usedNonces[nonce] = true;
        
        // this recereates the message that was signed on the client
        bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));

        // Here we verify 
        require(recoverSigner(message, signature) == owner);

        // transfer the amount to this contract to Bob
        payable(msg.sender).transfer(amount);
    }   
    
    /// destroy the contract and reclaim the leftover funds.
    function shutdown() public {
        require(msg.sender == owner);
        selfdestruct(payable(msg.sender));
    }    

    function splitSignature(bytes memory sig) 
        internal 
        pure 
        returns (uint8 v, bytes32 r, bytes32 s) 
    {
        // signature has to be 65 bytes long
        require(sig.length == 65);

        assembly {
            // first 32 bytes of the sig variable, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes of the sig variable
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // return the variables as a split signature 
        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig) 
        internal
        pure
        returns (address)
    {
        // Split the signature from the function parameter
        (uint8 v, bytes32 r, bytes32 s) = splitSignature((sig));
        // return the signing address
        return ecrecover((message), v, r, s);
    }

    /// builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }    
}