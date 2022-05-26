-- Alfredo Vasconcelos de Andrade - 120210139
-- Banco de Dados 1 - Roteiro 03

CREATE TYPE ESTADOS_NORDESTE AS ENUM('Paraíba', 'Bahia', 'Alagoas', 'Pernambuco', 'Ceará', 'Piauí', 'Maranhão', 'Rio Grande do Norte', 'Sergipe');
CREATE TYPE Tipo_Endereço AS ENUM ('Residência', 'Trabalho', 'Outro');

CREATE TABLE farmacia(
    id SERIAL PRIMARY KEY,
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado ESTADOS_NORDESTE NOT NULL,
    tipo CHAR(1) NOT NULL,
    cpf_gerente CHAR(11),
    funcao_gerente VARCHAR(20),
    UNIQUE(bairro,cidade,estado),
    CHECK(funcao_gerente IN('Administrador','Farmacêutico')),
    CHECK(tipo='S' or tipo='F')
);

CREATE TABLE funcionario(
    cpf CHAR(11),
    nome VARCHAR(50) NOT NULL,
    farmacia_contratante INTEGER REFERENCES farmacia(id),
    funcao VARCHAR(20) NOT NULL,
    CHECK(funcao IN('Farmacêutico', 'Vendedor', 'Entregador', 'Caixa', 'Administrador')),
    PRIMARY KEY(cpf, funcao)
);

ALTER TABLE farmacia ADD CONSTRAINT farmacia_gerente_func_gerente_fkey FOREIGN KEY(cpf_gerente, funcao_gerente) REFERENCES funcionario(cpf, funcao);
ALTER TABLE farmacia ADD CONSTRAINT farmacia_unica_sede_excl EXCLUDE USING gist(tipo WITH=)WHERE(tipo='S');

CREATE TABLE medicamento(
    id SERIAL,
    nome VARCHAR(25) NOT NULL,
    miligrama VARCHAR(5) NOT NULL,
    venda_com_receita BOOLEAN,
    PRIMARY KEY(id, venda_com_receita)
);

CREATE TABLE venda(
    id SERIAL PRIMARY KEY,
    cpf_vendedor CHAR(11),
    funcao_vendedor VARCHAR(20),
    id_medicamento INTEGER,
    venda_com_receita BOOLEAN,
    cpf_comprador CHAR(11),
    CHECK(not((venda_com_receita is true)and(cpf_comprador is null))),
    CHECK(funcao_vendedor='Vendedor'),
    FOREIGN KEY(id_medicamento, venda_com_receita)
    REFERENCES medicamento(id, venda_com_receita) ON DELETE RESTRICT,
    FOREIGN KEY(cpf_vendedor, funcao_vendedor)
    REFERENCES funcionario(cpf, funcao) ON DELETE RESTRICT
);

CREATE TABLE cliente(
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    data_nascimento DATE NOT NULL,
    CHECK(date_part('year',age(data_nascimento)) >= 18)
);

CREATE TABLE endereco(
    id SERIAL PRIMARY KEY,
    cpf_cliente CHAR(11) REFERENCES cliente(cpf),
    tipo Tipo_Endereço NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero INTEGER NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(20) NOT NULL
);

CREATE TABLE entrega(
    id SERIAL PRIMARY KEY,
    id_medicamento INTEGER NOT NULL,
    venda_com_receita BOOLEAN NOT NULL,
    cpf_cliente CHAR(11) REFERENCES cliente(cpf) NOT NULL,
    endereco INTEGER REFERENCES endereco(id) NOT NULL,
    FOREIGN KEY(id_medicamento, venda_com_receita)
    REFERENCES medicamento(id, venda_com_receita) 
);

--
-- COMANDOS ADICIONAIS
--

-- DEVEM SER EXECUTADOS COM SUCESSO

-- Adicionando Funcionários
INSERT INTO funcionario VALUES('12345678901', 'Chris Rock', null, 'Administrador');
INSERT INTO funcionario VALUES('12345678902', 'Tonya Rock', null, 'Vendedor');
INSERT INTO funcionario VALUES('12345678903', 'Drew Rock', null, 'Farmacêutico');
INSERT INTO funcionario VALUES('12345678904', 'Julius Rock', null, 'Entregador');
INSERT INTO funcionario VALUES('12345678905', 'Rochelle Rock', null, 'Caixa');

-- Adicionando dados da farmácia
INSERT INTO farmacia VALUES(1, 'Alto Branco', 'Campina Grande', 'Paraíba', 'S', '12345678901', 'Administrador');
INSERT INTO farmacia VALUES(2, 'Catolé', 'Campina Grande', 'Paraíba',  'F', '12345678903', 'Farmacêutico');

-- Adicionando os funcionarios as suas respectivas farmacias
UPDATE funcionario SET farmacia_contratante = '1' WHERE cpf = '12345678901' ;
UPDATE funcionario SET farmacia_contratante = '1' WHERE cpf = '12345678902' ;
UPDATE funcionario SET farmacia_contratante = '2' WHERE cpf = '12345678903';

-- Adicionando Cliente
INSERT INTO cliente VALUES('98765432101', 'Michel Teló', '1981-01-21');

-- Adicionando Endereço
INSERT INTO endereco VALUES(1, '98765432101' , 'Residência', 'rua dos bobos', '0', 'Catolé', 'Campina Grande','Paraíba');

-- Adicionando Medicamentos
INSERT INTO medicamento VALUES(1, 'dipirona', '500mg', false);
INSERT INTO medicamento VALUES(2, 'amoxilina', '500mg', true);

-- Adicionando Venda
INSERT INTO venda VALUES(1, '12345678902', 'Vendedor', 1, false, null);

-- Adicionando Entrega
INSERT INTO entrega VALUES(1, 1, false, '98765432101', 1);

-- Devem Retornar erro

-- Deve retornar erro pois só há uma sede, que já existe

INSERT INTO farmacia VALUES(10, 'S', '', 'Administrador', 'Liberdade', 'Campina Grande', 'Paraíba');

-- Deve retornar erro pois gerentes só podem ser farmacêuticos ou administradores

INSERT INTO farmacia VALUES(3, 'F', '', 'Vendedor', 'Liberdade', 'Campina Grande', 'Paraíba');

-- Deve retornar erro pois entregas são destinadas à clientes cadastrados

INSERT INTO entrega VALUES(2, 1, 1, '');

-- Deve retornar erro pois a entrega não possui um id de endereço válido

INSERT INTO entrega VALUES(2, 1, 5, '');

-- Deve retornar erro pois a entrega não possui um tipo de endereço válido

INSERT INTO endereco VALUES(3, '' , 'praia', 'Rua da praia', 'Bairro da praia', '12', 'João Pessoa' ,'Paraíba');

-- Deve retornar erro pois não é válido vender um medicamento com receita para um cliente não cadastrado

INSERT INTO venda VALUES(2, '', 'Vendedor', 2, true, '', null);

-- Deve ocorrer um erro ao tentar deletar um funcionário relacionado a uma venda

DELETE FROM funcionario WHERE cpf='';

-- Deve ocorrer um erro ao tentar deletar um medicamento relacionado a uma venda

DELETE FROM medicamento WHERE id=1;

-- Deve ocorrer um erro ao tentar adicionar um cliente menor de 18 anos

INSERT INTO cliente VALUES('', '', '2010-10-08');

-- Deve ocorrer um erro pois um mesmo bairro não pode ter mais de uma farmácia

INSERT INTO farmacia VALUES(3, 'F', '', 'Administrador', 'Cruzeiro', 'Campina Grande', 'Paraíba');

-- Deve retornar erro ao tentar atribuir uma venda a um funcionário que não é vendedor

INSERT INTO venda VALUES(2, '', 'Farmacêutico', 1, false, '', null);

-- Deve retornar erro pois a farmácia deve ser cadastrada apenas em estados do Nordeste

INSERT INTO farmacia VALUES(7, 'F', '', 'Administrador','Pinheiros', 'São Paulo', 'São Paulo');