# Section 1 Notes

## Calculating the Cost of an Ethereum Transfer
- How the tx fee for transferring Ethereum is computed:
- Tx fee is product of gas used by transaction * gas price
- Gas price is given in units of ether, usually in gwei
- (gas used by tx * gas price / 1 billion, * price of ether) = gas price approx to $ value
- Gas calculation formula is slightly more complex after EIP1559
## Heavy and Light Functions
- Heavy operations cost more gas and light operations cost less gas
- All transactions on Ethereum must cost at least 21,000 gas 
## Block Limit
### Block limits
- Historically, Bitcoin has limited each block to 1 MB
  - If the block is too big, it may become expensive to store or to synchronize with other nodes across the world
- Ethereum does not place an explicit byte limit to its block size like Bitcoin does
  - It actually limits the total amount of computations/gas that can be stored in a single block
  - The sum of all the transactions in a single block needs to fall below a certain number; this is how Ethereum limits its block size 
  - If the block gas limit is too high, then the network might stall 
- If a transaction requires too much gas, it will get pre-emptively reverted
- The block limit is currently around 30 million gas
  - An ETH transfer costs 21,000 gas, so theoretically one block can hold 1,428 transfers
  - This applies only to very light transactions that move ether around
  - Heavier transactions would limit the amount of transfers in a block 
### Throughput
- Throughput is measured in transactions per second, and a new block is generated every 15 seconds on Ethereum
  - The transaction throughput will be between 2 and 95 transactions per second (tps) depending on how light or heavy the operations are
  - Ethereum has been averaging around 13 tps 
### Implications 
- This gas limit is necessary to keep the Ethereum network running smoothly, but it has a side effect that there are more people trying to make transactions than there are space on the block for
  - There cannot be more thna 1428 transfers on one block
  - If more than 1428 people are trying to make a transfer, than the highest bidder will have their transcation included in the block; this is why gas prices fluctuate
- You can think of the 21,000 gas as a unit of what Ethereum can process over the course of 15 seconds 
  - It can be thought of as being 0.07% of Ethereum's computational capactity per 15 seconds 
  - This will help you understand how "larger" transactions are in a relative sense to Ethereum's capactity
- If your smart contract is over 30 million gas to execute, it won't fit on the block 
### Other Important Information
- 30 million isn't a hard limit; the gas limit changes and isn't completely static
- Ethereum technically has a preferred block limit and dynamic block limit, but conceptually it can be thought of as 30 million gas 
- A future hard fork may change this number
- Design smart contracts to what the current limits are
## What are Opcodes
- Ex: simple smart contract
```solidity
contract Test {
  uint256 a = 3;

  function aPlusOne() external view returns (uint256) {
    return a + 1;
  }
}
```
- For a computer to execute this it needs to know where exactly in memory or storage is `a` 
  - Need to move `a` from storage to memory, and the number being added needs to be loaded into memory as well
  - Also needs to be loaded into a specific location so when you do the addition operator, the addition knows where to look for these two numbers in order to add them together
- When the Solidity code is compiled, it's in Assembly opcodes 
- Relevant part of above function in Opcodes:
```assembly
/*
0 is a storage location for `a`, look inside of location 0
Take the value inside of location 0 and load those into memory 
while removing this value (0).
Once the values are loaded the 0 isn't relevant anymore
*/
PUSH 0 
/* 
When LOAD operation is executed, pull in what is stored on location 0 (which is 3) 
*/
LOAD
/* 
Load in the number that we're trying to add it with
Essentially push the number on top of a stack so when the ADD operation
comes along, it knows to only look at the top two items inside of the stack
in order to carry out the operation
*/
PUSH 1
/*
Specifically only programmed to look at the top two elements of the stack
Pops off the two items and adds them together as one
*/
ADD 
```
- More complicated example: 5x + 3y (assume x = 10 and y = 20)
```assembly
PUSH 5  ; push 5 onto the stack
PUSH 0  ; push on storage location of x, which is 0
LOAD    ; load value from x onto the stack while removing most recent item on the stack (0 replaced w/ 10)
PUSH 3  ; push 3 onto stack to correspond with 3y
PUSH 1  ; push storage location of y (in this case is 1)
LOAD    ; load value of y onto the stack 
MUL     ; multiply the two numbers (3 & y) together (which is 60)
SWAP 2  ; move 60 two units back and make sure two relevant numbers (5 and 10) are on top
MUL     ; pops off top two items, multiplies them (50), then adds result back 
ADD     ; adds top two numbers (60 + 50), resulting in 110
```
- This sequence of opcodes technically means that Ethereum can be programmed in any language, as long as it compiles to the appropiate opcodes
## Opcode Gas Cost
- Each opcode is defined inside of the Ethereum yellowpaper
  -  Delta value is how many items are being removed from the stack
  -  Alpha value is how many items are being added to the stack
- `SSLOAD` will cost 100 or 2100 gas, if it's the first time accessing variable in the transaction, that's considered a "cold access" and will be 2100 gas
- A signifcant amount of the gas in a Ethereum transcation is simply the sum of all the opcodes to execute within that transaction
  - The more opcodes executed, the more expensive opcodes are going to be
- This helps put a quantative number towards why heavy functions cost more than light ones
## Function Selectors
- When you create a contract, your function names aren't actually stored inside of the bytecode
  - They're actually stored as hashes of the function name and the first 4 bytes are taken
  - While doing this hash, you have to include the exact `uint` type, variable name not included
  - These hashes are used in the PUSH opcode