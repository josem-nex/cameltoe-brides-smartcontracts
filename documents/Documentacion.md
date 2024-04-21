# Bibliotecas externas, openzeppelin:

Standard: ERC721 (https://eips.ethereum.org/EIPS/eip-721)

- Counters (https://docs.openzeppelin.com/contracts/4.x/api/utils#Counters) para llevar la cuenta de los tokens minteados. Fue removida en versiones 5.x: (https://github.com/OpenZeppelin/openzeppelin-contracts/issues/4233)
- Owneable (https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable) para manejar la propiedad del contrato.
- ERC721 (https://docs.openzeppelin.com/contracts/5.x/api/token/erc721#ERC721) para implementar el estándar ERC721.
- ERC721URIStorage (https://docs.openzeppelin.com/contracts/5.x/api/token/erc721#ERC721URIStorage) para almacenar los URIs de los tokens.
- ERC2981 (https://docs.openzeppelin.com/contracts/5.x/api/token/common#ERC2981) para implementar el estándar EIP-2981. ??? considerar ERC721Royalty (https://docs.openzeppelin.com/contracts/5.x/api/token/erc721#ERC721Royalty) para ERC721.

## CrossMintNFT721.sol

- AccessControl (https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl) para manejar los roles de los usuarios.
- Strings (https://docs.openzeppelin.com/contracts/5.x/api/utils#Strings) para manejar las operaciones de strings.
