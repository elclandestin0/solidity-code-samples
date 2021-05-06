//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStore {
    // mapping of buyers and products
    mapping(uint256 => address) private _buyers;
    mapping(address => bool) private _didBuy;
    Product[] private _products;

    // product struct used when creating a product
    struct Product {
        string name;
        string description;
        uint256 productId;
        uint256 price;
        uint256 timeCreated;
    }

    // owner of the store
    address private _owner;

    // buyer counter
    uint256 private _buyerCount;

    // product counter
    uint256 private _productCount;

    constructor() {
        _owner = msg.sender;
        _productCount = 0;
        _buyerCount = 0;
    }

    function createProduct(
        string memory name_,
        uint256 price_,
        string memory description_
    ) public onlyOwner {
        // increment the product count by 1
        if (_products.length > 0) {
            uint256 count_ = _productCount;
            count_ = count_ + 1;
            _productCount = count_ - 1;
            // get the time created for product using block.timestamp
            uint256 time_ = block.timestamp;

            // create a new product variable from Product struct
            _products.push(Product(name_, description_, count_, price_, time_));
        } else {
            uint256 time_ = block.timestamp;
            // create a new product variable from Product struct
            _products.push(Product(name_, description_, 0, price_, time_));
        }
    }

    // shopper buys an item
    function buyItem(uint256 productId_) public payable {
        require(msg.value == _products[productId_].price, "Insufficient funds");
        if (_didBuy[msg.sender] == false) {
            _didBuy[msg.sender] = true;
            uint256 count_ = _buyerCount;
            count_ = count_ + 1;
            _buyerCount = count_;
            _buyers[_buyerCount] = msg.sender;
        }
    }

    // withdraw money from the smart contract to the store owner
    function withdraw(uint256 withdrawAmount_) public onlyOwner {
        require(
            withdrawAmount_ <= address(this).balance,
            "Cannot withdraw more than the store's balance"
        );
        payable(msg.sender).transfer(withdrawAmount_);
    }

    // get all products
    function products() public view returns (Product[] memory) {
        return _products;
    }

    // get balance of store
    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the owner can access this!");
        _;
    }
}
