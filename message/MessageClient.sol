// SPDX-License-Identifier: MIT
// (c)2021-2024 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMessageV3.sol";

/**
 * @title MessageV3 Client
 * @author CryptoLink.Tech <atlas@cryptolink.tech>
 */
abstract contract MessageClient is Ownable {
    IMessageV3 public MESSAGEv3;
    IERC20 public FEE_TOKEN;

    struct ChainData {
        address endpoint; // address of this contract on specified chain
        uint16 confirmations; // source confirmations
    }
    mapping(uint => ChainData) public CHAINS;

    modifier onlySelf(address _sender, uint _sourceChainId) {
        require(msg.sender == address(MESSAGEv3), "MessageClient: not authorized");
        require(_sender == CHAINS[_sourceChainId].endpoint, "MessageClient: not authorized");
        _;
    }

    modifier onlyActiveChain(uint _destinationChainId) {
        require(CHAINS[_destinationChainId].endpoint != address(0), "MessageClient: destination chain not active");
        _;
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
        return IMessageV3(MESSAGEv3).sendMessage(
            _chain.endpoint,      // corresponding MessageV3Client contract address on destination chain
            _destinationChainId,  // id of the destination chain
            _data,                // arbitrary data package to send
            _chain.confirmations, // amount of required transaction confirmations
            true                  // send express mode on destination
        );
    }

    /** OWNER */
    function configureClient(
        address _messageV3, // MessageV3 bridge address
        uint[] calldata _chains, // list of chains to accept as valid destinations
        address[] calldata _endpoints, // list of corresponding MessageV3Client addresses on each chain
        uint16[] calldata _confirmations // confirmations required on each chain before processing
    ) external onlyOwner {
        MESSAGEv3 = IMessageV3(_messageV3);
        FEE_TOKEN = IERC20(MESSAGEv3.feeToken());

        uint _chainsLength = _chains.length;
        for(uint x=0; x < _chainsLength; x++) {
            CHAINS[_chains[x]].confirmations = _confirmations[x];
            CHAINS[_chains[x]].endpoint = _endpoints[x];
        }

        // approve bridge for source chain fees (limited per transaction with setMaxfee)
        if(address(FEE_TOKEN) != address(0)) {
            FEE_TOKEN.approve(address(MESSAGEv3), type(uint).max);
        }

        // approve bridge for destination gas fees (limited per transaction with setMaxgas)
        if(address(MESSAGEv3.weth()) != address(0)) {
            IERC20(MESSAGEv3.weth()).approve(address(MESSAGEv3), type(uint).max);
        }
    }

    function setExsig(address _signer) external onlyOwner {
        MESSAGEv3.setExsig(_signer);
    }

    function setMaxgas(uint _maxGas) external onlyOwner {
        MESSAGEv3.setMaxgas(_maxGas);
    }

    function setMaxfee(uint _maxFee) external onlyOwner {
        MESSAGEv3.setMaxfee(_maxFee);
    }
}