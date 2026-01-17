--
-- PostgreSQL database dump
--

\restrict hTeqd2VVtuIIz1jfMWTCYPSYhM3eIfCj2ddTlrEsckinhXlVI524GTiADHKL4GI

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-17 16:53:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 229 (class 1259 OID 16592)
-- Name: gallery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gallery (
    id integer NOT NULL,
    title character varying(100),
    image_path text NOT NULL,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.gallery OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16591)
-- Name: gallery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gallery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gallery_id_seq OWNER TO postgres;

--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 228
-- Name: gallery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gallery_id_seq OWNED BY public.gallery.id;


--
-- TOC entry 225 (class 1259 OID 16549)
-- Name: order_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_services (
    order_id integer NOT NULL,
    service_id integer NOT NULL,
    kg numeric(8,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL
);


ALTER TABLE public.order_services OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16528)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    user_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_kg numeric(8,2),
    total_amount numeric(12,2) NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying,
    notes text,
    delivery_type character varying(20) DEFAULT 'pickup'::character varying,
    pickup_address text,
    pickup_phone character varying(20),
    CONSTRAINT orders_delivery_type_check CHECK (((delivery_type)::text = ANY ((ARRAY['pickup'::character varying, 'dropoff'::character varying])::text[]))),
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Processing'::character varying, 'Completed'::character varying, 'Delivered'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16527)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO postgres;

--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 223
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 227 (class 1259 OID 16569)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    order_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    method character varying(30),
    status character varying(20) DEFAULT 'Paid'::character varying,
    CONSTRAINT payments_method_check CHECK (((method)::text = ANY ((ARRAY['COD'::character varying, 'Transfer'::character varying, 'E-Wallet'::character varying])::text[]))),
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Paid'::character varying, 'Failed'::character varying])::text[])))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16568)
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 226
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- TOC entry 222 (class 1259 OID 16516)
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    service_id integer NOT NULL,
    name character varying(100) NOT NULL,
    price numeric(10,2) NOT NULL,
    estimated_days integer DEFAULT 2,
    unit character varying(20) DEFAULT 'Kg'::character varying
);


ALTER TABLE public.services OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16515)
-- Name: services_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_service_id_seq OWNER TO postgres;

--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 221
-- Name: services_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_service_id_seq OWNED BY public.services.service_id;


--
-- TOC entry 220 (class 1259 OID 16498)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    phone character varying(20),
    role character varying(20) NOT NULL,
    address text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['customer'::character varying, 'admin'::character varying, 'superadmin'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16497)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4892 (class 2604 OID 16595)
-- Name: gallery id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery ALTER COLUMN id SET DEFAULT nextval('public.gallery_id_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 16531)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 4889 (class 2604 OID 16572)
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 16519)
-- Name: services service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.services_service_id_seq'::regclass);


--
-- TOC entry 4880 (class 2604 OID 16501)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5078 (class 0 OID 16592)
-- Dependencies: 229
-- Data for Name: gallery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gallery (id, title, image_path, uploaded_at) FROM stdin;
5	Cuci Komplit Setrika	foto1.jpg	2026-01-15 22:31:55.929953
6	Cuci Sepatu	foto2.jpg	2026-01-15 22:31:55.929953
7	Cuci Karpet	foto3.jpg	2026-01-15 22:31:55.929953
11	cuci Jas	1768641866897_cuci jas.jpg	2026-01-17 16:24:27.004521
\.


--
-- TOC entry 5074 (class 0 OID 16549)
-- Dependencies: 225
-- Data for Name: order_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_services (order_id, service_id, kg, subtotal) FROM stdin;
1	1	5.50	44000.00
3	5	1.00	25000.00
4	2	8.00	0.00
5	1	8.00	64000.00
6	1	8.00	64000.00
7	1	3.00	24000.00
8	6	1.00	55000.00
9	1	2.00	16000.00
10	1	3.00	24000.00
11	2	3.00	36000.00
\.


--
-- TOC entry 5073 (class 0 OID 16528)
-- Dependencies: 224
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, user_id, order_date, total_kg, total_amount, status, notes, delivery_type, pickup_address, pickup_phone) FROM stdin;
3	3	2025-12-30 10:00:00	1.00	25000.00	Completed	\N	dropoff	\N	081234567890
4	6	2026-01-03 15:11:42.969004	8.00	0.00	Completed	Pembayaran: Transfer	pickup	\N	\N
2	4	2025-12-29 14:00:00	2.00	60000.00	Completed	\N	pickup	Jl. Sudirman No. 10	087788899999
5	6	2026-01-03 23:00:55.833162	8.00	64000.00	Completed	Pembayaran: COD	dropoff	-	08568648188
6	6	2026-01-07 15:36:00.166304	8.00	64000.00	Completed	Pembayaran: COD	pickup	ghgtttyf	08568648188
7	6	2026-01-07 16:42:51.533272	3.00	24000.00	Completed	Pembayaran: COD	pickup	awfeafawfa	08568648188
9	9	2026-01-11 21:19:52.304233	2.00	16000.00	Completed	Metode Bayar: COD. Catatan: 	dropoff		34436197113
10	9	2026-01-11 21:40:59.010795	3.00	24000.00	Completed	Pembayaran: COD	dropoff	-	08568648188
11	11	2026-01-13 23:21:51.697902	3.00	36000.00	Completed	Pembayaran: COD | Catatan: jangan pakai pemutih\r\n	dropoff	-	08568648188
1	3	2025-12-28 09:00:00	5.50	44000.00	Completed	\N	pickup	Jl. Merdeka No. 45	081234567890
8	6	2026-01-07 16:50:23.18949	1.00	55000.00	Completed	Pembayaran: COD | Catatan: -	pickup	ghgtttyf	08568648188
\.


--
-- TOC entry 5076 (class 0 OID 16569)
-- Dependencies: 227
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, order_id, amount, payment_date, method, status) FROM stdin;
1	3	25000.00	2026-01-03 14:55:18.830332	Transfer	Paid
\.


--
-- TOC entry 5071 (class 0 OID 16516)
-- Dependencies: 222
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (service_id, name, price, estimated_days, unit) FROM stdin;
1	Cuci Kiloan Regular	8000.00	3	Kg
2	Cuci Kiloan Express	12000.00	1	Kg
3	Cuci + Setrika	10000.00	2	Kg
5	Cuci Bedcover Besar	25000.00	3	Pcs
7	Cuci Karpet	20000.00	4	Meter
9	Setrika	6000.00	2	Kg
6	Dry Clean Jas	45000.00	5	Pcs
11	Cuci Sepatu	25000.00	2	Pasang
\.


--
-- TOC entry 5069 (class 0 OID 16498)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, email, password_hash, phone, role, address, created_at) FROM stdin;
1	Super Admin	admin@laundry.com	super123	08129999999	superadmin	Kantor Pusat	2026-01-03 14:53:52.760931
2	Staff Kasir	staff@laundry.com	admin123	0857123123	admin	Cabang Jakarta	2026-01-03 14:53:52.760931
3	Budi Santoso	budi@gmail.com	123456	081234567890	customer	Jl. Merdeka No. 45, Jakarta Selatan	2026-01-03 14:53:52.760931
4	Siti Aminah	siti@yahoo.com	123456	087788899999	customer	Jl. Sudirman No. 10, Bandung	2026-01-03 14:53:52.760931
5	Andi Pratama	andi@gmail.com	123456	081344455566	customer	Komplek Permata Hijau Blok A1	2026-01-03 14:53:52.760931
6	Muhamad Rojali	user@gmail.com	super123	08568648188	customer	ghgtttyf	2026-01-03 15:06:16.992007
9	radit	radit@gmail.com	123	08568648188	customer	ghgtttyf	2026-01-11 21:10:07.268192
10	Staff	staff@gmail.com	123	3847103104871	admin		2026-01-11 21:56:31.843196
11	user testing	tester@gmail.com	123	\N	customer	\N	2026-01-13 23:10:50.930886
\.


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 228
-- Name: gallery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gallery_id_seq', 11, true);


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 223
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 11, true);


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 226
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, true);


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 221
-- Name: services_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_service_id_seq', 11, true);


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 11, true);


--
-- TOC entry 4916 (class 2606 OID 16602)
-- Name: gallery gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gallery
    ADD CONSTRAINT gallery_pkey PRIMARY KEY (id);


--
-- TOC entry 4910 (class 2606 OID 16557)
-- Name: order_services order_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_services
    ADD CONSTRAINT order_services_pkey PRIMARY KEY (order_id, service_id);


--
-- TOC entry 4908 (class 2606 OID 16543)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4912 (class 2606 OID 16583)
-- Name: payments payments_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_key UNIQUE (order_id);


--
-- TOC entry 4914 (class 2606 OID 16581)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 4905 (class 2606 OID 16526)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- TOC entry 4901 (class 2606 OID 16514)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4903 (class 2606 OID 16512)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4906 (class 1259 OID 16590)
-- Name: idx_orders_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_user_id ON public.orders USING btree (user_id);


--
-- TOC entry 4899 (class 1259 OID 16589)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- TOC entry 4918 (class 2606 OID 16558)
-- Name: order_services order_services_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_services
    ADD CONSTRAINT order_services_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 4919 (class 2606 OID 16563)
-- Name: order_services order_services_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_services
    ADD CONSTRAINT order_services_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(service_id) ON DELETE CASCADE;


--
-- TOC entry 4917 (class 2606 OID 16544)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4920 (class 2606 OID 16584)
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


-- Completed on 2026-01-17 16:53:44

--
-- PostgreSQL database dump complete
--

\unrestrict hTeqd2VVtuIIz1jfMWTCYPSYhM3eIfCj2ddTlrEsckinhXlVI524GTiADHKL4GI

