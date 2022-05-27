--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_id_medicamento_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cpf_vendedor_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_farmacia_contratante_fkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_gerente_func_gerente_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_id_medicamento_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_endereco_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_cpf_cliente_fkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_cpf_cliente_fkey;
DROP TRIGGER teste ON public.venda;
DROP TRIGGER teste ON public.medicamento;
DROP TRIGGER teste ON public.funcionario;
DROP TRIGGER teste ON public.farmacia;
DROP TRIGGER teste ON public.entrega;
DROP TRIGGER teste ON public.endereco;
DROP TRIGGER teste ON public.cliente;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
ALTER TABLE ONLY public.medicamento DROP CONSTRAINT medicamento_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_unica_sede_excl;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_bairro_cidade_estado_key;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_pkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
ALTER TABLE public.venda ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medicamento ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.farmacia ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entrega ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.endereco ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.venda_id_seq;
DROP TABLE public.venda;
DROP SEQUENCE public.medicamento_id_seq;
DROP TABLE public.medicamento;
DROP TABLE public.funcionario;
DROP SEQUENCE public.farmacia_id_seq;
DROP TABLE public.farmacia;
DROP SEQUENCE public.entrega_id_seq;
DROP TABLE public.entrega;
DROP SEQUENCE public.endereco_id_seq;
DROP TABLE public.endereco;
DROP TABLE public.cliente;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.cliente (
    cpf character(11) NOT NULL,
    nome character varying(80) NOT NULL,
    data_nascimento date NOT NULL,
    CONSTRAINT cliente_data_nascimento_check CHECK ((date_part('year'::text, age((data_nascimento)::timestamp with time zone)) >= (18)::double precision))
);


ALTER TABLE public.cliente OWNER TO alfredovda;

--
-- Name: endereco; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.endereco (
    id integer NOT NULL,
    cpf_cliente character(11),
    tipo character varying(10) NOT NULL,
    rua character varying(100) NOT NULL,
    numero integer NOT NULL,
    bairro character varying(100) NOT NULL,
    cidade character varying(50) NOT NULL,
    estado character varying(20) NOT NULL,
    CONSTRAINT endereco_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['Residência'::character varying, 'Trabalho'::character varying, 'Outro'::character varying])::text[])))
);


ALTER TABLE public.endereco OWNER TO alfredovda;

--
-- Name: endereco_id_seq; Type: SEQUENCE; Schema: public; Owner: alfredovda
--

CREATE SEQUENCE public.endereco_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_id_seq OWNER TO alfredovda;

--
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alfredovda
--

ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;


--
-- Name: entrega; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.entrega (
    id integer NOT NULL,
    id_medicamento integer NOT NULL,
    venda_com_receita boolean NOT NULL,
    cpf_cliente character(11) NOT NULL,
    endereco integer NOT NULL
);


ALTER TABLE public.entrega OWNER TO alfredovda;

--
-- Name: entrega_id_seq; Type: SEQUENCE; Schema: public; Owner: alfredovda
--

CREATE SEQUENCE public.entrega_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entrega_id_seq OWNER TO alfredovda;

--
-- Name: entrega_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alfredovda
--

ALTER SEQUENCE public.entrega_id_seq OWNED BY public.entrega.id;


--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.farmacia (
    id integer NOT NULL,
    bairro character varying(50) NOT NULL,
    cidade character varying(50) NOT NULL,
    estado public.estados_nordeste NOT NULL,
    tipo character(1) NOT NULL,
    cpf_gerente character(11),
    funcao_gerente character varying(20),
    CONSTRAINT farmacia_funcao_gerente_check CHECK (((funcao_gerente)::text = ANY ((ARRAY['Administrador'::character varying, 'Farmacêutico'::character varying])::text[]))),
    CONSTRAINT farmacia_tipo_check CHECK (((tipo = 'S'::bpchar) OR (tipo = 'F'::bpchar)))
);


ALTER TABLE public.farmacia OWNER TO alfredovda;

--
-- Name: farmacia_id_seq; Type: SEQUENCE; Schema: public; Owner: alfredovda
--

CREATE SEQUENCE public.farmacia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacia_id_seq OWNER TO alfredovda;

--
-- Name: farmacia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alfredovda
--

ALTER SEQUENCE public.farmacia_id_seq OWNED BY public.farmacia.id;


--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    nome character varying(50) NOT NULL,
    farmacia_contratante integer,
    funcao character varying(20) NOT NULL,
    CONSTRAINT funcionario_funcao_check CHECK (((funcao)::text = ANY ((ARRAY['Farmacêutico'::character varying, 'Vendedor'::character varying, 'Entregador'::character varying, 'Caixa'::character varying, 'Administrador'::character varying])::text[])))
);


ALTER TABLE public.funcionario OWNER TO alfredovda;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    nome character varying(25) NOT NULL,
    miligrama character varying(5) NOT NULL,
    venda_com_receita boolean NOT NULL
);


ALTER TABLE public.medicamento OWNER TO alfredovda;

--
-- Name: medicamento_id_seq; Type: SEQUENCE; Schema: public; Owner: alfredovda
--

CREATE SEQUENCE public.medicamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamento_id_seq OWNER TO alfredovda;

--
-- Name: medicamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alfredovda
--

ALTER SEQUENCE public.medicamento_id_seq OWNED BY public.medicamento.id;


--
-- Name: venda; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.venda (
    id integer NOT NULL,
    cpf_vendedor character(11),
    funcao_vendedor character varying(20),
    id_medicamento integer,
    venda_com_receita boolean,
    cpf_comprador character(11),
    CONSTRAINT venda_check CHECK ((NOT ((venda_com_receita IS TRUE) AND (cpf_comprador IS NULL)))),
    CONSTRAINT venda_funcao_vendedor_check CHECK (((funcao_vendedor)::text = 'Vendedor'::text))
);


ALTER TABLE public.venda OWNER TO alfredovda;

--
-- Name: venda_id_seq; Type: SEQUENCE; Schema: public; Owner: alfredovda
--

CREATE SEQUENCE public.venda_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.venda_id_seq OWNER TO alfredovda;

--
-- Name: venda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alfredovda
--

ALTER SEQUENCE public.venda_id_seq OWNED BY public.venda.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.entrega ALTER COLUMN id SET DEFAULT nextval('public.entrega_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.farmacia ALTER COLUMN id SET DEFAULT nextval('public.farmacia_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.medicamento ALTER COLUMN id SET DEFAULT nextval('public.medicamento_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.venda ALTER COLUMN id SET DEFAULT nextval('public.venda_id_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.cliente (cpf, nome, data_nascimento) VALUES ('98765432101', 'Michel Teló', '1981-01-21');


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.endereco (id, cpf_cliente, tipo, rua, numero, bairro, cidade, estado) VALUES (1, '98765432101', 'Residência', 'rua dos bobos', 0, 'Catolé', 'Campina Grande', 'Paraíba');


--
-- Name: endereco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alfredovda
--

SELECT pg_catalog.setval('public.endereco_id_seq', 1, false);


--
-- Data for Name: entrega; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.entrega (id, id_medicamento, venda_com_receita, cpf_cliente, endereco) VALUES (1, 1, false, '98765432101', 1);


--
-- Name: entrega_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alfredovda
--

SELECT pg_catalog.setval('public.entrega_id_seq', 1, false);


--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.farmacia (id, bairro, cidade, estado, tipo, cpf_gerente, funcao_gerente) VALUES (1, 'Alto Branco', 'Campina Grande', 'Paraíba', 'S', '12345678901', 'Administrador');
INSERT INTO public.farmacia (id, bairro, cidade, estado, tipo, cpf_gerente, funcao_gerente) VALUES (2, 'Catolé', 'Campina Grande', 'Paraíba', 'F', '12345678903', 'Farmacêutico');


--
-- Name: farmacia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alfredovda
--

SELECT pg_catalog.setval('public.farmacia_id_seq', 1, false);


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.funcionario (cpf, nome, farmacia_contratante, funcao) VALUES ('12345678901', 'Chris Rock', 1, 'Administrador');
INSERT INTO public.funcionario (cpf, nome, farmacia_contratante, funcao) VALUES ('12345678902', 'Tonya Rock', 1, 'Vendedor');
INSERT INTO public.funcionario (cpf, nome, farmacia_contratante, funcao) VALUES ('12345678903', 'Drew Rock', 2, 'Farmacêutico');
INSERT INTO public.funcionario (cpf, nome, farmacia_contratante, funcao) VALUES ('12345678904', 'Julius Rock', NULL, 'Entregador');
INSERT INTO public.funcionario (cpf, nome, farmacia_contratante, funcao) VALUES ('12345678905', 'Rochelle Rock', NULL, 'Caixa');
INSERT INTO public.funcionario (cpf, nome, farmacia_contratante, funcao) VALUES ('12345678906', 'Adenor Tite', NULL, 'Administrador');
INSERT INTO public.funcionario (cpf, nome, farmacia_contratante, funcao) VALUES ('12345678907', 'William Silva', NULL, 'Entregador');


--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.medicamento (id, nome, miligrama, venda_com_receita) VALUES (1, 'dipirona', '500mg', false);
INSERT INTO public.medicamento (id, nome, miligrama, venda_com_receita) VALUES (2, 'amoxilina', '500mg', true);
INSERT INTO public.medicamento (id, nome, miligrama, venda_com_receita) VALUES (3, 'Loratamed', '10mg', false);


--
-- Name: medicamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alfredovda
--

SELECT pg_catalog.setval('public.medicamento_id_seq', 1, false);


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.venda (id, cpf_vendedor, funcao_vendedor, id_medicamento, venda_com_receita, cpf_comprador) VALUES (1, '12345678902', 'Vendedor', 1, false, NULL);
INSERT INTO public.venda (id, cpf_vendedor, funcao_vendedor, id_medicamento, venda_com_receita, cpf_comprador) VALUES (2, '12345678902', 'Vendedor', 2, true, '98765432101');


--
-- Name: venda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alfredovda
--

SELECT pg_catalog.setval('public.venda_id_seq', 1, false);


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- Name: entrega_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_pkey PRIMARY KEY (id);


--
-- Name: farmacia_bairro_cidade_estado_key; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_bairro_cidade_estado_key UNIQUE (bairro, cidade, estado);


--
-- Name: farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id);


--
-- Name: farmacia_unica_sede_excl; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_unica_sede_excl EXCLUDE USING gist (tipo WITH =) WHERE ((tipo = 'S'::bpchar));


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf, funcao);


--
-- Name: medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id, venda_com_receita);


--
-- Name: venda_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.cliente FOR EACH ROW EXECUTE PROCEDURE public.cliente();


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.endereco FOR EACH ROW EXECUTE PROCEDURE public.endereco();


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.entrega FOR EACH ROW EXECUTE PROCEDURE public.entrega();


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.farmacia FOR EACH ROW EXECUTE PROCEDURE public.farmacia();


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.funcionario FOR EACH ROW EXECUTE PROCEDURE public.funcionario();


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.medicamento FOR EACH ROW EXECUTE PROCEDURE public.medicamento();


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.venda FOR EACH ROW EXECUTE PROCEDURE public.venda();


--
-- Name: endereco_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: entrega_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: entrega_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_endereco_fkey FOREIGN KEY (endereco) REFERENCES public.endereco(id);


--
-- Name: entrega_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_id_medicamento_fkey FOREIGN KEY (id_medicamento, venda_com_receita) REFERENCES public.medicamento(id, venda_com_receita);


--
-- Name: farmacia_gerente_func_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_gerente_func_gerente_fkey FOREIGN KEY (cpf_gerente, funcao_gerente) REFERENCES public.funcionario(cpf, funcao);


--
-- Name: funcionario_farmacia_contratante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_farmacia_contratante_fkey FOREIGN KEY (farmacia_contratante) REFERENCES public.farmacia(id);


--
-- Name: venda_cpf_vendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cpf_vendedor_fkey FOREIGN KEY (cpf_vendedor, funcao_vendedor) REFERENCES public.funcionario(cpf, funcao) ON DELETE RESTRICT;


--
-- Name: venda_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_medicamento_fkey FOREIGN KEY (id_medicamento, venda_com_receita) REFERENCES public.medicamento(id, venda_com_receita) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

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