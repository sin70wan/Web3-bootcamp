// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedNumber;
    
    event NumberStored(uint256 indexed newNumber);
    
    function store(uint256 _number) public {
        storedNumber = _number;
        emit NumberStored(_number);
    }
    
    function retrieve() public view returns (uint256) {
        return storedNumber;
    }
    
    function increment() public {
        storedNumber = storedNumber + 1;
        emit NumberStored(storedNumber);
    }
}