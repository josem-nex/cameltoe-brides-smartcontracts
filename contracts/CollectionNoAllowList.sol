// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyToken is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Pausable,
    ERC721Royalty,
    Ownable
{
    using Strings for uint256;

    uint256 public maxSupply;
    uint256 private _nextTokenId;

    uint256 public pricePublicMint;
    uint256 private priceIncrement; //porcentual increment

    bool private publicMintOpen = false;

    mapping(address => uint256) private countMinted;
    uint256 private maxMintPerAddress;

    // token uri section
    string public currentBaseURI;
    string private baseExtension;

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
        uint256 _maxMintPerAddress,
        string memory baseURI,
        string memory extension, //  usually ".json"
        uint256 _pricePublicMint,
        uint8 _priceIncrement, // 20 = 20%, 100 = 100%
        uint96 _royaltyFee // 10000 = 100%,  500 = 5%
    ) ERC721(name, symbol) Ownable(msg.sender) {
        _setDefaultRoyalty(msg.sender, _royaltyFee); // 5%
        maxSupply = _maxSupply;
        maxMintPerAddress = _maxMintPerAddress;
        currentBaseURI = baseURI;
        baseExtension = extension;
        pricePublicMint = _pricePublicMint;
        priceIncrement = _priceIncrement;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function editMintWindow(bool _publicMintOpen) external onlyOwner {
        publicMintOpen = _publicMintOpen;
    }

    function publicMint() public payable {
        require(publicMintOpen, "Public Mint is not open");
        require(msg.value == pricePublicMint, "Incorrect amount");
        require(totalSupply() < maxSupply, "Token limit reached");
        require(
            countMinted[msg.sender] < maxMintPerAddress,
            "Max mint per address reached"
        );

        pricePublicMint = (pricePublicMint * (priceIncrement + 100)) / 100;

        uint256 tokenId = _nextTokenId++;
        string memory thistokenURI = string(
            abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
        );
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, thistokenURI);
        countMinted[msg.sender] += 1;
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        currentBaseURI = baseURI;
    }

    function withdraw(address _to) public onlyOwner {
        uint256 balance = address(this).balance;
        payable(_to).transfer(balance);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    function setRoyaltyFee(uint96 _royaltyFee, address _to) public onlyOwner {
        _setDefaultRoyalty(_to, _royaltyFee);
    }
}
