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
