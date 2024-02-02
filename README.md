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
  - [Using the MessageClient ABI](#using-the-messageclient-abi)
  - [Using the MessageClient Configuration](#using-the-messageclient-configuration)
    - [After Deployment Configuration Script](#after-deployment-configuration-script)
  - [Fee Management](#fee-management)
    - [Handling Gas Fees on Destination Chain](#handling-gas-fees-on-destination-chain)
    - [Managing Source Fees on Origin Chain](#managing-source-fees-on-origin-chain)
    - [Automatic Fee Approval](#automatic-fee-approval)
    - [Ensuring Funds for Fees](#ensuring-funds-for-fees)
    - [Fee Limits for Protection](#fee-limits-for-protection)
    - [Recovering Fee and Gas Tokens](#recovering-fee-and-gas-tokens)
  - [Supported Chains](#supported-chains)
    - [Mainnets](#mainnets)
    - [Testnets](#testnets)
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
      - [8. recoverFeeToken](#8-recoverfeetoken)
      - [9. recoverGasToken](#9-recovergastoken)
    - [Modifiers](#modifiers)
      - [1. onlySelf](#1-onlyself)
      - [2. onlyActiveChain](#2-onlyactivechain)
      - [3. onlyOwner](#3-onlyowner)
    - [Functions based off OpenZeppelin's `Ownable`](#functions-based-off-openzeppelins-ownable)
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
- **configureClient**: Sets chain-specific configurations and enables/disables chains.
- **setMaxgas**: Defines maximum gas refund allowed per transaction.
- **setMaxfee**: Sets a cap on transaction fees that the system can charge per message.
- **setExsig**: Assigns external signatures for security enhancement.

*Function examples are provided in the relevant sections.*

## Example Implementation and Explanation


```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@cryptolink/contracts/message/MessageClient.sol";

contract MyCrossChainContract is MessageClient {
    // Constructor to set up the MessageV3 Client
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
    ) external override onlySelf(_sender, _sourceChainId) {
        // Decode the incoming message and process it
        // Example: (address from, uint256 value) = abi.decode(_data, (address, uint256));
        // Process the message as required
    }

    // Additional functions and logic as required for your contract
    // ...
}
```

### Notes on the Example Code

- **Initialization**: The contract is initialized with the address of the Message system, which is crucial for enabling cross-chain messaging.
- **Sending Messages**: The `sendMessageToAnotherChain` and `sendMessageExpress` functions illustrate how to send standard and express messages to other chains.
- **Processing Incoming Messages**: The `messageProcess` function is overridden to handle messages received from other chains. This function should be customized based on how you want to process incoming messages.
- **Security**: The `onlySelf` modifier ensures that only messages sent through the established Message system and configured remote contracts are processed.
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
     function messageProcess(uint _txId, uint _sourceChainId, address _sender, address _reference, uint _amount, bytes calldata _data) external virtual onlySelf(_sender, _sourceChainId) {}
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

## Using the MessageClient ABI

You can import the ABI for the `MessageClient` contract directly from the package:

```javascript
// Using CommonJS
const { MessageClientABI } = require('@cryptolink/contracts/abis');

// Using ES6 imports
import { MessageClientABI } from '@cryptolink/contracts/abis';
```

You can then load contracts using this ABI:

```javascript
const myContract = new ethers.Contract(contractAddress, MessageClientABI, signer);
```

## Using the MessageClient Configuration

You can import common addresses and configuration for the `MessageClient` contract directly from the package:

```javascript
// Using CommonJS
const chainsConfig = require('@cryptolink/contracts/config/chains');

// Using ES6 imports
import chainsConfig from '@cryptolink/contracts/config/chains';
```

You can then reference values from chains by using the chainId as an index:

```javascript
// Get the message contract address of the current network
const messageAddress = chainsConfig[hre.network.config.chainId].message; 
```

### After Deployment Configuration Script

This script is an example to be ran after all of the corresponding Client contracts have been deployed and addresses collected. This script is used to enable all of the desired chains and configure each of the contracts to accept messages from each other utilizing the ```configureClient()``` function in the package.

```javascript
const { ethers } = require('ethers');
const chainsConfig = require('@cryptolink/contracts/config/chains');
const { MessageClientABI } = require('@cryptolink/contracts/message/abi');

async function configureContract() {
    // Configuration Parameters
    const rpcUrl = 'https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY'; // Example Ethereum RPC URL
    const privateKey = '0xYOUR_PRIVATE_KEY'; // Example private key
    const contractAddress = '0xabcd...1234'; // Example deployed contract address on Ethereum

    // Initialize ethers with provider and signer
    const provider = new ethers.providers.JsonRpcProvider(rpcUrl);
    const signer = new ethers.Wallet(privateKey, provider);

    // Instantiate the contract
    const myContract = new ethers.Contract(contractAddress, MessageClientABI, signer);

    try {
        const chains = [5, 11155111, 17000]; // Desired chain IDs
        const endpoints = ['0x000000','0x000000','0x000000']; // YOUR deployed instances of ATWTest on each chain
        const confirmations = [12, 6, 6]; // Desired confirmation counts for each chain

        // Configure the client with MessageV3 address and chain data
        const tx = await myContract.configureClient(
            chainsConfig[hre.network.config.chainId].message, // Use the message contract address of the current network
            chains, 
            endpoints, 
            confirmations
        );

        console.log('Transaction sent:', tx.hash);
        await tx.wait();
        console.log('Chains configured successfully.');
    } catch (error) {
        console.error('An error occurred during configuration:', error);
    }
}

// Execute the configuration
configureContract();
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

### Recovering Fee and Gas Tokens
- Functions `recoverGasToken` and `recoverFeeToken` allow the contract owner to recover funds sent to it for fees.
  

## Supported Chains

### Mainnets

| Chain Name              | Chain ID    | Contract Address                           |
|-------------------------|-------------|--------------------------------------------|
| Alveychain Mainnet      | 3797        |  |
| Arbitrum Mainnet        | 42161       |  |
| Avalanche Mainnet       | 43114       |  |
| Base Mainnet            | 8453        |  |
| Binance Mainnet         | 56          |  |
| Celo Mainnet            | 42220       |  |
| Cronos Mainnet          | 25          |  |
| Ethereum Mainnet        | 1           |  |
| Fantom Mainnet          | 250         |  |
| Gauss Mainnet           | 1777        |  |
| Gnosis Mainnet          | 100         |  |
| Harmony Mainnet         | 1666600000  |  |
| Kava Mainnet            | 2222        |  |
| Linea Mainnet           | 59144       |  |
| Metis Mainnet           | 1088        |  |
| Oasis Emerald Mainnet   | 42262       |  |
| Polygon Mainnet         | 137         |  |
| PolygonZK Mainnet       | 1101        |  |
| Pulse Mainnet           | 369         |  |
| Rollux Mainnet          | 570         |  |


### Testnets

| Chain Name                  | Chain ID   | Contract Address                           |
|-----------------------------|------------|--------------------------------------------|
| Arbitrum Testnet (Sepolia)  | 421614     | 0x0D7e59B0390e47E6C3a29cCdF68e43f3e50e2119 |
| Aurora Testnet              | 1313161555 | 0x52e1CFE18BD55bb8d885d463DC26D9C365cd316B |
| Autonity Testnet            | 65010001   | 0xA95c0BC77Ab8a8EfA3dF00366FFAe5CB1A2cba15 |
| Avalanche Testnet           | 43113      | 0x8f92F60ffFB05d8c64E755e54A216090D8D6Eaf9 |
| Base Testnet (Sepolia)      | 84532      | 0xE700Ee5d8B7dEc62987849356821731591c048cF |
| Binance Testnet             | 97         | 0x8eF8870CD5583891bDDcf2555e7833bD087392a3 |
| Blast Testnet (Sepolia)     | 168587773  | 0xA95c0BC77Ab8a8EfA3dF00366FFAe5CB1A2cba15 | 
| Boba Testnet                | 2888       | 0x1Ec7Dfbc9e310768A17145f03f3451f562cEc773 |
| Canto Testnet               | 7701       | 0x09FC1B8e1651A0D35258Ab919035d3087245F8f3 |
| Celo Testnet                | 44787      | 0xc959284fae7Cc3F41367dA2Df595b7267597094C |
| Cronos Testnet              | 338        | 0x8f92F60ffFB05d8c64E755e54A216090D8D6Eaf9 |
| CronosZK Testnet            | 282        | 0xCf421b3497a28b4215F09e5bAf862C3a2532d681 |
| Ethereum Goerli             | 5          | 0xae65E2211c4119cf92ee85D1a8c4ec20AdaE8aFE |
| Ethereum Holesky            | 17000      | 0x668de98389d5d6C9064E40Cfda2FC6471EDDE7ff |
| Ethereum Sepolia            | 11155111   | 0xF2AA17F92d4D9Be1c0b0D2A3235A06143A2D729f |
| Fantom Testnet              | 4002       | 0x48964a49B5826DB6Cb8d8ed0dAf93eEeD734b923 |
| Forest Testnet              | 377        | 0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F |
| Frame Testnet               | 68840142   | 0xCb69924aDf996315aDcd9051ccE2B572dD9450a9 |
| Gauss Testnet               | 1452       | 0xcbC2d50FA324c187adcf4a186fCb7EcC092E0758 |
| Gelato OP Celestia Testnet  | 123420111  | 0xAede7a77D49Eb88Cb129896d69f0E66ee51D44AC |
| Gelato OP Testnet           | 42069      | 0xAede7a77D49Eb88Cb129896d69f0E66ee51D44AC |
| Gelato ZKatana Testnet      | 1261120    | 0xAede7a77D49Eb88Cb129896d69f0E66ee51D44AC |
| Gnosis Testnet              | 10200      | 0x88776c0FbaCA594938C6B87a42a69D530A8CCDF3 |
| Harmony Testnet             | 1666700000 | 0x9cAa65b69Ad8118C3d1454393F5b96292FE3C0aB |
| Horizen Testnet             | 1663       | 0xA95c0BC77Ab8a8EfA3dF00366FFAe5CB1A2cba15 |
| Immutable Testnet           | 13473      | 0xC7E87B6614DAb7a4B3Feaa9e56a2cA29A84AD0a8 |
| Katla Testnet               | 167008     | 0xA95c0BC77Ab8a8EfA3dF00366FFAe5CB1A2cba15 |
| Kava Testnet                | 2221       | 0xd577fcBee5734c2da5e0063fF1df38845DaA7117 |
| Klaytn Testnet              | 1001       | 0xdCa897f920Df8015169838c428479D5e3d5Bf526 |
| Kyoto Testnet               | 1998       | 0xdCa897f920Df8015169838c428479D5e3d5Bf526 |
| Linea Testnet               | 59140      | 0x0eefCF172F7e5C04A8d565f4e955968221fDb18f |
| Mainnetz Testnet            | 9768       | 0x714c9202B3B5AF0C0Ad844c2a71803cebBFD3AF5 |
| Mantle Testnet              | 5001       | 0x02894D48c53Ad4AF56ab9624A07153C4fc379D9C |
| Metis Testnet               | 599        | 0x8E872249C1D7c533bCDC04f5ac124eCa603E0b6D |
| Oasis Emerald Testnet       | 42261      | 0x9Ca377D441B01A44fEab8D75B992ab2e4f710BA9 |
| Oasis Sapphire Testnet      | 23295      | 0x9c90eC23162C818A79B46C79Bb6EBC07C6733919 |
| OKEx Testnet                | 65         | 0x9744D38d26eF45C31c8D20783671506FebeDBAC4 |
| Onus Testnet                | 1945       | 0xF8d80d6E52b5B8484a7CD27a5C0F3D35695c57dF |
| opBNB Testnet               | 5611       | 0x7bB78097d7e672D65cD6596Ee9b4097CE16AC391 |
| Optimism Testnet            | 11155420   | 0xe511183765E1F325702EF8F3d92046e9d6DF6742 |
| Polygon Testnet             | 80001      | 0x524d9E4cB344A130696B29c182aA5a4A458379B6 |
| Polygon zkEVM Testnet       | 1442       | 0xe72599F2F5C8aA96E578E48A09Bc6C1123fA5783 |
| Pulse Testnet               | 943        | 0x91e26475016B923527B5Ef15789A9768EBA979e6 |
| Redstone Testnet            | 17001      | 0x1Ec7Dfbc9e310768A17145f03f3451f562cEc773 |
| Rollux Testnet              | 57000      | 0x7bB78097d7e672D65cD6596Ee9b4097CE16AC391 |
| Scroll Testnet (Sepolia)    | 534351     | 0x8Dcb34c02365116565A3d68b97e4ae98F983B9D0 |
| Sonic Testnet               | 64165      | 0xeFaDc14c2DD95D0E6969d0B25EA6e4F830150493 |
| Stratos Testnet             | 2047       | 0x4a7B33299a21c518d77eb3fF00fd1DC39C452Cba |
| Telos Testnet               | 41         | 0xF8d80d6E52b5B8484a7CD27a5C0F3D35695c57dF |
| X1 Testnet                  | 195        | 0x8f554B1b239a57C840d5902D1d901dAFF04F22C2 |
| ZetaChain Testnet           | 7001       | 0x714c9202B3B5AF0C0Ad844c2a71803cebBFD3AF5 |
| zkSync Testnet              | 280        | 0xCf421b3497a28b4215F09e5bAf862C3a2532d681 |



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
- **Modifiers**: `onlySelf`
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
- **Purpose**: Configures the client with MessageV3 address and chain data.
- **Visibility**: External
- **Modifiers**: `onlyMessageOwner`
- **Parameters**:
  - `_messageV3` (address): MessageV3 address.
  - `_chains` (uint[]): List of chain IDs to accept as valid destinations.
  - `_endpoints` (address[]): List of corresponding `MessageClient` addresses on each chain.
  - `_confirmations` (uint16[]): Confirmations required on each chain before processing.
- **Returns**: None

#### 5. setExsig
- **Purpose**: Assigns an external signature for enhanced security.
- **Visibility**: External
- **Modifiers**: `onlyMessageOwner`
- **Parameters**:
  - `_signer` (address): Address of the signer.
- **Returns**: None

#### 6. setMaxgas
- **Purpose**: Limits the gas usage for transactions.
- **Visibility**: External
- **Modifiers**: `onlyMessageOwner`
- **Parameters**:
  - `_maxGas` (uint): Maximum gas amount.
- **Returns**: None

#### 7. setMaxfee
- **Purpose**: Caps the fee amount per transaction.
- **Visibility**: External
- **Modifiers**: `onlyMessageOwner`
- **Parameters**:
  - `_maxFee` (uint): Maximum fee amount.
- **Returns**: None

#### 8. recoverFeeToken
- **Purpose**: Recovers Fee Tokens from the contract.
- **Visibility**: External
- **Modifiers**: `onlyMessageOwner`
- **Parameters**:
  - `_amount` (uint): Amount of tokens to recover.
- **Returns**: None

#### 9. recoverGasToken
- **Purpose**: Recovers Gas Tokens (WETH) from the contract.
- **Visibility**: External
- **Modifiers**: `onlyMessageOwner`
- **Parameters**:
  - `_amount` (uint): Amount of tokens to recover.
- **Returns**: None

### Modifiers

#### 1. onlySelf
- **Purpose**: Ensures that the function is called only by the authorized `MessageClient` contract from the source chain. This modifier will pass if the message originated from any deployment of this contract on any chain.

#### 2. onlyActiveChain
- **Purpose**: Ensures that the destination chain is active before sending a message.

#### 3. onlyOwner
- **Purpose**: Restricts function access to the contract owner.

### Functions based off OpenZeppelin's `Ownable`

1. **renounceMessageOwnership()**
   - **Purpose**: Leaves the contract without an owner, making it impossible to call `onlyMessageOwner` functions.
   - **Visibility**: Public
   - **Important Note**: Use with caution as it removes any functionality only available to the owner.

2. **transferMessageOwnership(newOwner)**
   - **Purpose**: Transfers ownership of the contract to a new account (`newOwner`).
   - **Visibility**: Public
   - **Parameters**:
     - `newOwner` (address): Address of the new owner.

### Event

1. **MessageOwnershipTransferred(previousOwner, newOwner)**
   - **Purpose**: Emitted when ownership of the contract is transferred.
   - **Parameters**:
     - `previousOwner` (address): Address of the previous owner.
     - `newOwner` (address): Address of the new owner.
