<h1 align="center">KipuBanco 🏦</h1>

<p align="center">
Un contrato inteligente de banco descentralizado desarrollado en Solidity que permite a los usuarios depositar y retirar ETH de manera segura con límites configurables.
</p>

<hr/>

<h2>📋 Descripción</h2>

<p>
KipuBanco es un sistema bancario digital implementado como contrato inteligente en <b>Ethereum</b>. 
Funciona como un banco tradicional pero de forma <b>completamente descentralizada</b>, 
donde cada usuario tiene una <b>bóveda personal</b> para almacenar sus fondos ETH de manera segura.
</p>

<h3>¿Cómo Funciona?</h3>

<p>
El contrato opera bajo el principio de <b>bóvedas individuales</b>. 
Cuando un usuario deposita ETH, estos fondos se asignan específicamente a su dirección en un mapeo interno. 
El usuario mantiene control total sobre sus fondos y puede retirarlos en cualquier momento, 
respetando los límites de seguridad establecidos.
</p>

<h3>Características Principales</h3>
<ul>
  <li><b>Bóvedas Personales</b>: Cada usuario tiene su propio espacio de almacenamiento identificado por su dirección de wallet</li>
  <li><b>Límite Global del Banco</b>: El contrato tiene un tope máximo de ETH que puede almacenar en total</li>
  <li><b>Límite por Retiro</b>: Los usuarios no pueden retirar más de un monto fijo por transacción (configurado al desplegar)</li>
  <li><b>Protección contra Reentrancia</b>: Implementa medidas de seguridad avanzadas para prevenir ataques</li>
  <li><b>Registro Completo</b>: Mantiene contadores de todas las operaciones realizadas</li>
  <li><b>Eventos Transparentes</b>: Emite eventos para cada operación exitosa</li>
  <li><b>Errores Descriptivos</b>: Proporciona mensajes de error claros cuando las operaciones fallan</li>
</ul>

<hr/>

<h2>🛠️ Instrucciones de Despliegue</h2>

<h3>Información Necesaria</h3>
<p>Para desplegar KipuBanco necesitas definir dos parámetros importantes:</p>
<ol>
  <li><b>Límite del Banco</b> (<code>limiteBanco</code>): La cantidad máxima de ETH que puede almacenar todo el contrato</li>
  <li><b>Límite de Retiro</b> (<code>limiteRetiroPorTransaccion</code>): La cantidad máxima que cualquier usuario puede retirar en una sola transacción</li>
</ol>

<p><b>Redes Recomendadas:</b></p>
<ul>
  <li><b>Testnet</b> (Sepolia, Goerli): Para pruebas y desarrollo</li>
  <li><b>Mainnet</b>: Solo para producción con auditoría completa</li>
</ul>

<h3>Proceso de Despliegue</h3>
<ol>
  <li><b>Preparación</b>: Asegúrate de tener ETH suficiente para gas fees</li>
  <li><b>Configuración</b>: Define los límites según tu caso de uso</li>
  <li><b>Despliegue</b>: Ejecuta el contrato con los parámetros elegidos</li>
  <li><b>Verificación</b>: Confirma que los límites se establecieron correctamente</li>
  <li><b>Pruebas</b>: Realiza transacciones de prueba antes del uso real</li>
</ol>

<hr/>

<h2>🎯 Cómo Interactuar con el Contrato</h2>

<h3>Operaciones Principales</h3>

<h4>Depositar ETH</h4>
<p><b>Función</b>: <code>depositar()</code></p>
<ul>
  <li><b>Propósito</b>: Agregar ETH a tu bóveda personal</li>
  <li><b>Proceso</b>: Envías ETH junto con la transacción, se registra en tu saldo</li>
  <li><b>Validaciones</b>: 
    <ul>
      <li>El monto debe ser mayor a cero</li>
      <li>No debe exceder el espacio disponible en el banco</li>
      <li>El banco no debe estar en su límite máximo</li>
    </ul>
  </li>
</ul>

<h4>Retirar ETH</h4>
<p><b>Función</b>: <code>retirar(cantidadRetiro)</code></p>
<ul>
  <li><b>Propósito</b>: Extraer ETH de tu bóveda personal</li>
  <li><b>Proceso</b>: Especificas la cantidad, se descuenta de tu saldo y se transfiere</li>
  <li><b>Validaciones</b>:
    <ul>
      <li>Debes tener saldo suficiente</li>
      <li>No puedes exceder el límite por transacción</li>
      <li>El monto debe ser mayor a cero</li>
    </ul>
  </li>
</ul>

<h3>Consultas de Información</h3>
<ul>
  <li><b>Consultar Tu Saldo</b> → <code>consultarMiSaldo()</code></li>
  <li><b>Consultar Saldo de Otros</b> → <code>consultarSaldoUsuario(direccion)</code></li>
  <li><b>Estadísticas del Banco</b> → <code>consultarEstadisticasBanco()</code></li>
  <li><b>Información de Límites</b> → <code>consultarLimites()</code></li>
</ul>

<hr/>

<h2>📡 Monitoreo y Eventos</h2>

<h3>Eventos de Depósito</h3>
<ul>
  <li>Dirección del usuario</li>
  <li>Cantidad depositada</li>
  <li>Nuevo saldo total del usuario</li>
</ul>

<h3>Eventos de Retiro</h3>
<ul>
  <li>Dirección del usuario</li>
  <li>Cantidad retirada</li>
  <li>Nuevo saldo restante del usuario</li>
</ul>

<hr/>

<h2>⚠️ Consideraciones Importantes</h2>

<h3>Limitaciones del Sistema</h3>
<ul>
  <li><b>Límite de Retiro por Transacción</b>: Si necesitas retirar más del límite, haz múltiples transacciones.</li>
  <li><b>Límite Global del Banco</b>: Una vez alcanzado, no se pueden hacer más depósitos.</li>
  <li><b>Inmutabilidad de Límites</b>: No pueden cambiarse después del despliegue.</li>
</ul>

<h3>Errores Comunes y Significados</h3>
<ul>
  <li><b>"ExcedeLimiteBanco"</b>: El depósito supera la capacidad máxima.</li>
  <li><b>"SaldoInsuficiente"</b>: Intentas retirar más ETH del que tienes.</li>
  <li><b>"ExcedeLimiteRetiro"</b>: El monto supera el límite por transacción.</li>
  <li><b>"DepositoVacio" / "RetiroVacio"</b>: Intentas operar con 0 ETH.</li>
</ul>
