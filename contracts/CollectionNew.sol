// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyToken is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Pausable,
    Ownable
{
    using Strings for uint256;

    uint256 maxSupply = 10000;
    uint256 private _nextTokenId;

    uint256 private pricePublicMint = 0.01 ether;
    uint256 private priceAllowListMint = 0.001 ether;

    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;

    mapping(address => bool) private allowList;

    // token uri section
    string public currentBaseURI;
    string private baseExtension;

    constructor(
        address initialOwner
    ) ERC721("MyToken", "MTK") Ownable(initialOwner) {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function editMintWindow(
        bool _publicMintOpen,
        bool _allowListMintOpen
    ) external onlyOwner {
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    function allowListMint() public payable {
        require(allowListMintOpen, "Allow List Mint closed");
        require(allowList[msg.sender], "You are not on the allow list");
        require(msg.value == priceAllowListMint, "Incorrect amount");

        _internalMint();
    }

    function publicMint() public payable {
        require(publicMintOpen, "Public Mint is not open");
        require(msg.value == pricePublicMint, "Incorrect amount");

        _internalMint();
    }

    function _internalMint() internal {
        require(totalSupply() < maxSupply, "Token limit reached");

        uint256 tokenId = _nextTokenId++;
        string memory thistokenURI = string(
            abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
        );
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, thistokenURI);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        currentBaseURI = baseURI;
    }

    function setAllowListAddress(
        address[] calldata addressess
    ) external onlyOwner {
        for (uint256 i = 0; i < addressess.length; i++) {
            allowList[addressess[i]] = true;
        }
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
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
