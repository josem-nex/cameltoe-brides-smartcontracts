# Documentation for the Collection Contract

This contract implements an ERC721 NFT with additional features like pausing the contract, public minting with price increments, minting limit per address, and royalties.

## Functionalities

- ERC721: The contract inherits from the OpenZeppelin ERC721 standard, providing the basic functions to create and manage NFTs.
- ERC721URIStorage: Stores the token URI within the contract, improving efficiency.
- ERC721Pausable: Allows pausing contract operations, such as transferring and minting NFTs, by the owner.
- ERC721Royalty: Implements royalties for the NFT creator, receiving a percentage of secondary sales.
- Ownable: Defines the contract owner, who has access to administrative functions.

## Events

- NFTMinted: Emitted when a new NFT is minted, indicating the recipient address and the token ID.
- ERC721 standard events.

## Variables

- maxSupply: The maximum supply of NFTs that can be minted.
- totalSupply: The total number of minted NFTs.
- nextTokenId: The ID of the next NFT to be minted.
- pricePublicMint: The current price to mint an NFT during the public mint. Given in wei. 1 ether = 10^18 wei.
- priceIncrement: The percentage increment of the public minting price after each mint. Given in percentage. Example: 10 for a 10% increment on each mint, 0 for a fixed price, and 100 for doubling the price.
- publicMintOpen: Indicates whether the public mint is active.
- countMinted: A mapping that tracks how many NFTs each address has minted.
- maxMintPerAddress: The maximum number of NFTs an address can mint.
- currentBaseURI: The base URI to construct the token URI.
- baseExtension: The extension used for the token URI (e.g., ".json").
- royaltyFee: The percentage of royalties charged to the buyer on secondary sales. usually: 500 = 5%

## Functions

- constructor: Receives the necessary values for the creation of a collection, such as: name, symbol, maxSupply, maxMintPerAddress, baseURI, extension, pricePublicMint, priceIncrement, royaltyFee.
- pause: Pauses the contract, preventing the transfer and minting of NFTs. Only the owner can call this function. Useful to avoid security issues or stop during some kind of special event or maintenance.
- unpause: Resumes the contract, allowing the transfer and minting of NFTs. Only the owner can call this function.
- editMintWindow: Activates or deactivates the public mint. Only the owner can call this function.
- publicMint: Allows users to mint NFTs during the public mint. Checks if the public mint is active, if the supply limit has been reached, if the user has reached the minting limit per address, and if the correct value has been sent. Increments the public minting price after each mint.
- setBaseURI: Allows the owner to change the base URI for the construction of the token URI.
- withdraw: Allows the owner to withdraw funds from the contract.
- update, increaseBalance, tokenURI, supportsInterface: Internal and overridden functions to ensure compatibility with the ERC721, ERC721Pausable, ERC721URIStorage, and ERC721Royalty standards.
- setRoyaltyFee: Allows the owner to change the royalty fee rate and the beneficiary address.

---

# Documentación del Contrato Collection

Este contrato implementa un NFT ERC721 con características adicionales como pausar el contrato, acuñación pública con incrementos de precio, límite de acuñación por dirección y regalías.

## Funcionalidades

- ERC721: El contrato hereda del estándar ERC721 de OpenZeppelin, proporcionando las funciones básicas para crear y administrar NFTs.
- ERC721URIStorage: Almacena la URI del token en el contrato, mejorando la eficiencia.
- ERC721Pausable: Permite pausar las operaciones del contrato, como la transferencia y acuñación de NFTs, por el propietario.
- ERC721Royalty: Implementa regalías para el creador del NFT, recibiendo un porcentaje de las ventas secundarias.
- Ownable: Define al propietario del contrato, quien tiene acceso a funciones administrativas.

## Eventos

- NFTMinted: Se emite cuando se acuña un nuevo NFT, indicando la dirección del receptor y el ID del token.
- Eventos del estándar ERC721.

## Variables

- maxSupply: El suministro máximo de NFTs que se pueden acuñar.
- totalSupply: El número total de NFTs acuñados.
- nextTokenId: El ID del siguiente NFT a ser acuñado.
- pricePublicMint: El precio actual para acuñar un NFT durante la acuñación pública. Se da en wei. 1 ether = 10^18 wei.
- priceIncrement: El porcentaje de incremento del precio de acuñación pública después de cada acuñación. Se da en porcentaje. Ejemplo: 10 para un incremento del 10% en cada acuñación, 0 para un precio fijo y 100 para duplicar el precio.
- publicMintOpen: Indica si la acuñación pública está activa.
- countMinted: Un mapeo que registra cuántos NFTs ha acuñado cada dirección.
- maxMintPerAddress: El número máximo de NFTs que una dirección puede acuñar.
- currentBaseURI: La URI base para construir la URI del token.
- baseExtension: La extensión utilizada para la URI del token (por ejemplo, ".json").

## Funciones

- constructor: Se reciben los valores necesarios para la creación de una colección, como son: name, symbol, maxSupply, maxMintPerAddress, baseURI, extension, pricePublicMint, priceIncrement, royaltyFee
- pause: Pausa el contrato, impidiendo la transferencia y acuñación de NFTs. Solo el propietario puede llamar a esta función. Útil para evitar problemas de seguridad o detener durante algún tipo de evento especial o mantenimiento.
- unpause: Reanuda el contrato, permitiendo la transferencia y acuñación de NFTs. Solo el propietario puede llamar a esta función.
- editMintWindow: Activa o desactiva la acuñación pública. Solo el propietario puede llamar a esta función.
- publicMint: Permite a los usuarios acuñar NFTs durante la acuñación pública. Verifica si la acuñación pública está activa, si se ha alcanzado el límite de suministro, si el usuario ha alcanzado el límite de acuñación por dirección y si se ha enviado el valor correcto. Incrementa el precio de acuñación pública después de cada acuñación.
- setBaseURI: Permite al propietario cambiar la URI base para la construcción de la URI del token.
- withdraw: Permite al propietario retirar los fondos del contrato.
- update, increaseBalance, tokenURI, supportsInterface: Funciones internas y sobrescritas para asegurar la compatibilidad con los estándares ERC721, ERC721Pausable, ERC721URIStorage y ERC721Royalty.
- setRoyaltyFee: Permite al propietario cambiar la tasa de regalías y la dirección del beneficiario.
