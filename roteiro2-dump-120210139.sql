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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;
DROP TRIGGER teste ON public.tarefas;
DROP TRIGGER teste ON public.funcionario;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(100) NOT NULL,
    funcao character varying(11),
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcionario_check CHECK ((NOT (((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NULL)))),
    CONSTRAINT funcionario_funcao_check CHECK ((((funcao)::text = 'LIMPEZA'::text) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT funcionario_nivel_check CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar)))
);


ALTER TABLE public.funcionario OWNER TO alfredovda;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: alfredovda
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao text NOT NULL,
    func_resp_cpf character(11),
    prioridade integer NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT tarefas_chk_func_resp_cpf_valida CHECK (((NOT ((func_resp_cpf IS NULL) AND (status = 'C'::bpchar))) AND (NOT ((func_resp_cpf IS NULL) AND (status = 'E'::bpchar))))),
    CONSTRAINT tarefas_chk_func_resp_cpf_valido CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT tarefas_chk_prioridade_valido CHECK ((prioridade < 32768)),
    CONSTRAINT tarefas_chk_status_valido CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar)))
);


ALTER TABLE public.tarefas OWNER TO alfredovda;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1999-03-09', 'Clara da Silva', 'LIMPEZA', 'P', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '2000-04-10', 'Lucas Pereira', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '2001-05-11', 'Cleber Melo', 'LIMPEZA', 'S', '12345678914');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '2000-07-12', 'Vinicius Junior', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1985-02-05', 'Cristiano Ronaldo', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '2001-04-10', 'Andreas Pereira', 'LIMPEZA', 'J', '12345678916');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1990-04-10', 'Ednaldo Pereira', 'LIMPEZA', 'P', '12345678914');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678920', '1987-06-24', 'Lionel Messi', 'LIMPEZA', 'S', '12345678917');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '2002-06-07', 'Julius Rock', 'LIMPEZA', 'J', '12345678917');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '1995-10-10', 'José Lima', 'LIMPEZA', 'J', '12345678916');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911', '2004-02-05', 'Lucio Silva', 'LIMPEZA', 'J', '12345678916');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '2004-02-05', 'Lavinia Pedrosa', 'LIMPEZA', 'J', '12345678916');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232956', '2004-02-05', 'Caio Rios', 'LIMPEZA', 'J', '12345678916');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: alfredovda
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483651, 'limpar portas do 1o andar', '32323232911', 5, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483652, 'limpar portas do 2o andar', '32323232911', 5, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483659, 'limpar portas do 5o andar', '32323232956', 2, 'E');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', NULL, 4, 'P');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.funcionario FOR EACH ROW EXECUTE PROCEDURE public.funcionario();


--
-- Name: teste; Type: TRIGGER; Schema: public; Owner: alfredovda
--

CREATE TRIGGER teste AFTER INSERT OR DELETE OR UPDATE ON public.tarefas FOR EACH ROW EXECUTE PROCEDURE public.tarefas();


--
-- Name: funcionario_superior_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alfredovda
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

