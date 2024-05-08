# Cambios

- OnlyOwner falta en varias funciones de los contratos, se agrega para restringir el acceso a funciones que solo deben ser ejecutadas por el owner.
- Eliminar la biblioteca Counters, ya que fue removida en versiones 5.x de OpenZeppelin. Ademas usar un contador uint256 para llevar la cuenta de los tokens minteados es más sencillo y eficiente.
- Eliminacion de numerosos llamados que hacen las funciones así como demasiadas validaciones innecesarias.
- Logica redundante y no robusta en diferentes funciones de los contratos.
- Optimizaciones generales de gas en las funciones de los contratos. Asi como de implementación de los contratos.
- Manejar la seccion de oldcollection con la lista de address añadiendolas a la whitelist

## Extras

- Añadir funcion withdraw para retirar los fondos del contrato. (Generados en el proceso de Mint)
- Implementar ERC721Royalty en lugar de ERC2981.
- Implementar Pausable en los contratos para poder pausar toda venta, transferencia, etc de los tokens.
- Implementar Enumerable en los contratos para poder listar los tokens minteados y un mayor control sobre los mismos.
- Testing con Hardhat y despliegue en la red de prueba de Ethereum (Sepolia). Despliegue en OpenSea y verificación de los contratos.
- Implementar una pre-venta para los usuarios que esten en la allowList con un precio especial.

# Contrato Collection:

# Español:

## Modificaciones:

- Revisión del Modificador onlyOwner: Varias funciones carecen del modificador onlyOwner, que restringe el acceso a las funciones que solo deben ser ejecutadas por el propietario del contrato. Se agregará esto para garantizar un control de acceso adecuado. (Tiempo estimado: 1 horas)
- Eliminar la Biblioteca Counters: Se eliminará la biblioteca Counters, obsoleta en las versiones 5.x de OpenZeppelin. En su lugar, se implementará un contador uint256 para un seguimiento de tokens más simple y eficiente. (Tiempo estimado: 1 hora)
- Refactorizar la Lógica Redundante: La lógica redundante y no robusta presente en varias funciones se refactorizará para mejorar la calidad y la estabilidad del código. (Tiempo estimado: 10 horas)
- Optimizaciones de Gas: Se implementarán optimizaciones generales de gas en las funciones del contrato y los procesos de implementación para reducir los costos de transacción. (Tiempo estimado: 3 horas)

Total estimado: 15 horas

## Adiciones:

- Función de Retiro: Se agregará una función de retiro para permitir que el propietario del contrato retire los fondos generados por el proceso de acuñación. (Tiempo estimado: 30min )
- Implementación de ERC721Royalty: Se implementará ERC721Royalty en lugar de ERC2981 para administrar los pagos de regalías por ventas secundarias. (Tiempo estimado: 30min )
- Funcionalidad Pausable: Se implementará la extensión Pausable, lo que permitirá al propietario del contrato pausar las ventas de tokens, transferencias y otras operaciones según sea necesario. (Tiempo estimado: 2 horas)
- Funcionalidad Enumerable: Se implementará la extensión Enumerable para permitir la lista de tokens acuñados y proporcionar un mayor control sobre la gestión de tokens. (Tiempo estimado: 1 horas)
- Pruebas e Implementación: Se realizarán pruebas de Hardhat, seguidas de la implementación en la red de prueba de Sepolia. Además, se realizarán la implementación de OpenSeaTesnet y la verificación del contrato. (Tiempo estimado: 8 horas)

Total estimado: 12 horas

Tiempo total estimado: 27 horas

Días estimados: 4 días

# English:

## Modifications:

- Review of onlyOwner Modifier: Several functions lack the onlyOwner modifier, which restricts access to functions that should only be executed by the contract owner. This will be added to ensure proper access control. (Estimated time: 1 hour)
- Remove Counters Library: The Counters library, deprecated in OpenZeppelin 5.x versions, will be removed. A uint256 counter will be implemented instead for simpler and more efficient token tracking. (Estimated time: 1 hour)
- Refactor Redundant Logic: Redundant and non-robust logic present in various functions will be refactored for improved code quality and stability. (Estimated time: 10 hours)
- Gas Optimizations: General gas optimizations will be implemented in contract functions and deployment processes to reduce transaction costs. (Estimated time: 3 hours)

Total estimated time: 15 hours

## Additions:

- Withdrawal Function: A withdrawal function will be added to allow the contract owner to withdraw funds generated from the minting process. (Estimated time: 30 minutes)
- ERC721Royalty Implementation: ERC721Royalty will be implemented instead of ERC2981 to manage royalty payments for secondary sales. (Estimated time: 30 minutes)
- Pausable Functionality: The Pausable extension will be implemented, allowing the contract owner to pause token sales, transfers, and other operations as needed. (Estimated time: 2 hours)
- Enumerable Functionality: The Enumerable extension will be implemented to enable listing of minted tokens and provide greater control over token management. (Estimated time: 1 hour)
- Testing and Deployment: Hardhat testing will be conducted, followed by deployment on the Sepolia testnet. Additionally, OpenSea Testnet deployment and contract verification will be performed. (Estimated time: 8 hours)

Total estimated time: 12 hours

### Total estimated time for all tasks: 27 hours

### Estimated number of days: 4 days
