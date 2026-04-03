// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Bank contract - allows users to deposit and withdraw ETH
contract Bank {
    // Mapping: user address => their balance
    // Like a dictionary: "0x123..." => 10 ETH
    mapping(address => uint256) public balances;
    
    // Event that triggers when someone deposits
    // Frontend can listen to this
    event Deposited(address indexed user, uint256 amount);
    
    // Event that triggers when someone withdraws
    event Withdrawn(address indexed user, uint256 amount);
    
    // FUNCTION 1: Deposit ETH
    // payable = function can receive ETH
    function deposit() public payable {
        // Check: User must send some ETH (not zero)
        require(msg.value > 0, "Must deposit at least 1 wei");
        
        // Add the deposited amount to user's balance
        balances[msg.sender] += msg.value;
        
        // Announce the deposit
        emit Deposited(msg.sender, msg.value);
    }
    
    // FUNCTION 2: Withdraw ETH
    function withdraw(uint256 amount) public {
        // Check: User must have enough balance
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // Subtract from user's balance
        balances[msg.sender] -= amount;
        
        // Send the ETH to user's address
        // payable(msg.sender) = convert address to payable
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        // Announce the withdrawal
        emit Withdrawn(msg.sender, amount);
    }
    
    // FUNCTION 3: Check Balance
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
    
    // OPTIONAL: Get contract's total balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}