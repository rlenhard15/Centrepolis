--
-- PostgreSQL database dump
--

-- Dumped from database version 12.7 (Ubuntu 12.7-1.pgdg16.04+1)
-- Dumped by pg_dump version 12.1

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
-- Name: accelerators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."accelerators" (
    "id" bigint NOT NULL,
    "name" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "hostname" character varying
);


--
-- Name: accelerators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."accelerators_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accelerators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."accelerators_id_seq" OWNED BY "public"."accelerators"."id";


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."ar_internal_metadata" (
    "key" character varying NOT NULL,
    "value" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


--
-- Name: assessment_progresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."assessment_progresses" (
    "id" bigint NOT NULL,
    "customer_id" integer,
    "assessment_id" integer,
    "risk_value" numeric,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


--
-- Name: assessment_progresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."assessment_progresses_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_progresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."assessment_progresses_id_seq" OWNED BY "public"."assessment_progresses"."id";


--
-- Name: assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."assessments" (
    "id" bigint NOT NULL,
    "name" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


--
-- Name: assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."assessments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."assessments_id_seq" OWNED BY "public"."assessments"."id";


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."categories" (
    "id" bigint NOT NULL,
    "title" character varying,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "assessment_id" integer
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."categories_id_seq" OWNED BY "public"."categories"."id";


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."notifications" (
    "id" bigint NOT NULL,
    "task_id" integer,
    "customer_id" integer,
    "read" boolean DEFAULT false,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."notifications_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."notifications_id_seq" OWNED BY "public"."notifications"."id";


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."schema_migrations" (
    "version" character varying NOT NULL
);


--
-- Name: stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."stages" (
    "id" bigint NOT NULL,
    "title" character varying,
    "sub_category_id" integer,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "position" integer
);


--
-- Name: stages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."stages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."stages_id_seq" OWNED BY "public"."stages"."id";


--
-- Name: sub_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sub_categories" (
    "id" bigint NOT NULL,
    "title" character varying,
    "category_id" integer,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


--
-- Name: sub_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sub_categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sub_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sub_categories_id_seq" OWNED BY "public"."sub_categories"."id";


--
-- Name: sub_category_progresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sub_category_progresses" (
    "id" bigint NOT NULL,
    "customer_id" bigint,
    "sub_category_id" bigint,
    "current_stage_id" bigint NOT NULL,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL
);


--
-- Name: sub_category_progresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sub_category_progresses_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sub_category_progresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sub_category_progresses_id_seq" OWNED BY "public"."sub_category_progresses"."id";


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."tasks" (
    "id" bigint NOT NULL,
    "title" character varying,
    "stage_id" integer,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "user_id" integer,
    "status" integer DEFAULT 0,
    "created_by" integer,
    "priority" integer,
    "due_date" timestamp without time zone
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."tasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."tasks_id_seq" OWNED BY "public"."tasks"."id";


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."users" (
    "id" bigint NOT NULL,
    "email" character varying DEFAULT ''::character varying NOT NULL,
    "encrypted_password" character varying DEFAULT ''::character varying NOT NULL,
    "reset_password_token" character varying,
    "reset_password_sent_at" timestamp without time zone,
    "remember_created_at" timestamp without time zone,
    "created_at" timestamp(6) without time zone NOT NULL,
    "updated_at" timestamp(6) without time zone NOT NULL,
    "first_name" character varying,
    "last_name" character varying,
    "company_name" character varying,
    "type" character varying,
    "created_by" integer,
    "accelerator_id" integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";


--
-- Name: accelerators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."accelerators" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."accelerators_id_seq"'::"regclass");


--
-- Name: assessment_progresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."assessment_progresses" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."assessment_progresses_id_seq"'::"regclass");


--
-- Name: assessments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."assessments" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."assessments_id_seq"'::"regclass");


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."categories_id_seq"'::"regclass");


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notifications" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."notifications_id_seq"'::"regclass");


--
-- Name: stages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."stages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stages_id_seq"'::"regclass");


--
-- Name: sub_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sub_categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sub_categories_id_seq"'::"regclass");


--
-- Name: sub_category_progresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sub_category_progresses" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sub_category_progresses_id_seq"'::"regclass");


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tasks" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tasks_id_seq"'::"regclass");


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_id_seq"'::"regclass");


--
-- Data for Name: accelerators; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."accelerators" ("id", "name", "created_at", "updated_at", "hostname") FROM stdin;
1	Centeropolis	2020-07-28 14:26:24.102434	2020-07-28 14:26:24.102434	CENTEROPOLIS_HOST
2	LeanRocketLab	2020-07-28 14:26:24.115402	2020-07-28 14:26:24.115402	LEANROCKETLAB_HOST
3	FuzeHub	2020-07-28 14:26:24.124487	2020-07-28 14:26:24.124487	FUZEHUB_HOST
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."ar_internal_metadata" ("key", "value", "created_at", "updated_at") FROM stdin;
environment	production	2020-04-07 13:33:37.062187	2020-04-07 13:33:37.062187
\.


--
-- Data for Name: assessment_progresses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."assessment_progresses" ("id", "customer_id", "assessment_id", "risk_value", "created_at", "updated_at") FROM stdin;
6	15	1	97.843137254902	2020-04-09 11:03:16.075738	2020-04-10 11:13:26.677521
41	110	1	2.94117647058824	2020-12-02 18:48:10.492549	2020-12-02 18:48:10.558703
35	104	2	57.1794871794872	2020-09-10 11:04:15.095839	2020-09-10 11:07:00.569008
11	30	1	77.4229691876751	2020-04-29 16:59:34.802	2020-05-05 17:51:34.56394
36	104	3	33.3333333333333	2020-09-10 11:07:28.155413	2020-09-10 11:07:28.169473
23	73	2	35.3846153846154	2020-06-22 17:43:14.346122	2021-02-15 14:21:15.003342
37	106	3	88.8888888888889	2020-09-10 22:25:46.38789	2020-09-10 22:26:05.99347
13	8	3	16.6666666666667	2020-05-15 11:06:56.415856	2020-05-15 11:06:56.51175
14	4	3	12.962962962963	2020-05-15 11:06:56.626163	2020-05-15 11:06:56.700026
3	9	1	18.2352941176471	2020-04-08 14:53:32.089662	2020-04-08 14:54:13.100207
28	97	1	71.4005602240896	2020-08-14 15:38:55.641933	2021-06-09 17:50:27.172827
5	12	1	38.7394957983193	2020-04-08 22:41:01.75503	2020-04-08 22:41:48.588395
22	73	1	54.4257703081233	2020-06-22 13:00:01.205975	2021-08-13 18:44:27.454006
51	73	3	33.3333333333333	2021-08-13 18:44:57.335254	2021-08-13 18:44:57.360463
50	164	3	77.7777777777778	2021-05-04 18:40:15.620281	2021-05-04 18:40:15.692383
48	164	2	97.4358974358974	2021-05-04 18:21:59.438005	2021-05-04 18:53:00.321675
2	8	1	100.0	2020-04-08 07:11:03.267244	2020-05-29 09:40:28.724107
33	103	1	79.859943977591	2020-09-03 10:54:09.048251	2020-09-03 11:15:59.366306
12	8	2	20.5882352941176	2020-05-15 11:06:23.798949	2020-06-03 16:29:48.30813
17	47	2	2.94117647058824	2020-06-04 17:55:54.240528	2020-06-04 17:55:54.270063
1	4	1	62.0448179271709	2020-04-07 18:45:44.876212	2020-04-10 16:09:11.450117
30	97	3	44.4444444444444	2020-08-14 15:48:30.050432	2021-05-07 17:05:24.810583
42	115	1	68.0672268907563	2020-12-03 13:31:32.397489	2020-12-03 13:37:36.19988
32	103	2	62.3076923076923	2020-09-03 10:12:00.974642	2020-09-03 11:20:35.488348
29	97	2	83.921568627451	2020-08-14 15:44:42.896337	2020-08-14 15:48:09.069624
49	164	1	20.8403361344538	2021-05-04 18:32:12.608557	2021-05-24 20:07:44.623491
18	52	2	78.0392156862745	2020-06-08 22:56:52.021717	2020-06-08 22:57:26.833756
19	47	1	3.92156862745098	2020-06-09 17:21:12.63895	2020-06-09 17:21:12.671336
38	106	1	22.7731092436975	2020-10-22 15:26:31.433116	2020-10-22 15:52:39.986213
20	54	1	22.3809523809524	2020-06-10 19:43:20.647889	2020-06-10 19:43:36.226367
47	162	1	13.1932773109244	2021-03-23 13:16:12.610747	2021-04-19 09:42:37.642266
31	103	3	77.7777777777778	2020-09-03 10:03:18.415778	2020-09-03 10:03:45.146059
43	115	2	54.8717948717949	2020-12-03 13:38:27.479068	2020-12-03 13:40:31.515618
44	115	3	44.4444444444444	2020-12-03 13:40:44.819247	2020-12-03 13:40:44.864912
26	89	1	2.35294117647059	2020-07-29 14:59:43.055163	2020-07-29 14:59:43.132288
34	104	1	77.6750700280112	2020-09-10 10:58:51.043336	2020-09-10 11:03:35.881454
21	64	1	14.8179271708683	2020-06-18 13:37:59.618635	2020-11-10 17:08:58.382626
39	105	1	1.68067226890756	2020-11-16 15:45:14.956352	2020-11-16 15:45:14.997532
40	105	2	2.56410256410256	2020-11-16 15:45:33.914086	2020-11-16 15:45:33.945145
45	112	2	23.3333333333333	2020-12-10 19:26:46.762325	2020-12-10 19:27:00.582963
46	112	1	54.6778711484594	2020-12-10 19:36:04.75076	2020-12-10 19:36:28.346991
\.


--
-- Data for Name: assessments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."assessments" ("id", "name", "created_at", "updated_at") FROM stdin;
1	CRL (Commercial Readiness Level)	2020-04-07 13:34:03.07311	2020-04-07 13:34:03.07311
2	MRL	2020-05-15 11:05:50.123204	2020-05-15 11:05:50.123204
3	TRL	2020-05-15 11:05:51.441782	2020-05-15 11:05:51.441782
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."categories" ("id", "title", "created_at", "updated_at", "assessment_id") FROM stdin;
1	IP Risk	2020-04-07 13:34:03.141931	2020-04-07 13:34:03.141931	1
2	Market Risk	2020-04-07 13:34:03.716282	2020-04-07 13:34:03.716282	1
3	Finance Risk	2020-04-07 13:34:04.037241	2020-04-07 13:34:04.037241	1
4	Management Team Risk	2020-04-07 13:34:04.373125	2020-04-07 13:34:04.373125	1
5	Product Design Risk	2020-05-15 11:05:50.136807	2020-05-15 11:05:50.136807	2
7	Manufacturing Risk	2020-05-15 11:05:50.783988	2020-05-15 11:05:50.783988	2
8	Supply Chain Risk	2020-05-15 11:05:51.075797	2020-05-15 11:05:51.075797	2
9	Technology Risk	2020-05-15 11:05:51.460206	2020-05-15 11:05:51.460206	3
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."notifications" ("id", "task_id", "customer_id", "read", "created_at", "updated_at") FROM stdin;
20	20	103	f	2020-11-16 16:20:23.885471	2020-11-16 16:20:23.885471
21	21	73	f	2021-02-15 14:20:00.710245	2021-02-15 14:20:00.710245
22	22	73	f	2021-02-15 14:20:52.728714	2021-02-15 14:20:52.728714
55	55	158	f	2021-03-22 18:14:04.588769	2021-03-22 18:14:04.588769
56	56	162	f	2021-03-23 13:00:18.581364	2021-03-23 13:00:18.581364
3	3	30	t	2020-04-29 16:59:51.941517	2020-04-29 16:59:51.941517
4	4	30	t	2020-04-29 17:00:04.99766	2020-04-29 17:00:04.99766
5	5	30	t	2020-04-29 17:01:15.749694	2020-04-29 17:01:15.749694
6	6	30	f	2020-04-29 17:06:56.469286	2020-04-29 17:06:56.469286
7	7	30	f	2020-04-29 17:09:10.30797	2020-04-29 17:09:10.30797
8	8	30	f	2020-04-30 10:41:36.097653	2020-04-30 10:41:36.097653
9	9	30	f	2020-04-30 17:33:28.592346	2020-04-30 17:33:28.592346
57	57	162	f	2021-04-09 13:02:00.356111	2021-04-09 13:02:00.356111
58	58	162	f	2021-04-09 13:02:13.333847	2021-04-09 13:02:13.333847
59	59	162	f	2021-04-19 10:13:26.570673	2021-04-19 10:13:26.570673
10	10	28	t	2020-04-30 17:35:56.056333	2020-04-30 17:35:56.056333
11	11	28	t	2020-05-01 16:41:19.853277	2020-05-01 16:41:19.853277
12	12	28	t	2020-05-01 16:44:25.232934	2020-05-01 16:44:25.232934
13	13	28	t	2020-05-01 16:58:29.225675	2020-05-01 16:58:29.225675
14	14	28	t	2020-05-01 17:17:05.196982	2020-05-01 17:17:05.196982
15	15	30	f	2020-05-05 17:58:36.471803	2020-05-05 17:58:36.471803
1	1	8	t	2020-04-29 16:53:11.178715	2020-04-29 16:53:11.178715
2	2	8	t	2020-04-29 16:55:02.579907	2020-04-29 16:55:02.579907
16	16	8	t	2020-05-15 11:07:14.864003	2020-05-15 11:07:14.864003
17	17	8	t	2020-05-29 09:35:57.125206	2020-05-29 09:35:57.125206
18	18	52	f	2020-06-09 17:23:00.997498	2020-06-09 17:23:00.997498
19	19	91	f	2020-07-29 19:18:12.464168	2020-07-29 19:18:12.464168
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."schema_migrations" ("version") FROM stdin;
20200218160236
20200218162011
20200219114421
20200219124302
20200219164309
20200220093211
20200220125533
20200221141330
20200221142849
20200316120946
20200316140812
20200317132450
20200325095512
20200325132038
20200326160353
20200402140557
20200415181255
20200416165335
20200424131734
20200702132341
20200703132949
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."stages" ("id", "title", "sub_category_id", "created_at", "updated_at", "position") FROM stdin;
1	Idea only	1	2020-04-07 13:34:03.268905	2020-04-07 13:34:03.268905	1
2	Basic tests showing potential	1	2020-04-07 13:34:03.310201	2020-04-07 13:34:03.310201	2
3	Prototype developed	1	2020-04-07 13:34:03.324799	2020-04-07 13:34:03.324799	3
4	Beta testing	1	2020-04-07 13:34:03.332899	2020-04-07 13:34:03.332899	4
5	Fully functional prototypes with customers	1	2020-04-07 13:34:03.344512	2020-04-07 13:34:03.344512	5
6	Sales to paying customers	1	2020-04-07 13:34:03.356957	2020-04-07 13:34:03.356957	6
7	Unknown\tLittle or no value	2	2020-04-07 13:34:03.37242	2020-04-07 13:34:03.37242	1
8	Limited advantage and difficult to defend	2	2020-04-07 13:34:03.398476	2020-04-07 13:34:03.398476	2
9	Proprietary know how/trade secrets	2	2020-04-07 13:34:03.420538	2020-04-07 13:34:03.420538	3
10	Some valuable and defensible IP	2	2020-04-07 13:34:03.434628	2020-04-07 13:34:03.434628	4
11	Significant and highly defensible IP	2	2020-04-07 13:34:03.449038	2020-04-07 13:34:03.449038	5
12	Fully outsourced	3	2020-04-07 13:34:03.490022	2020-04-07 13:34:03.490022	1
13	Partially outsourced with no development agreement in place	3	2020-04-07 13:34:03.510004	2020-04-07 13:34:03.510004	2
14	Partially outsourced with development agreements in place	3	2020-04-07 13:34:03.534072	2020-04-07 13:34:03.534072	3
15	Partially outsourced arrangements with strong development partners	3	2020-04-07 13:34:03.543077	2020-04-07 13:34:03.543077	4
16	Developed mostly in-house with some contracts with development partners	3	2020-04-07 13:34:03.561025	2020-04-07 13:34:03.561025	5
17	Developed fully in-house	3	2020-04-07 13:34:03.574594	2020-04-07 13:34:03.574594	6
18	Significant direct, indirect, and potential competing technologies	4	2020-04-07 13:34:03.613989	2020-04-07 13:34:03.613989	1
19	Limited direct and significant	4	2020-04-07 13:34:03.622261	2020-04-07 13:34:03.622261	2
20	Indirect competing technologies	4	2020-04-07 13:34:03.631198	2020-04-07 13:34:03.631198	3
21	Limited direct, but strong potential competitive technologies	4	2020-04-07 13:34:03.640134	2020-04-07 13:34:03.640134	4
22	Limited direct and indirect competing technologies	4	2020-04-07 13:34:03.650168	2020-04-07 13:34:03.650168	5
23	No direct and limited indirect competing technologies	4	2020-04-07 13:34:03.660394	2020-04-07 13:34:03.660394	6
24	No competing technologies	4	2020-04-07 13:34:03.700812	2020-04-07 13:34:03.700812	7
25	Unknown	5	2020-04-07 13:34:03.734994	2020-04-07 13:34:03.734994	1
26	Unclear or low	5	2020-04-07 13:34:03.744323	2020-04-07 13:34:03.744323	2
27	Recognizable but low value	5	2020-04-07 13:34:03.752094	2020-04-07 13:34:03.752094	3
28	Value clear but not quantifiable	5	2020-04-07 13:34:03.761529	2020-04-07 13:34:03.761529	4
29	Value clear, somewhat moderate	5	2020-04-07 13:34:03.768747	2020-04-07 13:34:03.768747	5
30	Clear, quantifiable, high ROI	5	2020-04-07 13:34:03.777296	2020-04-07 13:34:03.777296	6
31	No Market	6	2020-04-07 13:34:03.798252	2020-04-07 13:34:03.798252	1
32	Stagnating or diminishing market	6	2020-04-07 13:34:03.808301	2020-04-07 13:34:03.808301	2
33	Very small market	6	2020-04-07 13:34:03.81824	2020-04-07 13:34:03.81824	3
34	Small market	6	2020-04-07 13:34:03.826214	2020-04-07 13:34:03.826214	4
35	Moderate growing market	6	2020-04-07 13:34:03.833206	2020-04-07 13:34:03.833206	5
36	Large growing market	6	2020-04-07 13:34:03.84215	2020-04-07 13:34:03.84215	6
37	Target group not defined	7	2020-04-07 13:34:03.865483	2020-04-07 13:34:03.865483	1
38	Target group vaguely or too broadly defined	7	2020-04-07 13:34:03.875925	2020-04-07 13:34:03.875925	2
39	Target group defined but difficult to recognize or approach	7	2020-04-07 13:34:03.882783	2020-04-07 13:34:03.882783	3
40	Target group defined but no market segmentation	7	2020-04-07 13:34:03.89003	2020-04-07 13:34:03.89003	4
41	Target group defined and market segmented	7	2020-04-07 13:34:03.898337	2020-04-07 13:34:03.898337	5
42	Strong addressable market segmentation with target group very well defined	7	2020-04-07 13:34:03.906077	2020-04-07 13:34:03.906077	6
43	No Strategy	8	2020-04-07 13:34:03.926444	2020-04-07 13:34:03.926444	1
44	Tactical ideas but holistic strategy unclear	8	2020-04-07 13:34:03.938569	2020-04-07 13:34:03.938569	2
45	Outline / strategy identifiable but clear gaps exist	8	2020-04-07 13:34:03.945235	2020-04-07 13:34:03.945235	3
46	Strategy clearly recognizable with only modest gaps	8	2020-04-07 13:34:03.957026	2020-04-07 13:34:03.957026	4
47	Generally clear, consistent and complete strategy	8	2020-04-07 13:34:03.963724	2020-04-07 13:34:03.963724	5
48	Very convincing and promising strategy	8	2020-04-07 13:34:03.970395	2020-04-07 13:34:03.970395	6
49	Not addressed	9	2020-04-07 13:34:03.988625	2020-04-07 13:34:03.988625	1
50	Identified with little diligence or assessment	9	2020-04-07 13:34:03.99803	2020-04-07 13:34:03.99803	2
51	Significant & active competition	9	2020-04-07 13:34:04.006106	2020-04-07 13:34:04.006106	3
52	Moderate competition active or expected	9	2020-04-07 13:34:04.012539	2020-04-07 13:34:04.012539	4
53	Weak competition active or expected; limited entry barriers	9	2020-04-07 13:34:04.019241	2020-04-07 13:34:04.019241	5
54	Weak competition active or expected with significant entry barriers	9	2020-04-07 13:34:04.027527	2020-04-07 13:34:04.027527	6
55	Not addressed	10	2020-04-07 13:34:04.052396	2020-04-07 13:34:04.052396	1
56	Addressed but unclear or poorly defined	10	2020-04-07 13:34:04.068444	2020-04-07 13:34:04.068444	2
57	Defined revenue model but unrealistic	10	2020-04-07 13:34:04.076613	2020-04-07 13:34:04.076613	3
58	Realistic revenue model	10	2020-04-07 13:34:04.08739	2020-04-07 13:34:04.08739	4
59	Clearly defined model with limited sources of revenue	10	2020-04-07 13:34:04.100334	2020-04-07 13:34:04.100334	5
60	Clearly defined model with multiple sources of revenue	10	2020-04-07 13:34:04.108201	2020-04-07 13:34:04.108201	6
61	Critical Assumptions not present	11	2020-04-07 13:34:04.123921	2020-04-07 13:34:04.123921	1
62	Planning based on unrealistic assumptions	11	2020-04-07 13:34:04.131063	2020-04-07 13:34:04.131063	2
63	Planning based on somewhat unrealistic assumptions	11	2020-04-07 13:34:04.145786	2020-04-07 13:34:04.145786	3
64	Realistic assumptions but revenue potential only moderately attractive	11	2020-04-07 13:34:04.154542	2020-04-07 13:34:04.154542	4
65	Realistic assumptions with attractive revenue potential	11	2020-04-07 13:34:04.165263	2020-04-07 13:34:04.165263	5
66	Realistic assumptions with highly attractive revenue potential	11	2020-04-07 13:34:04.193932	2020-04-07 13:34:04.193932	6
67	Operating at a loss, burn rate exceeds break-even requirements and less than 6 months of cash is on hand	12	2020-04-07 13:34:04.211313	2020-04-07 13:34:04.211313	1
68	Operating at a loss, burn rate exceeds break-even requirements but greater than 6 months of cash is on hand	12	2020-04-07 13:34:04.226569	2020-04-07 13:34:04.226569	2
69	Operating at a loss but burn rate is consistent with forecasting for break-even	12	2020-04-07 13:34:04.235931	2020-04-07 13:34:04.235931	3
70	Generally achieving break-even cashflow but not positive cashflow from operations	12	2020-04-07 13:34:04.247954	2020-04-07 13:34:04.247954	4
71	Generating minimal positive cashflow from operations	12	2020-04-07 13:34:04.255897	2020-04-07 13:34:04.255897	5
72	Generating strong, positive cashflow from operations	12	2020-04-07 13:34:04.264949	2020-04-07 13:34:04.264949	6
73	Undefined\tCapital requirements and timing / milestones not validated	13	2020-04-07 13:34:04.295626	2020-04-07 13:34:04.295626	1
74	Timing / milestones acceptable, but capital requirements not validated	13	2020-04-07 13:34:04.30633	2020-04-07 13:34:04.30633	2
75	Capital requirements acceptable, but timing / milestones not validated	13	2020-04-07 13:34:04.32144	2020-04-07 13:34:04.32144	3
76	Capital requirements and timing / milestones validated and realistic	13	2020-04-07 13:34:04.341516	2020-04-07 13:34:04.341516	4
77	Capital requirements and timing / milestones very attractive	13	2020-04-07 13:34:04.36132	2020-04-07 13:34:04.36132	5
78	No notable experience	14	2020-04-07 13:34:04.391197	2020-04-07 13:34:04.391197	1
79	Technology or domain experience only	14	2020-04-07 13:34:04.397633	2020-04-07 13:34:04.397633	2
80	Technology / domain expert along with sales / marketing expertise	14	2020-04-07 13:34:04.403863	2020-04-07 13:34:04.403863	3
81	Team with notable experience, but gaps exists	14	2020-04-07 13:34:04.41159	2020-04-07 13:34:04.41159	4
82	Solid team with notable experience	14	2020-04-07 13:34:04.423311	2020-04-07 13:34:04.423311	5
83	Very strong team with notable experience and prior successful startups	14	2020-04-07 13:34:04.437472	2020-04-07 13:34:04.437472	6
84	Unknown	15	2020-04-07 13:34:04.464629	2020-04-07 13:34:04.464629	1
85	Alliance partners identified	15	2020-04-07 13:34:04.486359	2020-04-07 13:34:04.486359	2
86	Talks with potential partners commenced	15	2020-04-07 13:34:04.495285	2020-04-07 13:34:04.495285	3
87	Negotiations with all necessary partners commenced	15	2020-04-07 13:34:04.507353	2020-04-07 13:34:04.507353	4
88	Some alliances with partners closed but others still outstanding	15	2020-04-07 13:34:04.523361	2020-04-07 13:34:04.523361	5
89	All necessary alliances closed with A-List partners	15	2020-04-07 13:34:04.545265	2020-04-07 13:34:04.545265	6
90	Not addressed	16	2020-04-07 13:34:04.600715	2020-04-07 13:34:04.600715	1
91	Advisors identified	16	2020-04-07 13:34:04.624385	2020-04-07 13:34:04.624385	2
92	Some advisors approached but uncommitted	16	2020-04-07 13:34:04.634997	2020-04-07 13:34:04.634997	3
93	Some advisors committed	16	2020-04-07 13:34:04.647666	2020-04-07 13:34:04.647666	4
94	Some strong advisors committed	16	2020-04-07 13:34:04.674194	2020-04-07 13:34:04.674194	5
95	A-List technology & business advisors committed	16	2020-04-07 13:34:04.700848	2020-04-07 13:34:04.700848	6
96	Not addressed	17	2020-04-07 13:34:04.735325	2020-04-07 13:34:04.735325	1
97	Incomplete	17	2020-04-07 13:34:04.747242	2020-04-07 13:34:04.747242	2
98	Difficult to assess due to significant gaps	17	2020-04-07 13:34:04.75906	2020-04-07 13:34:04.75906	3
99	Fairly realistic but planning incomplete	17	2020-04-07 13:34:04.771773	2020-04-07 13:34:04.771773	4
100	Realistic with thorough planning	17	2020-04-07 13:34:04.804363	2020-04-07 13:34:04.804363	5
101	Highly realistic, easy to follow, thoroughly planned	17	2020-04-07 13:34:04.819781	2020-04-07 13:34:04.819781	6
102	Not identified or specified	18	2020-05-15 11:05:50.163756	2020-05-15 11:05:50.163756	1
103	Limited details on customer use designed into product	18	2020-05-15 11:05:50.179484	2020-05-15 11:05:50.179484	2
104	Detailed customer use specs designed ino product	18	2020-05-15 11:05:50.189495	2020-05-15 11:05:50.189495	3
105	Prototypes shared with limited customers for feedback	18	2020-05-15 11:05:50.199916	2020-05-15 11:05:50.199916	4
106	Prototypes shared with significant number of customers for feedback	18	2020-05-15 11:05:50.211758	2020-05-15 11:05:50.211758	5
107	Customer tested product directly for use specs to validate product design	18	2020-05-15 11:05:50.221757	2020-05-15 11:05:50.221757	6
108	Unknown	19	2020-05-15 11:05:50.243669	2020-05-15 11:05:50.243669	1
109	High level cost estimation of materials & components	19	2020-05-15 11:05:50.261715	2020-05-15 11:05:50.261715	2
110	High level Cost of Goods Sold (COGS)	19	2020-05-15 11:05:50.272325	2020-05-15 11:05:50.272325	3
111	Detailed Bill of Materials cost estimate	19	2020-05-15 11:05:50.282932	2020-05-15 11:05:50.282932	4
112	Detailed COGS	19	2020-05-15 11:05:50.292741	2020-05-15 11:05:50.292741	5
113	Intelligent COGS and production cost analysis at different volumes	19	2020-05-15 11:05:50.303529	2020-05-15 11:05:50.303529	6
114	Not measured or estimated	20	2020-05-15 11:05:50.324604	2020-05-15 11:05:50.324604	1
115	Evaluated internally through simulation(s) or prototype(s)	20	2020-05-15 11:05:50.335152	2020-05-15 11:05:50.335152	2
116	Evaluated internally through both prototype(s) and simulation(s) or DFMEA	20	2020-05-15 11:05:50.344696	2020-05-15 11:05:50.344696	3
117	Evaluated via experienced and trusted third party	20	2020-05-15 11:05:50.353295	2020-05-15 11:05:50.353295	4
118	Evaluated extensively by customer(s)	20	2020-05-15 11:05:50.36265	2020-05-15 11:05:50.36265	5
119	Tested extensively to life internally, external partner and/or customer	20	2020-05-15 11:05:50.375411	2020-05-15 11:05:50.375411	6
120	Not measured or estimated	21	2020-05-15 11:05:50.395816	2020-05-15 11:05:50.395816	1
121	Evaluated internally through simulation(s) or prototype(s)	21	2020-05-15 11:05:50.40991	2020-05-15 11:05:50.40991	2
122	Evaluated internally through both prototype(s) and simulation(s)	21	2020-05-15 11:05:50.421071	2020-05-15 11:05:50.421071	3
123	Evaluated via experienced and trusted third party	21	2020-05-15 11:05:50.432395	2020-05-15 11:05:50.432395	4
124	Evaluated extensively by customer(s)	21	2020-05-15 11:05:50.463858	2020-05-15 11:05:50.463858	5
125	Tested extensively to life internally, external partner and/or customer	21	2020-05-15 11:05:50.475332	2020-05-15 11:05:50.475332	6
150	Not fully evaluated	26	2020-05-15 11:05:50.802669	2020-05-15 11:05:50.802669	1
151	Limited material testing, evaluation, or alternatives considered	26	2020-05-15 11:05:50.812149	2020-05-15 11:05:50.812149	2
152	Some material testing, evaluation, alternatives considered	26	2020-05-15 11:05:50.822658	2020-05-15 11:05:50.822658	3
153	Some testing, evaluation of materials	26	2020-05-15 11:05:50.831815	2020-05-15 11:05:50.831815	4
154	Comprehensive material testing, evaluation, many alternatives considered	26	2020-05-15 11:05:50.840717	2020-05-15 11:05:50.840717	5
155	No understanding of tooling being used or required to make product	27	2020-05-15 11:05:50.859297	2020-05-15 11:05:50.859297	1
156	Limited understanding of tooling being used or required to make product	27	2020-05-15 11:05:50.868731	2020-05-15 11:05:50.868731	2
157	Tooling design considerations being evaluated now	27	2020-05-15 11:05:50.878319	2020-05-15 11:05:50.878319	3
158	Tooling design well understood	27	2020-05-15 11:05:50.88765	2020-05-15 11:05:50.88765	4
159	Tooling design and tooling cost well understood	27	2020-05-15 11:05:50.897002	2020-05-15 11:05:50.897002	5
160	No understanding of mfg equip being used or required to make product	28	2020-05-15 11:05:50.913273	2020-05-15 11:05:50.913273	1
161	Limited understanding of mfg equip being used or required to make product	28	2020-05-15 11:05:50.92205	2020-05-15 11:05:50.92205	2
162	Mfg equip considerations being evaluated now	28	2020-05-15 11:05:50.930604	2020-05-15 11:05:50.930604	3
163	Mfg equip well understood	28	2020-05-15 11:05:50.939314	2020-05-15 11:05:50.939314	4
164	Mfg equip, capacity constraints and capital cost well understood	28	2020-05-15 11:05:50.948087	2020-05-15 11:05:50.948087	5
165	No knowledge of Production and Workflow Process	29	2020-05-15 11:05:50.965272	2020-05-15 11:05:50.965272	1
166	Limited knowledge of Production and Workflow Process	29	2020-05-15 11:05:50.975665	2020-05-15 11:05:50.975665	2
167	Production and Workflow Process plan in place but not validated	29	2020-05-15 11:05:50.986737	2020-05-15 11:05:50.986737	3
168	Production and Workflow Process plan in place and validated through PFMEA	29	2020-05-15 11:05:50.999712	2020-05-15 11:05:50.999712	4
169	Production and Workflow Process plan in place and validated through actual audit	29	2020-05-15 11:05:51.012203	2020-05-15 11:05:51.012203	5
170	Production and Workflow Process without lean assessment	30	2020-05-15 11:05:51.030075	2020-05-15 11:05:51.030075	1
171	Production and Workflow Process evaluated through high level lean assessment	30	2020-05-15 11:05:51.039278	2020-05-15 11:05:51.039278	2
172	Production and Workflow Process evaluated through detailed lean assessment	30	2020-05-15 11:05:51.048009	2020-05-15 11:05:51.048009	3
173	Production and Workflow Process evaluated through detailed lean assessment and quality audit	30	2020-05-15 11:05:51.057491	2020-05-15 11:05:51.057491	4
174	Production and Workflow Process certified to Lean Mfg, ISO, Quality standards	30	2020-05-15 11:05:51.068832	2020-05-15 11:05:51.068832	5
175	No suppliers identified but needed	31	2020-05-15 11:05:51.095867	2020-05-15 11:05:51.095867	1
176	Supplier search started but not complete	31	2020-05-15 11:05:51.110399	2020-05-15 11:05:51.110399	2
177	Suppliers identified but not multiple sources	31	2020-05-15 11:05:51.120297	2020-05-15 11:05:51.120297	3
178	Multiple suppliers identified for each material/component	31	2020-05-15 11:05:51.132065	2020-05-15 11:05:51.132065	4
179	Multiple suppliers identified for each material/component, contacted and in discussions	31	2020-05-15 11:05:51.143829	2020-05-15 11:05:51.143829	5
180	Not evaluated or no formal process for evaluation	32	2020-05-15 11:05:51.178357	2020-05-15 11:05:51.178357	1
181	Limited evaluation of suppliers but no formal process for evaluation	32	2020-05-15 11:05:51.189608	2020-05-15 11:05:51.189608	2
182	Evaluation of suppliers including formal process for evaluation (cost, performance, lead time, quality)	32	2020-05-15 11:05:51.201986	2020-05-15 11:05:51.201986	3
183	Evaluation of suppliers includes on-site audit	32	2020-05-15 11:05:51.213306	2020-05-15 11:05:51.213306	4
184	Evaluation of suppliers includes detailed on-site audit to verify performance, quality takt time	32	2020-05-15 11:05:51.224245	2020-05-15 11:05:51.224245	5
185	No formal supplier agreements in place	33	2020-05-15 11:05:51.256995	2020-05-15 11:05:51.256995	1
186	Limited suppliers agreements in place (NDA’s, PO’s, contracts)	33	2020-05-15 11:05:51.26859	2020-05-15 11:05:51.26859	2
187	Most supplier agreements in place (NDA’s, PO’s, contracts)	33	2020-05-15 11:05:51.282247	2020-05-15 11:05:51.282247	3
188	Agreements include alternative procurement terms (e.g., volume, delivery time) and clear ownership of quality issues (e.g., product yield, failures)	33	2020-05-15 11:05:51.299731	2020-05-15 11:05:51.299731	4
189	Agreements include alternative procurement terms and supplier reward and/or penalty compensation contracting terms associated with performance, quality, lead time measures	33	2020-05-15 11:05:51.33229	2020-05-15 11:05:51.33229	5
190	No supply chain plan or supplier risk assessment in place	34	2020-05-15 11:05:51.368826	2020-05-15 11:05:51.368826	1
191	Weak supply chain plan or limited supplier risk assessment in place	34	2020-05-15 11:05:51.385004	2020-05-15 11:05:51.385004	2
192	Supply chain strategy and risk mitigation includes multiple sources under contract for each component	34	2020-05-15 11:05:51.397118	2020-05-15 11:05:51.397118	3
193	Supply chain strategy and risk mitigation includes lead time guarantees for each component	34	2020-05-15 11:05:51.410601	2020-05-15 11:05:51.410601	4
194	Detailed supply chain strategy followed, supply chain quality tracing in place, ERP systems connected	34	2020-05-15 11:05:51.428911	2020-05-15 11:05:51.428911	5
195	Basic Principles Observed and Reporte	35	2020-05-15 11:05:51.485709	2020-05-15 11:05:51.485709	1
196	Technology Concept and/or Application Formulate	35	2020-05-15 11:05:51.511314	2020-05-15 11:05:51.511314	2
197	Proof of concept analyzed and experimented on	35	2020-05-15 11:05:51.536506	2020-05-15 11:05:51.536506	3
198	System validation in lab environmen	35	2020-05-15 11:05:51.563082	2020-05-15 11:05:51.563082	4
199	System validation, testing in operating environmen	35	2020-05-15 11:05:51.57533	2020-05-15 11:05:51.57533	5
200	Prototype/pilot system verification in operating environmen	35	2020-05-15 11:05:51.592909	2020-05-15 11:05:51.592909	6
201	Full Scale prototype verified in operating environmen	35	2020-05-15 11:05:51.606176	2020-05-15 11:05:51.606176	7
202	Actual system complete and functioning in operating environmen	35	2020-05-15 11:05:51.619955	2020-05-15 11:05:51.619955	8
203	Actual system tested and data collected over lifetime of syste	35	2020-05-15 11:05:51.63889	2020-05-15 11:05:51.63889	9
\.


--
-- Data for Name: sub_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."sub_categories" ("id", "title", "category_id", "created_at", "updated_at") FROM stdin;
1	Development Status	1	2020-04-07 13:34:03.232498	2020-04-07 13:34:03.232498
2	IP Advantage/Value	1	2020-04-07 13:34:03.363712	2020-04-07 13:34:03.363712
3	Product Development Ownership:	1	2020-04-07 13:34:03.467193	2020-04-07 13:34:03.467193
4	Competitive Technologies:	1	2020-04-07 13:34:03.588253	2020-04-07 13:34:03.588253
5	Value to Customer:	2	2020-04-07 13:34:03.722848	2020-04-07 13:34:03.722848
6	Market Size	2	2020-04-07 13:34:03.782546	2020-04-07 13:34:03.782546
7	Customer Segment	2	2020-04-07 13:34:03.854473	2020-04-07 13:34:03.854473
8	Marketing/Sales Strategy	2	2020-04-07 13:34:03.913092	2020-04-07 13:34:03.913092
9	Competition (Direct & Indirect)	2	2020-04-07 13:34:03.978791	2020-04-07 13:34:03.978791
10	Revenue Model	3	2020-04-07 13:34:04.042434	2020-04-07 13:34:04.042434
11	Financial Planning	3	2020-04-07 13:34:04.113967	2020-04-07 13:34:04.113967
12	Cash Flow Requirements	3	2020-04-07 13:34:04.201579	2020-04-07 13:34:04.201579
13	Financing	3	2020-04-07 13:34:04.275254	2020-04-07 13:34:04.275254
14	Management Team	4	2020-04-07 13:34:04.378878	2020-04-07 13:34:04.378878
15	Alliance/Partners	4	2020-04-07 13:34:04.449333	2020-04-07 13:34:04.449333
16	Advisory Board	4	2020-04-07 13:34:04.560319	2020-04-07 13:34:04.560319
17	Implementation Plan	4	2020-04-07 13:34:04.709696	2020-04-07 13:34:04.709696
18	Customer Use:	5	2020-05-15 11:05:50.148212	2020-05-15 11:05:50.148212
19	Cost:	5	2020-05-15 11:05:50.229734	2020-05-15 11:05:50.229734
20	Durability/Reliability:	5	2020-05-15 11:05:50.312887	2020-05-15 11:05:50.312887
21	Performance:	5	2020-05-15 11:05:50.382194	2020-05-15 11:05:50.382194
26	Materials:	7	2020-05-15 11:05:50.791856	2020-05-15 11:05:50.791856
27	Tooling:	7	2020-05-15 11:05:50.847041	2020-05-15 11:05:50.847041
28	Manufacturing Equipment:	7	2020-05-15 11:05:50.903097	2020-05-15 11:05:50.903097
29	Manufacturing Process Validation:	7	2020-05-15 11:05:50.954489	2020-05-15 11:05:50.954489
30	Manufacturing Process Efficiency:	7	2020-05-15 11:05:51.019248	2020-05-15 11:05:51.019248
31	Supplier Identifaction:	8	2020-05-15 11:05:51.084298	2020-05-15 11:05:51.084298
32	Supplier Evaluation:	8	2020-05-15 11:05:51.165486	2020-05-15 11:05:51.165486
33	Supplier Agreements:	8	2020-05-15 11:05:51.233363	2020-05-15 11:05:51.233363
34	Supply Chain Plan:	8	2020-05-15 11:05:51.353802	2020-05-15 11:05:51.353802
35	\N	9	2020-05-15 11:05:51.468917	2020-08-24 11:33:29.916635
\.


--
-- Data for Name: sub_category_progresses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."sub_category_progresses" ("id", "customer_id", "sub_category_id", "current_stage_id", "created_at", "updated_at") FROM stdin;
64	15	12	72	2020-04-09 11:04:41.53597	2020-04-09 11:12:41.347656
65	15	13	77	2020-04-09 11:04:42.630772	2020-04-09 11:12:42.397854
66	15	14	83	2020-04-09 11:04:52.621685	2020-04-09 11:12:45.260537
67	15	15	89	2020-04-09 11:05:18.629303	2020-04-09 11:12:46.246766
69	15	16	95	2020-04-09 11:12:47.400033	2020-04-09 11:12:47.400033
68	15	17	101	2020-04-09 11:05:25.576171	2020-04-09 11:12:48.442583
70	4	11	62	2020-04-09 12:21:39.339301	2020-04-09 12:21:41.16921
1	4	1	1	2020-04-07 18:45:44.886052	2020-04-10 16:09:11.412323
4	9	1	4	2020-04-08 14:53:32.134317	2020-04-08 14:54:00.510607
5	9	2	9	2020-04-08 14:54:03.386398	2020-04-08 14:54:03.386398
6	9	3	16	2020-04-08 14:54:06.77608	2020-04-08 14:54:06.77608
7	9	4	24	2020-04-08 14:54:13.077356	2020-04-08 14:54:13.077356
371	106	4	21	2020-10-22 15:34:00.63738	2020-10-22 15:39:10.150708
9	4	5	30	2020-04-08 16:11:27.182637	2020-04-08 16:11:27.182637
10	4	6	36	2020-04-08 16:12:13.534625	2020-04-08 16:12:13.534625
11	4	7	42	2020-04-08 16:12:30.190898	2020-04-08 16:12:30.190898
12	4	8	48	2020-04-08 16:12:32.836337	2020-04-08 16:12:32.836337
13	4	9	54	2020-04-08 16:12:35.004116	2020-04-08 16:12:35.004116
368	106	1	6	2020-10-22 15:26:31.465452	2020-10-22 15:37:23.477734
372	106	5	25	2020-10-22 15:40:02.291888	2020-10-22 15:43:07.199406
369	106	2	10	2020-10-22 15:27:10.795854	2020-10-22 15:37:29.121175
89	4	17	101	2020-04-10 15:54:35.366966	2020-04-10 15:54:37.886811
370	106	3	15	2020-10-22 15:31:56.316308	2020-10-22 15:37:34.932062
373	106	6	31	2020-10-22 15:44:59.649431	2020-10-22 15:45:04.416817
377	105	4	19	2020-11-16 15:45:14.975172	2020-11-16 15:45:14.975172
2	8	1	6	2020-04-08 07:11:03.634958	2020-04-29 16:53:25.083739
14	8	2	11	2020-04-08 18:52:49.756722	2020-04-29 16:56:28.618286
90	8	4	24	2020-04-10 16:03:27.398303	2020-04-29 16:56:30.076927
15	8	3	17	2020-04-08 18:52:55.7644	2020-04-29 16:56:31.336583
153	30	14	83	2020-04-29 17:00:37.502995	2020-04-29 17:00:37.502995
154	30	15	89	2020-04-29 17:00:38.261618	2020-04-29 17:00:38.261618
155	30	17	101	2020-04-29 17:00:41.412295	2020-04-29 17:00:41.412295
156	30	16	95	2020-04-29 17:00:42.075303	2020-04-29 17:00:42.075303
157	30	10	60	2020-04-29 17:00:46.693121	2020-04-29 17:00:46.693121
158	30	11	66	2020-04-29 17:00:47.196681	2020-04-29 17:00:47.196681
159	30	13	77	2020-04-29 17:00:48.455148	2020-04-29 17:00:48.455148
160	30	12	72	2020-04-29 17:00:49.54548	2020-04-29 17:00:49.54548
35	4	10	60	2020-04-08 19:27:15.573803	2020-04-08 19:27:15.573803
36	12	1	3	2020-04-08 22:41:01.762723	2020-04-08 22:41:01.762723
37	12	2	8	2020-04-08 22:41:03.89056	2020-04-08 22:41:03.89056
38	12	3	13	2020-04-08 22:41:06.76437	2020-04-08 22:41:06.76437
39	12	4	19	2020-04-08 22:41:08.510243	2020-04-08 22:41:08.510243
40	12	5	27	2020-04-08 22:41:17.018264	2020-04-08 22:41:17.018264
41	12	6	33	2020-04-08 22:41:19.426393	2020-04-08 22:41:19.426393
42	12	7	38	2020-04-08 22:41:23.616649	2020-04-08 22:41:23.616649
43	12	8	45	2020-04-08 22:41:26.112351	2020-04-08 22:41:26.112351
44	12	9	51	2020-04-08 22:41:27.730364	2020-04-08 22:41:27.730364
45	12	10	56	2020-04-08 22:41:30.092407	2020-04-08 22:41:30.092407
46	12	11	62	2020-04-08 22:41:33.341115	2020-04-08 22:41:33.341115
47	12	12	68	2020-04-08 22:41:35.170379	2020-04-08 22:41:35.170379
48	12	13	74	2020-04-08 22:41:36.885669	2020-04-08 22:41:36.885669
49	12	14	79	2020-04-08 22:41:40.573718	2020-04-08 22:41:40.573718
50	12	15	85	2020-04-08 22:41:43.628778	2020-04-08 22:41:43.628778
51	12	17	97	2020-04-08 22:41:46.910952	2020-04-08 22:41:46.910952
52	12	16	91	2020-04-08 22:41:48.572846	2020-04-08 22:41:48.572846
162	30	3	17	2020-04-29 17:03:49.741379	2020-04-29 17:03:49.741379
34	4	3	13	2020-04-08 19:27:00.063006	2020-04-10 15:58:08.37672
55	15	3	17	2020-04-09 11:03:37.606953	2020-04-09 11:12:28.374431
8	4	4	22	2020-04-08 16:10:58.846931	2020-04-10 15:58:12.046669
56	15	4	24	2020-04-09 11:03:48.205604	2020-04-09 11:12:29.160267
161	30	4	20	2020-04-29 17:03:48.788458	2020-04-29 17:04:51.493898
57	15	5	30	2020-04-09 11:04:00.049148	2020-04-09 11:12:31.553753
58	15	6	36	2020-04-09 11:04:06.905524	2020-04-09 11:12:32.211739
59	15	7	42	2020-04-09 11:04:12.390015	2020-04-09 11:12:33.398552
61	15	9	54	2020-04-09 11:04:26.05475	2020-04-09 11:12:34.696478
60	15	8	48	2020-04-09 11:04:19.267821	2020-04-09 11:12:35.840256
62	15	10	60	2020-04-09 11:04:36.397438	2020-04-09 11:12:38.774222
63	15	11	66	2020-04-09 11:04:39.56958	2020-04-09 11:12:39.527749
163	30	5	28	2020-04-29 17:05:39.632401	2020-04-29 17:05:39.632401
164	30	6	35	2020-04-29 17:05:40.464496	2020-04-29 17:05:40.464496
165	30	7	42	2020-04-29 17:05:41.553456	2020-04-29 17:05:41.553456
151	30	1	5	2020-04-29 16:59:34.814166	2020-05-05 10:12:27.337463
152	30	2	8	2020-04-29 16:59:35.682389	2020-05-05 17:51:34.54606
169	8	35	203	2020-05-15 11:06:56.4516	2020-05-15 11:06:56.4516
53	15	1	5	2020-04-09 11:03:16.084419	2020-04-10 11:13:25.207474
54	15	2	10	2020-04-09 11:03:26.407873	2020-04-10 11:13:26.655188
167	8	20	119	2020-05-15 11:06:42.949453	2020-05-15 11:06:42.949453
94	8	8	48	2020-04-10 16:03:33.522496	2020-04-10 16:03:33.522496
91	8	5	30	2020-04-10 16:03:30.376037	2020-04-10 16:03:30.376037
33	4	2	11	2020-04-08 19:26:46.707837	2020-04-10 15:54:12.310164
95	8	9	54	2020-04-10 16:03:34.707734	2020-04-10 16:03:34.707734
88	4	13	77	2020-04-10 15:54:25.072153	2020-04-10 15:54:29.26534
96	8	10	60	2020-04-10 16:03:40.586354	2020-04-10 16:03:40.586354
92	8	6	36	2020-04-10 16:03:31.097861	2020-04-10 16:03:31.097861
93	8	7	42	2020-04-10 16:03:32.648881	2020-04-10 16:03:32.648881
97	8	11	66	2020-04-10 16:03:41.417728	2020-04-10 16:03:41.417728
98	8	12	72	2020-04-10 16:03:42.957836	2020-04-10 16:03:42.957836
99	8	13	77	2020-04-10 16:03:43.66871	2020-04-10 16:03:43.66871
168	8	21	125	2020-05-15 11:06:45.240573	2020-05-15 11:06:46.299708
3	8	14	83	2020-04-08 14:35:50.550666	2020-05-29 09:40:23.738679
170	4	35	201	2020-05-15 11:06:56.656785	2020-05-15 11:06:56.656785
378	105	21	121	2020-11-16 15:45:33.926054	2020-11-16 15:45:33.926054
379	110	1	3	2020-12-02 18:48:10.516268	2020-12-02 18:48:10.516268
380	115	1	6	2020-12-03 13:31:33.022057	2020-12-03 13:31:33.022057
381	115	2	9	2020-12-03 13:31:43.506021	2020-12-03 13:31:43.506021
166	8	18	104	2020-05-15 11:06:23.825546	2020-06-03 16:29:46.86647
382	115	3	16	2020-12-03 13:32:14.547872	2020-12-03 13:32:14.547872
383	115	4	21	2020-12-03 13:32:31.074597	2020-12-03 13:32:31.074597
384	115	5	29	2020-12-03 13:32:38.026707	2020-12-03 13:32:38.026707
385	115	6	35	2020-12-03 13:32:44.722928	2020-12-03 13:32:46.558152
386	115	7	40	2020-12-03 13:32:54.75454	2020-12-03 13:32:54.75454
387	115	8	45	2020-12-03 13:33:00.943802	2020-12-03 13:33:00.943802
388	115	9	52	2020-12-03 13:33:12.986727	2020-12-03 13:33:12.986727
389	115	10	58	2020-12-03 13:36:45.755041	2020-12-03 13:36:45.755041
173	8	15	89	2020-05-29 09:40:25.238701	2020-05-29 09:40:25.238701
174	8	17	101	2020-05-29 09:40:27.17934	2020-05-29 09:40:27.17934
175	8	16	95	2020-05-29 09:40:28.697583	2020-05-29 09:40:28.697583
248	89	2	8	2020-07-29 14:59:43.06777	2020-07-29 14:59:43.06777
374	106	7	37	2020-10-22 15:46:50.153916	2020-10-22 15:46:51.397402
176	8	19	113	2020-06-03 16:28:44.149694	2020-06-03 16:29:48.288703
177	47	18	104	2020-06-04 17:55:54.255441	2020-06-04 17:55:54.255441
178	52	18	104	2020-06-08 22:56:52.038194	2020-06-08 22:56:52.038194
179	52	19	112	2020-06-08 22:56:53.806959	2020-06-08 22:56:53.806959
180	52	20	116	2020-06-08 22:56:55.861067	2020-06-08 22:56:55.861067
182	52	21	125	2020-06-08 22:57:01.782079	2020-06-08 22:57:01.782079
375	106	8	43	2020-10-22 15:48:53.938626	2020-10-22 15:48:57.49358
376	106	9	49	2020-10-22 15:52:37.233104	2020-10-22 15:52:39.963603
186	52	26	154	2020-06-08 22:57:09.764595	2020-06-08 22:57:09.764595
187	52	27	158	2020-06-08 22:57:11.599832	2020-06-08 22:57:11.599832
188	52	28	164	2020-06-08 22:57:13.353805	2020-06-08 22:57:13.353805
189	52	29	167	2020-06-08 22:57:15.207029	2020-06-08 22:57:15.207029
190	52	30	174	2020-06-08 22:57:16.874862	2020-06-08 22:57:16.874862
191	52	31	178	2020-06-08 22:57:19.709045	2020-06-08 22:57:19.709045
192	52	32	182	2020-06-08 22:57:21.639723	2020-06-08 22:57:21.639723
193	52	33	189	2020-06-08 22:57:23.526198	2020-06-08 22:57:23.526198
194	52	34	193	2020-06-08 22:57:26.81935	2020-06-08 22:57:26.81935
195	47	6	34	2020-06-09 17:21:12.653753	2020-06-09 17:21:12.653753
196	54	1	2	2020-06-10 19:43:20.662155	2020-06-10 19:43:20.662155
197	54	2	8	2020-06-10 19:43:21.661546	2020-06-10 19:43:21.661546
198	54	3	15	2020-06-10 19:43:23.163828	2020-06-10 19:43:23.163828
199	54	4	21	2020-06-10 19:43:24.139608	2020-06-10 19:43:24.139608
200	54	5	26	2020-06-10 19:43:30.295811	2020-06-10 19:43:30.295811
201	54	6	33	2020-06-10 19:43:31.800272	2020-06-10 19:43:31.800272
202	54	11	63	2020-06-10 19:43:34.216525	2020-06-10 19:43:34.216525
203	54	14	80	2020-06-10 19:43:36.207507	2020-06-10 19:43:36.207507
242	64	2	8	2020-07-13 19:21:50.185182	2020-11-10 17:08:58.360378
390	115	11	65	2020-12-03 13:36:52.79498	2020-12-03 13:36:52.79498
391	115	12	71	2020-12-03 13:36:57.784357	2020-12-03 13:36:57.784357
205	73	1	4	2020-06-22 13:00:01.225423	2020-06-22 13:00:08.896673
206	73	2	8	2020-06-22 13:00:38.243518	2020-06-22 13:00:38.243518
207	73	3	13	2020-06-22 13:14:19.311607	2020-06-22 13:14:19.311607
208	73	4	19	2020-06-22 13:14:49.704557	2020-06-22 13:14:49.704557
392	115	13	74	2020-12-03 13:37:07.049589	2020-12-03 13:37:07.049589
210	73	6	35	2020-06-22 13:16:09.405529	2020-06-22 13:16:15.684651
211	73	7	41	2020-06-22 13:26:33.624645	2020-06-22 13:26:33.624645
212	73	8	45	2020-06-22 13:27:15.336764	2020-06-22 13:27:15.336764
213	73	9	51	2020-06-22 13:27:47.954725	2020-06-22 13:27:47.954725
214	73	10	58	2020-06-22 13:28:04.648136	2021-08-13 18:44:27.439472
215	73	11	64	2020-06-22 13:28:51.056133	2020-06-22 13:28:51.056133
216	73	12	70	2020-06-22 13:29:04.621361	2020-06-22 13:29:04.621361
217	73	13	74	2020-06-22 13:29:23.365935	2020-06-22 13:29:23.365935
218	73	14	81	2020-06-22 13:30:48.41413	2020-06-22 13:30:49.365348
399	115	20	117	2020-12-03 13:39:11.801284	2020-12-03 13:39:14.415401
219	73	15	86	2020-06-22 13:31:30.320291	2020-06-22 13:31:40.703461
220	73	16	90	2020-06-22 13:31:46.427856	2020-06-22 13:31:52.255519
221	73	17	98	2020-06-22 13:32:28.23864	2020-06-22 13:32:28.23864
223	73	19	108	2020-06-22 17:43:28.962291	2020-06-22 17:43:28.962291
224	73	20	115	2020-06-22 17:43:55.042133	2020-06-22 17:43:55.042133
225	73	21	121	2020-06-22 17:44:09.350883	2020-06-22 17:44:09.350883
393	115	14	81	2020-12-03 13:37:13.507961	2020-12-03 13:37:16.722589
394	115	15	87	2020-12-03 13:37:25.837719	2020-12-03 13:37:25.837719
204	64	1	3	2020-06-18 13:37:59.63491	2020-11-10 17:08:56.232089
395	115	16	91	2020-12-03 13:37:29.378813	2020-12-03 13:37:29.378813
230	73	26	152	2020-06-22 17:45:03.177488	2020-06-22 17:45:03.177488
231	73	27	156	2020-06-22 17:45:15.174213	2020-06-22 17:45:21.591644
232	73	28	161	2020-06-22 17:45:25.802621	2020-06-22 17:45:25.802621
233	73	29	166	2020-06-22 17:45:34.723121	2020-06-22 17:45:34.723121
234	73	30	171	2020-06-22 17:45:40.064127	2020-06-22 17:45:40.064127
235	73	31	176	2020-06-22 17:45:50.011965	2020-06-22 17:45:50.011965
236	73	32	181	2020-06-22 17:45:56.039723	2020-06-22 17:45:56.039723
237	73	33	185	2020-06-22 17:46:00.309841	2020-06-22 17:46:00.309841
396	115	17	99	2020-12-03 13:37:36.180382	2020-12-03 13:37:36.180382
397	115	18	104	2020-12-03 13:38:27.487391	2020-12-03 13:38:27.487391
398	115	19	110	2020-12-03 13:39:09.107449	2020-12-03 13:39:09.107449
400	115	21	123	2020-12-03 13:39:37.099804	2020-12-03 13:39:37.099804
401	115	26	153	2020-12-03 13:39:42.724568	2020-12-03 13:39:42.724568
402	115	27	157	2020-12-03 13:39:46.615555	2020-12-03 13:39:46.615555
243	64	3	13	2020-07-13 19:21:52.172505	2020-07-13 19:21:52.172505
244	64	4	19	2020-07-13 19:21:53.784849	2020-07-13 19:21:53.784849
245	64	5	26	2020-07-13 19:21:57.914975	2020-07-13 19:21:57.914975
246	64	6	33	2020-07-13 19:22:02.89292	2020-07-13 19:22:02.89292
247	64	10	55	2020-07-13 19:22:30.474877	2020-07-13 19:22:30.474877
403	115	28	161	2020-12-03 13:39:54.342536	2020-12-03 13:39:54.342536
404	115	29	167	2020-12-03 13:40:04.775572	2020-12-03 13:40:04.775572
405	115	30	172	2020-12-03 13:40:08.488718	2020-12-03 13:40:08.488718
406	115	31	177	2020-12-03 13:40:16.528585	2020-12-03 13:40:16.528585
407	115	32	181	2020-12-03 13:40:19.297965	2020-12-03 13:40:22.532876
408	115	33	186	2020-12-03 13:40:26.299783	2020-12-03 13:40:26.299783
409	115	34	191	2020-12-03 13:40:31.495856	2020-12-03 13:40:31.495856
238	73	34	191	2020-06-22 17:46:12.596175	2020-08-13 11:43:23.448208
268	97	3	15	2020-08-14 15:39:44.503643	2020-08-14 15:39:55.294411
269	97	4	21	2020-08-14 15:40:25.938725	2020-08-14 15:40:25.938725
270	97	5	29	2020-08-14 15:40:50.511691	2020-08-14 15:40:50.511691
271	97	6	36	2020-08-14 15:41:01.723697	2020-08-14 15:41:01.723697
274	97	9	51	2020-08-14 15:41:47.497056	2020-08-14 15:41:47.497056
275	97	10	60	2020-08-14 15:42:01.968231	2020-08-14 15:42:01.968231
276	97	11	65	2020-08-14 15:42:16.061414	2020-08-14 15:42:16.061414
278	97	13	76	2020-08-14 15:43:22.147384	2020-08-14 15:43:22.147384
279	97	14	81	2020-08-14 15:43:37.351799	2020-08-14 15:43:37.351799
280	97	15	88	2020-08-14 15:43:49.397531	2020-08-14 15:43:49.397531
281	97	16	93	2020-08-14 15:43:56.533048	2020-08-14 15:43:56.533048
410	115	35	198	2020-12-03 13:40:44.843991	2020-12-03 13:40:44.843991
411	112	18	104	2020-12-10 19:26:46.793466	2020-12-10 19:26:46.793466
267	97	2	9	2020-08-14 15:39:21.127841	2021-05-06 18:19:47.795285
209	73	5	28	2020-06-22 13:15:51.961377	2021-02-16 21:11:24.03853
273	97	8	44	2020-08-14 15:41:23.978251	2021-05-06 18:31:40.063046
272	97	7	38	2020-08-14 15:41:10.339511	2021-05-06 18:31:45.926338
266	97	1	5	2020-08-14 15:38:55.667958	2021-05-17 20:40:05.325546
277	97	12	71	2020-08-14 15:42:24.282437	2021-06-09 17:50:27.146237
282	97	17	100	2020-08-14 15:44:05.201321	2020-08-14 15:44:09.132728
283	97	18	107	2020-08-14 15:44:42.904349	2020-08-14 15:44:42.904349
284	97	19	112	2020-08-14 15:44:51.016194	2020-08-14 15:44:53.661696
285	97	20	119	2020-08-14 15:45:16.646717	2020-08-14 15:45:16.646717
286	97	21	124	2020-08-14 15:45:23.530581	2020-08-14 15:45:23.530581
412	112	19	111	2020-12-10 19:26:48.800467	2020-12-10 19:26:48.800467
413	112	20	115	2020-12-10 19:26:49.982201	2020-12-10 19:26:49.982201
414	112	21	121	2020-12-10 19:26:52.04652	2020-12-10 19:26:52.04652
415	112	26	151	2020-12-10 19:26:57.484797	2020-12-10 19:26:57.484797
291	97	26	153	2020-08-14 15:46:15.872225	2020-08-14 15:46:15.872225
292	97	27	159	2020-08-14 15:46:21.610779	2020-08-14 15:46:25.63715
293	97	28	164	2020-08-14 15:46:34.373658	2020-08-14 15:46:34.373658
294	97	29	169	2020-08-14 15:46:43.353772	2020-08-14 15:46:43.353772
295	97	30	172	2020-08-14 15:46:59.233903	2020-08-14 15:46:59.233903
296	97	31	179	2020-08-14 15:47:11.49384	2020-08-14 15:47:11.49384
297	97	32	183	2020-08-14 15:47:20.327274	2020-08-14 15:47:20.327274
298	97	33	188	2020-08-14 15:47:32.501068	2020-08-14 15:47:32.501068
299	97	34	192	2020-08-14 15:48:09.050303	2020-08-14 15:48:09.050303
416	112	27	156	2020-12-10 19:26:59.444143	2020-12-10 19:26:59.444143
417	112	29	166	2020-12-10 19:27:00.521173	2020-12-10 19:27:00.521173
418	112	2	9	2020-12-10 19:36:04.766546	2020-12-10 19:36:04.766546
419	112	1	3	2020-12-10 19:36:05.605917	2020-12-10 19:36:05.605917
420	112	3	15	2020-12-10 19:36:07.112678	2020-12-10 19:36:07.112678
345	104	9	52	2020-09-10 11:00:48.175304	2020-09-10 11:00:48.175304
346	104	10	60	2020-09-10 11:01:29.019128	2020-09-10 11:01:38.693967
347	104	11	65	2020-09-10 11:02:02.876735	2020-09-10 11:02:02.876735
306	103	35	201	2020-09-03 10:03:18.428807	2020-09-03 10:03:45.134884
348	104	13	76	2020-09-10 11:02:43.95081	2020-09-10 11:02:43.95081
349	104	17	100	2020-09-10 11:03:02.1776	2020-09-10 11:03:02.1776
350	104	15	86	2020-09-10 11:03:17.134784	2020-09-10 11:03:17.134784
308	103	18	105	2020-09-03 10:12:52.700988	2020-09-03 10:13:08.343911
351	104	16	95	2020-09-10 11:03:25.224971	2020-09-10 11:03:29.468315
352	104	14	82	2020-09-10 11:03:35.867461	2020-09-10 11:03:35.867461
310	103	20	117	2020-09-03 10:13:41.29994	2020-09-03 10:13:45.893699
309	103	19	111	2020-09-03 10:13:18.53723	2020-09-03 10:52:51.538804
311	103	21	122	2020-09-03 10:53:04.956252	2020-09-03 10:53:06.071692
353	104	20	116	2020-09-10 11:04:15.105243	2020-09-10 11:04:15.105243
354	104	18	104	2020-09-10 11:04:29.428989	2020-09-10 11:04:29.428989
355	104	21	121	2020-09-10 11:04:36.891611	2020-09-10 11:04:36.891611
312	103	1	6	2020-09-03 10:54:09.056237	2020-09-03 10:54:16.078643
313	103	2	10	2020-09-03 10:54:24.455321	2020-09-03 10:54:29.508921
356	104	19	110	2020-09-10 11:04:47.166938	2020-09-10 11:04:52.259305
314	103	3	16	2020-09-03 10:54:40.272156	2020-09-03 10:54:44.455414
357	104	26	154	2020-09-10 11:05:10.16357	2020-09-10 11:05:10.16357
358	104	27	158	2020-09-10 11:05:18.559684	2020-09-10 11:05:18.559684
359	104	28	163	2020-09-10 11:05:27.693844	2020-09-10 11:05:27.693844
360	104	30	172	2020-09-10 11:05:42.626951	2020-09-10 11:05:42.626951
361	104	29	167	2020-09-10 11:05:57.246795	2020-09-10 11:05:57.246795
315	103	4	18	2020-09-03 10:55:50.371006	2020-09-03 10:58:19.762588
316	103	5	30	2020-09-03 11:12:39.344576	2020-09-03 11:12:39.344576
317	103	6	36	2020-09-03 11:12:47.197866	2020-09-03 11:12:47.197866
318	103	7	42	2020-09-03 11:12:58.447162	2020-09-03 11:12:58.447162
319	103	8	47	2020-09-03 11:13:09.000448	2020-09-03 11:13:09.000448
320	103	9	52	2020-09-03 11:13:24.339054	2020-09-03 11:13:24.339054
321	103	10	60	2020-09-03 11:13:41.093509	2020-09-03 11:13:41.093509
322	103	11	65	2020-09-03 11:14:03.789341	2020-09-03 11:14:03.789341
323	103	12	69	2020-09-03 11:14:28.646717	2020-09-03 11:14:28.646717
324	103	13	76	2020-09-03 11:15:00.473064	2020-09-03 11:15:00.473064
325	103	14	82	2020-09-03 11:15:21.437167	2020-09-03 11:15:21.437167
326	103	15	88	2020-09-03 11:15:38.076737	2020-09-03 11:15:38.076737
327	103	16	94	2020-09-03 11:15:45.295709	2020-09-03 11:15:45.295709
328	103	17	99	2020-09-03 11:15:59.342615	2020-09-03 11:15:59.342615
307	103	26	153	2020-09-03 10:12:00.984407	2020-09-03 11:17:12.320579
329	103	27	158	2020-09-03 11:17:31.181276	2020-09-03 11:17:31.181276
330	103	28	162	2020-09-03 11:17:49.928646	2020-09-03 11:17:49.928646
331	103	29	167	2020-09-03 11:18:04.862253	2020-09-03 11:18:04.862253
332	103	30	172	2020-09-03 11:19:23.219253	2020-09-03 11:19:23.219253
333	103	31	177	2020-09-03 11:19:35.144506	2020-09-03 11:19:35.144506
334	103	32	181	2020-09-03 11:19:48.642484	2020-09-03 11:19:48.642484
335	103	33	187	2020-09-03 11:19:58.133642	2020-09-03 11:19:58.133642
336	103	34	192	2020-09-03 11:20:35.474275	2020-09-03 11:20:35.474275
337	104	1	3	2020-09-10 10:58:51.053804	2020-09-10 10:58:51.053804
338	104	2	11	2020-09-10 10:58:58.253814	2020-09-10 10:58:58.253814
339	104	3	17	2020-09-10 10:59:03.346877	2020-09-10 10:59:03.346877
340	104	4	21	2020-09-10 10:59:24.224195	2020-09-10 10:59:24.224195
341	104	5	30	2020-09-10 11:00:07.752689	2020-09-10 11:00:07.752689
342	104	6	36	2020-09-10 11:00:13.602182	2020-09-10 11:00:13.602182
343	104	7	41	2020-09-10 11:00:23.465076	2020-09-10 11:00:23.465076
344	104	8	47	2020-09-10 11:00:30.419185	2020-09-10 11:00:30.419185
362	104	33	186	2020-09-10 11:06:15.255821	2020-09-10 11:06:22.725076
363	104	31	177	2020-09-10 11:06:30.598886	2020-09-10 11:06:30.598886
364	104	34	191	2020-09-10 11:06:41.51053	2020-09-10 11:06:50.926003
365	104	32	181	2020-09-10 11:07:00.552879	2020-09-10 11:07:00.552879
366	104	35	197	2020-09-10 11:07:28.162021	2020-09-10 11:07:28.162021
421	112	4	20	2020-12-10 19:36:08.396537	2020-12-10 19:36:08.396537
367	106	35	202	2020-09-10 22:25:46.397853	2020-09-10 22:26:05.931981
422	112	5	28	2020-12-10 19:36:12.440866	2020-12-10 19:36:12.440866
423	112	6	33	2020-12-10 19:36:13.086454	2020-12-10 19:36:13.086454
424	112	7	39	2020-12-10 19:36:14.076262	2020-12-10 19:36:14.076262
425	112	8	46	2020-12-10 19:36:15.218023	2020-12-10 19:36:15.218023
426	112	11	62	2020-12-10 19:36:18.21124	2020-12-10 19:36:18.21124
427	112	10	56	2020-12-10 19:36:18.894549	2020-12-10 19:36:18.894549
428	112	12	69	2020-12-10 19:36:20.482963	2020-12-10 19:36:20.482963
429	112	13	75	2020-12-10 19:36:21.822749	2020-12-10 19:36:21.822749
430	112	14	81	2020-12-10 19:36:24.824698	2020-12-10 19:36:24.824698
431	112	15	88	2020-12-10 19:36:25.328069	2020-12-10 19:36:25.328069
432	112	16	93	2020-12-10 19:36:26.979254	2020-12-10 19:36:26.979254
433	112	17	100	2020-12-10 19:36:28.24177	2020-12-10 19:36:28.24177
222	73	18	102	2020-06-22 17:43:14.35913	2021-02-15 14:21:14.97697
434	162	1	3	2021-03-23 13:16:12.62577	2021-04-19 09:41:47.127855
436	162	14	81	2021-04-19 09:21:24.390548	2021-04-19 09:22:41.292654
435	162	2	9	2021-03-23 13:16:13.729469	2021-04-19 09:41:52.870408
438	162	4	18	2021-04-19 09:42:11.168676	2021-04-19 09:42:13.559133
437	162	3	13	2021-04-19 09:41:04.370781	2021-04-19 09:42:37.620013
300	97	35	198	2020-08-14 15:48:30.061018	2021-05-07 17:05:24.796407
470	73	35	197	2021-08-13 18:44:57.348234	2021-08-13 18:44:57.348234
440	164	19	113	2021-05-04 18:23:54.610752	2021-05-04 18:23:54.610752
441	164	20	119	2021-05-04 18:24:57.357645	2021-05-04 18:24:57.357645
442	164	21	125	2021-05-04 18:25:21.776856	2021-05-04 18:25:21.776856
443	164	26	154	2021-05-04 18:26:39.620971	2021-05-04 18:26:39.620971
444	164	27	159	2021-05-04 18:27:04.609132	2021-05-04 18:27:04.609132
445	164	28	164	2021-05-04 18:27:18.963218	2021-05-04 18:27:18.963218
446	164	29	169	2021-05-04 18:27:38.320934	2021-05-04 18:27:38.320934
447	164	30	174	2021-05-04 18:27:52.152599	2021-05-04 18:27:52.152599
448	164	31	179	2021-05-04 18:29:19.965137	2021-05-04 18:29:19.965137
449	164	32	184	2021-05-04 18:29:27.671698	2021-05-04 18:29:27.671698
450	164	33	189	2021-05-04 18:29:39.033251	2021-05-04 18:29:39.033251
451	164	34	194	2021-05-04 18:29:56.532999	2021-05-04 18:29:56.532999
453	164	2	7	2021-05-04 18:32:16.018416	2021-05-04 18:32:16.018416
454	164	3	12	2021-05-04 18:32:36.57538	2021-05-04 18:32:36.57538
455	164	4	18	2021-05-04 18:32:51.18789	2021-05-04 18:32:51.18789
456	164	5	25	2021-05-04 18:33:10.243008	2021-05-04 18:33:10.243008
457	164	6	31	2021-05-04 18:33:22.167142	2021-05-04 18:33:22.167142
458	164	7	37	2021-05-04 18:34:07.100669	2021-05-04 18:34:07.100669
459	164	8	43	2021-05-04 18:34:23.201135	2021-05-04 18:34:23.201135
460	164	9	49	2021-05-04 18:34:32.505463	2021-05-04 18:34:32.505463
461	164	10	55	2021-05-04 18:35:02.969832	2021-05-04 18:35:02.969832
462	164	11	61	2021-05-04 18:35:08.221156	2021-05-04 18:35:08.221156
463	164	12	67	2021-05-04 18:35:15.571668	2021-05-04 18:35:15.571668
464	164	13	73	2021-05-04 18:35:23.599535	2021-05-04 18:35:23.599535
465	164	14	78	2021-05-04 18:35:32.522396	2021-05-04 18:35:32.522396
466	164	15	84	2021-05-04 18:35:42.458772	2021-05-04 18:35:42.458772
467	164	16	90	2021-05-04 18:35:49.485031	2021-05-04 18:35:49.485031
468	164	17	96	2021-05-04 18:35:53.884282	2021-05-04 18:35:53.884282
469	164	35	201	2021-05-04 18:40:15.65235	2021-05-04 18:40:15.65235
439	164	18	105	2021-05-04 18:21:59.501854	2021-05-04 18:53:00.133206
452	164	1	5	2021-05-04 18:32:12.665983	2021-05-24 20:07:44.610128
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."tasks" ("id", "title", "stage_id", "created_at", "updated_at", "user_id", "status", "created_by", "priority", "due_date") FROM stdin;
20	Trademark name	11	2020-11-16 16:20:23.859894	2020-11-16 16:20:23.859894	103	0	72	1	2020-11-20 00:00:00
21	get on that task brotha!	106	2021-02-15 14:20:00.648007	2021-02-15 14:20:00.648007	73	0	72	2	2021-02-19 00:00:00
57	d	32	2021-04-09 13:02:00.308549	2021-04-09 13:02:00.308549	162	0	161	1	2021-04-15 00:00:00
55	FFF	39	2021-03-22 18:14:04.562373	2021-03-22 18:14:04.562373	158	0	157	1	2021-03-23 00:00:00
56	sdfsdf	67	2021-03-23 13:00:18.545803	2021-03-23 13:00:18.545803	162	0	161	1	2021-03-24 00:00:00
4	Test task 2	18	2020-04-29 17:00:04.990016	2020-04-29 17:00:22.598277	30	0	29	0	2020-05-01 00:00:00
58	Test	63	2021-04-09 13:02:13.320786	2021-04-09 13:20:56.563936	162	1	161	1	2021-04-28 00:00:00
59	d	9	2021-04-19 10:13:26.52761	2021-04-19 10:13:26.52761	162	0	161	1	2021-04-21 00:00:00
6	Test task 4	68	2020-04-29 17:06:56.461331	2020-04-29 17:06:56.461331	30	0	29	0	2020-05-01 00:00:00
7	Test task 5 Updated	32	2020-04-29 17:09:10.299272	2020-04-29 17:09:20.028169	30	0	29	1	2020-05-13 00:00:00
8	Test task top updated	99	2020-04-30 10:41:36.062097	2020-04-30 10:41:41.553906	30	0	29	1	2020-05-02 00:00:00
9	ыав	61	2020-04-30 17:33:28.556322	2020-04-30 17:33:28.556322	30	0	29	2	2020-05-01 00:00:00
15	Task from stage Update	33	2020-05-05 17:58:36.372377	2020-05-05 17:58:52.606668	30	1	29	1	2020-05-26 00:00:00
2	Test task 1 Updated\n	98	2020-04-29 16:55:02.569899	2020-05-29 09:35:12.816156	8	0	2	1	2020-05-30 00:00:00
17	New task from assessment MRL	105	2020-05-29 09:35:57.101991	2020-05-29 09:36:12.301877	8	0	2	1	2020-05-30 00:00:00
14	Send emails to 50 potential advisors within next 2 weeks	91	2020-05-01 17:17:05.171718	2020-05-01 17:20:27.716844	\N	1	\N	2	2020-05-15 00:00:00
18	Get your fucking designs in place 	105	2020-06-09 17:23:00.969102	2020-06-09 17:23:00.969102	52	0	51	2	2020-06-30 00:00:00
19	Interview minimum of 10 developers by due date\nMake final hire by 2 weeks post due date 	17	2020-07-29 19:18:12.437777	2020-07-29 19:18:12.437777	\N	0	\N	2	2020-08-01 00:00:00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."users" ("id", "email", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "created_at", "updated_at", "first_name", "last_name", "company_name", "type", "created_by", "accelerator_id") FROM stdin;
165	andrew.daidone@gmail.com	$2a$11$qXgs.Lj6sOfTbT.EK6pZ3evqyibj1.ye.w4DQ3NolZ1IPKHSnZhqK	\N	\N	\N	2021-08-11 17:57:05.23971	2021-08-11 17:57:05.23971	Andrew	Daidone	\N	Admin	\N	1
107	elidavis@automotivedynamicscorp.com	$2a$11$zhufTZI2eerlVFne/QrlieSZRHc/Bbpc4X3GeuPksiaL1yMXH3mC.	926a9ec2b43f1cbd41e92338d5791e3b1be0e707ca61f32e8428b5e470984510	2020-10-30 13:34:34.293905	\N	2020-10-30 13:34:33.936601	2020-10-30 13:34:34.294366	\N	\N	DeepView	Customer	72	1
108	kim@fuzehub.com	$2a$11$cKDrjjxQ5FHEFfZhyhEk5ubfHIpZ9.WXGWbKAGG8a1Fu2d4QU/uxO	\N	\N	\N	2020-11-29 07:53:55.782256	2020-11-29 07:53:55.782256	Kim	Lloyd	\N	Admin	\N	3
120	rakesh@bhogarmed.com	$2a$11$1mT/GCrXAjre2ID9JM.f7uGK3k4RZQdz00Sf9d03FoLBqTygom2Uq	598379d34b3399b7400935a6643b7748142bbe8c92934103808ee862165291d0	2021-02-15 14:10:22.756166	\N	2021-02-15 14:10:22.498408	2021-02-15 14:10:22.756583	\N	\N	Celcius One	Customer	72	1
118	andrew.daidone.2@gmail.com	$2a$11$w1ljw841VAsQXE0xr8g4uu0As793e0uO4MsBQWzGKCSE51G7ua4eK	\N	\N	\N	2020-12-14 12:19:21.486177	2020-12-15 01:53:32.357697	Andy	Daidone	Test Team	Customer	108	3
109	eric@fuzehub.com	$2a$11$Le/pLoLH/pE6SzWd7DuTX.8jk2B8WMBVYEPmJYYjZ7qm2UOx0VGD.	\N	\N	\N	2020-11-29 07:55:22.149987	2020-12-02 18:38:21.467155	Eric	Fasser	Hub Controller	Customer	108	3
111	everton@fuzehub.com	$2a$11$dXEjmdyMNzM580l30LyHueqdLs/BeOi3XCG00KsQyAmxwCG9/C/fa	\N	\N	\N	2020-12-02 18:37:24.421874	2020-12-02 18:38:59.912653	Everton H.	Henriques	FuzeHub	Customer	108	3
113	alex@grid-guardian.com	$2a$11$rCJbZbGAINqKwhEKubR5K.EteOV5mXHepVYrxchxpI5KmxLdn8xy2	13dd865b66b81113944cf65eefac9d750034911804b2ce86585b9ccb58715300	2020-12-02 18:52:37.401715	\N	2020-12-02 18:52:37.391035	2020-12-02 18:52:37.401976	\N	\N	Grid Guardian - Build4Scale	Customer	108	3
119	kyounes@itac.nyc	$2a$11$5v7CJBp51WrzuD7vF8IAKOrT/wpzAAxyn00hARHSXvmbPNBGFuHI2	\N	\N	\N	2020-12-15 11:24:36.159737	2020-12-15 15:06:50.404193	Kinda	Younes	ITAC - Kinda's Team	Customer	108	3
115	jdagostino@tdo.org	$2a$11$VQT.Dd5iSwnLckmt41mkJOsVmj5l/9xszTjHU.XhuPfzpqBy19niC	\N	\N	\N	2020-12-02 18:54:08.819681	2020-12-03 13:30:34.491505	James	D'Agostino	TDO	Customer	108	3
123	mike.riedlinger@nextcorps.org	$2a$11$.NpW4Ql8/d9/pOckXf/UveBPKhJC/QMS8SYc5G41nzUf/hurBjB4C	f15d8e3a71bf70728e5f558b634c9e680dba10af950556e4afab147ac1acabcf	2021-02-17 19:02:54.36535	\N	2021-02-17 19:02:54.33712	2021-02-17 19:02:54.365774	\N	\N	Mike Riedlinger	Customer	108	3
156	mstein11@u.rochester.edu	$2a$11$d7R8T65ivhwBdvpNG32uhuzbHYVEuziHRz9ej7rAXenzADwxwJK4.	\N	\N	\N	2021-03-01 19:42:39.16648	2021-03-01 19:42:39.16648	Matt	Stein	\N	Admin	\N	3
157	max@communityfunded.com	$2a$11$lADu6myQP15r7cKOP9o6ROcoYFGsYrkU2HM03UJvlEDi3cR3yNoWW	\N	\N	\N	2021-03-22 18:06:50.455117	2021-03-22 18:06:50.455117	Max	Test	\N	Admin	\N	1
164	matt.stein@nextcorps.org	$2a$11$9EiXNgXiUOHwHMm2n2rr9ut/OlPAHKr8FAfRWBYL8vJFLorVAZYVi	\N	\N	\N	2021-05-04 15:46:24.726379	2021-05-04 17:51:56.875278	Matt	Stein	Matt Stein - NextCorps	Customer	108	3
158	max@test.com	$2a$11$K925YxPzeu6yaCx9tPlkku3Wy5HAp4G6woPyf0giojSxf1QTnKo9O	61d1f1fc20fa1fbd6eab515e7d433bd2d75a53bb125b27ee1956067a69bd76e9	2021-03-22 18:09:19.014195	\N	2021-03-22 18:09:17.990687	2021-03-22 18:09:19.014496	\N	\N	test	Customer	157	1
160	fz@test.com	$2a$11$ddfN9PhuKsNhcZi9goYuRODoRfZbSA6Ekpkdi0SUH8spcRUitI1sS	98b8e6c96b742a059f929b68811afafcdbc8d637a044101c5f508e31f8902ef8	2021-03-22 18:17:27.372648	\N	2021-03-22 18:17:27.356961	2021-03-22 18:17:27.37298	\N	\N	f	Customer	157	1
161	test@gmail.com	$2a$11$JHvIEZhf4GltjZ/yahcrUu6SWJt5JEVKOYYFf2157Frei4.g1tG3i	\N	\N	\N	2021-03-23 12:55:00.150855	2021-03-23 12:55:00.150855	First	Last	\N	Admin	\N	1
162	test1@gmail.com	$2a$11$Z3ayaZ/SxLX7PnxUtHnoButmOfIZ0ZOIP1UYJa0YkN/aaup6hH77G	cf633073d54e806d6d9ea4464ed1dce9cf2d97c43529e4aa2aee0ac98d7217a5	2021-03-23 12:55:33.42884	\N	2021-03-23 12:55:33.209939	2021-03-23 12:55:33.429108	\N	\N	121231	Customer	161	1
86	michael@michael2.com	$2a$11$T4jKKWKKw/4pSOC5iBf3BOP32UYE5GTmW6zM/F/SHt3q6Ed9AaCJm	\N	\N	\N	2020-07-28 14:27:09.056306	2020-07-28 14:27:09.056306	Michael	Shatskiy	\N	Admin	\N	3
87	kuvvert@gmail.com	$2a$11$Ov5SFPSV64cPPNDm7Tx7x.qw63jfws5Xr0ImiY6iVfFGzOUyXU6o.	\N	\N	\N	2020-07-28 14:28:01.315505	2020-07-28 14:28:45.788184	Eugene	Lievoshko	Misha	Customer	86	3
88	andy@thepresentapp.com	$2a$11$QXYEnlWRB3GzxEPp/w/9HOWIGQP/bc0a8dRmyRVABlESrKybteldO	\N	\N	\N	2020-07-29 14:57:14.848022	2020-07-29 14:57:14.848022	Andy	Daidone	\N	Admin	\N	3
89	andy@communityfunded.com	$2a$11$jv5jew9c4N//phyO48KLRu9o3Lg8i7xiYSJfgCYvryQptcthgk7yq	\N	\N	\N	2020-07-29 14:57:36.141014	2020-07-29 14:58:49.099245	Andy	Daidone	CF	Customer	88	3
62	nastia@nastia.com	$2a$11$Jv/o4Wsy8p29lU449PaTd.vkJU5lCvQa4G4Gt8RpA1uZ2znPVNSpS	b66dc8d19402ba11359e650308ce9328698fced225adf111560315c531fc6011	2020-06-18 09:52:54.374125	\N	2020-06-18 09:52:54.186763	2020-06-18 09:52:54.37506	\N	\N	Test	Customer	61	1
63	charlie@scrumlaunch.com	$2a$11$9Xw7Hblg8c/dog1t/u.kBeyIuKhA6aO5vOiDSVAq1xwb5o7il9d52	\N	\N	\N	2020-06-18 13:37:32.066407	2020-06-18 13:37:32.066407	Charlie	Lambro	\N	Admin	\N	1
64	charlie101010@gmail.com	$2a$11$DDCnypOlH8PNVkkZMkkU0uPDnlIO6GzWqFfkX6285M.ZLMk6bmxSa	263d7870774d1b64329bc196e4e339bf3029ed44815401d7f20d5de7f1b3fd72	2020-06-18 13:37:51.380636	\N	2020-06-18 13:37:51.35957	2020-06-18 13:37:51.381012	\N	\N	Charlie	Customer	63	1
65	brandon@leanrocketlab.org	$2a$11$EfPuCy9iZl/EJrKzjl5XgedaJ61cuxRC9DzgWaYenbwNkWH6b6gXC	\N	\N	\N	2020-06-18 16:02:55.275596	2020-06-18 16:02:55.275596	Brandon 	Marken	\N	Admin	\N	1
66	ken@leanrocketlab.org	$2a$11$UUNdDKmRHb1j7smPPFZ.Guf6s2JeX6XBFCBojIM3ktOope.mfnQia	\N	\N	\N	2020-06-18 16:03:12.643055	2020-06-18 16:03:12.643055	Ken	Seneff	\N	Admin	\N	1
67	ken@leanrocketgroup.com	$2a$11$gZeZjXYqF8krsKZZB777VOyPsr5JX2l6mdRu4LpXirkNlg7TZgA8e	4a463cf8430dff2a65a7bd59d7d1082e671c5227bc6d66a16da9f50b77b3f612	2020-06-18 16:03:33.1712	\N	2020-06-18 16:03:32.952558	2020-06-18 16:03:33.171688	\N	\N	Lean Rocket	Customer	66	1
68	ken@agilegrowthshop.com	$2a$11$le0.XakSs8a7WBaWuZR2..iToZkrCXeMpO4uPX4ocExX1Gadt.76a	c8e439a1c6b64c57d9d041ee6d6459e09ef03177dd65ae258d3da3370590ee4d	2020-06-18 16:03:44.38433	\N	2020-06-18 16:03:44.370128	2020-06-18 16:03:44.384588	\N	\N	Agile Growth Shop	Customer	65	1
69	dan@moregolfusa.com	$2a$11$LdBFmzly0Ba/A4b.P2MquePNgOhhzI6oxndDGaFs5/3lvPy8iKF7.	5ea44ef87b919186acad165f02a2c7b524a4a1dc0033e826dcc89d91f4c34dcd	2020-06-18 16:06:23.494748	\N	2020-06-18 16:06:23.482898	2020-06-18 16:06:23.494977	\N	\N	More Golf	Customer	65	1
70	brandon@agilegrowthshop.com	$2a$11$Yl4bUol0a/DZvZB5A2ILCOuJagoHRnXU052XPOFmSwkWJUBwTiGBK	17249b022a89be8bf06be61c267bf7fede0c772058917804e8a8ae20ce8039de	2020-06-18 16:08:01.536598	\N	2020-06-18 16:08:01.517979	2020-06-18 16:08:01.536891	\N	\N	AGS Test Co. 	Customer	65	1
72	dradomski@ltu.edu	$2a$11$kslYVxIf6rQP29PHa2.DWOArWK9ldATalmQCgRkWsK/zUBqq1YP9S	\N	\N	\N	2020-06-19 15:41:32.844848	2020-06-19 15:41:32.844848	Dan	Radomski	\N	Admin	\N	1
76	tripp@wavehalo.com	$2a$11$qipGEias8ubOQmA8KxxnzOwOqqOcXKzDsDP9VDpKtqdq/CiPbE.y6	\N	\N	\N	2020-06-19 17:04:33.192187	2020-06-19 17:04:33.192187	\N	\N	Archimedes	Customer	72	1
77	gadams@wareologie.com	$2a$11$PORT4wnOtXpNBD9bUthES.0cGXttNi8cCOdqvNbTpiBBXw9sG9v.y	47011816df8faaba4377a4499c5d039f12c715b9d79bb7c6210ee8f8e9713738	2020-06-19 17:05:11.838932	\N	2020-06-19 17:05:11.823128	2020-06-19 17:05:11.839769	\N	\N	Wareologie	Customer	72	1
78	gaddisgaming@gmail.com	$2a$11$Ay7dgg0AV9pSZN0PnQu0ReVazQYKXWTDSPdb1JTCfBzoM6yHUnrta	\N	\N	\N	2020-06-19 17:05:49.053262	2020-06-19 17:05:49.053262	\N	\N	Gaddis Gaming 	Customer	72	1
79	dwhite@perisense.io	$2a$11$sviLLrp1TzHSu8pbeRGcAuPevvepBgM8qwC44pe3XRhJ3QWp07OD2	fd31c8177f61deb22f7d81414917d5de0cafe46ee6d4760090ccc61bee7643dd	2020-06-19 17:06:20.925702	\N	2020-06-19 17:06:20.914266	2020-06-19 17:06:20.926043	\N	\N	Perisense	Customer	72	1
73	dennisgshaver@gmail.com	$2a$11$oLckh2i20yyLjVwnPPs2IOYHpLzwk2DAoHn6EDYBNyG2c2pq9i/Qe	\N	\N	\N	2020-06-19 15:43:10.589588	2020-06-19 17:27:18.15644	Dennis	Shaver	Dennis Shaver	Customer	72	1
80	michael@michael.com	$2a$11$vUKGfMSnB73eLuSQxDZL0epTpkBREdQyad/O0WJlZgnlp6USnvtSm	\N	\N	\N	2020-06-23 18:37:32.94801	2020-06-23 18:37:32.94801	Michael	Shatskiy	\N	Admin	\N	1
83	brian@solartonic.com	$2a$11$yjjbdG0cco51ZNgfnN7nvuUAxNUBTBXbMElK5BWgexEId5/vTDs6m	4dbc8ce62cb1052fa127d838f4faf3b51b46cdacb5459f9202bac2fbbb9d963b	2020-07-03 13:49:00.793468	\N	2020-07-03 13:49:00.612168	2020-07-03 13:49:00.793758	\N	\N	Solartonic	Customer	72	1
84	michael2@michael.com	$2a$11$cIse2QlpUwZZ3s.K3peQHeUKLpxH6ux0.sTYHPIAvXl00jpwBnyci	\N	\N	\N	2020-07-23 10:29:18.759009	2020-07-23 10:29:18.759009	Michael	Shatskiy	\N	Admin	\N	1
85	michael.shatskiy@gmail.com	$2a$11$kQfuvkR7kAf8YomvbWGnYO2j/nfODpEerZy6iqGtz2E3bwrd3/FPG	\N	\N	\N	2020-07-23 10:30:20.247631	2020-07-23 10:30:53.522663	Misha	Shatskiy	New Cool Company	Customer	84	1
96	anastasia.syrovatskaa@gmail.com	$2a$11$Osc/Bhn.MwClhWer.nFrWecokNgEI5GJM4gFRijsJyygl1FpPO0te	\N	\N	\N	2020-08-12 11:57:13.340835	2020-11-17 17:46:40.320721	Nasta	Syrovatskaya	TestCompany2	Customer	94	1
92	annmarie@l2lmanagement.com	$2a$11$cxLBw5lzy3hwPV76d.i.HO8WPG7DeYtHyswuMWuB2VH6tdEJpUQcu	60c103784ab5644de5354729cf0c861e694db270776d350c43423cdacbe9049f	2020-08-02 16:58:30.704945	\N	2020-08-02 16:58:30.484334	2020-08-02 16:58:30.705243	\N	\N	CS Coatings LLC	Customer	72	1
122	annette.brenner@nextcorps.org	$2a$11$dqNHNFL3XTpBRkKsJ7CdmubCZ6OqXrj4leRoBGU6.Nu0omRv2y6m.	63c39a01c2f7f0b5793a57137839d6585aedc4b9920167a0016f25fd97cfba8f	2021-02-17 19:02:30.987048	\N	2021-02-17 19:02:30.974566	2021-02-17 19:02:30.987384	\N	\N	Annette Brenner - NextCorps	Customer	108	3
94	kkk@kkk.com	$2a$11$9cOd4WjF4jFnzLbThvGftu9GU9caK.tS4daLsOH6ZvqaQhdOe/E3K	\N	\N	\N	2020-08-12 11:56:31.920161	2020-08-12 11:56:31.920161	Michael	Shatskiy	\N	Admin	\N	1
159	t@t.com	$2a$11$Be59VivnPvmrKMZgA/Di5ObJOHwU8xDyrxKzEjKtDAoxKd3X2LxZ2	e7ab4ec664682cca3bac502b8e3b85ca9ee500c0716f0a985c059eb106a9f39e	2021-03-22 18:16:52.301444	\N	2021-03-22 18:16:52.202883	2021-03-22 18:16:52.301887	\N	\N	sdfsdf	Customer	157	1
112	michaell@ceg.org	$2a$11$Xf3MFYq26uF5KUGUONZupuJLWBRvidz3neDWuEGygWbrP4U7nNHi6	\N	\N	\N	2020-12-02 18:51:55.731824	2020-12-02 19:41:48.203058	Michael	Lobsinger	CEG	Customer	108	3
110	tyler@fuzehub.com	$2a$11$UUH2pfqMVJup2EfIZoTsMec7greKYSKGAHX1Iwp9iW.nrr5JqEcBu	\N	\N	\N	2020-11-29 07:56:41.544612	2020-12-02 18:38:51.95105	Tyler	Roach	Grid Guardian	Customer	108	3
98	anastasia.syrovatskaa@outloook.com	$2a$11$e/Hn7/8mV30lDLOy4YWEtO0LkJ7V.U0uE10CYpbUQoscowxJGeepS	\N	\N	\N	2020-08-13 10:05:03.745475	2020-08-13 10:05:03.745475	Admin	Adm	\N	Admin	\N	1
97	ron@sanapackaging.com	$2a$11$Ys/aY4zwTnV9xVwaa0a2ve/ZHdRscNgnsiTLGy5eF3k6Otd29962S	\N	\N	\N	2020-08-12 21:48:50.425165	2020-08-14 15:37:38.471941	Ron	Basak-Smith 	Sana Packaging	Customer	72	1
100	m@m.com	$2a$11$GRVsVYDZO/.ic8iwrooyIuV.kB86U233mGRWmPDwzyJpP1uc68ULy	c1e42483974acbd1c31d604d2a536382d6aeda51e00c1cd1162291449e6ece52	2020-08-19 18:37:26.173027	\N	2020-08-19 18:37:25.876536	2020-08-19 18:37:26.17348	\N	\N	Test2	Customer	80	1
101	andy@codecatalyst.co	$2a$11$WTRIa.WOOMQU41D.TIvd1Oiio0EsncuiEzLrU2VEj2C0zpQmAWmjq	\N	\N	\N	2020-08-25 15:56:07.356983	2020-08-25 15:56:07.356983	Andy	Daidone	\N	Admin	\N	1
114	james.vernay@thehubcontroller.com	$2a$11$YpF7B1S/ernhuL3v9TTLueXF4p..JVYU1AtnGYXsy2RUhgTPFZiam	b3507836ed73b52665cf2467a3fd76a7cef5b6d8f49d27a9b881c04e7fda02e0	2020-12-02 18:53:42.54616	\N	2020-12-02 18:53:42.536276	2020-12-02 18:53:42.546354	\N	\N	HubControls - Build4Scale	Customer	108	3
102	andy@scrumlaunch.com	$2a$11$yt.GRD0YjOYaUzMw7Ac9XugpwHsw3aeoII2rMup4AjaPIAFavgjL2	0860b06f1a81ba1c516709b6695b68b4cdce0b74b2c5e2e9155061f6b960c7e1	2020-08-25 15:56:21.73556	\N	2020-08-25 15:56:21.373663	2020-08-25 15:56:21.736047	\N	\N	ScrumLaunch	Customer	101	1
117	mmckay@itac.nyc	$2a$11$BB95VNDu3L.11n4ViYYAn.m5lxKMHkLnqnJWxJAHI89N5hyI0bnPy	f2bf21cce51b81c9b419521a3b0e548d9bce8e912613cc44ce116726ccc38721	2020-12-02 18:54:37.147661	\N	2020-12-02 18:54:37.136734	2020-12-02 18:54:37.147868	\N	\N	ITAC - Mary	Customer	108	3
103	gonenz@onvego.com	$2a$11$ikcxLn.fPCQ9QP9vyJ37lO9Q.5gn.pUP8AoF2sfvkvGc5xJG7vRv2	\N	\N	\N	2020-08-30 01:39:17.306285	2020-09-02 01:45:11.051969	Gonen	Ziv	Onvego	Customer	72	1
104	schofield.bill@gmail.com	$2a$11$GiWv8ehrHcxTo21hVvK2MOohddbLJfsCNMphbhx6OtRwmZgiB1/Iq	\N	\N	\N	2020-09-01 12:39:19.710414	2020-09-10 10:58:18.057302	William	Schofield	AptumBuild	Customer	72	1
105	andy@fgnight.com	$2a$11$.0t.UIol2RL7WtNPB8dcpO6/knP7UI8162P5Jso.dG75EkX5qM2x6	\N	\N	\N	2020-09-10 15:33:36.864666	2020-09-10 15:34:09.980351	A	D	FGN	Customer	101	1
\.


--
-- Name: accelerators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."accelerators_id_seq"', 3, true);


--
-- Name: assessment_progresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."assessment_progresses_id_seq"', 51, true);


--
-- Name: assessments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."assessments_id_seq"', 3, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."categories_id_seq"', 9, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."notifications_id_seq"', 59, true);


--
-- Name: stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."stages_id_seq"', 248, true);


--
-- Name: sub_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."sub_categories_id_seq"', 40, true);


--
-- Name: sub_category_progresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."sub_category_progresses_id_seq"', 470, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."tasks_id_seq"', 59, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."users_id_seq"', 165, true);


--
-- Name: accelerators accelerators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."accelerators"
    ADD CONSTRAINT "accelerators_pkey" PRIMARY KEY ("id");


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ar_internal_metadata"
    ADD CONSTRAINT "ar_internal_metadata_pkey" PRIMARY KEY ("key");


--
-- Name: assessment_progresses assessment_progresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."assessment_progresses"
    ADD CONSTRAINT "assessment_progresses_pkey" PRIMARY KEY ("id");


--
-- Name: assessments assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."assessments"
    ADD CONSTRAINT "assessments_pkey" PRIMARY KEY ("id");


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."schema_migrations"
    ADD CONSTRAINT "schema_migrations_pkey" PRIMARY KEY ("version");


--
-- Name: stages stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."stages"
    ADD CONSTRAINT "stages_pkey" PRIMARY KEY ("id");


--
-- Name: sub_categories sub_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sub_categories"
    ADD CONSTRAINT "sub_categories_pkey" PRIMARY KEY ("id");


--
-- Name: sub_category_progresses sub_category_progresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sub_category_progresses"
    ADD CONSTRAINT "sub_category_progresses_pkey" PRIMARY KEY ("id");


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tasks"
    ADD CONSTRAINT "tasks_pkey" PRIMARY KEY ("id");


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");


--
-- Name: index_users_on_company_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_users_on_company_name" ON "public"."users" USING "btree" ("company_name");


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_users_on_email" ON "public"."users" USING "btree" ("email");


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "public"."users" USING "btree" ("reset_password_token");


--
-- PostgreSQL database dump complete
--

