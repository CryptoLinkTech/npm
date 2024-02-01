// SPDX-License-Identifier: MIT
// (c)2021-2024 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

import "./IMessageV3.sol";
import "./IERC20cl.sol";

/**
 * @title MessageV3 Client
 * @author CryptoLink.Tech <atlas@cryptolink.tech>
 */
abstract contract MessageClient {
    IMessageV3 public MESSAGEv3;
    IERC20cl public FEE_TOKEN;

    struct ChainData {
        address endpoint; // address of this contract on specified chain
        bytes endpointExtended; // address of this contract on non EVM
        uint16 confirmations; // source confirmations
        bool extended; // are we using extended endpoint? (addresses larger than uint256)
    }
    mapping(uint => ChainData) public CHAINS;
    address public MESSAGE_OWNER;

    modifier onlySelf(address _sender, uint _sourceChainId) {
        require(msg.sender == address(MESSAGEv3), "MessageClient: not authorized");
        require(_sender == CHAINS[_sourceChainId].endpoint, "MessageClient: not authorized");
        _;
    }

    modifier onlyActiveChain(uint _destinationChainId) {
        require(CHAINS[_destinationChainId].endpoint != address(0), "MessageClient: destination chain not active");
        _;
    }

    modifier onlyMessageOwner() {
        require(msg.sender == MESSAGE_OWNER, "MessageClient: not authorized");
        _;
    }

    event OwnershipTransferred(address previousOwner, address newOwner);
    event RecoverFeeToken(address owner, uint amount);
    event RecoverGasToken(address owner, uint amount);
    event SetMaxgas(address owner, uint maxGas);
    event SetMaxfee(address owner, uint maxfee);
    event SetExsig(address owner, address exsig);

    constructor() {
        MESSAGE_OWNER = msg.sender;
    }

    function transferMessageOwnership(address _newMessageOwner) external onlyMessageOwner {
        MESSAGE_OWNER = _newMessageOwner;
        emit OwnershipTransferred(msg.sender, _newMessageOwner);
    }

    /** BRIDGE RECEIVER */
    function messageProcess(
        uint _txId,          // transaction id
        uint _sourceChainId, // source chain id
        address _sender,     // corresponding MessageClient address on source chain
        address _reference,  // (optional source reference address)
        uint _amount,        // (not used for messages, always 0)
        bytes calldata _data // encoded message from source chain
    ) external virtual onlySelf (_sender, _sourceChainId) {
    }

    /** BRIDGE SENDER */
    function _sendMessage(uint _destinationChainId, bytes memory _data) internal returns (uint _txId) {
        ChainData memory _chain = CHAINS[_destinationChainId];
        if(_chain.extended) { // non-evm addresses larger than uint256
            _data = abi.encode(_data, _chain.endpointExtended);
        }
        return IMessageV3(MESSAGEv3).sendMessage(
            _chain.endpoint,      // corresponding MessageClient contract address on destination chain
            _destinationChainId,  // id of the destination chain
            _data,                // arbitrary data package to send
            _chain.confirmations, // amount of required transaction confirmations
            false                 // send express mode on destination
        );
    }

    function _sendMessageExpress(uint _destinationChainId, bytes memory _data) internal returns (uint _txId) {
        ChainData memory _chain = CHAINS[_destinationChainId];
        if(_chain.extended) { // non-evm addresses larger than uint256
            _data = abi.encode(_data, _chain.endpointExtended);
        }
        return IMessageV3(MESSAGEv3).sendMessage(
            _chain.endpoint,      // corresponding MessageV3Client contract address on destination chain
            _destinationChainId,  // id of the destination chain
            _data,                // arbitrary data package to send
            _chain.confirmations, // amount of required transaction confirmations
            true                  // send express mode on destination
        );
    }

    /** OWNER */
    function configureClientExtended(
        uint[] calldata _chains, // list of chains to accept as valid destinations
        bytes[] calldata _endpoints, // list of corresponding MessageV3Client addresses on each chain
        uint16[] calldata _confirmations // confirmations required on each chain before processing
    ) external onlyMessageOwner {
        uint _chainsLength = _chains.length;
        for(uint x=0; x < _chainsLength; x++) {
            CHAINS[_chains[x]].confirmations = _confirmations[x];
            CHAINS[_chains[x]].endpointExtended = _endpoints[x];
            CHAINS[_chains[x]].extended = true;
        }
    }

    function configureClient(
        address _messageV3, // MessageV3 bridge address
        uint[] calldata _chains, // list of chains to accept as valid destinations
        address[] calldata _endpoints, // list of corresponding MessageV3Client addresses on each chain
        uint16[] calldata _confirmations // confirmations required on each chain before processing
    ) external onlyMessageOwner {
        MESSAGEv3 = IMessageV3(_messageV3);
        FEE_TOKEN = IERC20cl(MESSAGEv3.feeToken());

        uint _chainsLength = _chains.length;
        for(uint x=0; x < _chainsLength; x++) {
            CHAINS[_chains[x]].confirmations = _confirmations[x];
            CHAINS[_chains[x]].endpoint = _endpoints[x];
            CHAINS[_chains[x]].extended = false;
        }

        // approve bridge for source chain fees (limited per transaction with setMaxfee)
        if(address(FEE_TOKEN) != address(0)) {
            FEE_TOKEN.approve(address(MESSAGEv3), type(uint).max);
        }

        // approve bridge for destination gas fees (limited per transaction with setMaxgas)
        if(address(MESSAGEv3.weth()) != address(0)) {
            IERC20cl(MESSAGEv3.weth()).approve(address(MESSAGEv3), type(uint).max);
        }
    }

    function setExsig(address _signer) external onlyMessageOwner {
        MESSAGEv3.setExsig(_signer);
        emit SetExsig(msg.sender, _signer);
    }

    function setMaxgas(uint _maxGas) external onlyMessageOwner {
        MESSAGEv3.setMaxgas(_maxGas);
        emit SetMaxgas(msg.sender, _maxGas);
    }

    function setMaxfee(uint _maxFee) external onlyMessageOwner {
        MESSAGEv3.setMaxfee(_maxFee);
        emit SetMaxfee(msg.sender, _maxFee);
    }

    function recoverFeeToken(uint _amount) external onlyMessageOwner {
        FEE_TOKEN.transfer(msg.sender, _amount);
        emit RecoverFeeToken(msg.sender, _amount);
    }
    
    function recoverGasToken(uint _amount) external onlyMessageOwner {
        IERC20cl(MESSAGEv3.weth()).transfer(msg.sender, _amount);
        emit RecoverGasToken(msg.sender, _amount);
    } 

    receive() external payable {}
    fallback() external payable {}
}