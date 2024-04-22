# Cambios

- Anteriormente se utilizaba ERC2981 para implementar el estándar EIP-2981 (los royalties) y ERC721 para implementar el estándar ERC721. Ahora se utiliza ERC721Royalty para implementar ambos estándares.
- OnlyOwner falta en varias funciones de los contratos, se agrega para restringir el acceso a funciones que solo deben ser ejecutadas por el owner.
- Eliminar la biblioteca Counters, ya que fue removida en versiones 5.x de OpenZeppelin. Ademas usar un contador uint256 para llevar la cuenta de los tokens minteados es más sencillo y eficiente.
- Eliminacion de numerosos llamados que hacen las funciones así como demasiadas validaciones innecesarias.
- Logica redundante y no robusta en diferentes funciones de los contratos.
- Optimizaciones generales de gas en las funciones de los contratos. Asi como de implementación de los contratos.
