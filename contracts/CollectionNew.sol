// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Interface to interact with other contracts
interface ICollection {
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract Collection is ERC721Royalty, ERC721URIStorage, Ownable {}
