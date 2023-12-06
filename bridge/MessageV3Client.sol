// SPDX-License-Identifier: MIT
// (c)2021-2023 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
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

            else if(block.chainid == 421614)     _bridge = address(0x0C78346555e9e04028C7C7b267dfc7d32f6B24D4); // Arbitrum Testnet (sepolia)
            else if(block.chainid == 43113)      _bridge = address(0x8b7AA007eA9BF2Bf507a4eE9ff10093898eb3FC0); // Avalanche Testnet
            else if(block.chainid == 84532)      _bridge = address(0x8507a0Bb83e5663E5BB4CacfF66f6E3c558C0726); // Base Testnet (sepolia)
            else if(block.chainid == 97)         _bridge = address(0xcA877c797D599bE2Bf8C897a3B9eba6bA4113332); // Binance Testnet
            else if(block.chainid == 44787)      _bridge = address(0xBD49b9156D288367a5364F9857a4e951374A0E87); // Celo Testnet
            else if(block.chainid == 338)        _bridge = address(0xbcAc93907BD9436f956273aE8Ed431F092BD5590); // Cronos Testnet
            else if(block.chainid == 4002)       _bridge = address(0xD07129F94934757A1653de9cb076910de39Fba6F); // Fantom Testnet
            else if(block.chainid == 1452)       _bridge = address(0xAEB094Cb391cFf1978FD157D34FE146ba117b4ac); // Gauss Testnet
            else if(block.chainid == 10200)      _bridge = address(0xF1FBB3E9977dAcF3909Ab541792cB2Bba10FFD5E); // Gnosis Testnet
            else if(block.chainid == 1666700000) _bridge = address(0x9eF05C01d9A393eec6c26FCc2B726025ab14Ef31); // Harmony Testnet
            else if(block.chainid == 599)        _bridge = address(0x46917eFCC99E624fE035AC9D02afB61141a53F7b); // Metis Testnet
            else if(block.chainid == 65)         _bridge = address(0xc14D902deeFF0Efa668Dc0405A97685BBAd79Db3); // OKEx Testnet
            else if(block.chainid == 11155420)   _bridge = address(0x18716F6E46a66919deacD3c6fd4fa6Da02fa30b2); // Optimism Testnet
            else if(block.chainid == 80001)      _bridge = address(0x3CA2E8eCBe81C1a86E13415b0e7634A9a47270D6); // Polygon Testnet
            else if(block.chainid == 1442)       _bridge = address(0xbcAc93907BD9436f956273aE8Ed431F092BD5590); // Polygon zkEVM Testnet
            else if(block.chainid == 943)        _bridge = address(0x54c82B81Bbb4252543eE5055074Aba65D123dFA8); // Pulse Testnet
            else if(block.chainid == 534351)     _bridge = address(0xB09780607F0cbCC3c7B95f17d42417269ED53a1D); // Scroll Testnet (sepolia)
            else if(block.chainid == 195)        _bridge = address(0x46917eFCC99E624fE035AC9D02afB61141a53F7b); // X1 Testnet
            require(_bridge != address(0), "invalid chain in list");
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