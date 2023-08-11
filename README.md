# 🪝 Solhooks: Functional hooks for Ethereum

Solhooks is a powerful and flexible Solidity library that provides pre and post hooks for function calls to other contracts. It allows you to execute custom code before or after a function call, either safely or unsafely.

### Features
🛡️ **Safety First**: Execute hooks securely with `safePreHook` and `safePostHook`.

⚡ **Flexibility**: With both `preHook` and `postHook`, integrate hooks as per your needs.

🌐 **Universal Compatibility**: Designed specifically for Solidity, but adaptable for various contract programming languages.


## 🚀 Quick Start
Install with Foundry:

```sh
forge install 0xfuturistic/solhooks
```

## 🛠️ Usage
Dive into the world of hooks with four powerful modifiers:

- `preHook`: Executes an unsafe hook before the function it modifies.
- `postHook`: Executes an unsafe hook after the function it modifies.
- `safePreHook`: Executes a safe hook before the function it modifies.
- `safePostHook`: Executes a safe hook after the function it modifies.

### Quick Examples

Using `preHook`:

```solidity
function transfer(address _to, uint256 _value) public preHook(_to, "transfer(address,uint256)", abi.encode(_to, _value)) {
    // Your function code here
}
```

In this example, the `transfer` function will execute the `_unsafeHook` function in the `Hooks` contract before executing the function code. The `_unsafeHook` function will call the `_to` contract's `transfer` function with the encoded `_to` and `_value` arguments.

Using `postHook`:

```solidity
function transfer(address _to, uint256 _value) public postHook(_to, "transfer(address,uint256)", abi.encode(_to, _value)) {
    // Your function code here
}
```

For chaining multiple operations:

```solidity
function multiStepOperation() public preHook(target1, "step1", callData1) postHook(target2, "step2", callData2) {
    // Core operation logic
}
```

# 🧍 Use cases

## 🖇️ Chaining Multiple Operations with Solhooks
In the realm of Ethereum smart contracts, there are times when you might want to sequence multiple operations or even call functions from various contracts in a specific order. This is where Solhooks truly shines.

### What does "chaining multiple operations" mean?
Imagine you have a set of operations that need to be executed in a specific order:

1. **Operation A** needs to be executed before the main function.
1. **Operation B** should be executed right after the main function.

Typically, you'd have to manually ensure this sequence within the body of your function. With Solhooks, you can elegantly sequence these operations using `preHook` and `postHook`.

### Example
Consider a scenario where:

- Before executing the main function, you want: to check the balance of an account in a token contract (**Operation A**).
- After executing the main function, you want: to update a ledger contract with the new transaction details (**Operation B**).

Using Solhooks, you can achieve this as follows:

```solidity
function sendAndRecord(address _to, uint256 _amount) public 
    preHook(tokenContract, "balanceOf(address)", abi.encode(_to)) 
    postHook(ledgerContract, "recordTransaction(address,uint256)", abi.encode(_to, _amount))
{
    // Main function: send tokens
    token.transfer(_to, _amount);
}
```
In the above example:

- The `preHook` ensures that the balance is checked in the token contract before making the transfer.

- The `postHook` records the transaction details in the ledger contract after the transfer.

### Benefits of Chaining Operations with Solhooks
- **Modularity**: Each operation remains a separate module, enhancing code readability and maintainability.

- **Reusability**: Common operations (like balance checks) can be reused across different functions or contracts.

- **Flexibility**: Easily change the sequence of operations or add/remove operations as needed without restructuring the entire function.

### Potential Applications
- **Complex DApps**: In decentralized applications with multiple contracts interacting, Solhooks can ensure the correct sequence of calls between them.

- **Upgrades & Migrations**: If you're migrating from one contract version to another, hooks can help in sequencing data transfers and updates.

- **Security**: By adding checks or validations as pre-hooks, you can enhance the security of your main function.

In essence, Solhooks provides a powerful framework for developers to seamlessly stitch together intricate workflows in their Ethereum smart contracts, making the development process both efficient and elegant.

## 🪢 Enforcing Invariants and Constraints
With Solhooks, developers can add arbitrary invariants and enforce constraints as pre and post hooks. This ensures:

- **Preconditions:** Before the execution of the main function, the preHook can be used to check certain conditions (preconditions) that must be satisfied.

- **Postconditions:** After the function's execution, the postHook can validate that the function maintained certain conditions (postconditions).

Example: Imagine a simple bank contract where users can deposit and withdraw Ether. An invariant might be that the total balance of the contract should never be negative.

Using Solhooks:

```solidity
function withdraw(uint256 amount) public 
    preHook(this, "ensureSufficientBalance(uint256)", abi.encode(amount)) 
{
    // Withdrawal logic
}
```

Here, the ensureSufficientBalance function (added as a preHook) might look something like:

```solidity
function ensureSufficientBalance(uint256 amount) internal view {
    require(address(this).balance >= amount, "Insufficient balance for withdrawal");
}
```
This `preHook` ensures the invariant that the contract has enough balance for the withdrawal.

### Advantages of Using Solhooks for Invariants
- **Explicitness**: By using hooks to enforce invariants, the conditions are made explicit, enhancing code readability.
- **Modularity**: Separating invariants from the main function logic allows for better modularization of code.
- **Reusability**: Common invariants can be reused across different functions, ensuring consistency and reducing redundancy.
- **Enhanced Security**: By ensuring invariants, potential vulnerabilities or logical errors can be detected and halted before they cause issues.

### Potential Use Cases
- **Token Contracts**: Ensure that the total supply of tokens remains constant after minting and burning operations.
- **Voting Systems**: Ensure that the total number of votes doesn't exceed the total number of eligible voters.
- **Auction Contracts**: Ensure that bids are only accepted if they're higher than the current highest bid.

In summary, Solhooks provides a structured and efficient way to embed invariants into Ethereum smart contracts, ensuring that they operate within defined boundaries, enhancing their reliability and security.

---
## Contributing

If you'd like to contribute to Hooks, please fork the repository and make changes as you'd like. Pull requests are welcome!

## License

Hooks is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.