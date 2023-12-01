// SPDX-License-Identifier: MIT
// (c)2021-2023 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

interface IBridgeV2 {
    function weth() external returns (address wethTokenAddress);
    function stable() external returns (address stableTokenAddress);
    function paper() external returns (address paperTokenAddress);

    function minTokenForChain(uint chainId) external returns (uint amount);
    function sendRequest(address recipient, uint chainId, uint amount, address referrer, bytes calldata data, uint16 confirmations) external returns (uint txId);
}