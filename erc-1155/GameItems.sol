//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract GameItems is ERC1155 {
    uint256 public constant HAWK_MOBILE = 0;
    uint256 public constant SILVER_HAWK_MOBILE = 1;
    uint256 public constant PSYCHE_HAWK_MOBILE = 2;
    uint256 public constant GOLD_HAWK_MOBILE = 3;
    uint256 public constant CHOPPA = 4;
    uint256 public constant DIAMOND_CHOPPA = 5;
    
    // the URI must point to a JSON file that conforms to the ERC 1155 METADATA 
    // URI JSON Schema
    constructor("https://api.wearestudios.io/hawkz/item/{id}") public ERC1155() {
        _mint(msg.sender, HAWK_MOBILE, 1000, "");
        _mint(msg.sender, SILVER_HAWK_MOBILE, 1000, "");
        _mint(msg.sender, PSYCHE_HAWK_MOBILE, 1, "");
        _mint(msg.sender, GOLD_HAWK_MOBILE, 100, "");
        _mint(msg.sender, CHOPPA, 100, "");
        _mint(msg.sender, DIAMOND_CHOPPA, 5, "");
    }
}
