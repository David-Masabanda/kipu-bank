// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract KipuBanco is ReentrancyGuard {

    /// @notice Bóveda personal de cada usuario ETH
    mapping(address => uint256) public bovedaPersonal;
    
    /// @notice Límite máximo
    uint256 public immutable limiteBanco;
    
    /// @notice Límite máximo por transacción
    uint256 public immutable limiteRetiroPorTransaccion;
    
    /// @notice Total de ETH depositado
    uint256 public totalDepositado;
    
    /// @notice Contador de  depósitos realizados
    uint256 public numeroDepositos;
    
    /// @notice Contador de retiros realizados
    uint256 public numeroRetiros;
    
    // EVENTOS
    
    event DepositoExitoso(address indexed usuario, uint256 cantidad, uint256 nuevoSaldoUsuario);
    event RetiroExitoso(address indexed usuario, uint256 cantidad, uint256 nuevoSaldoUsuario);
    
    // ERRORES PERSONALIZADOS
    error ExcedeLimiteRetiro(uint256 montoSolicitado, uint256 limiteMaximo);
    error SaldoInsuficiente(uint256 montoSolicitado, uint256 saldoDisponible);
    error ExcedeLimiteBanco(uint256 montoDeposito, uint256 espacioDisponible);
    error DepositoVacio();
    error RetiroVacio();
    
    // MODIFICADORES
    
    /// @notice Valida que el monto de depósito sea mayor a 0
    modifier depositoValido(uint256 monto) {
        if (monto == 0) {
            revert DepositoVacio();
        }
        _;
    }
    
    /// @notice Valida que el monto de retiro sea mayor a 0
    modifier retiroValido(uint256 monto) {
        if (monto == 0) {
            revert RetiroVacio();
        }
        _;
    }
    
    // CONSTRUCTOR
    constructor(uint256 _limiteBanco, uint256 _limiteRetiroPorTransaccion) {
        limiteBanco = _limiteBanco;
        limiteRetiroPorTransaccion = _limiteRetiroPorTransaccion;
    }
    
    // FUNCIONES EXTERNAS    
    /// @notice Permite a los usuarios depositar ETH en su bóveda personal
    function depositar() external payable nonReentrant depositoValido(msg.value) {
        if (_excedeLimiteBanco(msg.value)) {
            uint256 espacioDisponible = limiteBanco - totalDepositado;
            revert ExcedeLimiteBanco(msg.value, espacioDisponible);
        }

        bovedaPersonal[msg.sender] += msg.value;
        totalDepositado += msg.value;
        numeroDepositos++;
        
        emit DepositoExitoso(msg.sender, msg.value, bovedaPersonal[msg.sender]);
    }
    
    /// @notice Permite a los usuarios retirar ETH de su bóveda personal
    function retirar(uint256 cantidadRetiro) external nonReentrant retiroValido(cantidadRetiro) {
        if (cantidadRetiro > limiteRetiroPorTransaccion) {
            revert ExcedeLimiteRetiro(cantidadRetiro, limiteRetiroPorTransaccion);
        }
        
        if (bovedaPersonal[msg.sender] < cantidadRetiro) {
            revert SaldoInsuficiente(cantidadRetiro, bovedaPersonal[msg.sender]);
        }
        
        bovedaPersonal[msg.sender] -= cantidadRetiro;
        totalDepositado -= cantidadRetiro;
        numeroRetiros++;
        
        uint256 nuevoSaldo = bovedaPersonal[msg.sender];
        
        (bool exito, ) = payable(msg.sender).call{value: cantidadRetiro}("");
        require(exito, "Fallo en la transferencia");
        
        emit RetiroExitoso(msg.sender, cantidadRetiro, nuevoSaldo);
    }
    
    // FUNCIONES DE VISTA 
    /// @notice Consulta el saldo de ETH en la bóveda de un usuario específico
    function consultarSaldoUsuario(address usuario) external view returns (uint256) {
        return bovedaPersonal[usuario];
    }
    
    /// @notice Consulta el saldo de ETH en la bóveda del usuario que llama la función
    function consultarMiSaldo() external view returns (uint256) {
        return bovedaPersonal[msg.sender];
    }
    
    /// @notice Consulta las estadísticas generales del banco
    function consultarEstadisticasBanco() external view returns (uint256 totalFondos, uint256 capacidadRestante, uint256 totalOperaciones) {
        totalFondos = totalDepositado;
        capacidadRestante = limiteBanco - totalDepositado;
        totalOperaciones = numeroDepositos + numeroRetiros;
    }
    
    /// @notice Consulta los límites de seguridad del contrato
    function consultarLimites() external view returns (uint256 limiteGlobal, uint256 limiteRetiroIndividual) {
        limiteGlobal = limiteBanco;
        limiteRetiroIndividual = limiteRetiroPorTransaccion;
    }
    
    // FUNCIONES PRIVADAS
    
    /// @notice Verifica si un depósito excedería el límite global del banco
    function _excedeLimiteBanco(uint256 montoDeposito) private view returns (bool) {
        return (totalDepositado + montoDeposito) > limiteBanco;
    }
}