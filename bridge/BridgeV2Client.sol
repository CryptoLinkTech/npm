// SPDX-License-Identifier: MIT
// (c)2021-2023 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IBridgeV2.sol";

/**
 * @title Bridge Client
 * @author CryptoLink.Tech <atlas@cryptolink.tech>
 */
abstract contract BridgeV2Client is Ownable {
    IBridgeV2 public BRIDGE;
    IERC20    public PAPER;

    struct ChainData {
        uint fee; // MIN FEE in PAPER by Bridge (fees taken out, change delivered to dest contract)
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
    function _sendMessage(uint _destinationChainId, address _source, bytes memory _data) internal returns (uint _txId) {
        ChainData memory _chain = CHAINS[_destinationChainId];
        return IBridgeV2(BRIDGE).sendRequest(
            _chain.endpoint,     // contract address on destination chain
            _destinationChainId, // id of the destination chain
            _chain.fee,          // amount of tokens to send
            _source,             // "source" address for tracking
            _data,               // arbitrary data package to send
            _chain.confirmations // amount of required transaction confirmations
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
            if     (block.chainid == 1)         _bridge = address(0x83F46Bb0bc8bcEfe48E3eE98e8230e44A50877eB); // Ethereum
            else if(block.chainid == 43114)     _bridge = address(0x6DCb6A1De98Cf9293603AA992093da91702FF3eB); // Avalanche
            else if(block.chainid == 8453)      _bridge = address(0xC583294f30C76438e03B9B6f3B6F00bfe5FAb014); // Base
            else if(block.chainid == 56)        _bridge = address(0x478BdcDe3B67D4407e3Bf981c7FF73eAFa553a4F); // Binance
            else if(block.chainid == 42220)     _bridge = address(0x3886809F42D7B100f054A1E34B49D96D1F3b3516); // Celo 
            else if(block.chainid == 25)        _bridge = address(0x84C9a6e6D013b9f28B8b9C392ae1c8AE044271dF); // Cronos
            else if(block.chainid == 250)       _bridge = address(0x610efbCbdf6FA413daEC1C0f27cF899f74E17970); // Fantom
            else if(block.chainid == 1777)      _bridge = address(0xf317e1Ec40d8f95F0bD8a84E83d32430C15e796d); // Gauss
            else if(block.chainid == 1666600000)_bridge = address(0x3309F8Ec209bBAD3DFa278fc28B4f88D5d1F05cc); // Harmony
            else if(block.chainid == 1088)      _bridge = address(0x82719FC6024a1B6133c1A153661227f9aCcC7cD4); // Metis
            else if(block.chainid == 42262)     _bridge = address(0x4338c4E3773735b488166E0C42D5Caee2227bBCB); // Oasis
            else if(block.chainid == 137)       _bridge = address(0xaf0d056D59F4290C9B691B4A785E5BC3bf7F8881); // Polygon
            else if(block.chainid == 369)       _bridge = address(0x43b5344361F821B250254FB242D4818fD2F5CaeF); // Pulsechain
        }

        BRIDGE = IBridgeV2(_bridge);
        PAPER  = IERC20(BRIDGE.paper());

        uint _chainsLength = _chains.length;
        for(uint x=0; x < _chainsLength; x++) {
            CHAINS[_chains[x]].fee = BRIDGE.minTokenForChain(_chains[x]);
            CHAINS[_chains[x]].confirmations = _confirmations[x];
            CHAINS[_chains[x]].endpoint = _endpoints[x];
            CHAINS[_chains[x]].price = _prices[x];
        }

        PAPER.approve(address(BRIDGE), type(uint).max);
    }
}