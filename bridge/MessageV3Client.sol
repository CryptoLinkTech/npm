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

            else if(block.chainid == 421614)     _bridge = address(0x05730dAC0b9cd39f37F0415EB4E503Ea7A8bBa1B); // Arbitrum Testnet (sepolia)
            else if(block.chainid == 43113)      _bridge = address(0x665B3D012b8Ead9FdB7AA973bb79Af3C035D7c1b); // Avalanche Testnet
            else if(block.chainid == 84532)      _bridge = address(0x558c52b67594faf5Fdb0cAACAa906d05Ae1F3c4F); // Base Testnet (sepolia)
            else if(block.chainid == 97)         _bridge = address(0xa143a4d139b85959B20c8c50E52B4845E5c16bD4); // Binance Testnet
            else if(block.chainid == 44787)      _bridge = address(0x6732F9F60C764159a50B84DD6F9ACff631D9a42f); // Celo Testnet
            else if(block.chainid == 338)        _bridge = address(0x9a535F991620615f2a24ba28949b056aFe6bd1dA); // Cronos Testnet
            else if(block.chainid == 4002)       _bridge = address(0x491F2495D20B81F9674386FB698b15e99A206deA); // Fantom Testnet
            else if(block.chainid == 1452)       _bridge = address(0x8683C7031E38577c720CA97874698B2A2E05Bdc1); // Gauss Testnet
            else if(block.chainid == 10200)      _bridge = address(0xf0B8DfCdDC9587d00F3ace2d123FD1F04DDB6211); // Gnosis Testnet
            else if(block.chainid == 1666700000) _bridge = address(0x5eB3c4f89d76C05b81714d6126642EF6EA86C9aE); // Harmony Testnet
            else if(block.chainid == 599)        _bridge = address(0x292A4A28f143B951fBE8bBa32d176c33674286Ad); // Metis Testnet
            else if(block.chainid == 65)         _bridge = address(0xdD15300544b66ffACD50EA5917194142f04a0b9a); // OKEx Testnet
            else if(block.chainid == 11155420)   _bridge = address(0x2Ba3070E0FF0fd46BC300FB071b6771FF094a2d1); // Optimism Testnet
            else if(block.chainid == 80001)      _bridge = address(0xa4F33Ae2D9A72091cF0fd2B6D142D9d6DE3E8bcA); // Polygon Testnet
            else if(block.chainid == 1442)       _bridge = address(0x990033C63B9c270af8315F7f8dB3aFC9b0E408DD); // Polygon zkEVM Testnet
            else if(block.chainid == 940)        _bridge = address(0xc864D304F9238ef4788DA60d743589a31BF8A843); // Pulse Testnet
            else if(block.chainid == 534351)     _bridge = address(0xA648df7adFa847Cf0149083857ddA1680926899F); // Scroll Testnet (sepolia)
            else if(block.chainid == 195)        _bridge = address(0x79FeD6ab7D2b277a415d0D58dbCBBcBe06D4D23D); // X1 Testnet
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