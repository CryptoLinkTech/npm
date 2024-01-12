# CryptoLink Cross-Chain Messaging NPM Package Documentation

## Table of Contents
- [CryptoLink Cross-Chain Messaging NPM Package Documentation](#cryptolink-cross-chain-messaging-npm-package-documentation)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Benefits of Using the NPM Package](#benefits-of-using-the-npm-package)
  - [Installation and Setup](#installation-and-setup)
  - [Implementing MessageV3Client](#implementing-messagev3client)
  - [Contract Function Details](#contract-function-details)
  - [Example Implementation and Explanation](#example-implementation-and-explanation)
    - [Notes on the Example Code](#notes-on-the-example-code)
    - [Breakdown of Key Components](#breakdown-of-key-components)
  - [Configuration Script](#configuration-script)
  - [Fee Management](#fee-management)
    - [Handling Gas Fees on Destination Chain](#handling-gas-fees-on-destination-chain)
    - [Managing Source Fees on Origin Chain](#managing-source-fees-on-origin-chain)
    - [Automatic Fee Approval](#automatic-fee-approval)
    - [Ensuring Funds for Fees](#ensuring-funds-for-fees)
    - [Fee Limits for Protection](#fee-limits-for-protection)
  - [Supported Chains](#supported-chains)
    - [Example Use Cases](#example-use-cases)
  - [Full Contract Documentation](#full-contract-documentation)
    - [Functions](#functions)
      - [1. messageProcess](#1-messageprocess)
      - [2. \_sendMessage](#2-_sendmessage)
      - [3. \_sendMessageExpress](#3-_sendmessageexpress)
      - [4. configureClient](#4-configureclient)
      - [5. setExsig](#5-setexsig)
      - [6. setMaxgas](#6-setmaxgas)
      - [7. setMaxfee](#7-setmaxfee)
    - [Modifiers](#modifiers)
      - [1. onlySelfBridge](#1-onlyselfbridge)
      - [2. onlyActiveBridge](#2-onlyactivebridge)
      - [3. onlyOwner](#3-onlyowner)
    - [Functions from OpenZeppelin's `Ownable`](#functions-from-openzeppelins-ownable)
    - [Event](#event)

## Introduction
CryptoLink's Cross-Chain Messaging npm package (`@cryptolink/contracts`) streamlines the integration of cross-chain communication in blockchain applications.

## Benefits of Using the NPM Package
- Simplified cross-chain communication setup.
- Compatibility with various EVM-compatible chains.
- Direct integration with CryptoLink's infrastructure.

## Installation and Setup
Install the package from NPM:
```bash
npm install @cryptolink/contracts
```
*Note: Alternatively, the package can be installed locally by fetching it from the GitHub repository.*

## Implementing MessageV3Client
- **Inheritance**: Extend your contract from `MessageClient`.
- **Message Sending**: Use `_sendMessage` and `_sendMessageExpress`.
- **Message Processing**: Implement `messageProcess` for incoming message handling.

*See [Examples](#example-implementation-and-explanation) for detailed use cases.*

## Contract Function Details
- **configureBridge**: Sets chain-specific bridge configurations.
- **setMaxgas**: Defines maximum gas refund allowed per transaction.
- **setMaxfee**: Sets a cap on transaction fees that the system can charge per message.
- **setExsig**: Assigns external signatures for security enhancement.

*Function examples are provided in the relevant sections.*

## Example Implementation and Explanation


```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@cryptolink/contracts/message/MessageClient.sol"; // Ensure this path matches your actual import path

contract MyCrossChainContract is MessageClient {
    // Constructor to set up the MessageV3 bridge
    constructor(address messageV3Address) {
        MESSAGEv3 = IMessageV3(messageV3Address);
    }

    // Function to send a message to another chain
    function sendMessageToAnotherChain(uint destinationChainId, bytes memory data) public {
        // Sending a message to the specified chain
        uint txId = _sendMessage(destinationChainId, data);
        // Additional logic after sending the message (if needed)
    }

    // Function to send a message using express mode
    function sendExpressMessageToAnotherChain(uint destinationChainId, bytes memory data) public {
        // Sending a message using express mode
        uint txId = _sendMessageExpress(destinationChainId, data);
        // Additional logic after sending the message (if needed)
    }

    // Overriding the messageProcess function to handle incoming messages
    function messageProcess(
        uint _txId, uint _sourceChainId, address _sender, address _reference, 
        uint _amount, bytes calldata _data
    ) external override onlySelfBridge(_sender, _sourceChainId) {
        // Decode the incoming message and process it
        // Example: (address from, uint256 value) = abi.decode(_data, (address, uint256));
        // Process the message as required
    }

    // Additional functions and logic as required for your contract
    // ...
}
```

### Notes on the Example Code

- **Initialization**: The contract is initialized with the address of the Message bridge, which is crucial for enabling cross-chain messaging.
- **Sending Messages**: The `sendMessageToAnotherChain` and `sendMessageExpress` functions illustrate how to send standard and express messages to other chains.
- **Processing Incoming Messages**: The `messageProcess` function is overridden to handle messages received from other chains. This function should be customized based on how you want to process incoming messages.
- **Security**: The `onlySelfBridge` modifier ensures that only messages sent through the established bridge and configured remote contracts are processed.
- **Customization**: This example provides a basic structure. You should customize the logic within these functions to fit your specific application requirements.


### Breakdown of Key Components

1. **Contract Declaration and Inheritance**
   - `pragma solidity ^0.8.9;`: Specifies the Solidity compiler version for compatibility.
   - `import "@cryptolink/contracts/message/MessageClient.sol";`: Imports the `MessageClient` abstract contract.
   - `contract MyCrossChainContract is MessageClient`: Declares a new contract `MyCrossChainContract` that inherits the functionalities of `MessageClient`.

2. **Function: messageProcess**
   - **Purpose**: Processes incoming messages from other chains.
   - **Declaration**: 
     ```solidity
     function messageProcess(uint _txId, uint _sourceChainId, address _sender, address _reference, uint _amount, bytes calldata _data) external virtual onlySelfBridge(_sender, _sourceChainId) {}
     ```
   - **Implementation**: Override this function in your contract to define how incoming messages should be processed.

3. **Function: _sendMessage**
   - **Purpose**: Sends a message to a specified chain.
   - **Declaration**: 
     ```solidity
     function _sendMessage(uint _destinationChainId, bytes memory _data) internal returns (uint _txId) {}
     ```
   - **Implementation**: Used internally to send messages to other chains. Invokes `sendMessage` of the `MESSAGEv3` interface.

4. **Function: _sendMessageExpress**
   - **Purpose**: Sends a message to a specified chain using express mode.
   - **Declaration**: 
     ```solidity
     function _sendMessageExpress(uint _destinationChainId, bytes memory _data) internal returns (uint _txId) {}
     ```
   - **Implementation**: Similar to `_sendMessage` but sends the message in express mode.


## Configuration Script

Here's the revised Ethers.js configuration script. This script should be configured for and ran on every chain deployed AFTER all contracts have been deployed on each chain.

```javascript
const { ethers } = require('ethers');

// Configuration Parameters
const rpcUrl = 'https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY'; // Example Ethereum RPC URL
const privateKey = '0xYOUR_PRIVATE_KEY'; // Example private key
const messageV3Address = '0x1234...abcd'; // Example MessageV3 contract address for Ethereum
const contractAddress = '0xabcd...1234'; // Example deployed contract address on Ethereum

// Chain configuration data
const chains = [1, 3, 4]; // Example chain IDs for Ethereum, Ropsten, Rinkeby
const endpoints = ['0x1111...2222', '0x3333...4444', '0x5555...6666']; // Example corresponding MessageClient addresses on each chain
const confirmations = [12, 6, 6]; // Example confirmation counts for each chain

// Initialize ethers with provider and signer
const provider = new ethers.providers.JsonRpcProvider(rpcUrl);
const signer = new ethers.Wallet(privateKey, provider);

const contractAbi = [
    "function configureClient(address _messageV3, uint[] calldata _chains, address[] calldata _endpoints, uint16[] calldata _confirmations) external"
];

// Instantiate the contract
const myContract = new ethers.Contract(contractAddress, contractAbi, signer);

async function configureChains() {
    try {
        // Configure the client with MessageV3 bridge and chain data
        const tx = await myContract.configureClient(
            messageV3Address, chains, endpoints, confirmations
        );

        console.log('Transaction sent:', tx.hash);
        await tx.wait();
        console.log('Chains configured successfully.');
    } catch (error) {
        console.error('An error occurred during configuration:', error);
    }
}

// Execute the configuration
configureChains();
```

## Fee Management

The fee management in cross-chain messaging involves two main types of fees: gas fees on the destination chain and source fees on the origin chain. Gas fees are paid in the wrapped native gas token of the respective blockchain, such as WETH on Ethereum, WMATIC on Polygon, and WBNB on Binance Smart Chain. Source fees are paid in FEE_TOKEN. The NPM package facilitates automatic approval for these tokens, ensuring that fees are deducted during transaction processing. Developers are responsible for ensuring their contracts have sufficient funds in both the wrapped native gas token and FEE_TOKEN. They also have the option to set limits on these fees using `setMaxgas` and `setMaxFee` functions for added protection against unexpected fee increases.

### Handling Gas Fees on Destination Chain
- Gas fees are paid in the wrapped native gas token of the respective blockchain (e.g., WETH on Ethereum, WMATIC on Polygon, WBNB on Binance Smart Chain).

### Managing Source Fees on Origin Chain
- Source chain fees are paid in FEE_TOKEN.

### Automatic Fee Approval
- The NPM package automatically approves the wrapped native gas token (like WETH, WMATIC) and FEE_TOKEN, enabling the Message system to automatically deduct fees during transaction processing.

### Ensuring Funds for Fees
- Developers must ensure their contracts have sufficient funds in the wrapped native gas token and FEE_TOKEN for fees. This can be achieved either by depositing funds or designing the contract to collect these from users.

### Fee Limits for Protection
- Functions `setMaxgas` and `setMaxFee` allow developers to set limits on gas and message fees, offering protection against high or unexpected fees. 


## Supported Chains

| Chain Name                  | Chain ID   | Contract Address                         |
|-----------------------------|------------|------------------------------------------|
| Arbitrum Testnet (Sepolia)  | 421614     | 0x207CbCa48258591CD1e953739c663184A02bB320 |
| Aurora Testnet              | 1313161555 | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Avalanche Testnet           | 43113      | 0x24BEFF24327C8E956d5FC74a5C502038683cDc0A |
| Base Testnet (Sepolia)      | 84532      | 0x18716F6E46a66919deacD3c6fd4fa6Da02fa30b2 |
| Boba Testnet                | 2888       | 0xAF1f0C79cc043AD4a263dfe7715ca657F9bDeced |
| Binance Testnet             | 97         | 0x535CCeD6C471eE907eEB3bBECf1C8223208Ca5e0 |
| Canto Testnet               | 7701       | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Celo Testnet                | 44787      | 0x6e658066340C7cae09dB68F5339Ddc4b806d3598 |
| Cronos Testnet              | 338        | 0x8eb10FC1793094113E7f52bA159A6AeB54CaB92c |
| Fantom Testnet              | 4002       | 0x7d474aA4DbDBc276b67abcc5f54262978b369cEC |
| Ethereum Goerli             | 5          | 0x566B40Dd59A868c244E1353368e08ddaD1C1d74f |
| Ethereum Holesky            | 17000      | 0x9d75f706b986F0075b3778a12153390273dE95eC |
| Ethereum Sepolia            | 11155111   | 0x8DE416ABd87307f966a5655701F2f78012585225 |
| Forest Testnet              | 377        | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Frame Testnet               | 68840142   | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Gauss Testnet               | 1452       | 0x6c83DC6C5128ff3E073E737523D2176aAeB08525 |
| Gnosis Testnet              | 10200      | 0x146449fb27e4A4B4721a9c5742f3baB1e34eb31f |
| Harmony Testnet             | 1666700000 | 0xE0a5cBb1f15a84C4a4A0f7E98F9721997182deD6 |
| Kava Testnet                | 2221       | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Klaytn Testnet              | 1001       | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Linea Testnet               | 59140      | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Mainnetz Testnet            | 9768       | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Mantle Testnet              | 5001       | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Metis Testnet               | 599        | 0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33 |
| Oasis Emerald Testnet       | 42261      | 0x566B40Dd59A868c244E1353368e08ddaD1C1d74f |
| Oasis Sapphire Testnet      | 23295      | 0x566B40Dd59A868c244E1353368e08ddaD1C1d74f |
| OKEx Testnet                | 65         | 0xF1FBB3E9977dAcF3909Ab541792cB2Bba10FFD5E |
| Onus Testnet                | 1945       | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Optimism Testnet            | 11155420   | 0xB4245BFEA4AfE63c7F7863D090166890e9FEf1b2 |
| Polygon Testnet             | 80001      | 0x08A2d304547A4B93B254d906502A3fc778D78412 |
| Polygon zkEVM Testnet       | 1442       | 0xcA877c797D599bE2Bf8C897a3B9eba6bA4113332 |
| Pulse Testnet               | 943        | 0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33 |
| Redstone Testnet            | 17001      | 0x9d75f706b986F0075b3778a12153390273dE95eC |
| Scroll Testnet (Sepolia)    | 534351     | 0x23E2CE1fF48cF21239f8c5eb783CE89df02B6f35 |
| Telos Testnet               | 41         | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| X1 Testnet                  | 195        | 0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33 |
| XDC Testnet                 | 51         | 0x0EFafca24E5BbC1C01587B659226B9d600fd671f |
| ZetaChain Testnet           | 7001       | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |



### Example Use Cases

1. **Cross-Chain Non-Fungible Tokens (NFTs):** CryptoLink enables the creation and management of NFTs that exist across multiple blockchains. This opens up new avenues for artists and collectors, increasing market reach and creative possibilities.

2. **Rebroadcasting Oracle Data:** The platform allows for oracle data to be broadcasted across many EVM chains, with the possibility for the oracle owner to run their own validation layer. This is crucial for maintaining data consistency and reliability across different blockchains.

3. **Multi-Chain Initial Coin Offerings (ICOs):** With CryptoLink, projects can conduct ICOs across various blockchains, allowing them to tap into diverse communities and maximize potential contributions.

4. **Cross-Chain Lending Platforms:** The technology can be used to build platforms where users can lend and borrow assets across different blockchains, enhancing the efficiency of capital utilization in the decentralized finance (DeFi) space.

5. **Arbitrage Bots:** By identifying and capitalizing on arbitrage opportunities across multiple chains, traders and investors can maximize profits by leveraging price discrepancies.

6. **Unified Metaverses:** CryptoLink's technology can be used to build interconnected virtual worlds that span multiple blockchains, leading to more immersive and engaging user experiences.

7. **Social Media Notifications:** Innovative applications can be developed where cross-chain events trigger social media notifications, enhancing user engagement and interaction within the cross-chain ecosystem.


## Full Contract Documentation

### Functions

#### 1. messageProcess
- **Purpose**: Processes incoming messages from other chains.
- **Visibility**: External
- **Modifiers**: `onlySelfBridge`
- **Parameters**:
  - `_txId` (uint): Transaction ID.
  - `_sourceChainId` (uint): Source chain ID.
  - `_sender` (address): Address of the sender's `MessageClient` contract on the source chain.
  - `_reference` (address): Optional source reference address.
  - `_amount` (uint): Not used for messages, always 0.
  - `_data` (bytes): Encoded message from the source chain.
- **Returns**: None

#### 2. _sendMessage
- **Purpose**: Sends a message to a specified chain.
- **Visibility**: Internal
- **Parameters**:
  - `_destinationChainId` (uint): Destination chain ID.
  - `_data` (bytes): Arbitrary data package to send.
- **Returns**:
  - `_txId` (uint): Transaction ID of the sent message.

#### 3. _sendMessageExpress
- **Purpose**: Sends a message to a specified chain using express mode.
- **Visibility**: Internal
- **Parameters**:
  - `_destinationChainId` (uint): Destination chain ID.
  - `_data` (bytes): Arbitrary data package to send.
- **Returns**:
  - `_txId` (uint): Transaction ID of the sent message.

#### 4. configureClient
- **Purpose**: Configures the client with MessageV3 bridge and chain data.
- **Visibility**: External
- **Modifiers**: `onlyOwner`
- **Parameters**:
  - `_messageV3` (address): MessageV3 bridge address.
  - `_chains` (uint[]): List of chain IDs to accept as valid destinations.
  - `_endpoints` (address[]): List of corresponding `MessageClient` addresses on each chain.
  - `_confirmations` (uint16[]): Confirmations required on each chain before processing.
- **Returns**: None

#### 5. setExsig
- **Purpose**: Assigns an external signature for enhanced security.
- **Visibility**: External
- **Modifiers**: `onlyOwner`
- **Parameters**:
  - `_signer` (address): Address of the signer.
- **Returns**: None

#### 6. setMaxgas
- **Purpose**: Limits the gas usage for transactions.
- **Visibility**: External
- **Modifiers**: `onlyOwner`
- **Parameters**:
  - `_maxGas` (uint): Maximum gas amount.
- **Returns**: None

#### 7. setMaxfee
- **Purpose**: Caps the fee amount per transaction.
- **Visibility**: External
- **Modifiers**: `onlyOwner`
- **Parameters**:
  - `_maxFee` (uint): Maximum fee amount.
- **Returns**: None

### Modifiers

#### 1. onlySelfBridge
- **Purpose**: Ensures that the function is called only by the authorized `MessageClient` contract from the source chain.

#### 2. onlyActiveBridge
- **Purpose**: Ensures that the destination chain is active before sending a message.

#### 3. onlyOwner
- **Purpose**: Restricts function access to the contract owner.

### Functions from OpenZeppelin's `Ownable`

1. **owner()**
   - **Purpose**: Returns the address of the current owner.
   - **Visibility**: Public

2. **isOwner()**
   - **Purpose**: Checks if the caller is the current owner.
   - **Visibility**: Public

3. **renounceOwnership()**
   - **Purpose**: Leaves the contract without an owner, making it impossible to call `onlyOwner` functions.
   - **Visibility**: Public
   - **Important Note**: Use with caution as it removes any functionality only available to the owner.

4. **transferOwnership(newOwner)**
   - **Purpose**: Transfers ownership of the contract to a new account (`newOwner`).
   - **Visibility**: Public
   - **Parameters**:
     - `newOwner` (address): Address of the new owner.

### Event

1. **OwnershipTransferred(previousOwner, newOwner)**
   - **Purpose**: Emitted when ownership of the contract is transferred.
   - **Parameters**:
     - `previousOwner` (address): Address of the previous owner.
     - `newOwner` (address): Address of the new owner.

For more detailed information, please refer to the [OpenZeppelin Documentation](https://docs.openzeppelin.com/contracts/2.x/api/ownership).