// SPDX-License-Identifier: MIT
// (c)2021-2024 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;
import "./FeatureBase.sol";

abstract contract FeatureSMS is FeatureBase {   
    function _sendSMS(string calldata _number, string calldata _message) internal {
        _sendSMS(_number, _message, '');
    }

    function _sendSMS(string calldata _number, string calldata _message, bytes memory _data) internal {
        _sendMessageWithFeature(block.chainid, _data, uint32(1000010), abi.encode(_number, _message));
    }
}