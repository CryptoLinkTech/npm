// SPDX-License-Identifier: MIT
// (c)2021-2023 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.19;

import "../MessageClient.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SimpleToken is ERC20, ERC20Burnable, MessageClient {
    mapping(uint => uint) public BRIDGE_PRICE;

    constructor() ERC20("Simple Cross Chain Token", "xTOKE") {
        _mint(msg.sender, 100_000_000 ether);
    }

    function bridge(address _to, uint _chainId, uint _amount) external onlyActiveChain(_chainId) returns (uint _txId) {
        // burn tokens
        _burn(msg.sender, _amount);

        // data package to send across chain
        bytes memory _data = abi.encode(_to, _amount);

        // send bridge request
        return _sendMessage(_chainId, _data);
    }

    /** BRIDGE RECEIVER */
    function messageProcess(uint, uint _sourceChainId, address _sender, address, uint, bytes calldata _data) external override onlySelf(_sender, _sourceChainId) {
        // process data package
        (address _to, uint _amount) = abi.decode(_data, (address, uint));

        // mint tokens
        _mint(_to, _amount);
    }
}