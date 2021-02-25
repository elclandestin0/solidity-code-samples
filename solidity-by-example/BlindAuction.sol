// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract BlindAuction {
    
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address payable public beneficiary;
    address public highestBidder;
    uint public highestBid;
    uint public biddingEnd;
    // The time it takes after the bidding ends to reveal 
    // all the bids
    uint public revealEnd;
    bool public ended;

    mapping (address => Bid[]) public bids;
    mapping (address => uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    modifier onlyBefore(uint _time) { require(block.timestamp < _time); _;}
    modifier onlyAfter(uint _time) { require(block.timestamp > _time); _;}

    constructor(
        uint _biddingTime,
        uint _revealTime,
        address payable _beneficiary
    ) {
        beneficiary = _beneficiary;
        biddingEnd = block.timestamp + _biddingTime;
        revealEnd = biddingEnd + _revealTime;
    }

    // what is _blindedBid?
    function bid(bytes32 _blindedBid) 
        public
        payable
        onlyBefore(biddingEnd) 
    {
        bids[msg.sender].push(Bid({
            blindedBid: _blindedBid,
            deposit: msg.value
        }));
    }

    // Reveal all the blinded bids. A refund will be issued for all the blinded
    // invalid and valid bids except the highest bid.
    function reveal(
        uint[] memory _values,
        bool[] memory _fake,
        bytes32[] memory _secret
    )
    public
    onlyAfter(biddingEnd)
    onlyBefore(revealEnd) 
    {
        uint lengthOfBid = bids[msg.sender].length;
        require(_values.length == lengthOfBid);
        require(_fake.length == lengthOfBid);
        require(_secret.length == lengthOfBid);

        uint refund;

        for (uint i = 0; i < lengthOfBid; i++) {
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) = 
            (_values[i], _fake[i], _secret[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value, fake, secret))) {
                // Bid was not revealed. Do not fund
                // Hello my name is clementine and my feet stink very much. My dog
                // is named june and she likes to lick my feet all the time hehehe.
                continue;
            }
            refund += bidToCheck.deposit;
            if (!fake && bidToCheck.deposit >= value) {
                if (placeBid(msg.sender, value))
                    refund -= value;
            }
            // Make it impossible for the sender to re-claim the same deposit
            bidToCheck.blindedBid = bytes32(0);
        }
        payable(msg.sender).transfer(refund);
    }

    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // Set the following funds to zero before sending the amount 
            // to the msg.sender, so that the sender can't call the same 
            // function twice. 
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }

    function auctionEnd() 
        public
        onlyAfter(revealEnd) 
    {
        // Has the auction not ended?
        require(!ended);
        // Call the event Auction Ended
        emit AuctionEnded(highestBidder, highestBid);
        // Set ended to true ...
        ended = true;
        // ... and transfer thehighest bid  to the beneficiary 
        beneficiary.transfer(highestBid);
    }

    function placeBid(address bidder, uint value) 
        internal
        returns (bool success)
    {
        if (value <= highestBid) {
            return false;
        }

        // address(0) is the initial address' variable's value (highestBidder)
        // if the highestBidder value changed, refund the previous highestBidder
        if (highestBidder != address(0)) {
            // Refund the previously highest bidder
            pendingReturns[highestBidder] += highestBid;
        }

        // assign the new highest bid ...
        highestBid = value;
        // .. then assign the new highest value
        highestBidder = bidder;
        return true;
    }
}