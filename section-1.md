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