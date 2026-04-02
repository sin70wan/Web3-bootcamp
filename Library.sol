// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MathLib {
    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        require(a >= b, "Cannot subtract larger number");
        return a - b;
    }
    
    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }
}

contract Calculator {
    using MathLib for uint256;
    
    function subtract(uint256 a, uint256 b) public pure returns (uint256) {
        return a.sub(b);
    }
    
    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        return a.multiply(b);
    }
}