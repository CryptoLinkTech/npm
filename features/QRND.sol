// SPDX-License-Identifier: MIT
// (c)2021-2024 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;
import "../message/MessageClient.sol";

abstract contract FeatureQRND is MessageClient {
    function _getRandom() internal {
        _getRandom('');
    }

    function _getRandom(bytes memory _data) internal {
        _sendMessageWithFeature(block.chainid, _data, abi.encode(bytes32("QRND")));
    }
}