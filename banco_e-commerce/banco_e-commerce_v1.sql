create database ecommerce;
use ecommerce;

create table endereco(
		idEndereco int auto_increment primary key,
        Rua varchar(20)not null,
        Numero int not null,
        Bairro varchar(20) not null,
        CEP char(9) not null,
        Cidade varchar(30) not null,
        Estado char(2) not null
);

create table cliente(
		idCliente int auto_increment primary key,
        idClienteEndereco int,
        FNome varchar(40)not null,
        LNome varchar(40) not null,
        DatadeNascimento date not null,
        constraint fk_cliente_endereco foreign key (idClienteEndereco) references endereco(idEndereco)
);

create table pf(
		idPf int auto_increment primary key,
        idPfCliente int,
        Pf char(12),
        constraint fk_pf_cliente foreign key (idPfCliente) references cliente(idCliente)
);

create table pj(
		idPj int auto_increment primary key,
        idPjCliente int,
        Pj char(12),
        constraint fk_pj_cliente foreign key (idPjCliente) references cliente(idCliente)
);

create table tpagamento(
		idTPagamento int auto_increment primary key,
        ValorT float,
        Ndeparcelas int
);

create table boleto(
	idBoleto int auto_increment primary key,
    idBoletoTpagamento int,
    Codigo varchar(40),
    CodigodeBarras varchar(40),
    constraint fk_boleto_tpagamento foreign key (idBoletoTpagamento) references tpagamento(idTPagamento)
);

create table pix(
	idPix int auto_increment primary key,
    idPixTpagamento int,
    QRcode varchar(40),
    Chave varchar(40),
    constraint fk_pix_tpagamento foreign key (idPixTpagamento) references tpagamento(idTPagamento)
);

create table cartaoc(
	idCartaoC int auto_increment primary key,
    idCartaoCTpagamento int,
    NdoCartaoc varchar(20),
    DatadeV varchar(10),
    Agencia varchar(40),
    CVC int,
    constraint fk_cartaoc_tpagamento foreign key (idCartaoCTpagamento) references tpagamento(idTPagamento)
);

create table cartaod(
	idCartaoD int auto_increment primary key,
    idCartaoDTpagamento int,
    NdoCartaod varchar(20),
    DatadeV varchar(10),
    Agencia char(4),
    CVC int,
    constraint fk_cartaod_tpagamento foreign key (idCartaoDTpagamento) references tpagamento(idTPagamento)
);

create table statusentrega(
		idStatusEntrega int auto_increment primary key,
        Situacao enum('Em estoque', 'Enviado', 'Na cidade', 'Entrege')
);

create table entrega(
	idEntrega int auto_increment primary key,
    idEntregaStatusEntrega int,
    NotaFiscal varchar(40),
    CodigodeRastreio varchar(40),
    constraint fk_entrega_statusentrega foreign key (idEntregaStatusEntrega) references statusentrega(idStatusEntrega)
);

create table statuspedido(
		idStatusPedido int auto_increment primary key,
        Situacao enum('Aprovado', 'Rejeitado')
);

create table pedido(
		idPedido int auto_increment primary key,
        Descricao varchar(40),
        Frete float,
        idPedidoCliente int,
        idPedidoStatusPedido int,
        idPedidoEntrega int,
        idPedidoTPagamento int,
        constraint fk_pedido_cliente foreign key (idPedidoCliente) references cliente(idCliente),
        constraint fk_pedido_statuspedido foreign key (idPedidoStatusPedido) references statuspedido(idStatusPedido),
        constraint fk_pedido_entrega foreign key (idPedidoEntrega) references entrega(idEntrega),
        constraint fk_pedido_tpagamento foreign key (idPedidoTPagamento) references tpagamento(idTPagamento)
);

create table produto(
	idProduto int auto_increment primary key,
    Categoria varchar(40) not null,
    Descricao varchar(40),
    Valor float
);

create table relacaoprodutopedido(
		idRelacaoProdutoP int,
        idRelacaoPedidoP int,
        Quantidade int,
        StatusP enum('Disponível', 'Indisponível'),
        constraint fk_relacaoprodutopedido_produto foreign key (idRelacaoProdutoP) references produto(idProduto),
        constraint fk_relacaoprodutopedido_pedido foreign key (idRelacaoPedidoP) references pedido(idPedido)
);

create table estoque(
	idEstoque int auto_increment primary key,
    LocalE varchar(40) not null
);

create table relacaoprodutoestoque(
		idRelacaoProdutoE int,
        idRelacaoEstoqueE int,
        Quantidade int,
        constraint fk_relacaoprodutoestoque_produto foreign key (idRelacaoProdutoE) references produto(idProduto),
        constraint fk_relacaoprodutoestoque_estoque foreign key (idRelacaoEstoqueE) references estoque(idEstoque)
);

create table fornecedor(
	idFornecedor int auto_increment primary key,
    RazaoSocial varchar(40) not null,
    CNPJ varchar(20) not null
);

create table relacaoprodutofornecedor(
		idRelacaoProdutoF int,
        idRelacaoFornecedorF int,
        constraint fk_relacaoprodutofornecedor_produto foreign key (idRelacaoProdutoF) references produto(idProduto),
        constraint fk_relacaoprodutofornecedor_estoque foreign key (idRelacaoFornecedorF) references fornecedor(idFornecedor)
);

create table fornecedorterceiro(
	idFornecedorTerceiro int auto_increment primary key,
    RazaoSocial varchar(40) not null,
    CNPJ varchar(20) not null
);

create table relacaoprodutofornecedorterceiro(
		idRelacaoProdutoT int,
        idRelacaoFornecedorTerceiroT int,
        QuantidadeT int,
        constraint fk_relacaoprodutofornecedorterceiro_produto foreign key (idRelacaoProdutoT) references produto(idProduto),
        constraint fk_relacaoprodutofornecedorterceiro_fornecedorterceiro foreign key (idRelacaoFornecedorTerceiroT) references fornecedorterceiro(idFornecedorTerceiro)
);

select * from cliente;
select * from cliente c, pedido p where c.idCliente = idPedidoCliente;
select concat(FNome, ' ', LNome) as ClienteNomeC, idPedido as NumerodoPedido, Situacao as Estado from cliente c, pedido p, statuspedido s where c.idCliente = idPedidoCliente;
select * from cliente c, pedido p where c.idCliente = idPedidoCliente order by idPedido;
select * from produto p, relacaoprodutopedido r, estoque e where r.StatusP = 'Disponível' having p.valor > 30;
select * from cliente c, endereco e where e.idEndereco = idClienteEndereco group by cidade = 'Brasília'
