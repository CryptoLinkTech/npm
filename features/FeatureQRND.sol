// SPDX-License-Identifier: MIT
// (c)2021-2024 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;
import "./FeatureBase.sol";

abstract contract FeatureQRND is FeatureBase {   
    function _requestQRND() internal {
        _requestQRND('');
    }

    function _requestQRND(bytes memory _data) internal {
        _sendMessageWithFeature(block.chainid, _data, uint32(1000000), '');
    }
}