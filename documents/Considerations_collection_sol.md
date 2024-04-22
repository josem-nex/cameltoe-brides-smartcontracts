# PRINCIPALES:

### Panel de Administración: http://149.28.41.69:3000/admin

- Crea nuevas colecciones desde aquí.
- Puedes actualizar colecciones antiguas.
- Puedes editar colecciones.
- Para cargar contratos inteligentes puedes usar Remix.

### Fondo de Coleccionista: http://149.28.41.69:3000/collectorfond

- Puedes ver el fondo de coleccionista aquí.
- El administrador necesita cargar los 10 datos principales en el contrato inteligente del fondo de coleccionista.
- Y luego, después del final del mes, el administrador puede llamar a una función en el contrato del fondo de coleccionista y enviar todos los fondos a las personas.

NOTA: Este proceso de agregar la dirección de la billetera del usuario al contrato del fondo de coleccionista se puede hacer con código, pero no es seguro en absoluto. Para llamar a esa función, debemos necesitar la clave privada de la billetera del administrador y compartir la clave privada de la billetera del administrador en un servidor VPS no es un enfoque seguro, por lo que después de cada mes debe cargarlo manualmente. Es un proceso fácil, y ya lo discutí hace mucho tiempo, por eso lo escribo aquí.

## Considerations:

Análisis de seguridad y optimización de funciones de un contrato Solidity:
A continuación, se presenta un análisis en español e inglés de las observaciones sobre las funciones del contrato Solidity:
Español:

1. safeMintForTeam()
   Función pagable: Esta función está marcada como pagable, lo que significa que puede recibir ether. Sin embargo, no hay lógica dentro de la función para manejar el ether recibido, por lo que se recomienda eliminarla como pagable.
   Optimización: La función llama a \_tokenIdCounterPublic.current() varias veces. Es más eficiente almacenar el valor en memoria y utilizarlo según sea necesario.
2. safeMint()
   Límite de acuñación por billetera: La verificación del límite de acuñación solo considera el saldo actual, pero una billetera podría transferir NFTs a otras direcciones y seguir acuñando. Se requiere una lógica más robusta para controlar el límite por usuario.
   Manejo de valor de transacción: No se maneja el caso donde el valor de la transacción es mayor que el precio de acuñación. Se debería procesar y devolver la diferencia.
   Lógica redundante: Existe lógica redundante en las condiciones onlyWhitelisted y !onlyWhitelisted. Se debe simplificar el código.
   Conflicto de precios: Si haveOldCollections y onlyWhitelisted son verdaderos, se verifica el valor de la transacción contra dos precios diferentes sin lógica para priorizar.
   Mensaje de error: El mensaje de error no coincide con la verificación del require.
   Optimización: Similar a la función anterior, se llama a \_tokenIdCounterPublic.current() varias veces. Es más eficiente almacenar el valor en memoria.
3. checkIfTheCallerOwnsOldCollections()
   Visibilidad de la función: La función no modifica el estado del contrato y realiza una llamada externa, por lo que no debería ser privada para evitar posibles ataques de reentrada.
4. setReservedCollectionSize / setCollectionSize
   Modificación del suministro máximo: La posibilidad de modificar el suministro máximo después de desplegar el contrato afecta la escasez y la previsibilidad de la colección. Es una decisión de diseño que debe considerarse cuidadosamente.

### Inglés:

5. safeMintForTeam()
   Payable function: This function is marked as payable, meaning it can receive ether. However, there is no logic within the function to handle the received ether, so it is recommended to remove the payable modifier.
   Optimization: The function calls \_tokenIdCounterPublic.current() multiple times. It is more efficient to store the value in memory and use it as needed.
6. safeMint()
   Minting limit per wallet: The minting limit check only considers the current balance, but a wallet could transfer NFTs to other addresses and continue minting. More robust logic is needed to control the limit per user.
   Transaction value handling: The case where the transaction value is higher than the mint price is not handled. The difference should be processed and returned.
   Redundant logic: There is redundant logic in the onlyWhitelisted and !onlyWhitelisted conditions. The code should be simplified.
   Price conflict: If haveOldCollections and onlyWhitelisted are true, the transaction value is checked against two different prices without logic to prioritize.
   Error message: The error message does not match the check in the require.
   Optimization: Similar to the previous function, \_tokenIdCounterPublic.current() is called multiple times. It is more efficient to store the value in memory.
7. checkIfTheCallerOwnsOldCollections()
   Function visibility: The function does not modify the contract's state and makes an external call, so it should not be private to avoid possible reentrancy attacks.
8. setReservedCollectionSize / setCollectionSize
   Modifying max supply: The ability to modify the max supply after deploying the contract affects scarcity and the predictability of the collection. It is a design decision that should be carefully considered.

---
