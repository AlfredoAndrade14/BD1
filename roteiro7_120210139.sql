-- tables
-- Table: Equipe
CREATE TABLE Equipe (
    ID bigserial  NOT NULL,
    Nome varchar(30)  NOT NULL,
    CONSTRAINT Equipe_pk PRIMARY KEY (ID)
);

-- Table: Jogador
CREATE TABLE Jogador (
    ID bigserial  NOT NULL,
    Nome varchar(30)  NOT NULL,
    Data_De_Nascimento date  NOT NULL,
    Numero_Camisa smallint,
    Equipe_ID bigint NOT NULL,
    CONSTRAINT Jogador_pk PRIMARY KEY (ID)
);

-- Table: Participacao
CREATE TABLE Participacao (
    Partida_ID bigint  NOT NULL,
    Jogador_ID bigint  NOT NULL,
    Assistencias int  NOT NULL DEFAULT 0,
    Gols int  NOT NULL DEFAULT 0,
    Posicao varchar(30) NOT NULL,
    Cartoes_Amarelos int  NOT NULL DEFAULT 0,
    Cartoes_Vermelhos int  NOT NULL DEFAULT 0,
    CONSTRAINT Participacao_pk PRIMARY KEY (Partida_ID,Jogador_ID)
);

-- Table: Partida
CREATE TABLE Partida (
    ID bigserial  NOT NULL,
    Data_Hora timestamp  NOT NULL,
    Equipe_1 bigint  NOT NULL,
    Equipe_2 bigint  NOT NULL,
    CONSTRAINT Partida_pk PRIMARY KEY (ID)
);

-- foreign keys
-- Reference: Equipe_Jogador (table: Jogador)
ALTER TABLE Jogador ADD CONSTRAINT Equipe_Jogador FOREIGN KEY (Equipe_ID) REFERENCES Equipe (ID) NOT DEFERRABLE INITIALLY IMMEDIATE;

-- Reference: Participacao_Jogador (table: Participacao)
ALTER TABLE Participacao ADD CONSTRAINT Participacao_Jogador FOREIGN KEY (Jogador_ID) REFERENCES Jogador (ID)  NOT DEFERRABLE INITIALLY IMMEDIATE;

-- Reference: Partida_Equipe_1 (table: Partida)
ALTER TABLE Partida ADD CONSTRAINT Partida_Equipe_1 FOREIGN KEY (Equipe_1) REFERENCES Equipe (ID)  NOT DEFERRABLE INITIALLY IMMEDIATE;

-- Reference: Partida_Equipe_2 (table: Partida)
ALTER TABLE Partida ADD CONSTRAINT Partida_Equipe_2 FOREIGN KEY (Equipe_2) REFERENCES Equipe (ID)  NOT DEFERRABLE INITIALLY IMMEDIATE;

-- Reference: Partida_Participacao (table: Participacao)
ALTER TABLE Participacao ADD CONSTRAINT Partida_Participacao FOREIGN KEY (Partida_ID) REFERENCES Partida (ID)  NOT DEFERRABLE INITIALLY IMMEDIATE;

--inserts


--Equipe 1
INSERT INTO Equipe (ID,Nome) VALUES (1,'Lanches');

INSERT INTO Jogador (ID,Nome,Data_De_Nascimento,Numero_Camisa,Equipe_ID)
VALUES
  (1,'Brett','2013-11-04',9,1),
  (2,'Vance','2002-09-19',25,1),
  (3,'Wade','2005-08-19',27,1),
  (4,'Leonard','2002-03-01',10,1),
  (5,'Deacon','2011-03-05',18,1),
  (6,'Abel','2008-11-13',24,1),
  (7,'Jarrod','2007-10-09',20,1),
  (8,'Jelani','2010-11-15',24,1),
  (9,'Dustin','2008-12-10',24,1),
  (10,'Michael','2004-04-04',16,1),
  (11,'Ronan','2003-12-27',30,1),
  (12,'Maxwell','2007-08-20',8,1),
  (13,'Ian','2009-03-11',10,1);

--Equipe 2
INSERT INTO Equipe (ID,Nome) VALUES (2,'Carnauba');

INSERT INTO Jogador (ID,Nome,Data_De_Nascimento,Numero_Camisa,Equipe_ID)
VALUES
  (14,'Merrill','2009-01-30',14,2),
  (15,'Colin','2012-07-31',4,2),
  (16,'Gage','2006-09-02',26,2),
  (17,'Lewis','2010-08-18',13,2),
  (18,'Vladimir','2006-03-05',3,2),
  (19,'Chester','2012-07-15',12,2),
  (20,'Porter','2002-03-16',14,2),
  (21,'Hashim','2006-08-09',28,2),
  (22,'Forrest','2004-06-16',11,2),
  (23,'Micah','2004-07-26',6,2),
  (24,'Acton','2007-07-07',17,2),
  (25,'Howard','2004-07-08',5,2),
  (26,'Brady','2009-12-14',3,2);

--Equipe 3
INSERT INTO Equipe (ID,Nome) VALUES (3,'Galdino');

INSERT INTO Jogador (ID,Nome,Data_De_Nascimento,Numero_Camisa,Equipe_ID)
VALUES
  (27,'Merrill','2008-10-17',27,3),
  (28,'Samson','2002-03-11',15,3),
  (29,'Hunter','2004-08-31',23,3),
  (30,'Omar','2009-12-29',3,3),
  (31,'Dominic','2004-04-28',8,3),
  (32,'Melvin','2002-06-20',26,3),
  (33,'Jasper','2003-12-30',10,3),
  (34,'Tad','2007-03-11',8,3),
  (35,'Keaton','2012-04-12',24,3),
  (36,'Kenyon','2010-07-29',13,3),
  (37,'Yardley','2002-08-15',16,3),
  (38,'Declan','2010-12-19',4,3),
  (39,'Timon','2006-06-19',13,3);

--Equipe 4
INSERT INTO Equipe (ID,Nome) VALUES (4,'Oliveiras');

INSERT INTO Jogador (ID,Nome,Data_De_Nascimento,Numero_Camisa,Equipe_ID)
VALUES
  (40,'Lionel','2008-01-10',12,4),
  (41,'Nero','2011-05-17',15,4),
  (42,'Timothy','2003-01-31',28,4),
  (43,'Barry','2008-08-27',20,4),
  (44,'Randall','2008-04-11',6,4),
  (45,'Chaney','2010-12-31',12,4),
  (46,'Henry','2006-02-19',23,4),
  (47,'Len','2012-01-05',19,4),
  (48,'Quinlan','2004-05-16',28,4),
  (49,'Kamal','2006-01-02',6,4),
  (50,'Fulton','2007-04-14',0,4),
  (51,'Zachery','2003-10-07',19,4),
  (52,'Cedric','2008-07-14',9,4);

--Partida
INSERT INTO Partida (ID,Data_Hora,Equipe_1,Equipe_2)
VALUES
  (1,'2022-04-17 15:00:00',1,2),
  (2,'2022-04-02 18:30:00',3,4),
  (3,'2022-06-17 15:00:00',1,4),
  (4,'2022-06-02 18:30:00',2,3),
  (5,'2022-08-17 15:00:00',1,3),
  (6,'2022-08-02 18:30:00',2,4);

--Participação Partida 1
--Equipe 1
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (1,3,0,0,'Goleiro',1,0),
  (1,13,1,0,'Lateral',0,0),
  (1,5,0,1,'Zagueiro',0,0),
  (1,6,1,0,'Zagueiro',1,0),
  (1,2,0,0,'Lateral',0,0),
  (1,8,2,0,'Meio_Campista',0,0),
  (1,10,1,0,'Meio_Campista',0,0),
  (1,12,0,2,'Meio_Campista',1,0),
  (1,1,1,0,'Ponta',0,0),
  (1,4,0,3,'Atacante',0,0),
  (1,9,0,0,'Ponta',1,0);

--Equipe 2
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (1,20,0,0,'Goleiro',0,0),
  (1,25,0,0,'Lateral',0,0),
  (1,18,0,0,'Zagueiro',1,0),
  (1,14,0,0,'Zagueiro',0,0),
  (1,17,0,0,'Zagueiro',1,0),
  (1,15,2,0,'Lateral',0,0),
  (1,23,1,0,'Meio_Campista',0,0),
  (1,24,1,0,'Meio_Campista',0,0),
  (1,16,0,2,'Ponta',0,0),
  (1,21,0,2,'Atacante',0,0),
  (1,26,0,0,'Ponta',0,0);

--Participação Partida 2
--Equipe 3
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (2,31,0,0,'Goleiro',0,0),
  (2,27,0,0,'Lateral',0,0),
  (2,38,0,1,'Zagueiro',0,1),
  (2,30,0,0,'Zagueiro',0,0),
  (2,33,0,0,'Lateral',0,0),
  (2,29,0,0,'Meio_Campista',0,0),
  (2,32,2,0,'Meio_Campista',0,0),
  (2,28,0,0,'Ponta',0,0),
  (2,34,0,2,'Atacante',0,0),
  (2,36,0,0,'Atacante',0,0),
  (2,35,1,0,'Ponta',0,0);

--Equipe 4
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (2,41,0,0,'Goleiro',0,0),
  (2,44,0,0,'Lateral',0,0),
  (2,46,0,0,'Zagueiro',0,0),
  (2,52,0,0,'Zagueiro',1,0),
  (2,45,0,0,'Lateral',0,0),
  (2,40,0,0,'Meio_Campista',0,0),
  (2,42,0,0,'Meio_Campista',0,0),
  (2,47,0,0,'Meio_Campista',0,0),
  (2,49,0,0,'Ponta',0,0),
  (2,43,0,0,'Atacante',1,0),
  (2,51,0,0,'Ponta',0,0);

--Participação Partida 3
--Equipe 1
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (3,3,0,0,'Goleiro',0,0),
  (3,13,0,0,'Lateral',0,0),
  (3,5,1,0,'Zagueiro',0,0),
  (3,6,0,0,'Zagueiro',0,0),
  (3,2,0,0,'Lateral',0,0),
  (3,8,1,0,'Meio_Campista',0,0),
  (3,10,1,0,'Meio_Campista',0,0),
  (3,7,0,0,'Meio_Campista',0,0),
  (3,1,1,0,'Ponta',0,0),
  (3,4,0,3,'Atacante',0,0),
  (3,9,0,1,'Ponta',0,0);

--Equipe 4
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (3,41,0,0,'Goleiro',0,0),
  (3,44,1,0,'Lateral',1,0),
  (3,46,0,0,'Zagueiro',0,0),
  (3,52,0,0,'Zagueiro',1,0),
  (3,45,0,0,'Lateral',0,0),
  (3,40,0,0,'Meio_Campista',0,0),
  (3,42,1,0,'Meio_Campista',1,0),
  (3,47,1,0,'Meio_Campista',0,0),
  (3,49,0,0,'Ponta',0,0),
  (3,43,0,3,'Atacante',0,0),
  (3,51,0,0,'Ponta',0,0);

--Participação Partida 4
--Equipe 2
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (4,20,0,0,'Goleiro',0,0),
  (4,25,0,0,'Lateral',0,0),
  (4,18,0,0,'Zagueiro',0,0),
  (4,14,0,0,'Zagueiro',1,0),
  (4,17,0,0,'Zagueiro',0,0),
  (4,15,0,0,'Lateral',0,0),
  (4,22,0,0,'Meio_Campista',0,0),
  (4,24,0,0,'Meio_Campista',0,0),
  (4,19,0,0,'Ponta',0,0),
  (4,21,0,0,'Atacante',0,0),
  (4,26,0,0,'Ponta',0,0);

--Equipe 3
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (4,31,0,0,'Goleiro',0,0),
  (4,37,0,0,'Lateral',0,0),
  (4,38,0,0,'Zagueiro',0,0),
  (4,30,1,0,'Zagueiro',0,0),
  (4,33,0,0,'Lateral',0,0),
  (4,39,1,0,'Meio_Campista',0,0),
  (4,32,0,0,'Meio_Campista',1,0),
  (4,28,0,0,'Ponta',0,0),
  (4,34,0,0,'Atacante',0,0),
  (4,36,0,2,'Atacante',0,1),
  (4,35,0,0,'Ponta',0,0);

--Participação Partida 5
--Equipe 1
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (5,3,0,0,'Goleiro',0,0),
  (5,13,1,0,'Lateral',1,0),
  (5,5,0,0,'Zagueiro',0,0),
  (5,6,0,0,'Zagueiro',0,0),
  (5,2,1,0,'Lateral',0,0),
  (5,8,0,3,'Meio_Campista',1,0),
  (5,10,0,0,'Meio_Campista',1,0),
  (5,12,2,0,'Meio_Campista',0,0),
  (5,11,0,0,'Ponta',0,0),
  (5,4,1,2,'Atacante',1,0),
  (5,9,0,0,'Ponta',0,0);

--Equipe 3
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (5,31,0,0,'Goleiro',1,0),
  (5,27,1,0,'Lateral',0,0),
  (5,38,0,0,'Zagueiro',0,0),
  (5,30,0,0,'Zagueiro',0,0),
  (5,33,1,0,'Lateral',1,0),
  (5,29,0,0,'Meio_Campista',0,0),
  (5,32,0,0,'Meio_Campista',0,0),
  (5,28,0,1,'Ponta',0,1),
  (5,34,0,2,'Atacante',0,0),
  (5,36,1,0,'Atacante',0,0),
  (5,35,0,0,'Ponta',0,0);

--Participação Partida 6
--Equipe 2
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (6,20,0,0,'Goleiro',0,0),
  (6,25,0,0,'Lateral',0,0),
  (6,18,0,0,'Zagueiro',0,0),
  (6,14,0,0,'Zagueiro',1,0),
  (6,17,0,0,'Zagueiro',0,0),
  (6,15,0,0,'Lateral',0,0),
  (6,23,0,0,'Meio_Campista',0,0),
  (6,24,0,0,'Meio_Campista',1,0),
  (6,16,0,0,'Ponta',0,0),
  (6,21,0,0,'Atacante',0,0),
  (6,26,0,0,'Ponta',0,0);

--Equipe 4
INSERT INTO Participacao (Partida_ID,Jogador_ID,Assistencias,Gols,Posicao,Cartoes_Amarelos,Cartoes_Vermelhos)
VALUES
  (6,41,0,0,'Goleiro',0,0),
  (6,44,0,0,'Lateral',0,0),
  (6,46,0,0,'Zagueiro',0,0),
  (6,52,0,0,'Zagueiro',0,0),
  (6,45,0,0,'Lateral',0,0),
  (6,40,0,0,'Meio_Campista',1,0),
  (6,42,0,0,'Meio_Campista',1,0),
  (6,47,0,2,'Meio_Campista',1,0),
  (6,49,0,0,'Ponta',0,0),
  (6,43,1,0,'Atacante',0,0),
  (6,51,1,0,'Ponta',0,0);