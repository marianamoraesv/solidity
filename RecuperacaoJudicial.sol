pragma solidity 0.5.12;

contract RecuperacaoJudicial {

 string public EmpresaRecuperanda;
    string public Credor1;
    string public Credor2;
    uint256 public valorRecuperacaoTotal;
    uint256 public valorCredor1;
    uint256 public valorCredor2;
    bool public statusPagamento;
    bool jaFoiReembolsado;
    address payable public contaCredor1;
    address payable public contaCredor2;
    address public contaEmpresaRecuperanda;
    address payable public AdministradorJudicial;
    
    event pagamentoRealizado (uint valor);

    constructor(string memory nomeRecuperanda, 
        string memory nomeCredora1, 
        string memory nomeCredora2, 
        address payable paraContaCredora1, 
        address payable paraContaCredora2, 
        address payable paraAdministrador,
        address _contaEmpresaRecuperanda,
        uint256 _valorRecuperacaoTotal,
        uint _valorCredor1,
        uint _valorCredor2
       ) public {
            
            Credor1 = nomeCredora1;
            Credor2 = nomeCredora2;
            EmpresaRecuperanda = nomeRecuperanda;
            AdministradorJudicial = paraAdministrador;
            valorCredor1 = _valorCredor1;
            valorCredor2 = _valorCredor2;
            valorRecuperacaoTotal = _valorRecuperacaoTotal;
            contaCredor1 = paraContaCredora1;
            contaCredor2 = paraContaCredora2;
            contaEmpresaRecuperanda = _contaEmpresaRecuperanda;
            
    }
    
    modifier somenteEmpresaRecuperanda {
        require(msg.sender == contaEmpresaRecuperanda, "Somente EmpresaRecuperanda pode realizar essa operacao");
        _;
    }
    
     modifier autorizadosRecebimento () {
        require (msg.sender == contaCredor1 || msg.sender == contaCredor2, "Operaçao exclusiva dos Credores.");
        _;    
    }


    function pagamento () public payable somenteEmpresaRecuperanda {
            require (msg.value <= valorRecuperacaoTotal, "Valor diverso do devido");
        statusPagamento = true;
        emit pagamentoRealizado(msg.value);
    }

    function distribuicaoDeValores() public autorizadosRecebimento {
        require(statusPagamento, "Pagamento não realizado");
        require(jaFoiReembolsado == false, "Distribuição já realizada.");
        contaCredor1.transfer(valorCredor1);
        contaCredor2.transfer(valorCredor2);
        
        jaFoiReembolsado = true;
    }
   
    function kill() public {
        require(msg.sender==AdministradorJudicial, "Only owner can destroy the contract");
        selfdestruct(AdministradorJudicial);
    }
}
