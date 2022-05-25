-- Alfredo Vasconcelos de Andrade - 120210139
-- Banco de Dados 1 - Roteiro 02

-- Questão 1
CREATE TABLE tarefas(
 id INTEGER,
 descrição TEXT,
 cpf_trabalhador CHAR(11),
 prioridade INTEGER,
 status_tarefa CHAR(1)
);

-- Comandos que dão certo
INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');

INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');

INSERT INTO tarefas VALUES (null, null, null, null, null);

-- Comandos que não dão certo
INSERT INTO tarefas VALUES(2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');

INSERT INTO tarefas VALUES(2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');

-- Questão 2
-- Edição para funcionar o comando
ALTER TABLE tarefas ALTER COLUMN id TYPE BIGINT;

INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');

-- Questão 3
-- Alteração
ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridade_valido CHECK(prioridade < 32768);

-- Comandos que não são pra dar certo
INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal', '32322525199', 32768, 'A');
INSERT INTO tarefas VALUES(2147483650, 'limpar janelas da entrada principal', '32333233288', 32769, 'A');

-- Comandos que são pra dar certo
INSERT INTO tarefas VALUES (2147483651, 'limpar portas do 1o andar', '32323232911', 32767, 'A');
INSERT INTO tarefas VALUES (2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A');

-- Questão 4
ALTER TABLE tarefas RENAME COLUMN descrição TO descricao;
ALTER TABLE tarefas RENAME COLUMN cpf_trabalhador TO func_resp_cpf;
ALTER TABLE tarefas RENAME COLUMN status_tarefa TO status;

-- Colocando NOT NULL com erro
ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;

-- Removendo as tuplas nulas
DELETE FROM tarefas WHERE id IS NULL;
DELETE FROM tarefas WHERE descricao IS NULL;
DELETE FROM tarefas WHERE func_resp_cpf IS NULL;
DELETE FROM tarefas WHERE prioridade IS NULL;
DELETE FROM tarefas WHERE status IS NULL;

-- Colocando NOT NULL com sucesso
ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;

-- Questão 5
ALTER TABLE tarefas ADD CONSTRAINT tarefas_pkey PRIMARY KEY(id);

-- Funciona
INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'A');

-- Não Funciona
INSERT INTO tarefas VALUES (2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A');

-- Questão 6
-- A) Constraint
ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_func_resp_cpf_valido CHECK(LENGTH(func_resp_cpf)=11);
-- Teste mais dígitos de cpf
INSERT INTO tarefas VALUES(2147483657, 'aparar a grama da área frontal', '323232329118', 3, 'A');
-- Teste menos dígitos de cpf
INSERT INTO tarefas VALUES(2147483657, 'aparar a grama da área frontal', '3232323291', 3, 'A');

-- B)
-- Atualização
UPDATE tarefas SET status='P' WHERE status='A';
UPDATE tarefas SET status='E' WHERE status='R';
UPDATE tarefas SET status='C' WHERE status='F';

-- Adição de restrição
ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_status_valido CHECK(status='P' or status='E' or status='C');

-- Questão 7
-- Atualização
UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

-- Adição de restrição
ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridade_valido CHECK(prioridade >= 0 AND prioridade <= 5);

-- Questão 8
CREATE TABLE funcionario( 
    cpf CHAR(11) PRIMARY KEY,
    data_nasc DATE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    funcao VARCHAR(11),
    nivel CHAR(1) NOT NULL,
    superior_cpf CHAR(11) REFERENCES funcionario(cpf),
    CHECK(funcao='LIMPEZA' or funcao='SUP_LIMPEZA'),
    CHECK(not(funcao='LIMPEZA' and superior_cpf is null)),
    CHECK(nivel = 'J' or nivel = 'P' or nivel = 'S')
);

-- Devem funcionar
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911','1980-05-07','Pedro da Silva','SUP_LIMPEZA','S',null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912','1980-03-08','Jose da Silva', 'LIMPEZA', 'J', '12345678911');

-- Não deve funcionar
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf)VALUES('12345678913','1980-04-09','joao da Silva','LIMPEZA', 'J', null);

-- Questão 9
-- Inserções que dão certo
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913','1999-03-09','Clara da Silva', 'LIMPEZA', 'P', '12345678911');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914','2000-04-10','Lucas Pereira', 'SUP_LIMPEZA', 'J', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915','2001-05-11','Cleber Melo', 'LIMPEZA', 'S', '12345678914');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916','2000-07-12','Vinicius Junior', 'SUP_LIMPEZA', 'J', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917','1985-02-05','Cristiano Ronaldo', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918','2001-04-10','Andreas Pereira', 'LIMPEZA', 'J', '12345678916');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919','1990-04-10','Ednaldo Pereira', 'LIMPEZA', 'P', '12345678914');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678920','1987-06-24','Lionel Messi', 'LIMPEZA', 'S', '12345678917');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921','2002-06-07','Julius Rock', 'LIMPEZA', 'J', '12345678917');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922','1995-10-10','José Lima', 'LIMPEZA', 'J', '12345678916');

-- Inserções que não dão certo
-- CPF já cadastrado
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917','2004-02-05','Cristiano Ronaldo Junior', 'LIMPEZA', 'S', '12345678916');
-- Nível inexistente
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923','1998-03-23','Lima Santos', 'LIMPEZA', 'Z', '12345678916');
-- Nível existente em letra minúscula
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923','1998-03-23','Lima Santos', 'LIMPEZA', 'j', '12345678916');
-- Codigo de superior invalido
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923','1998-03-23','Lima Santos', 'LIMPEZA', 'J', '12345678901');
-- Função inexistente
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678930','1987-06-24','Lionel Messi', 'PIPOQUEIRO', 'S', '12345678917');
-- CPF invalido
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('123456789115','2004-02-05','Cristiano Ronaldo Junior', 'LIMPEZA', 'S', '12345678916');
-- CPF Nulo
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES (NULL,'2004-02-05','Cristiano Ronaldo Junior', 'LIMPEZA', 'S', '12345678916');
-- Funcionário de limpeza sem superior
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf)VALUES('12345678925','1980-10-08','Jailton da Silva','LIMPEZA','J', null);
-- Valor nulo para data de nascimento
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf)VALUES('12345678931',null,'Fabiana da Silva','SUP_LIMPEZA','S',null);

-- Questão 10
-- ON DELETE CASCADE
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122','2004-02-05','Livia Araujo','LIMPEZA','J','12345678916');
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955','2004-02-05','Luis Lucena','LIMPEZA','J','12345678916');
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911','2004-02-05','Lucio Silva','LIMPEZA','J','12345678916');
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111','2004-02-05','Lavinia Pedrosa','LIMPEZA','J','12345678916');

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY(func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE CASCADE;
DELETE FROM funcionario WHERE cpf='98765432122';

ALTER TABLE tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;

-- ON DELETE RESTRICT
ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY(func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE RESTRICT;
DELETE FROM funcionario WHERE cpf='32323232955';
-- ERROR:  update or delete on table "funcionario" violates foreign key constraint "tarefas_func_resp_cpf_fkey" on table "tarefas"
-- DETAIL:  Key (cpf)=(32323232955) is still referenced from table "tarefas".

-- Questão 11
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL;
ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_func_resp_cpf_valida CHECK(NOT(func_resp_cpf is null and status='C') and NOT(func_resp_cpf is null and status='E'));
ALTER TABLE tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY(func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE SET NULL;

-- Testando
-- DELETE de funcionario em tarefa com status "C"
DELETE FROM funcionario WHERE cpf='98765432111';
-- Mensagem de erro quando o status é "C":
-- ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_func_resp_cpf_valida"
--DETAIL:  Failing row contains (2147483646, limpar chão do corredor central, null, 0, C).
--CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232956','2004-02-05','Caio Rios','LIMPEZA','J','12345678916');
INSERT INTO tarefas VALUES(2147483659, 'limpar portas do 5o andar', '32323232956', 2, 'E');
-- DELETE de funcionario em tarefa com status "E"
DELETE FROM funcionario WHERE cpf='32323232956';
-- ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_func_resp_cpf_valida"
-- DETAIL:  Failing row contains (2147483659, limpar portas do 5o andar, null, 2, E).
-- CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""

-- DELETE de funcionario em tarefa com status "P"
DELETE FROM funcionario WHERE cpf='32323232955';