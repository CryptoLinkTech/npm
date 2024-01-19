// SPDX-License-Identifier: MIT
// (c)2021-2023 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.9;

interface IMessageV3 {
    event SendRequested(uint txId, address sender, address recipient, uint chain, bool express, bytes data, uint16 confirmations);
    event SendProcessed(uint txId, uint sourceChainId, address sender, address recipient);
    event Success(uint txId, uint sourceChainId, address sender, address recipient, uint amount);
    event ErrorLog(uint txId, string message);
    event SetExsig(address caller, address signer);
    event SetMaxgas(address caller, uint maxGas);
    event SetMaxfee(address caller, uint maxFee);

    function chainsig() external view returns (address signer);
    function weth() external view returns (address wethTokenAddress);
    function feeToken() external view returns (address feeToken);
    function feeTokenDecimals() external view returns (uint feeTokenDecimals);
    function minFee() external view returns (uint minFee);
    function bridgeEnabled() external view returns (bool bridgeEnabled);
    function takeFeesOffline() external view returns (bool takeFeesOffline);
    function whitelistOnly() external view returns (bool whitelistOnly);

    function enabledChains(uint destChainId) external view returns (bool enabled);
    function customSourceFee(address caller) external view returns (uint customSourceFee);
    function maxgas(address caller) external view returns (uint maxgas);
    function exsig(address caller) external view returns (address signer);

    // @dev backwards compat with BridgeClient
    function minTokenForChain(uint chainId) external returns (uint amount);

    function sendMessage(address recipient, uint chain, bytes calldata data, uint16 confirmations, bool express) external returns (uint txId);
    // @dev backwards compat with BridgeClient
    function sendRequest(address recipient, uint chainId, uint amount, address referrer, bytes calldata data, uint16 confirmations) external returns (uint txId);

    function setExsig(address signer) external;
    function setMaxgas(uint maxgas) external;
    function setMaxfee(uint maxfee) external;
}