// SPDX-License-Identifier: MIT
// (c)2021-2023 Atlas
// security-contact: atlas@cryptolink.tech
pragma solidity ^0.8.20;

import "../MessageClient.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SimpleNFT is ERC721, ERC721Enumerable, Ownable, MessageClient {
    uint public COUNTER;

    string public BASE_URI  = "https://example.com/metadata/";
    uint   public BUY_PRICE = 10 ether;
    uint   public BRIDGE_PRICE = 0;
    IERC20 public BUY_TOKEN = IERC20(address(0)); // todo: update with wanted token address for deployed chain!

    constructor() ERC721("Simple Cross Chain NFT", "sNFT") Ownable(msg.sender) {}

    /** USER */
    function mint() external returns (uint _nftId) {
        SafeERC20.safeTransferFrom(BUY_TOKEN, msg.sender, address(this), BUY_PRICE);

        _nftId = _mint(msg.sender);
    }

    function _mint(address _to) private returns (uint _nftId) {
        uint _currId = COUNTER;
        require(_currId < 1000, "mint at max capacity");

        _nftId = (block.chainid * 10**7) + _currId;
        _safeMint(_to, _nftId);

        COUNTER++;
    }

    function bridge(address _to, uint _chainId, uint _nftId) public onlyActiveBridge(_chainId) returns (uint _txId) {
        require(_ownerOf(_nftId) == msg.sender, "you do not own this nft");

        // take fee for bridging
        SafeERC20.safeTransferFrom(BUY_TOKEN, msg.sender, address(this), BRIDGE_PRICE);

        // burn the nft from source chain
        _burn(_nftId);

        // data package to send across chain
        bytes memory _data = abi.encode(
            _to,
            _nftId
        );

        // send cross chain message
        return _sendMessage(
            _chainId,      // id of the destination chain
            _data          // arbitrary data package to send
        );
    }

    /** BRIDGE RECEIVER */
    function messageProcess(uint, uint _sourceChainId, address _sender, address, uint, bytes calldata _data) external override onlySelfBridge(_sender, _sourceChainId) {
        // process data package from source chain
        (address _to, uint _nftId) = abi.decode(_data, (address, uint));

        // mint/send nft
        _safeMint(_to, _nftId);
    }

    /** VIEWS */
    function walletOfOwner(address _owner) external view returns (uint[] memory _nftIds) {
        uint _count = balanceOf(_owner);
        _nftIds = new uint[](_count);

        for (uint x = 0; x < _count; x++) {
            _nftIds[x] = tokenOfOwnerByIndex(_owner, x);
        }
    }

    function tokenURI(uint _nftId) public view override returns (string memory _uri) {
        return string(abi.encodePacked(BASE_URI, _nftId, ".json"));
    }

    function _update(address _to, uint256 _tokenId, address _auth) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(_to, _tokenId, _auth);
    }

    function _increaseBalance(address _account, uint128 _value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(_account, _value);
    }

    function supportsInterface(bytes4 _interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(_interfaceId);
    }    
}