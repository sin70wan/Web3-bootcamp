// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Animal {
    function speak() public virtual pure returns (string memory) {
        return "Some animal sound";
    }
}

contract Dog is Animal {
    function speak() public override pure returns (string memory) {
        return "Bark";
    }
}

contract Cat is Animal {
    function speak() public override pure returns (string memory) {
        return "Meow";
    }
}