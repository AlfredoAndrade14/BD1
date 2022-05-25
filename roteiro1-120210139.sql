-- Alfredo Vasconcelos de Andrade - 120210139
-- Banco de Dados 1 - Roteiro 01

--Questão 1
-- Automovel Atributos: chassi, placa, marca, modelo, ano, cor, se ha seguro
-- Segurado Atributos: cpf, nome, endereço, idade, chassi do automovel
-- Perito Atributos: cpf, nome, endereço, idade, chassi do automovel
-- Oficina Atributos: id, cnpj, endereço, nome
-- Seguro Atributos: apolice, chassi do automovel , cpf do segurado , data de inicio, data de fim, valor
-- Sinistro Atributos: id, cpf do segurado , chassi do automovel, data realizada, endereço, apolice, id pericia
-- Pericia Atributos: id, cpf do perito, cpf do segurado, chassi do Automovel, relatorio, data realizada, local feito
-- Reparo Atributos: id, cnpj da oficina, custo, id do sinistro

--Questão 2
CREATE TABLE automovel (
    chassi CHAR(17),
    placa CHAR(7),
    marca VARCHAR(25),
    modelo VARCHAR(25),
    ano VARCHAR(9),
    cor VARCHAR(25),
    ha_Seguro BOOLEAN
);

CREATE TABLE segurado (
    cpf CHAR(11),
    nome VARCHAR(100),
    endereço VARCHAR(300),
    data_nascimento DATE,
    chassi_automovel CHAR(17)
);

CREATE TABLE perito (
    cpf CHAR(11),
    nome VARCHAR(100),
    endereço VARCHAR(300),
    data_nascimento DATE
);

CREATE TABLE oficina (
    cnpj CHAR(14),
    endereço VARCHAR(300),
    nome VARCHAR(100)
);

CREATE TABLE seguro (
    apolice SERIAL,
    chassi_automovel CHAR(17),
    cpf_segurado CHAR(11),
    data_inicio DATE,
    data_fim DATE,
    valor NUMERIC
);

CREATE TABLE sinistro (
    id SERIAL,
    cpf_segurado CHAR(11),
    chassi_automovel CHAR(17),
    data_ocorrido TIMESTAMP,
    endereco VARCHAR(150),
    apolice INTEGER
);

CREATE TABLE pericia (
    id SERIAL,
    cpf_perito CHAR(11),
    cpf_segurado CHAR(11),
    chassi_automovel CHAR(17),
    relatorio TEXT,
    data_realizada DATE,
    id_sinistro INTEGER
);

CREATE TABLE reparo (
    id SERIAL,
    cnpj_oficina CHAR(14),
    custo NUMERIC,
    id_sinistro INTEGER
);

--Questão 3
--Automovel
ALTER TABLE automovel ADD CONSTRAINT automovel_pkey PRIMARY KEY(chassi);

--Segurado
ALTER TABLE segurado ADD CONSTRAINT segurado_pkey PRIMARY KEY(cpf);

--Perito
ALTER TABLE perito ADD CONSTRAINT perito_pkey PRIMARY KEY(cpf);

--Oficina
ALTER TABLE oficina ADD CONSTRAINT oficina_pkey PRIMARY KEY(cnpj);

--Seguro
ALTER TABLE seguro ADD CONSTRAINT seguro_pkey PRIMARY KEY(apolice);

--Sinistro
ALTER TABLE sinistro ADD CONSTRAINT sinistro_pkey PRIMARY KEY(id);

--Pericia
ALTER TABLE pericia ADD CONSTRAINT pericia_pkey PRIMARY KEY(id);

--Reparo
ALTER TABLE reparo ADD CONSTRAINT reparo_pkey PRIMARY KEY(id);

--Questão 4
--Segurado
ALTER TABLE segurado ADD CONSTRAINT segurado_chassi_automovel_fkey FOREIGN KEY(chassi_automovel) REFERENCES automovel(chassi);

--Seguro
ALTER TABLE seguro ADD CONSTRAINT seguro_chassi_automovel_fkey FOREIGN KEY(chassi_automovel) REFERENCES automovel(chassi);
ALTER TABLE seguro ADD CONSTRAINT seguro_cpf_segurado_fkey FOREIGN KEY(cpf_segurado) REFERENCES segurado(cpf);

--Sinistro
ALTER TABLE sinistro ADD CONSTRAINT sinistro_cpf_segurado_fkey FOREIGN KEY(cpf_segurado) REFERENCES segurado(cpf);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_chassi_automovel_fkey FOREIGN KEY(chassi_automovel) REFERENCES automovel(chassi);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_apolice_fkey FOREIGN KEY(apolice) REFERENCES seguro(apolice);

--Pericia
ALTER TABLE pericia ADD CONSTRAINT pericia_cpf_perito_fkey FOREIGN KEY(cpf_perito) REFERENCES perito(cpf);
ALTER TABLE pericia ADD CONSTRAINT pericia_cpf_segurado_fkey FOREIGN KEY(cpf_segurado) REFERENCES segurado(cpf);
ALTER TABLE pericia ADD CONSTRAINT pericia_chassi_automovel_fkey FOREIGN KEY(chassi_automovel) REFERENCES automovel(chassi);
ALTER TABLE pericia ADD CONSTRAINT pericia_id_sinistro_fkey FOREIGN KEY(id_sinistro) REFERENCES sinistro(id);

--Reparo
ALTER TABLE reparo ADD CONSTRAINT reparo_id_sinistro_fkey FOREIGN KEY(id_sinistro) REFERENCES sinistro(id);
ALTER TABLE reparo ADD CONSTRAINT reparo_cnpj_oficina_fkey FOREIGN KEY(cnpj_oficina) REFERENCES oficina(cnpj);

--Questão 5
-- As primary key são NOT NULL pois ser primary key faz com que sejam NOT NULL
--Automovel: placa, marca, modelo, ano, cor, ha_seguro são atributos que devem ser NOT NULL
--Segurado: nome, data_nascimento, chassi_automovel são atributos que devem ser NOT NULL
--Perito: nome, data_nascimento são atributos que devem ser NOT NULL
--Oficina: cnpj, endereço, nome
--Seguro: chassi_automovel, cpf_segurado, data_inicio, data_fim são atributos que devem ser NOT NULL
--Sinistro: cpf_segurado, chassi_automovel, data_ocorrido, apolice são atributos que devem ser NOT NULL
--Pericia: cpf_perito, cpf_segurado, chassi_automovel, relatorio, data_realizada são atributos que devem ser NOT NULL
--Reparo: cnpj_oficina, custo, id_sinistro são atributos que devem ser NOT NULL

--Questão 6
DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE oficina;
DROP TABLE perito;
DROP TABLE segurado;
DROP TABLE automovel;

--Questão 7 e 8
CREATE TABLE automovel (
    chassi CHAR(17) PRIMARY KEY,
    placa CHAR(7) NOT NULL,
    marca VARCHAR(25) NOT NULL,
    modelo VARCHAR(25) NOT NULL,
    ano VARCHAR(9) NOT NULL,
    cor VARCHAR(25) NOT NULL,
    ha_Seguro BOOLEAN NOT NULL
);

CREATE TABLE segurado (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereço VARCHAR(300),
    data_nascimento DATE NOT NULL,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL
);

CREATE TABLE perito (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereço VARCHAR(300),
    data_nascimento DATE NOT NULL
);

CREATE TABLE oficina (
    cnpj CHAR(14) PRIMARY KEY,
    endereço VARCHAR(300) NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE seguro (
    apolice SERIAL PRIMARY KEY,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL,
    cpf_segurado CHAR(11) REFERENCES segurado(cpf) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor NUMERIC
);

CREATE TABLE sinistro (
    id SERIAL PRIMARY KEY,
    cpf_segurado CHAR(11) REFERENCES segurado(cpf) NOT NULL,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL,
    data_ocorrido TIMESTAMP NOT NULL,
    endereco VARCHAR(150),
    apolice INTEGER REFERENCES seguro(apolice) NOT NULL
);

CREATE TABLE pericia (
    id SERIAL PRIMARY KEY,
    cpf_perito CHAR(11) REFERENCES perito(cpf) NOT NULL,
    cpf_segurado CHAR(11) REFERENCES segurado(cpf) NOT NULL,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL,
    relatorio TEXT NOT NULL,
    data_realizada DATE NOT NULL,
    id_sinistro INTEGER REFERENCES sinistro(id) NOT NULL
);

CREATE TABLE reparo (
    id SERIAL PRIMARY KEY,
    cnpj_oficina CHAR(14) REFERENCES oficina(cnpj) NOT NULL,
    custo NUMERIC NOT NULL,
    id_sinistro INTEGER REFERENCES sinistro(id) NOT NULL
);

--Questão 9
DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE oficina;
DROP TABLE perito;
DROP TABLE segurado;
DROP TABLE automovel;

--Questão 10
-- Adição das tabelas "automovel_reserva" e "locadora" para caso o seguro dê direito a um cautomovel reserva
CREATE TABLE automovel (
    chassi CHAR(17) PRIMARY KEY,
    placa CHAR(7) NOT NULL,
    marca VARCHAR(25) NOT NULL,
    modelo VARCHAR(25) NOT NULL,
    ano VARCHAR(9) NOT NULL,
    cor VARCHAR(25) NOT NULL,
    ha_Seguro BOOLEAN NOT NULL
);

CREATE TABLE segurado (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereço VARCHAR(300),
    data_nascimento DATE NOT NULL,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL
);

CREATE TABLE perito (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereço VARCHAR(300),
    data_nascimento DATE NOT NULL
);

CREATE TABLE oficina (
    cnpj CHAR(14) PRIMARY KEY,
    endereço VARCHAR(300) NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE seguro (
    apolice SERIAL PRIMARY KEY,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL,
    cpf_segurado CHAR(11) REFERENCES segurado(cpf) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor NUMERIC
);

CREATE TABLE locadora (
    cnpj CHAR(14) PRIMARY KEY,
    endereço VARCHAR(300) NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE automovel_reserva (
    chassi CHAR(17) PRIMARY KEY,
    placa CHAR(7) NOT NULL,
    marca VARCHAR(25) NOT NULL,
    modelo VARCHAR(25) NOT NULL,
    ano VARCHAR(9) NOT NULL,
    cor VARCHAR(25) NOT NULL,
    cnpj_locadora CHAR(14) REFERENCES locadora(cnpj) NOT NULL
);

CREATE TABLE sinistro (
    id SERIAL PRIMARY KEY,
    cpf_segurado CHAR(11) REFERENCES segurado(cpf) NOT NULL,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL,
    data_ocorrido TIMESTAMP NOT NULL,
    endereco VARCHAR(150),
    apolice INTEGER REFERENCES seguro(apolice) NOT NULL,
    chassi_automovel_reserva CHAR(17) REFERENCES automovel_reserva(chassi) NOT NULL
);

CREATE TABLE pericia (
    id SERIAL PRIMARY KEY,
    cpf_perito CHAR(11) REFERENCES perito(cpf) NOT NULL,
    cpf_segurado CHAR(11) REFERENCES segurado(cpf) NOT NULL,
    chassi_automovel CHAR(17) REFERENCES automovel(chassi) NOT NULL,
    relatorio TEXT NOT NULL,
    data_realizada DATE NOT NULL,
    id_sinistro INTEGER REFERENCES sinistro(id) NOT NULL
);

CREATE TABLE reparo (
    id SERIAL PRIMARY KEY,
    cnpj_oficina CHAR(14) REFERENCES oficina(cnpj) NOT NULL,
    custo NUMERIC NOT NULL,
    id_sinistro INTEGER REFERENCES sinistro(id) NOT NULL
);