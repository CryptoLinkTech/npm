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
        uint fee; // MIN FEE in ether in "feeToken" normalized to 18 decimals (fees taken out, change delivered to dest contract)
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

            else if(block.chainid == 421614)     _bridge = address(0xbd9F6E783a2872f703953F0db1d6D60912F86af4); // Arbitrum Testnet (sepolia)
            else if(block.chainid == 43113)      _bridge = address(0x950F4E9a06b2Cd3049B4A57B9DD9B83D16a26EFc); // Avalanche Testnet
            else if(block.chainid == 97)         _bridge = address(0x714853D6197e560013ee161fC259b87E8B3cA7E9); // Binance Testnet
            else if(block.chainid == 44787)      _bridge = address(0x33b965Bcbdfa7367178304A8517eB725CD244f65); // Celo Testnet
            else if(block.chainid == 338)        _bridge = address(0x33b965Bcbdfa7367178304A8517eB725CD244f65); // Cronos Testnet
            else if(block.chainid == 4002)       _bridge = address(0x9A148b374500B710c6215a131eE55E6E13fC8284); // Fantom Testnet
            else if(block.chainid == 1452)       _bridge = address(0x714853D6197e560013ee161fC259b87E8B3cA7E9); // Gauss Testnet
            else if(block.chainid == 1666700000) _bridge = address(0x0135c25Bd3e88b1aac5FDC6f16FEe2C63d967f9d); // Harmony Testnet
            else if(block.chainid == 599)        _bridge = address(0x0135c25Bd3e88b1aac5FDC6f16FEe2C63d967f9d); // Metis Testnet
            else if(block.chainid == 11155420)   _bridge = address(0x33b965Bcbdfa7367178304A8517eB725CD244f65); // Optimism Testnet
            else if(block.chainid == 80001)      _bridge = address(0xd04CfEC7ff7EdBC09BB3461Ea95C7ECBCfC61bd5); // Polygon Testnet
            else if(block.chainid == 1442)       _bridge = address(0x33b965Bcbdfa7367178304A8517eB725CD244f65); // Polygon zkEVM Testnet
            else if(block.chainid == 940)        _bridge = address(0x33b965Bcbdfa7367178304A8517eB725CD244f65); // Pulse Testnet
            else if(block.chainid == 195)        _bridge = address(0x33b965Bcbdfa7367178304A8517eB725CD244f65); // X1 Testnet
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

        // approve bridge for source chain fees
        FEE_TOKEN.approve(address(BRIDGE), type(uint).max);

        // approve bridge for destination gas fees (limited per transaction with setMaxgas)
        IERC20(BRIDGE.weth()).approve(address(BRIDGE), type(uint).max);    
    }

    function setExsig(address _signer) external onlyOwner {
        BRIDGE.setExsig(_signer);
    }

    function setMaxgas(uint _maxGas) external onlyOwner {
        BRIDGE.setMaxgas(_maxGas);
    }
}