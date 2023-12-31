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
function transfer(address from, address to, uint256 amount)
    public
    preHook(from, "beforeTokenTransfer(address,uint256)", abi.encode(to, amount))
{
    // Your function code here
}
```

In this example, the `transfer` function will execute the `_unsafeHook` function in the `Hooks` contract before executing the function code. The `_unsafeHook` function will call the `from` contract's `beforeTokenTransfer` function with the encoded `from` and `amount` arguments.

Using `postHook`:

```solidity
function transfer(address from, address to, uint256 amount)
    public
    postHook(from, "afterTokenTransfer(address,uint256)", abi.encode(to, amount))
{
    // Your function code here
}
```

For adding hooks to already defined methods:

```solidity
function transfer(address from, address to, uint256 amount)
    public
    postHook(from, "afterTokenTransfer(address,uint256)", abi.encode(to, amount))
    override
{
    super.transfer(from, amount);
}
```

For chaining multiple operations:

```solidity
function multiStepOperation()
    public
    preHook(target1, "step1", callData1)
    postHook(target2, "step2", callData2)
{
    // Core operation logic
}
```

<details open>
<summary><h2>🖇️ Chaining Multiple Operations with Solhooks</h2></summary>

In the realm of Ethereum smart contracts, there are times when you might want to sequence multiple operations or even call functions from various contracts in a specific order. This is where Solhooks truly shines.

### What does _chaining_ multiple operations mean?
Imagine you have a set of operations that need to be executed in a specific order:

- **Operation A** needs to be executed before the main function.
- **Operation B** should be executed right after the main function.

Typically, you'd have to manually ensure this sequence within the body of your function. With Solhooks, you can elegantly sequence these operations using `preHook` and `postHook`.

### Example
- Before executing the main function: you want to check the balance of an account in a token contract (**Operation A**).
- After executing the main function: you want to update a ledger contract with the new transaction details (**Operation B**).

Using Solhooks, you can achieve this as follows:

```solidity
function sendAndRecord(address from, uint256 amount) public 
    preHook(tokenContract, "balanceOf(address)", abi.encode(from)) 
    postHook(ledgerContract, "recordTransaction(address,uint256)", abi.encode(from, amount))
{
    // Main function: send tokens
    token.transfer(from, amount);
}
```
In the above example:

- The `preHook` ensures that the balance is checked in the token contract before making the transfer.

- The `postHook` records the transaction details in the ledger contract after the transfer.

### Benefits of Chaining Operations with Solhooks
- **Modularity**: Each operation remains a separate module, enhancing code readability, maintainability, and security.

- **Reusability**: Common operations (like balance checks) can be reused across different functions or contracts.

- **Flexibility**: Easily change the sequence of operations or add/remove operations as needed without restructuring the entire function.

### Potential Applications
- **Complex DApps**: In decentralized applications with multiple contracts interacting, Solhooks can ensure the correct sequence of calls between them.

- **Upgrades & Migrations**: If you're migrating from one contract version to another, hooks can help in sequencing data transfers and updates.

- **Security**: By adding checks or validations as pre-hooks, you can enhance the security of your main function.

In essence, Solhooks provides a powerful framework for developers to seamlessly stitch together intricate workflows in their Ethereum smart contracts, making the development process both efficient and elegant.

</details>

<details open>
<summary><h2>🪢 Enforcing State Transition Invariants</h2></summary>

With Solhooks, developers can add arbitrary invariants and enforce constraints as pre and post hooks. This ensures:

- **Preconditions:** Before the execution of the main function, the preHook can be used to check certain conditions (preconditions) that must be satisfied.

- **Postconditions:** After the function's execution, the postHook can validate that the function maintained certain conditions (postconditions).

### Example
Imagine a simple pool contract where users can deposit and withdraw tokens. An invariant might be that the total balance of the pool should never be negative.

We can inherit this contract and add a `preHook` modifier to the functions we want to add invariants to:

```solidity
function withdraw(uint256 amount) public
    preHook(address(this), "ensureSufficientBalance(uint256)", abi.encode(amount))
    override
{
    super.withdraw(amount);
}
```

Here, the `ensureSufficientBalance` function (called via a `preHook`) might look something like:

```solidity
function ensureSufficientBalance(uint256 amount) internal view {
    require(address(this).balance >= amount, "Insufficient balance for withdrawal");
}
```
`preHook` calls it to ensure the invariant that the pool has enough balance for the withdrawal.

### Advantages of Using Solhooks for Invariants
- **Explicitness**: By using hooks to enforce invariants, the conditions are made explicit, improving security and enhancing code readability.
- **Modularity**: Separating invariants from the main function logic allows for better modularization of code.
- **Reusability**: Common invariants can be reused across different functions, ensuring consistency and reducing redundancy.
- **Enhanced Security**: By ensuring invariants, potential vulnerabilities or logical errors can be detected and halted before they cause issues.

### Potential Use Cases
- **Automated market makers**: Ensure that an AMM's invariants (e.g., `xy=k`) are maintained after each swap.
- **Token Contracts**: Ensure that the total supply of tokens remains constant after minting and burning operations.
- **Voting Systems**: Ensure that the total number of votes doesn't exceed the total number of eligible voters.
- **Auction Contracts**: Ensure that bids are only accepted if they're higher than the current highest bid.

In summary, Solhooks provides a structured and efficient way to embed invariants into Ethereum smart contracts, ensuring that they operate within defined boundaries, enhancing their reliability and security.

</details>

---
## Contributing

If you'd like to contribute to Solhooks, please fork the repository and make changes as you'd like. Pull requests are welcome!

## License

Solhooks is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.