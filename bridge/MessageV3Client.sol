// SPDX-License-Identifier: MIT
// (c)2021-2023 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMessageV3.sol";

/**
 * @title MessageV3 Client
 * @author CryptoLink.Tech <atlas@cryptolink.tech>
 */
abstract contract MessageV3Client is Ownable {
    IMessageV3 public BRIDGE;
    IERC20 public FEE_TOKEN;

    struct ChainData {
        uint fee; // MIN FEE in ether in "feeToken" normalized to 18 decimals
        uint price; // fee for us (you) to charge on source when sending to this dest
        address endpoint; // dest chain contract address
        uint16 confirmations; // source confirmations
    }

    mapping(uint => ChainData) public CHAINS;

    modifier onlySelfBridge(address _sender, uint _sourceChainId) {
        require(msg.sender == address(BRIDGE), "not authorized");
        require(_sender == CHAINS[_sourceChainId].endpoint, "not authorized");
        _;
    }

    modifier onlyActiveBridge(uint _destinationChainId) {
        require(CHAINS[_destinationChainId].endpoint != address(0), "destination chain not active");
        _;
    }

    /** BRIDGE RECEIVER */
    function messageProcess(uint, uint _sourceChainId, address _sender, address, uint, bytes calldata _data) external virtual onlySelfBridge (_sender, _sourceChainId) {
    }

    /** BRIDGE SENDER */
    // @dev backwards compat with BridgeClientV2
    function _sendMessage(uint _destinationChainId, address, bytes memory _data) internal returns (uint _txId) {
        ChainData memory _chain = CHAINS[_destinationChainId];
        return IMessageV3(BRIDGE).sendMessage(
            _chain.endpoint,      // contract address on destination chain
            _destinationChainId,  // id of the destination chain
            _data,                // arbitrary data package to send
            _chain.confirmations, // amount of required transaction confirmations
            false                 // send express mode on destination
        );
    }

    function _sendMessageExpress(uint _destinationChainId, address, bytes memory _data) internal returns (uint _txId) {
        ChainData memory _chain = CHAINS[_destinationChainId];
        return IMessageV3(BRIDGE).sendMessage(
            _chain.endpoint,      // contract address on destination chain
            _destinationChainId,  // id of the destination chain
            _data,                // arbitrary data package to send
            _chain.confirmations, // amount of required transaction confirmations
            true                  // send express mode on destination
        );
    }

    /** OWNER */
    function configureBridge(
        address _bridge, 
        uint[] calldata _chains,
        uint[] calldata _prices,
        address[] calldata _endpoints, 
        uint16[] calldata _confirmations
    ) external onlyOwner {
        if(_bridge == address(0)) {
            if     (block.chainid == 1)         _bridge = address(0); // Ethereum
            else if(block.chainid == 43114)     _bridge = address(0); // Avalanche
            else if(block.chainid == 8453)      _bridge = address(0); // Base
            else if(block.chainid == 56)        _bridge = address(0); // Binance
            else if(block.chainid == 42220)     _bridge = address(0); // Celo 
            else if(block.chainid == 25)        _bridge = address(0); // Cronos
            else if(block.chainid == 250)       _bridge = address(0); // Fantom
            else if(block.chainid == 1777)      _bridge = address(0); // Gauss
            else if(block.chainid == 1666600000)_bridge = address(0); // Harmony
            else if(block.chainid == 1088)      _bridge = address(0); // Metis
            else if(block.chainid == 42262)     _bridge = address(0); // Oasis
            else if(block.chainid == 137)       _bridge = address(0); // Polygon
            else if(block.chainid == 369)       _bridge = address(0); // Pulsechain

            else if(block.chainid == 421614)     _bridge = address(0x09137471942530BF2BEe56a8753745D2C8fc0560); // Arbitrum Testnet (sepolia)
            else if(block.chainid == 43113)      _bridge = address(0x38DE8d52544D60adA3d5FEFD548528FdeeccF334); // Avalanche Testnet
            else if(block.chainid == 84532)      _bridge = address(0x9A148b374500B710c6215a131eE55E6E13fC8284); // Base Testnet (sepolia)
            else if(block.chainid == 97)         _bridge = address(0x06EF0100f5CA88E6F1F5742BD3a913D29Db39505); // Binance Testnet
            else if(block.chainid == 44787)      _bridge = address(0x9Ca377D441B01A44fEab8D75B992ab2e4f710BA9); // Celo Testnet
            else if(block.chainid == 338)        _bridge = address(0x9c90eC23162C818A79B46C79Bb6EBC07C6733919); // Cronos Testnet
            else if(block.chainid == 4002)       _bridge = address(0xd8786BCED05F38a0bDdFb14711872E045931878E); // Fantom Testnet
            else if(block.chainid == 1452)       _bridge = address(0x5d0693Fd8AB0046c944e7618451A16FF2248Cc6F); // Gauss Testnet
            else if(block.chainid == 10200)      _bridge = address(0xCdc7D21D3F75809ec8CC3030AB8018A98AD0b296); // Gnosis Testnet
            else if(block.chainid == 1666700000) _bridge = address(0x5d0693Fd8AB0046c944e7618451A16FF2248Cc6F); // Harmony Testnet
            else if(block.chainid == 599)        _bridge = address(0xc5f8fbE61aF2b5f0DB8A51e10133062e54F77947); // Metis Testnet
            else if(block.chainid == 65)         _bridge = address(0x2f3bc26eFE51bBe209E0afD2Da29616cF3755E03); // OKEx Testnet
            else if(block.chainid == 11155420)   _bridge = address(0x9Ca377D441B01A44fEab8D75B992ab2e4f710BA9); // Optimism Testnet
            else if(block.chainid == 80001)      _bridge = address(0xAfA6622B2Be450aC6752A6a5e6955B7D73E206B9); // Polygon Testnet
            else if(block.chainid == 1442)       _bridge = address(0xc5f8fbE61aF2b5f0DB8A51e10133062e54F77947); // Polygon zkEVM Testnet
            else if(block.chainid == 940)        _bridge = address(0xae65E2211c4119cf92ee85D1a8c4ec20AdaE8aFE); // Pulse Testnet
            else if(block.chainid == 534351)     _bridge = address(0x2f3bc26eFE51bBe209E0afD2Da29616cF3755E03); // Scroll Testnet (sepolia)
            else if(block.chainid == 195)        _bridge = address(0xc5f8fbE61aF2b5f0DB8A51e10133062e54F77947); // X1 Testnet
        }

        BRIDGE    = IMessageV3(_bridge);
        FEE_TOKEN = IERC20(BRIDGE.feeToken());

        uint _chainsLength = _chains.length;
        for(uint x=0; x < _chainsLength; x++) {
            CHAINS[_chains[x]].fee = BRIDGE.minTokenForChain(_chains[x]);
            CHAINS[_chains[x]].confirmations = _confirmations[x];
            CHAINS[_chains[x]].endpoint = _endpoints[x];
            CHAINS[_chains[x]].price = _prices[x];
        }

        // approve bridge for source chain fees (limited per transaction with setMaxfee)
        if(address(FEE_TOKEN) != address(0)) {
            FEE_TOKEN.approve(address(BRIDGE), type(uint).max);
        }

        // approve bridge for destination gas fees (limited per transaction with setMaxgas)
        if(address(BRIDGE.weth()) != address(0)) {
            IERC20(BRIDGE.weth()).approve(address(BRIDGE), type(uint).max);
        }
    }

    function setExsig(address _signer) external onlyOwner {
        BRIDGE.setExsig(_signer);
    }

    function setMaxgas(uint _maxGas) external onlyOwner {
        BRIDGE.setMaxgas(_maxGas);
    }

    function setMaxfee(uint _maxFee) external onlyOwner {
        BRIDGE.setMaxfee(_maxFee);
    }
}