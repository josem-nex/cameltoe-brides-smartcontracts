// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CNFT721 is ERC721, AccessControl {
    // Import the Counters library and create an instance of the Counters.Counter struct.
    using Counters for Counters.Counter;

    // Import the Strings library to enable string operations on uint256 variables.
    using Strings for uint256;


    // Declare an event named 'Mint' with a single parameter 'tokenId' of type uint256.
    event Mint(uint256 tokenId);

    // Declare an event named 'Airdrop' with a single parameter 'tokenId' of type uint256.
    event Airdrop(uint256 tokenId);

    // Declare an event named 'NewURI' with two parameters 'oldURI' and 'newURI', both of type string.
    event NewURI(string oldURI, string newURI);


   // Declare an internal variable named 'nextId' of type Counters.Counter from the Counters library.
    Counters.Counter internal nextId;

    // Declare a public constant named 'MAX_SUPPLY' with a value of 10000.
    uint256 public constant MAX_SUPPLY = 10000;

    // Declare a public variable named 'price' with an initial value of 0.001 ether.
    uint256 public price = 0.001 ether;

    // Declare a public string variable named 'baseUri' with an initial value of "IPFS LINK".
    string public baseUri = "IPFS LINK";

    // Declare two public constants 'ADMIN_ROLE' and 'AIRDROPPER_ROLE' of type bytes32.
    // These constants are used to define roles within the contract and are initialized with unique values.
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant AIRDROPPER_ROLE = keccak256("AIRDROPPER_ROLE");


    constructor() payable ERC721("NFT", "NFT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(AIRDROPPER_ROLE, msg.sender);
    }
        
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // MODIFIERS

    modifier isCorrectPayment(uint256 _quantity) {
        require(msg.value >= (price * _quantity), "Incorrect Payment Sent");
        _;
    }

    modifier isAvailable(uint256 _quantity) {
        require(nextId.current() + _quantity <= MAX_SUPPLY, "Not enough tokens left for quantity");
        _;
    }

    // PUBLIC

    function mint(address _to, uint256 _quantity) 
        external  
        payable
        isCorrectPayment(_quantity)
        isAvailable(_quantity) 
    {
        mintInternal(_to, _quantity);
    }


    // INTERNAL

    function mintInternal(address _to, uint256 _quantity) internal {
        for (uint256 i = 0; i < _quantity; i++) {
            uint256 tokenId = nextId.current();
            nextId.increment();

            _safeMint(_to, tokenId);

            emit Mint(tokenId);
        }
    }   

    // ADMIN// Define a function 'airdrop' which is external and can only be called by users with the 'AIRDROPPER_ROLE'.
    // It takes two parameters: '_to' for the recipient's address and '_quantity' for the number of tokens to mint and airdrop.
    function airdrop(address _to, uint256 _quantity) external onlyRole(AIRDROPPER_ROLE) {
        // Call the 'mintInternal' function to mint and distribute tokens to the specified recipient.
        mintInternal(_to, _quantity);
    }

    // Define a function 'setPrice' which is external and can only be called by users with the 'DEFAULT_ADMIN_ROLE'.
    // It allows the contract owner to set a new 'price' for the tokens.
    function setPrice(uint256 _newPrice) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // Update the 'price' variable with the new price value.
        price = _newPrice;
    }

    // Define a function 'setUri' which is external and can only be called by users with the 'DEFAULT_ADMIN_ROLE'.
    // It allows the contract owner to set a new base URI for token metadata.
    function setUri(string calldata _newUri) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // Emit a 'NewURI' event to log the change in the base URI.
        emit NewURI(baseUri, _newUri);
        // Update the 'baseUri' variable with the new URI.
        baseUri = _newUri;
    }

    // Define a function 'withdraw' which is public and can only be called by users with the 'DEFAULT_ADMIN_ROLE'.
    // It allows the contract owner to withdraw the contract's balance.
    function withdraw() public onlyRole(DEFAULT_ADMIN_ROLE) {
        // Transfer the contract's balance to the address of the contract owner.
        payable(msg.sender).transfer(address(this).balance);
    }

    // VIEW

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        // same uri for all NFTs, logic looks wrong but is intended to use the _tokenId
        // argument to avoid compiler warnings about it not being used
        // for a standard 721 where each NFT is unique this function will def need to be changed
        return
            bytes(baseUri).length > 0
                ? baseUri // this will always be the intended return
                : string(abi.encodePacked(baseUri, _tokenId.toString(), ".json")); 
    }
}