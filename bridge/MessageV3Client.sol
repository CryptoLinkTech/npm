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
        uint fee; // MIN FEE with 6 decimals of allowed max precision
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
            if     (block.chainid == 421614)     _bridge = address(0x207CbCa48258591CD1e953739c663184A02bB320); // Arbitrum Testnet (sepolia)
            else if(block.chainid == 1313161555) _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Aurora Testnet
            else if(block.chainid == 43113)      _bridge = address(0x24BEFF24327C8E956d5FC74a5C502038683cDc0A); // Avalanche Testnet
            else if(block.chainid == 84532)      _bridge = address(0x18716F6E46a66919deacD3c6fd4fa6Da02fa30b2); // Base Testnet (sepolia)
            else if(block.chainid == 2888)       _bridge = address(0xAF1f0C79cc043AD4a263dfe7715ca657F9bDeced); // Boba Testnet
            else if(block.chainid == 97)         _bridge = address(0x535CCeD6C471eE907eEB3bBECf1C8223208Ca5e0); // Binance Testnet
            else if(block.chainid == 7701)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Canto Testnet
            else if(block.chainid == 44787)      _bridge = address(0x6e658066340C7cae09dB68F5339Ddc4b806d3598); // Celo Testnet
            else if(block.chainid == 338)        _bridge = address(0x8eb10FC1793094113E7f52bA159A6AeB54CaB92c); // Cronos Testnet 
            else if(block.chainid == 4002)       _bridge = address(0x7d474aA4DbDBc276b67abcc5f54262978b369cEC); // Fantom Testnet
            else if(block.chainid == 5)          _bridge = address(0x566B40Dd59A868c244E1353368e08ddaD1C1d74f); // Ethereum Goerli
            else if(block.chainid == 17000)      _bridge = address(0x9d75f706b986F0075b3778a12153390273dE95eC); // Ethereum Holesky
            else if(block.chainid == 11155111)   _bridge = address(0x8DE416ABd87307f966a5655701F2f78012585225); // Ethereum Sepolia
            else if(block.chainid == 377)        _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Forest Testnet
            else if(block.chainid == 68840142)   _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Frame Testnet
            else if(block.chainid == 1452)       _bridge = address(0x6c83DC6C5128ff3E073E737523D2176aAeB08525); // Gauss Testnet
            else if(block.chainid == 10200)      _bridge = address(0x146449fb27e4A4B4721a9c5742f3baB1e34eb31f); // Gnosis Testnet
            else if(block.chainid == 1666700000) _bridge = address(0xE0a5cBb1f15a84C4a4A0f7E98F9721997182deD6); // Harmony Testnet
            else if(block.chainid == 13473)      _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Immutable Testnet
            else if(block.chainid == 2221)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Kava Testnet
            else if(block.chainid == 1001)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Klaytn Testnet
            else if(block.chainid == 1998)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Kyoto Testnet
            else if(block.chainid == 59140)      _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Linea Testnet
            else if(block.chainid == 9768)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Mainnetz Testnet
            else if(block.chainid == 5001)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Mantle Testnet
            else if(block.chainid == 599)        _bridge = address(0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33); // Metis Testnet
            else if(block.chainid == 42261)      _bridge = address(0x566B40Dd59A868c244E1353368e08ddaD1C1d74f); // Oasis Emerald Testnet
            else if(block.chainid == 23295)      _bridge = address(0x566B40Dd59A868c244E1353368e08ddaD1C1d74f); // Oasis Sapphire Testnet
            else if(block.chainid == 65)         _bridge = address(0xF1FBB3E9977dAcF3909Ab541792cB2Bba10FFD5E); // OKEx Testnet
            else if(block.chainid == 1945)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Onus Testnet
            else if(block.chainid == 11155420)   _bridge = address(0xB4245BFEA4AfE63c7F7863D090166890e9FEf1b2); // Optimism Testnet
            else if(block.chainid == 80001)      _bridge = address(0x08A2d304547A4B93B254d906502A3fc778D78412); // Polygon Testnet
            else if(block.chainid == 1442)       _bridge = address(0xcA877c797D599bE2Bf8C897a3B9eba6bA4113332); // Polygon zkEVM Testnet
            else if(block.chainid == 943)        _bridge = address(0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33); // Pulse Testnet
            else if(block.chainid == 17001)      _bridge = address(0x9d75f706b986F0075b3778a12153390273dE95eC); // Redstone Testnet
            else if(block.chainid == 534351)     _bridge = address(0x23E2CE1fF48cF21239f8c5eb783CE89df02B6f35); // Scroll Testnet (sepolia)
            else if(block.chainid == 41)         _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // Telos Testnet
            else if(block.chainid == 195)        _bridge = address(0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33); // X1 Testnet
            else if(block.chainid == 51)         _bridge = address(0x0EFafca24E5BbC1C01587B659226B9d600fd671f); // XDC Testnet
            else if(block.chainid == 7001)       _bridge = address(0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F); // ZetaChain Testnet
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