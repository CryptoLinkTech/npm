// SPDX-License-Identifier: MIT
// (c)2021-2024 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

import "./IMessageV3.sol";
import "./IERC20cl.sol";

interface IFeature {
    function getPayload(uint _txId) external view returns (bytes memory);
}

interface IFeatureGateway {
    function isFeatureEnabled(uint32) external view returns (bool);
    function featureAddresses(uint32) external view returns (address);
    function messageV3() external view returns (IMessageV3);
    function processForward(uint _txId, uint _sourceChainId, uint _destChainId, address _sender, address _recipient, uint _gas, bytes[] calldata _data) external;
    function process(uint txId, uint sourceChainId, uint destChainId, address sender, address recipient, uint gas, uint32 featureId, bytes calldata featureReply, bytes[] calldata data) external;
}

/**
 * @title MessageV3 Client
 * @author CryptoLink.Tech <atlas@cryptolink.tech>
 */
abstract contract MessageClient {
    IMessageV3 public MESSAGEv3;
    IERC20cl public FEE_TOKEN;
    IFeatureGateway public FEATURE_GATEWAY;
    mapping(uint => mapping(uint32 => ChainData)) public FEATURES;

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

    event MessageOwnershipTransferred(address previousOwner, address newOwner);
    event RecoverToken(address owner, address token, uint amount);
    event SetMaxgas(address owner, uint maxGas);
    event SetMaxfee(address owner, uint maxfee);
    event SetExsig(address owner, address exsig);
    event SendMessageWithFeature(uint txId, uint destinationChainId, uint32 featureId, bytes featureData);

    constructor() {
        MESSAGE_OWNER = msg.sender;
    }

    function transferMessageOwnership(address _newMessageOwner) external onlyMessageOwner {
        MESSAGE_OWNER = _newMessageOwner;
        emit MessageOwnershipTransferred(msg.sender, _newMessageOwner);
    }

    /** BRIDGE RECEIVER */
    // @dev depricated, not compatible with features
    function messageProcess(
        uint _txId,          // transaction id
        uint _sourceChainId, // source chain id
        address _sender,     // corresponding MessageClient address on source chain
        address,
        uint,
        bytes calldata _data // encoded message from source chain
    ) external virtual onlySelf (_sender, _sourceChainId) {
        _processMessage(_txId, _sourceChainId, _data);
    }

    // @dev PREFERRED if no Features used
    // this is extended by the implementing class if not using Features
    function _processMessage(uint _txId, uint _sourceChainId, bytes calldata _data) internal virtual {
        (uint32 _featureId, bytes memory _featureData, bytes memory _messageData) = abi.decode(_data, (uint32, bytes, bytes));
        
        // call the implementing class to process the message
        _processMessageWithFeature(_txId, _sourceChainId, _messageData, _featureId, _featureData, _getFeatureResponse(_featureId, _txId));
    }

    // @dev REQUIRED if using Features
    // this is extended by the implementing class if using Features
    function _processMessageWithFeature(
        uint _txId,          // transaction id
        uint _sourceChainId, // source chain id
        bytes memory _data,// encoded message from source chain
        uint32 _featureId, // feature id
        bytes memory _featureData, // encoded feature data
        bytes memory _featureResponse // reply from feature processing off-chain
    ) internal virtual {
        revert("MessageClient: _processMessage or _processMessageWithFeature not implemented");
    }

    function _getFeatureResponse(uint32 _featureId, uint _txId) internal view returns (bytes memory) {
        return IFeature(FEATURE_GATEWAY.featureAddresses(_featureId)).getPayload(_txId);
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

    function _sendMessageWithFeature(uint _destinationChainId, bytes memory _messageData, uint32 _featureId, bytes memory _featureData) internal returns (uint _txId) {
        require(FEATURE_GATEWAY.isFeatureEnabled(_featureId), "MessageClient: feature not enabled");

        // wrap feature data into message data so it can be signed
        bytes memory _data = abi.encode(_featureId, _featureData, _messageData);

        ChainData memory _chain = CHAINS[_destinationChainId];
        if(_chain.extended) { // non-evm addresses larger than uint256
            _data = abi.encode(_data, _chain.endpointExtended);
        }

        _txId = IMessageV3(MESSAGEv3).sendMessage(
            _chain.endpoint,      // corresponding MessageV3Client contract address on destination chain
            _destinationChainId,  // id of the destination chain
            _data,                // arbitrary data package to send
            _chain.confirmations, // amount of required transaction confirmations
            false                 // send express mode on destination
        );

        // signal we have feature data included with the message data
        emit SendMessageWithFeature(_txId, _destinationChainId, _featureId, _featureData);
    }

    /** OWNER */
    function configureClientExtended(
        address _messageV3, // MessageV3 bridge address
        uint[] calldata _chains, // list of chains to accept as valid destinations
        bytes[] calldata _endpoints, // list of corresponding MessageV3Client addresses on each chain
        uint16[] calldata _confirmations // confirmations required on each chain before processing
    ) external onlyMessageOwner {
        uint _chainsLength = _chains.length;
        for(uint x=0; x < _chainsLength; x++) {
            CHAINS[_chains[x]].confirmations = _confirmations[x];
            CHAINS[_chains[x]].endpointExtended = _endpoints[x];
            CHAINS[_chains[x]].extended = true;
            CHAINS[_chains[x]].endpoint = address(1);
        }

        _configureMessageV3(_messageV3);
    }

    function configureClient(
        address _messageV3, // MessageV3 bridge address
        uint[] calldata _chains, // list of chains to accept as valid destinations
        address[] calldata _endpoints, // list of corresponding MessageV3Client addresses on each chain
        uint16[] calldata _confirmations // confirmations required on each chain before processing
    ) public onlyMessageOwner {
        uint _chainsLength = _chains.length;
        for(uint x=0; x < _chainsLength; x++) {
            CHAINS[_chains[x]].confirmations = _confirmations[x];
            CHAINS[_chains[x]].endpoint = _endpoints[x];
            CHAINS[_chains[x]].extended = false;
        }

        _configureMessageV3(_messageV3);
    }

    function configureFeatureGateway(address _featureGateway) external onlyMessageOwner {
        FEATURE_GATEWAY = IFeatureGateway(_featureGateway);
    }

    function _configureMessageV3(address _messageV3) internal {
        MESSAGEv3 = IMessageV3(_messageV3);
        FEE_TOKEN = IERC20cl(MESSAGEv3.feeToken());

        // approve bridge for source chain fees (limited per transaction with setMaxfee)
        if(address(FEE_TOKEN) != address(0)) {
            FEE_TOKEN.approve(address(MESSAGEv3), type(uint).max);
        }

        // approve bridge for destination gas fees (limited per transaction with setMaxgas)
        if(address(MESSAGEv3.weth()) != address(0)) {
            IERC20cl(MESSAGEv3.weth()).approve(address(MESSAGEv3), type(uint).max);
        }
    }

    function setExsig(address _signer) public onlyMessageOwner {
        MESSAGEv3.setExsig(_signer);
        emit SetExsig(msg.sender, _signer);
    }

    function setMaxgas(uint _maxGas) public onlyMessageOwner {
        MESSAGEv3.setMaxgas(_maxGas);
        emit SetMaxgas(msg.sender, _maxGas);
    }

    function setMaxfee(uint _maxFee) public onlyMessageOwner {
        MESSAGEv3.setMaxfee(_maxFee);
        emit SetMaxfee(msg.sender, _maxFee);
    }

    function recoverToken(address _token, uint _amount) public onlyMessageOwner {
        if(_token == address(0)) {
            payable(msg.sender).transfer(_amount);
        } else {
            IERC20cl(_token).transfer(msg.sender, _amount);
        }
        emit RecoverToken(msg.sender, _token, _amount);
    }

    function isSelf(address _sender, uint _sourceChainId) public view returns (bool) {
        if(_sender == CHAINS[_sourceChainId].endpoint) return true;
        return false;
    }

    function isAuthorized(address _sender, uint _sourceChainId) public view returns (bool) {
        return isSelf(_sender, _sourceChainId);
    }

    receive() external payable {}
    fallback() external payable {}
}