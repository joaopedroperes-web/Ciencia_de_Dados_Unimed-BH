create database oficina;
use oficina;

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
        ValorT float not null,
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

create table dinheiro(
	idDinheiro int auto_increment primary key,
    idDinheiroTpagamento int,
    Moeda1R int,
    Moeda5C int,
    Moeda10C int,
    Moeda25C int,
    Moeda50C int,
    Nota2 int,
    Nota5 int,
    Nota10 int,
    Nota20 int,
    Nota50 int,
    Nota100 int,
    Nota200 int,
    constraint fk_dinheiro_tpagamento foreign key (idDinheiroTpagamento) references tpagamento(idTPagamento)
);

create table statusos(
		idStatusOS int auto_increment primary key,
        Status enum('Aceito', 'Rejeitado')
);

create table os(
		idOS int auto_increment primary key,
        DatadeEmissao date,
        DatadeConclusao date,
        idOSTpagamento int,
        idOSStatusOS int,
        constraint fk_os_statusos foreign key (idOSStatusOS) references statusos(idStatusOS),
        constraint fk_os_tpagamento foreign key (idOSTpagamento) references tpagamento(idTPagamento)
);

create table conserto(
		idConserto int auto_increment primary key,
        Descricao varchar(40)
);

create table revisao(
		idRevisao int auto_increment primary key,
        Revisao varchar(40)
);

create table veiculo(
		idVeiculo int auto_increment primary key,
        Placa varchar(20),
        Marca varchar(20),
        Modelo varchar(20),
        idVeiculoCliente int,
        idVeiculoOS int,
        idVeiculoConserto int,
        idVeiculoRevisao int,
        constraint fk_veiculo_cliente foreign key (idVeiculoCliente) references cliente(idCliente),
        constraint fk_veiculo_os foreign key (idVeiculoOS) references os(idOS),
        constraint fk_veiculo_conserto foreign key (idVeiculoConserto) references conserto(idConserto),
        constraint fk_veiculo_revisao foreign key (idVeiculoRevisao) references revisao(idRevisao)
);

create table estoque(
	idEstoque int auto_increment primary key,
    Localp varchar(40) not null
);

create table peca(
	idPeca int auto_increment primary key,
    idPecaEstoque int,
    Valor varchar(40) not null,
    constraint fk_peca_estoque foreign key (idPecaEstoque) references estoque(idEstoque)
);

create table pecanecessarias(
		idPecanecessariasP int,
        idPecanecessariasOS int,
        Quantidade int,
        constraint fk_pecanecessarias_peca foreign key (idPecanecessariasP) references peca(idPeca),
        constraint fk_pecanecessarias_os foreign key (idPecanecessariasOS) references os(idOS)
);

create table enderecom(
		idEnderecoM int auto_increment primary key,
        RuaM varchar(20)not null,
        NumeroM int not null,
        BairroM varchar(20) not null,
        CEPm char(9) not null,
        CidadeM varchar(30) not null,
        EstadoM char(2) not null
);

create table mecanico(
		idMecanico int auto_increment primary key,
        idMecanicoEnderecoM int,
        FNome varchar(40)not null,
        LNome varchar(40) not null,
        Especialidade varchar(40),
        DatadeNascimento date not null,
        constraint fk_mecanico_enderecom foreign key (idMecanicoEnderecoM) references enderecom(idEnderecoM)
);

create table statusproblema(
		idStatusProblema int auto_increment primary key,
        Problema varchar(40)
);

create table equipe(
		idEquipeOS int,
        idEquipeMecanico int,
        idEquipeStatusProblema int,
        ValordoConserto float,
		ValordaRevisao float,
        constraint fk_equipe_os foreign key (idEquipeOS) references os(idOS),
        constraint fk_equipe_mecanico foreign key (idEquipeMecanico) references mecanico(idMecanico),
        constraint fk_equipe_statusproblema foreign key (idEquipeStatusProblema) references statusproblema(idStatusProblema)
);

select * from os;
select * from cliente c, veiculo v where c.idCliente = idVeiculoCliente;
select concat(FNome, ' ', LNome) as ClienteNomeC, idVeiculo as NumerododoVeiculo, Status as Estado from cliente c, veiculo v, statusos s where c.idCliente = idVeiculoCliente;
select * from cliente c, veiculo v where c.idCliente = idVeiculoCliente order by idVeiculo;
select * from peca p, pecanecessarias n where p.valor < 3000.00 having n.quantidade = 1;
select * from cliente c, endereco e where e.idEndereco = idClienteEndereco group by cidade = 'Brasília'