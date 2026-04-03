# Day 4: Bank Contract with Foundry Testing

## What This Is
A Bank smart contract that lets users deposit, withdraw, and check ETH balances. Tested with Foundry framework.

## Contract Functions
| Function | What it does |
|----------|--------------|
| `deposit()` | Send ETH to the contract |
| `withdraw(uint amount)` | Take ETH out of the contract |
| `getBalance(address user)` | Check how much ETH a user has |

## Test Cases (10 total - ALL PASSING)
1. ✅ User can deposit ETH
2. ✅ Deposit emits correct event
3. ✅ Cannot deposit 0 ETH (reverts)
4. ✅ User can withdraw ETH
5. ✅ Cannot withdraw more than balance (reverts)
6. ✅ Balance updates correctly after multiple operations
7. ✅ Different users have separate balances
8. ✅ Withdraw emits correct event
9. ✅ Fuzz test - random deposit amounts (1001 runs)
10. ✅ Fuzz test - random withdrawal amounts (1001 runs)

## How to Set Up and Run Tests

### 1. Install Foundry (if not already installed)
```bash
# Mac/Linux
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Verify installation
forge --version