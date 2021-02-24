# Function types
`external` functions can be called from other contracts and via transactions. External functions are sometimes more efficient when they receive large arrays of data, as the data is not copied from calldata to memory. 

`public` functions are part of the contract interface. They can be called internally or via messages. `public` state variables automatically containe a getter function.

`internal` functions and state variables can only be accessed internally (i.e: from within the current contract or contracts deriving from it), without using `this`.

`private` functions and state variables are only visible for the contract they are defined in and not in derived contracts.

# Function keywords
`payable`: It is important to mark the `payable` keyword on a function, otherwise the function will reject all Ether sent to it. 

# Variable types
`public`
`storage`

# View vs. Pure
## View
While both keywords indicate that a function doesn't modify a state, a `view` function will not alter the storage state in any way.
## Pure
The `pure` keyword is quite more restrictive as it won't even read the storage state.