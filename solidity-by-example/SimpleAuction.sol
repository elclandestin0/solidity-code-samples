// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract SimpleAuction {
    // The beneficiary of the auction .. AKA whoever receives the highest bid 
    address payable public beneficiary;
    // Times are either absolute unix timestamps
    // or measured ins econds
    uint public auctionEndTime;

    // We have the address of the highest bidder along with 
    // the variable highest bid
    address public highestBidder;
    uint public highestBid;

    // Hash table that maps addresses to money that is pending return
    mapping(address => uint) pendingReturns;

    // Auction eneded contract
    bool ended;

    // HighestBid or AuctionEnded events
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount); 

    /// Create a simple auction with `biddingTime` set in seconds and 
    /// with the beneficiary address
    constructor (
        uint _biddingTime,
        address payable _beneficiary
    ) {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    /// Bid on the auction with the value sent together 
    /// with this transacton. The value will only be 
    // refunded if the auction is not won.
    function bid() public payable {
        // Is the auction still going?
        require(
            block.timestamp <= auctionEndTime,
            "Auction has already ended."
        );

        // Is the value greater than the highest bid?
        require(
            msg.value > highestBid,
            "There already is a higher bid."
        );


        if (highestBid != 0) {
            // It is completely unsafe to use the send(highestBid) option 
            // as it is executing an untrusted contract. It is always safer 
            // to let the recipients withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        }

        // if it passes the two requires, then the highest bidder becomes the 
        // person executing this contract and the highest bid state becomes the 
        // value sent.
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns (bool) {
        // get the amount from the caller of this function
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[msg.sender] = 0;
            if (!payable(msg.sender).send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// The way to structure functions that call other contracts
    ///  is by doing three steps. 
    /// 1. Checking conditions
    /// 2. Performing actions (changing the state)
    /// 3. Interacting with other contracts
    /// If these phases are mixed up, the other contract could
    /// call back into the current contract and modify the state or cause
    /// payouts.  
    function auctionEnd() public {
        // Has the auction ended according to the elapsed timespan?
        require(block.timestamp >= auctionEndTime, "Auction not yet ended.");

        // Auction has already ended and it already has been called 
        require(!ended, "auctionEnd has already been called.");

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
}