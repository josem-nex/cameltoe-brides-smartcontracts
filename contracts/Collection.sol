// SPDX-License-Identifier: MIT

// Specifies the version of Solidity that the contract is written with
pragma solidity ^0.8.9;

// Import statements for other contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

// Interface to interact with other contracts
interface ICollection {
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract Collection is ERC721, ERC721URIStorage, Ownable, ERC2981 {
    // Libraries used by the contract
    using Counters for Counters.Counter;
    using Strings for uint256;

    // Counters to track the total number of tokens minted
    Counters.Counter private _tokenIdCounterPublic;
    Counters.Counter private _tokenIdCounterTeam;

    // Mapping to store the whitelisted addresses and their token balances
    mapping(address => uint256) public whiteListedAddress;

    // Boolean flags to control certain contract functions
    bool public onlyWhitelisted;
    bool public haveOldCollections;

    // Public minting prices for different groups of users
    uint256 public publicMintPrice;
    uint256 public whiteListedMintPrice;

    // Variables to control the total number of tokens in the collection and the number reserved for special uses
    uint256 public collectionSize;
    uint256 public reservedCollectionSize;
    uint256 public nftPerWalletLimit;

    // String to store static metadata about the collection
    string public staticMetadata;

    // Boolean flag to indicate whether the collection is public or not
    bool public isCollectionPublic = false;

    // Array to store addresses of old collections that are allowed to mint tokens in this contract
    address[] public oldCollections;

    // Strings to store the base URI and extension for token metadata URIs
    string public currentBaseURI;
    string private baseExtension;

    /// EVENTS
    // Event to be emitted when an NFT is minted
    event NFTMinted(address indexed owner, uint256 indexed tokenId);

    /**
    @dev Sets the initial values for contract variables.
    @param _publicMintPrice - Public mint price for NFTs.
    @param _whiteListedMintPrice - Mint price for whitelisted addresses.
    @param _collectionSize - Maximum size of the collection.
    @param _reservedCollectionSize - Size of the reserved collection.
    @param _nftPerWalletLimit - The limit of NFTs can be minted by a single wallet.
    @param _staticMetadata - Static metadata of NFTs.
    @param _isCollectionPublic - If the collection is public or not.
    @param _oldCollections - Array of old collection addresses.
    @param _haveOldCollections - If the collection has old collections or not.
    @param _onlyWhitelisted - If only whitelisted addresses can mint NFTs or not.
    */
    constructor(
        uint256 _publicMintPrice,
        uint256 _whiteListedMintPrice,
        uint256 _collectionSize,
        uint256 _reservedCollectionSize,
        uint256 _nftPerWalletLimit,
        string memory _staticMetadata,
        string memory _currentBaseURI,
        bool _isCollectionPublic,
        address[] memory _oldCollections,
        bool _haveOldCollections,
        bool _onlyWhitelisted
    ) ERC721("MyToken", "MTK") {
        _setDefaultRoyalty(msg.sender, 500); // 5.00 %
        publicMintPrice = _publicMintPrice;
        whiteListedMintPrice = _whiteListedMintPrice;
        collectionSize = _collectionSize;
        reservedCollectionSize = _reservedCollectionSize;
        nftPerWalletLimit = _nftPerWalletLimit;
        staticMetadata = _staticMetadata;
        currentBaseURI = _currentBaseURI;
        isCollectionPublic = _isCollectionPublic;
        oldCollections = _oldCollections;
        haveOldCollections = _haveOldCollections;
        onlyWhitelisted = _onlyWhitelisted;
        baseExtension = ".json";
    }

    /*
    @dev Safely mints a new token and assigns it to the specified address, with the given metadata URI.
    Requirements:
    The caller must send a payment to cover the minting fees.
    */ function safeMint()
        external
        payable
    {
        // Ensure the collection size limit has not been reached
        require(
            _tokenIdCounterPublic.current() <
                collectionSize - reservedCollectionSize,
            "Total Number Of Minted NFT Reached the Collection Size"
        );

        // Ensure the caller has not already reached the wallet limit
        require(
            balanceOf(msg.sender) < nftPerWalletLimit,
            "This wallet is already reached the maximum limit"
        );

        // Ensure the caller is whitelisted (if whitelist is enabled)
        // Ensure the caller has sent the correct amount (if whitelist is enabled)
        if (onlyWhitelisted) {
            require(
                whiteListedAddress[msg.sender] == 1,
                "The Caller is Not Whitelisted"
            );
            require(
                msg.value == whiteListedMintPrice,
                "The Given value is Lower then the Whitelisted Price"
            );
        }

        // Ensure the caller has old collections and has sent the correct amount (if enabled)
        if (haveOldCollections) {
            require(
                msg.value == publicMintPrice,
                "The Given value is Lower then the Whitelisted Price"
            );
            require(
                checkIfTheCallerOwnsOldCollections(msg.sender),
                "The caller has not owned the old collections"
            );
        }

        // Ensure the caller has sent the correct amount (if whitelist is disabled)
        if (!onlyWhitelisted) {
            require(
                msg.value == publicMintPrice,
                "The Given value is Lower then the Public Mint Price"
            );
        }

        // Mint the NFT and set its metadata URI
        uint256 tokenId = _tokenIdCounterPublic.current();
        string memory tokenURI = string(
            abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
        );
        _tokenIdCounterPublic.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        // Emit an event to indicate that the NFT has been minted
        emit NFTMinted(msg.sender, tokenId);
    }

    /**
    @dev This function allows the owner to safely mint a token with a specific URI for a team member.
    @notice Requires the function to be called by the contract owner.
    */
    function safeMintForTeam() public payable onlyOwner {
        require(
            _tokenIdCounterTeam.current() < reservedCollectionSize,
            "Total Number Of Minted NFT Reached the Collection Size"
        );
        uint256 tokenId = _tokenIdCounterTeam.current();
        string memory tokenURI = string(
            abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
        );
        _tokenIdCounterTeam.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        // Emit an event to indicate that the NFT has been minted
        emit NFTMinted(msg.sender, tokenId);
    }

    // Helper functions
    /**
    @dev This private function checks whether the caller of the function owns old collections.
    @param _receiver The address of the caller to check for ownership of old collections.
    @return Returns true if the caller owns old collections, otherwise returns false.
    */
    function checkIfTheCallerOwnsOldCollections(
        address _receiver
    ) private returns (bool) {
        uint256 length = oldCollections.length;
        for (uint256 i = 0; i < length; i++) {
            if (ICollection(oldCollections[i]).balanceOf(_receiver) > 0) {
                return true;
            }
        }
        return false;
    }

    // onlyOwner Function

    /**
    @dev This function sets the default royalty fee for a receiver.
    @param _receiver The address of the receiver to set the default royalty fee for.
    @param _feeNumerator The royalty fee numerator to set for the receiver. 10000 is 100%. 500 is 5%.
    @notice Requires the function to be called by the contract owner.
    */
    function setDefaultRoyalty(
        address _receiver,
        uint96 _feeNumerator
    ) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    /**
    @dev This function adds an address to the whitelist.
    @param _receiver The address to add to the whitelist.
    @notice Requires the function to be called by the contract owner.
    */
    function addAddressToWhiteList(address _receiver) external onlyOwner {
        whiteListedAddress[_receiver] = 1;
    }

    /**
    @dev This function sets whether only whitelisted addresses are allowed to mint NFTs.
    @param _onlyWhitelisted A boolean value indicating whether only whitelisted addresses are allowed to mint NFTs.
    @notice Requires the function to be called by the contract owner.
    */

    function setOnlyWhitelisted(bool _onlyWhitelisted) external onlyOwner {
        onlyWhitelisted = _onlyWhitelisted;
    }

    /*
    @dev This function sets the permission for the minter to allow only old collection holders to mint NFTs.
    @param _onlyOldCollectionHolders A boolean value indicating whether only old collection holders can mint NFTs.
    @notice Requires the function to be called by the contract owner.
    */
    function setHaveOldCollections(
        bool _haveOldCollections
    ) external onlyOwner {
        haveOldCollections = _haveOldCollections;
    }

    /**
    @dev This function sets the public mint price for NFTs.
    @param _publicMintPrice The public mint price to set for NFTs.
    @notice Requires the function to be called by the contract owner.
    */
    function setPublicMintPrice(uint256 _publicMintPrice) external onlyOwner {
        publicMintPrice = _publicMintPrice;
    }

    /**
    @dev This function sets the mint price for whitelisted addresses.
    @param _whiteListedMintPrice The mint price to set for whitelisted addresses.
    @notice Requires the function to be called by the contract owner.
    */
    function setWhiteListedMintPrice(
        uint256 _whiteListedMintPrice
    ) external onlyOwner {
        whiteListedMintPrice = _whiteListedMintPrice;
    }

    /**
    @dev This function sets the size of the NFT collection.
    @param _collectionSize The size of the NFT collection to set.
    @notice Requires the function to be called by the contract owner.
    */
    function setCollectionSize(uint256 _collectionSize) external onlyOwner {
        collectionSize = _collectionSize;
    }

    /**
    @dev This function sets the reserved size of the NFT collection.
    @param _reservedCollectionSize The reserved size of the NFT collection to set.
    @notice Requires the function to be called by the contract owner.
    */
    function setReservedCollectionSize(
        uint256 _reservedCollectionSize
    ) external onlyOwner {
        reservedCollectionSize = _reservedCollectionSize;
    }

    /**
    @dev This function sets the limit of NFTs that can be minted per wallet.
    @param _nftPerWalletLimit The limit of NFTs that can be minted per wallet to set.
    @notice Requires the function to be called by the contract owner.
    */
    function setNftPerWalletLimit(
        uint256 _nftPerWalletLimit
    ) external onlyOwner {
        nftPerWalletLimit = _nftPerWalletLimit;
    }

    /**
    @dev This function sets the static metadata for the NFT collection.
    @param _staticMetadata The static metadata to set for the NFT collection.
    @notice Requires the function to be called by the contract owner.
    */
    function setStaticMetadata(
        string memory _staticMetadata
    ) external onlyOwner {
        staticMetadata = _staticMetadata;
    }

    /**
    @dev This function sets whether the NFT collection is public.
    @param _isCollectionPublic Whether the NFT collection is public or not.
    @notice Requires the function to be called by the contract owner.
    */
    function setIsCollectionPublic(
        bool _isCollectionPublic
    ) external onlyOwner {
        isCollectionPublic = _isCollectionPublic;
    }

    /**
    @dev This function adds an old collection to the list of old collections.
    @param _oldCollection The address of the old collection to add.
    @notice Requires the function to be called by the contract owner.
    */
    function addOldCollection(address _oldCollection) external onlyOwner {
        oldCollections.push(_oldCollection);
    }

    /**
    @dev This function sets the current base URI for the NFT collection.
    @param _currentBaseURI The current base URI to set.
    @notice Requires the function to be called by the contract owner.
    */
    function setCurrentBaseURI(
        string memory _currentBaseURI
    ) external onlyOwner {
        currentBaseURI = _currentBaseURI;
    }

    // The following functions are overrides required by Solidity.

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        if (!isCollectionPublic) {
            return staticMetadata;
        } else {
            return super.tokenURI(tokenId);
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
