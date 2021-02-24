# Introduction
## EVM
### Storage, memory and the stack
Each account has a persistent memory area which is called storage. Storage is a key-value store that maps 256-bit words to 256-bit words. It is not possible to enumerate storage from within a contract and it is comparatively costly to read and even more so, to modify storage. A contract can neither read nor write to any storage apart from its own.

The second memory area is called memory, of which a contract obtains a freshly cleared instance for each message call. Memory is linear and can be addressed at byte level, but reads are limited to a width of 256 bits, while writes can be either 8 bits or 256 bits wide. Memory is expanded by a word (256-bit), when accessing (either reading or writing) a previously untouched memory word (ie. any offset within a word). At the time of expansion, the cost in gas must be paid. Memory is more costly the larger it grows (it scales quadratically).

The EVM is not a register machine but a stack machine, so all computations are performed on an area called the stack. It has a maximum size of 1024 elements and contains words of 256 bits. Access to the stack is limited to the top end in the following way: It is possible to copy one of the topmost 16 elements to the top of the stack or swap the topmost element with one of the 16 elements below it. All other operations take the topmost two (or one, or more, depending on the operation) elements from the stack and push the result onto the stack. Of course it is possible to move stack elements to storage or memory, but it is not possible to just access arbitrary elements deeper in the stack without first removing the top of the stack.

### Instruction Set
The instruction set of the EVM is kept minimal in order to avoid incorrect implementations which could cause consensus problems. All instructions operate on the basic data type, 256-bit words. The usual arithmetic, bit, logical and comparison operations are present. Conditional and unconditional jumps are possible. Furthermore, contracts can access relevant properties of the current block like its number and timestamp.

### Message call
Contracts can call other contracts or send Ether to non-contract accounts (humans) by means of message calls. 
### Delegate call
A delegatecall is a special variant of a message call. It is quite similar to the message call apart from the fact that the script at the target address is executed in the context of the calling contract. `msg.sender` and `msg.value` do not change their values. 

This means that contracts can dynamically load other contracts' code like "libraries" which results in complex data structures for contracts

### Create call
Contracts can create other contracts. The only difference between create and message calls is that the result of create calls is stored as code and the creator receives the address of the new contract on the stack.

### Self-destruct
The only possibility where code is removed from the blockchain is when a contract at that address performs the `selfdestruct` operation. A contract's code does NOT need to have `selfdestruct` to destroy itself. It can still do so with `delegatecall` and `callcode`.