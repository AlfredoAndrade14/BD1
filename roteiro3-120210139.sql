-- Alfredo Vasconcelos de Andrade - 120210139
-- Banco de Dados 1 - Roteiro 03

CREATE TYPE ESTADOS_NORDESTE AS ENUM('Paraíba', 'Bahia', 'Alagoas', 'Pernambuco', 'Ceará', 'Piauí', 'Maranhão', 'Rio Grande do Norte', 'Sergipe');

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
    tipo VARCHAR(10) NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero INTEGER NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    CHECK(tipo IN('Residência', 'Trabalho', 'Outro'))
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

-- Adicionando farmácia
INSERT INTO farmacia VALUES(1, 'Alto Branco', 'Campina Grande', 'Paraíba', 'S', null, null);
INSERT INTO farmacia VALUES(2, 'Catolé', 'Campina Grande', 'Paraíba',  'F', null, null);

-- Adicionando Funcionários
INSERT INTO funcionario VALUES('12345678901', 'Chris Rock', 1, 'Administrador');
INSERT INTO funcionario VALUES('12345678902', 'Tonya Rock', 1, 'Vendedor');
INSERT INTO funcionario VALUES('12345678903', 'Drew Rock', 2, 'Farmacêutico');
INSERT INTO funcionario VALUES('12345678904', 'Julius Rock', null, 'Entregador');
INSERT INTO funcionario VALUES('12345678905', 'Rochelle Rock', null, 'Caixa');
INSERT INTO funcionario VALUES('12345678906', 'Adenor Tite', null, 'Administrador');
INSERT INTO funcionario VALUES('12345678907', 'William Silva', null, 'Entregador');

-- Adicionando Cliente
INSERT INTO cliente VALUES('98765432101', 'Michel Teló', '1981-01-21');

-- Adicionando Endereço
INSERT INTO endereco VALUES(1, '98765432101' , 'Residência', 'rua dos bobos', '0', 'Catolé', 'Campina Grande','Paraíba');

-- Adicionando Medicamentos
INSERT INTO medicamento VALUES(1, 'dipirona', '500mg', false);
INSERT INTO medicamento VALUES(2, 'amoxilina', '500mg', true);
INSERT INTO medicamento VALUES(3, 'Loratamed', '10mg', false);

-- Adicionando Venda
INSERT INTO venda VALUES(1, '12345678902', 'Vendedor', 1, false, null);
INSERT INTO venda VALUES(2, '12345678902', 'Vendedor', 2, true, '98765432101');

-- Adicionando Entrega
INSERT INTO entrega VALUES(1, 1, false, '98765432101', 1);

-- Adiconando gerente as farmacias
UPDATE farmacia SET cpf_gerente = '12345678901', funcao_gerente = 'Administrador' WHERE id = '1';
UPDATE farmacia SET cpf_gerente = '12345678903', funcao_gerente = 'Farmacêutico' WHERE id = '2';

--
-- COMANDOS ADICIONAIS
--

-- Deve ser executado com sucesso
DELETE FROM funcionario WHERE cpf='12345678907';

-- Deve ser executado com sucesso
DELETE FROM medicamento WHERE id=3;

-- Devem Retornar erro

-- Deve retornar erro pois só pode haver uma sede, e existe uma
INSERT INTO farmacia VALUES(5, 'Liberdade', 'Campina Grande', 'Paraíba', 'S', '12345678906', 'Administrador');
-- ERROR:  conflicting key value violates exclusion constraint "farmacia_unica_sede_excl"
-- DETAIL:  Key (tipo)=(S) conflicts with existing key (tipo)=(S). 

-- Deve retornar erro pois gerentes só podem ser farmacêuticos ou administradores
INSERT INTO farmacia VALUES(4, 'Liberdade', 'Campina Grande', 'Paraíba', 'F', '12345678905', 'Caixa');
-- ERROR:  new row for relation "farmacia" violates check constraint "farmacia_funcao_gerente_check"
-- DETAIL:  Failing row contains (4, Liberdade, Campina Grande, Paraíba, F, 12345678905, Caixa).

-- Deve retornar erro pois entregas são destinadas à clientes cadastrados
INSERT INTO entrega VALUES(2, 1, false, '98765432102', 1);
-- ERROR:  insert or update on table "entrega" violates foreign key constraint "entrega_cpf_cliente_fkey"
-- DETAIL:  Key (cpf_cliente)=(98765432102) is not present in table "cliente".

-- Deve retornar erro pois a entrega não possui um id de endereço válido
INSERT INTO entrega VALUES(2, 1, false, '98765432101', 7);
-- ERROR:  insert or update on table "entrega" violates foreign key constraint "entrega_endereco_fkey"
-- DETAIL:  Key (endereco)=(7) is not present in table "endereco".

-- Deve retornar erro pois a entrega não possui um tipo de endereço válido
INSERT INTO endereco VALUES(1, '98765432101' , 'Hotel', 'Praia de botafogo', '15', 'Botafogo', 'Rio de Janeiro','Rio de Janeiro');
-- ERROR:  new row for relation "endereco" violates check constraint "endereco_tipo_check"
-- DETAIL:  Failing row contains (1, 98765432101, Hotel, Praia de botafogo, 15, Botafogo, Rio de Janeiro, Rio de Janeiro).

-- Deve retornar erro pois não é válido vender um medicamento com receita para um cliente não cadastrado
INSERT INTO venda VALUES(3, '12345678902', 'Vendedor', 2, true, null);
-- ERROR:  new row for relation "venda" violates check constraint "venda_check"
-- DETAIL:  Failing row contains (2, 12345678902, Vendedor, 2, t, null).

-- Deve ocorrer um erro ao tentar deletar um funcionário relacionado a uma venda
DELETE FROM funcionario WHERE cpf='12345678902';
-- ERROR:  update or delete on table "funcionario" violates foreign key constraint "venda_cpf_vendedor_fkey" on table "venda"
-- DETAIL:  Key (cpf, funcao)=(12345678902, Vendedor) is still referenced from table "venda".

-- Deve ocorrer um erro ao tentar deletar um medicamento relacionado a uma venda
DELETE FROM medicamento WHERE id=1;
-- ERROR:  update or delete on table "medicamento" violates foreign key constraint "venda_id_medicamento_fkey" on table "venda"
-- DETAIL:  Key (id, venda_com_receita)=(1, f) is still referenced from table "venda".

-- Deve ocorrer um erro ao tentar adicionar um cliente menor de 18 anos
INSERT INTO cliente VALUES('98765432102', 'Claudio Alves', '2010-10-08');
-- ERROR:  new row for relation "cliente" violates check constraint "cliente_data_nascimento_check"
-- DETAIL:  Failing row contains (98765432102, Claudio Alves, 2010-10-08).

-- Deve ocorrer um erro pois um mesmo bairro não pode ter mais de uma farmácia
INSERT INTO farmacia VALUES(3, 'Catolé', 'Campina Grande', 'Paraíba', 'F', '12345678906', 'Administrador');
-- ERROR:  duplicate key value violates unique constraint "farmacia_bairro_cidade_estado_key"
-- DETAIL:  Key (bairro, cidade, estado)=(Catolé, Campina Grande, Paraíba) already exists.

-- Deve retornar erro ao tentar atribuir uma venda a um funcionário que não é vendedor
INSERT INTO venda VALUES(9, '12345678905', 'Caixa', 1, false, '98765432101');
-- ERROR:  new row for relation "venda" violates check constraint "venda_funcao_vendedor_check"
-- DETAIL:  Failing row contains (9, 12345678905, Caixa, 1, f, 98765432101).

-- Deve retornar erro pois a farmácia deve ser cadastrada apenas em estados do Nordeste
INSERT INTO farmacia VALUES(7, 'Pinheiros', 'São Paulo', 'São Paulo', 'F', '12345678906', 'Administrador');
-- ERROR:  invalid input value for enum estados_nordeste: "São Paulo"
-- LINE 1: ...INTO farmacia VALUES(7, 'Pinheiros', 'São Paulo', 'São Paulo...