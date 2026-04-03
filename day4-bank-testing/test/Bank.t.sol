// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Import Foundry's testing utilities
import {Test} from "forge-std/Test.sol";
// Import our Bank contract
import {Bank} from "../src/Bank.sol";

// Test contract - inherits from Foundry's Test
contract BankTest is Test {
    // Instance of Bank contract we'll test
    Bank public bank;
    
    // Test users (different addresses)
    address public alice = address(0x123);
    address public bob = address(0x456);
    
    // This runs BEFORE every single test
    function setUp() public {
        // Deploy a new Bank contract
        bank = new Bank();
        
        // Give Alice and Bob some test ETH
        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);
    }
    
    
    function test_Deposit() public {
        // Start impersonating Alice
        vm.startPrank(alice);
        
        // Alice deposits 10 ETH
        bank.deposit{value: 10 ether}();
        
        // Check: Alice's balance should be 10 ETH
        uint256 balance = bank.getBalance(alice);
        assertEq(balance, 10 ether);
        
        // Stop impersonating
        vm.stopPrank();
    }
    
    function test_DepositEmitsEvent() public {
        vm.startPrank(alice);
        
        // Expect an event to be emitted
        vm.expectEmit(true, false, false, true);
        
        // The event we expect to hear
        emit Bank.Deposited(alice, 5 ether);
        
        // Do the deposit
        bank.deposit{value: 5 ether}();
        
        vm.stopPrank();
    }
    
   
    function test_RevertWhen_DepositZero() public {
        vm.startPrank(alice);
        
        // Expect the next call to revert with this message
        vm.expectRevert("Must deposit at least 1 wei");
        
        // This should FAIL (good! we want it to fail)
        bank.deposit{value: 0}();
        
        vm.stopPrank();
    }
    
    
    function test_Withdraw() public {
        vm.startPrank(alice);
        
        // First, Alice deposits 20 ETH
        bank.deposit{value: 20 ether}();
        
        // Then Alice withdraws 10 ETH
        bank.withdraw(10 ether);
        
        // Check: Alice's balance should be 10 ETH (20 - 10)
        uint256 balance = bank.getBalance(alice);
        assertEq(balance, 10 ether);
        
        vm.stopPrank();
    }
    
    
    function test_RevertWhen_InsufficientBalance() public {
        vm.startPrank(alice);
        
        // Alice deposits 10 ETH
        bank.deposit{value: 10 ether}();
        
        // Try to withdraw 20 ETH (more than she has)
        vm.expectRevert("Insufficient balance");
        bank.withdraw(20 ether);
        
        vm.stopPrank();
    }
    
   
    function test_BalanceUpdateAfterMultipleOperations() public {
        vm.startPrank(alice);
        
        // Deposit 1 ETH
        bank.deposit{value: 1 ether}();
        assertEq(bank.getBalance(alice), 1 ether);
        
        // Deposit 2 more ETH
        bank.deposit{value: 2 ether}();
        assertEq(bank.getBalance(alice), 3 ether);
        
        // Withdraw 0.5 ETH
        bank.withdraw(0.5 ether);
        assertEq(bank.getBalance(alice), 2.5 ether);
        
        // Withdraw 1 ETH
        bank.withdraw(1 ether);
        assertEq(bank.getBalance(alice), 1.5 ether);
        
        vm.stopPrank();
    }
    
    
    function test_DifferentUsersSeparateBalances() public {
        // Alice deposits 10 ETH
        vm.startPrank(alice);
        bank.deposit{value: 10 ether}();
        vm.stopPrank();
        
        // Bob deposits 20 ETH
        vm.startPrank(bob);
        bank.deposit{value: 20 ether}();
        vm.stopPrank();
        
        // Check balances
        assertEq(bank.getBalance(alice), 10 ether);
        assertEq(bank.getBalance(bob), 20 ether);
    }
    
   
    function test_WithdrawEmitsEvent() public {
        vm.startPrank(alice);
        
        // First deposit
        bank.deposit{value: 10 ether}();
        
        // Expect withdrawal event
        vm.expectEmit(true, false, false, true);
        emit Bank.Withdrawn(alice, 5 ether);
        
        // Withdraw
        bank.withdraw(5 ether);
        
        vm.stopPrank();
    }
    
   
    function testFuzz_Deposit(uint256 amount) public {
        // Bound the amount to reasonable values (1 wei to 100 ETH)
        amount = bound(amount, 1, 100 ether);
        
        vm.startPrank(alice);
        
        // Get balance before
        uint256 balanceBefore = bank.getBalance(alice);
        
        // Deposit
        bank.deposit{value: amount}();
        
        // Balance should increase by 'amount'
        uint256 balanceAfter = bank.getBalance(alice);
        assertEq(balanceAfter, balanceBefore + amount);
        
        vm.stopPrank();
    }
    
    
    function testFuzz_Withdraw(uint256 depositAmount, uint256 withdrawAmount) public {
        // Bound deposit amount between 1 wei and 100 ETH
        depositAmount = bound(depositAmount, 1, 100 ether);
        
        // Bound withdraw amount between 1 and depositAmount
        withdrawAmount = bound(withdrawAmount, 1, depositAmount);
        
        vm.startPrank(alice);
        
        // Deposit first
        bank.deposit{value: depositAmount}();
        
        // Balance after deposit
        uint256 balanceAfterDeposit = bank.getBalance(alice);
        assertEq(balanceAfterDeposit, depositAmount);
        
        // Withdraw
        bank.withdraw(withdrawAmount);
        
        // Balance should be depositAmount - withdrawAmount
        uint256 balanceAfterWithdraw = bank.getBalance(alice);
        assertEq(balanceAfterWithdraw, depositAmount - withdrawAmount);
        
        vm.stopPrank();
    }
}