--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+1)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: animais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animais (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    especie character varying(50) NOT NULL,
    idade integer,
    peso numeric(5,2),
    habitat character varying(100),
    data_de_entrada date DEFAULT CURRENT_DATE
);


ALTER TABLE public.animais OWNER TO postgres;

--
-- Name: animais_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animais_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animais_id_seq OWNER TO postgres;

--
-- Name: animais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animais_id_seq OWNED BY public.animais.id;


--
-- Name: animais id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animais ALTER COLUMN id SET DEFAULT nextval('public.animais_id_seq'::regclass);


--
-- Data for Name: animais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animais (id, nome, especie, idade, peso, habitat, data_de_entrada) FROM stdin;
1	Simba	Leão	5	190.50	Savanas da África	2024-08-30
2	Nemo	Peixe-palhaço	2	0.15	Oceano Pacífico	2024-08-30
3	Kaa	Cobra	4	15.30	Floresta Amazônica	2024-08-30
4	Dumbo	Elefante	10	540.00	África	2024-08-30
5	Bambi	Cervo	3	80.20	Florestas da Europa	2024-08-30
6	Baloo	Urso	7	450.75	Montanhas da Índia	2024-08-30
7	Zazu	Calau	2	0.55	Savanas da África	2024-08-30
8	Manny	Mamute	25	600.00	Era do Gelo	2024-08-30
9	Timon	Suricato	3	0.75	Savanas da África	2024-08-30
10	Pumba	Javali	4	120.00	Savanas da África	2024-08-30
\.


--
-- Name: animais_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animais_id_seq', 30, true);


--
-- Name: animais animais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animais
    ADD CONSTRAINT animais_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

