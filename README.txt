# KipuBanco 🏦

Un contrato inteligente de banco descentralizado desarrollado en Solidity que permite a los usuarios depositar y retirar ETH de manera segura con límites configurables.

## 📋 Descripción

KipuBanco es un sistema bancario digital implementado como contrato inteligente en Ethereum. Funciona como un banco tradicional pero de forma completamente descentralizada, donde cada usuario tiene una **bóveda personal** para almacenar sus fondos ETH de manera segura.

### ¿Cómo Funciona?

El contrato opera bajo el principio de **bóvedas individuales**. Cuando un usuario deposita ETH, estos fondos se asignan específicamente a su dirección en un mapeo interno. El usuario mantiene control total sobre sus fondos y puede retirarlos en cualquier momento, respetando los límites de seguridad establecidos.

### Características Principales

- **Bóvedas Personales**: Cada usuario tiene su propio espacio de almacenamiento identificado por su dirección de wallet
- **Límite Global del Banco**: El contrato tiene un tope máximo de ETH que puede almacenar en total
- **Límite por Retiro**: Los usuarios no pueden retirar más de un monto fijo por transacción (configurado al desplegar)
- **Protección contra Reentrancia**: Implementa medidas de seguridad avanzadas para prevenir ataques
- **Registro Completo**: Mantiene contadores de todas las operaciones realizadas
- **Eventos Transparentes**: Emite eventos para cada operación exitosa
- **Errores Descriptivos**: Proporciona mensajes de error claros cuando las operaciones fallan

## 🛠️ Instrucciones de Despliegue

### Información Necesaria

Para desplegar KipuBanco necesitas definir dos parámetros importantes:

1. **Límite del Banco** (`limiteBanco`): La cantidad máxima de ETH que puede almacenar todo el contrato
2. **Límite de Retiro** (`limiteRetiroPorTransaccion`): La cantidad máxima que cualquier usuario puede retirar en una sola transacción


**Redes Recomendadas:**
- **Testnet** (Sepolia, Goerli): Para pruebas y desarrollo
- **Mainnet**: Solo para producción con auditoría completa

### Proceso de Despliegue

1. **Preparación**: Asegúrate de tener ETH suficiente para gas fees
2. **Configuración**: Define los límites según tu caso de uso
3. **Despliegue**: Ejecuta el contrato con los parámetros elegidos
4. **Verificación**: Confirma que los límites se establecieron correctamente
5. **Pruebas**: Realiza transacciones de prueba antes del uso real

## 🎯 Cómo Interactuar con el Contrato

### Operaciones Principales

#### Depositar ETH
**Función**: `depositar()`
- **Propósito**: Agregar ETH a tu bóveda personal
- **Proceso**: Envías ETH junto con la transacción, se registra en tu saldo
- **Validaciones**: 
  - El monto debe ser mayor a cero
  - No debe exceder el espacio disponible en el banco
  - El banco no debe estar en su límite máximo

#### Retirar ETH
**Función**: `retirar(cantidadRetiro)`
- **Propósito**: Extraer ETH de tu bóveda personal
- **Proceso**: Especificas la cantidad, se descuenta de tu saldo y se transfiere
- **Validaciones**:
  - Debes tener saldo suficiente
  - No puedes exceder el límite por transacción
  - El monto debe ser mayor a cero

### Consultas de Información

#### Consultar Tu Saldo
**Función**: `consultarMiSaldo()`
- Devuelve cuánto ETH tienes almacenado en tu bóveda personal
- No consume gas (función de solo lectura)

#### Consultar Saldo de Otros
**Función**: `consultarSaldoUsuario(direccion)`
- Permite ver el saldo de cualquier usuario
- Útil para transparencia y verificación
- Las bóvedas son públicamente visibles

#### Estadísticas del Banco
**Función**: `consultarEstadisticasBanco()`
- **Total de Fondos**: Cuánto ETH hay almacenado en total
- **Capacidad Restante**: Cuánto espacio queda para más depósitos
- **Total de Operaciones**: Suma de todos los depósitos y retiros

#### Información de Límites
**Función**: `consultarLimites()`
- **Límite Global**: Capacidad máxima del banco
- **Límite de Retiro**: Máximo que se puede retirar por transacción
- Útil para planificar operaciones grandes

### Monitoreo y Eventos

#### Eventos de Depósito
Cuando depositas exitosamente, el contrato emite:
- Dirección del usuario
- Cantidad depositada
- Nuevo saldo total del usuario

#### Eventos de Retiro
Cuando retiras exitosamente, el contrato emite:
- Dirección del usuario
- Cantidad retirada
- Nuevo saldo restante del usuario

## ⚠️ Consideraciones Importantes

### Limitaciones del Sistema

**Límite de Retiro por Transacción:**
- Si necesitas retirar más del límite, debes hacer múltiples transacciones
- Esto es una medida de seguridad para prevenir drenajes masivos

**Límite Global del Banco:**
- Una vez alcanzado, no se pueden hacer más depósitos
- Los retiros liberan espacio para nuevos depósitos

**Inmutabilidad de Límites:**
- Los límites no pueden cambiarse después del despliegue
- Planifica cuidadosamente estos valores antes de lanzar

### Errores Comunes y Significados

**"ExcedeLimiteBanco"**
- Tu depósito haría que el banco supere su capacidad máxima
- Espera a que otros retiren fondos o deposita menos

**"SaldoInsuficiente"**
- Intentas retirar más ETH del que tienes
- Verifica tu saldo antes de intentar el retiro

**"ExcedeLimiteRetiro"**
- El monto que quieres retirar supera el límite por transacción
- Divide tu retiro en múltiples transacciones menores

**"DepositoVacio" / "RetiroVacio"**
- Intentas depositar o retirar 0 ETH
- Las operaciones deben ser por montos mayores a cero
