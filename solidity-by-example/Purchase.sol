// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Purchase {
    // value of item
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State { Created, Locked, Release, Inactive}
    // Any variable of type enum automatically takes the first member 
    // in this case it's `State.Created`
    State public state;

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyBuyer() {
        require(
            msg.sender == buyer,
            "Only buyer can call this."
        );
        _;
    }

    modifier onlySeller() {
        require(
            msg.sender == seller,
            "Only seller can call this."
        );
        _;
    }

    modifier inState(State _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerRefunded();

    /// Ensure the msg.value is an even number.
    constructor() payable {
        // Only the seller can call this contract
        seller = payable(msg.sender);
        value = msg.value / 2;
        require((2 * value) == msg.value, "Value has to be even.");
    }

    // Abort the purchase and reclaim the ether. Can only be called
    // by the seller before the contract is locked. 
    function abort() 
        public 
        onlySeller
        inState(State.Created)
    {
        emit Aborted();
        state = State.Inactive;
        // We use transfer() function here because 
        // it is re-entry proofed, as it is the last 
        // call in this function and we already changed
        // the state. Send the ether back to the seller.
        seller.transfer(address(this).balance);
    }

    /// Confirm the purchase as buyer.
    function confirmPurchase() 
        public 
        inState(State.Created) 
        condition(msg.value == (2 * value)) 
        payable
    {
        emit PurchaseConfirmed();
        // Buyer can only call this
        buyer = payable(msg.sender);
        // Change state
        state = State.Locked;
    }

    // Confirm that buyer received the item
    function confirmReceived() 
        public
        onlyBuyer
        inState(State.Locked)
    {
        emit ItemReceived();
        // It is important to change the state first because
        // otherwise, the contracts called using `send` below
        // can call in again here
        state = State.Release;
        buyer.transfer(value);
    }

    function refundSeller()
        public
        onlySeller
        inState(State.Release)
    {
        emit SellerRefunded();
        state = State.Inactive;
        seller.transfer(3 * value);
    }
}