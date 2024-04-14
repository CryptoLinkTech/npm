// SPDX-License-Identifier: MIT
// (c)2021-2024 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;
import "../message/MessageClient.sol";

abstract contract FeatureQRND is MessageClient {
    function getRandom(bytes memory _data)  public {
        _sendMessageWithFeature(block.chainid, _data, abi.encode(bytes32("QRND")));
    }
}