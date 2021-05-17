//SPDX-License-Identifier
pragma solidity ^0.8.0;

contract ReEntrancyGuard {
    bool internal lock;

    modifier noRentryGuard() {
        require(!lock, "Cannot execute this function twice in a row!");
        lock = true;
        _;
        lock = false;
    } 
}