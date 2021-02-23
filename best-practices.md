# Prepare for failure
## Circuit breaker
Pause the contract when things are going the opposite direction.
## Rate limiting
Manage the amount of money at risk
## Effective upgrade path

# Rollout carefully
## Always test thoroughly on TestNet
## Provide bug bounties starting from TestNet releases
## Rollout in phases whilst increasing usage and testing with each phase

# Keep contracts simple
## Ensure contract logic is simple
## Modularize the code to keep functions and contracts small
## Use already-written tools when possible
## Prefer clarity to performance whenever possible
## Only use blockchain for the parts of your system that require decentralization

# Stay up to date
## Check your contracts for any bugs as soon as it is discovered
## Upgrade to the latest version of any tool or library as soon as possible
Command like the: `npm u`?
## Adopt new security techniques that appear useful

# Be aware of blockchain properties
## Be extremely careful about external contract cools, which may execute malicious code and change control flow
## Understand that your public functions are public and may be called maliciously and in any order
The private data in smart contracts is also viewable by anyone
## Keep gas costs minimal
## Be aware that timestamps are imprecise on blackchain
Miners can influence the time of TX execution within a margin of several seconds
## Randomness is significant on Blockchain
Most approaches to random number generation are gameable on a blockchain.

# Fundamental clash: Simplicity vs. Complexity
## Ideal smart contract system from an Engineering PoV
- Modular
- Reuses code (no duplication)
- Supports upgradeable components

# Fundamental tradeoffs between efficiency and security
## Rigid vs. Upgradeable
## Monolithic vs. Modular
Monolithic contracts are rarely held high in regard when it comes to being efficient. However, they do increase security and ease of code review with the extreme 
locality. 

Modular contracts are good for simple short-lived contracts while more complex contracts are better kept in a monolithic structure (?). 


## Duplication vs. Reuse
Reusability makes the most sense when you own it and when the trust of previous code is relied on. A blockchain engineer must be vigilante when using a new library that hasn't established trust yet. 


# View vs. Pure
## View
While both keywords indicate that a function doesn't modify a state, a view function will not alter the storage state in any way.
## Pure
Pure is quite more restrictive as it won't even read the storage state