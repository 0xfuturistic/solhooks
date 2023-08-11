# 🪝 Solhooks: Functional hooks for Ethereum

Solhooks is a powerful and flexible Solidity library that provides pre and post hooks for function calls to other contracts. It allows you to execute custom code before or after a function call, either safely or unsafely.

### Features
🛡️ **Safety First**: Execute hooks securely with our safePreHook and safePostHook.

⚡ **Flexibility**: With both preHook and postHook, integrate hooks as per your needs.

🌐 **Universal Compatibility**: Designed specifically for Ethereum, but adaptable for various contract designs.


## 🚀 Quick Start
### 1️⃣ Installation
Get Solhooks up and running in your Solidity project with Forge:

```sh
forge install 0xfuturistic/solhooks
```
### 2️⃣ Integration
Import Solhooks into your Solidity contract:

```solidity
import "solhooks/Hooks.sol";
```

## 🛠️ Usage
Dive into the world of hooks with four powerful modifiers:

- `preHook`: Executes an UNSAFE hook BEFORE the function call.
- `postHook`: Executes an UNSAFE hook AFTER the function call.
- `safePreHook`: Executes a SAFE hook BEFORE the function call.
- `safePostHook`: Executes a SAFE hook AFTER the function call.

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

## Contributing

If you'd like to contribute to Hooks, please fork the repository and make changes as you'd like. Pull requests are welcome!

## License

Hooks is licensed under the MIT License. See the LICENSE file for more information.

