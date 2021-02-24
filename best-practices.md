# General Philosophy
## Prepare for failure
### Circuit breaker
Pause the contract when things are going the opposite direction.
### Rate limiting
Manage the amount of money at risk
### Effective upgrade path

## Rollout carefully
### Always test thoroughly on TestNet
### Provide bug bounties starting from TestNet releases
### Rollout in phases whilst increasing usage and testing with each phase

## Keep contracts simple
### Ensure contract logic is simple
### Modularize the code to keep functions and contracts small
### Use already-written tools when possible
### Prefer clarity to performance whenever possible
### Only use blockchain for the parts of your system that require decentralization

## Stay up to date
### Check your contracts for any bugs as soon as it is discovered
### Upgrade to the latest version of any tool or library as soon as possible
Command like the: `npm u`?
### Adopt new security techniques that appear useful

## Be aware of blockchain properties
### Be extremely careful about external contract cools, which may execute malicious code and change control flow
### Understand that your public functions are public and may be called maliciously and in any order
The private data in smart contracts is also viewable by anyone
### Keep gas costs minimal
### Be aware that timestamps are imprecise on blackchain
Miners can influence the time of TX execution within a margin of several seconds
### Randomness is significant on Blockchain
Most approaches to random number generation are gameable on a blockchain.

## Fundamental clash: Simplicity vs. Complexity
### Ideal smart contract system from an Engineering PoV
- Modular
- Reuses code (no duplication)
- Supports upgradeable components

## Fundamental tradeoffs between efficiency and security
### Rigid vs. Upgradeable
### Monolithic vs. Modular
Monolithic contracts are rarely held high in regard when it comes to being efficient. However, they do increase security and ease of code review with the extreme 
locality. 

Modular contracts are good for simple short-lived contracts while more complex contracts are better kept in a monolithic structure (?). 


### Duplication vs. Reuse
Reusability makes the most sense when you own it and when the trust of previous code is relied on. A blockchain engineer must be vigilante when using a new library that hasn't established trust yet. 


# Protocol specific recommendations
## External Calls
Use caution when making external calls, especially to untrusted contracts. EVERY external call should be treated as a potential security risk.

## Differentiate between trusted and untrusted contracts using variables
> UntrustedBank.withdraw(100); // untrusted external call
> TrustedBank.withdraw(100); // trusted external call

## Avoid state changes after external call
When making either a raw call from an address or a contract call, always assume that malicious code might execute. Even if `AnotherContract` is not malicious, it may execute malicious code by an other contracts that it 
calls itself. For that reason, always avoid state changes after the call. This pattern is also known as `check-effects-interactions pattern`.

## Using Checks-Effects-Interactions Pattern
- Checks should be done first in functions
- If all checks are passed, then change the state variables of the current contract
- Finally, make the call to known contracts. Even if they are trusted.  

## Don't use `send()` or `transfer()`
Both of them now cost 2300 gas and that is also subject to change. Use `.call()` instead. Although `call()` saves on gas, it does nothing to prevent reentrency attacks. 

## Handle errors in external calls
Since address calls will never throw an exception, we must define them ourselves as the developers. Most address calls return `false` if the call encounters an exception. Here's what you can do. 

```solidity
// bad
someAddress.send(55);
someAddress.call.value(55)(""); // this is doubly dangerous, as it will forward all remaining gas and doesn't check for result
someAddress.call.value(100)(bytes4(sha3("deposit()"))); // if deposit throws an exception, the raw call() will only return false and transaction will NOT be reverted

// good
(bool success, ) = someAddress.call.value(55)("");
if(!success) {
    // handle failure code
}

ExternalContract(someAddress).deposit.value(100)();
```