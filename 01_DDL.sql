--
-- PostgreSQL database dump
--

\restrict vwVnLbu19MxQRNjgXTYN3CJn1WdSegDgOvsuCedwjx4UlXygFcGVtFs9LPh1bBd

-- Dumped from database version 17.10 (98a80fa)
-- Dumped by pg_dump version 17.10 (Homebrew)

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
-- Name: availability; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.availability (
    branch_code integer NOT NULL,
    product_code integer NOT NULL,
    quantity integer NOT NULL,
    local_price numeric(6,2) NOT NULL,
    CONSTRAINT availability_local_price_check CHECK ((local_price > (0)::numeric)),
    CONSTRAINT availability_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.availability OWNER TO neondb_owner;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.branches (
    branch_code integer NOT NULL,
    phone character varying(20) NOT NULL,
    city character varying(100) NOT NULL,
    street character varying(150) NOT NULL,
    postal_code character varying(10) NOT NULL,
    number character varying(10) NOT NULL
);


ALTER TABLE public.branches OWNER TO neondb_owner;

--
-- Name: current_employee; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.current_employee (
    employee_code integer NOT NULL,
    hiring_day smallint NOT NULL,
    hiring_month smallint NOT NULL,
    hiring_year smallint NOT NULL,
    CONSTRAINT current_employee_hiring_day_check CHECK (((hiring_day >= 1) AND (hiring_day <= 31))),
    CONSTRAINT current_employee_hiring_month_check CHECK (((hiring_month >= 1) AND (hiring_month <= 12))),
    CONSTRAINT current_employee_hiring_year_check CHECK (((hiring_year >= 1970) AND (hiring_year <= 2025)))
);


ALTER TABLE public.current_employee OWNER TO neondb_owner;

--
-- Name: customer_phones; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.customer_phones (
    loyalty_card_id integer NOT NULL,
    phone_number character varying(20) NOT NULL
);


ALTER TABLE public.customer_phones OWNER TO neondb_owner;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.customers (
    loyalty_card_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    accumulated_points integer DEFAULT 0,
    CONSTRAINT customers_accumulated_points_check CHECK ((accumulated_points >= 0))
);


ALTER TABLE public.customers OWNER TO neondb_owner;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.departments (
    department_code character(3) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.departments OWNER TO neondb_owner;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.employees (
    employee_code integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    ssn character(16) NOT NULL,
    role character varying(50) NOT NULL,
    gender character(1),
    contract_type character varying(50),
    branch_code integer NOT NULL,
    department_code character(3) NOT NULL,
    CONSTRAINT employees_gender_check CHECK ((gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar, 'X'::bpchar])))
);


ALTER TABLE public.employees OWNER TO neondb_owner;

--
-- Name: former_employee; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.former_employee (
    employee_code integer NOT NULL,
    termination_day smallint NOT NULL,
    termination_month smallint NOT NULL,
    termination_year smallint NOT NULL,
    CONSTRAINT former_employee_termination_day_check CHECK (((termination_day >= 1) AND (termination_day <= 31))),
    CONSTRAINT former_employee_termination_month_check CHECK (((termination_month >= 1) AND (termination_month <= 12))),
    CONSTRAINT former_employee_termination_year_check CHECK (((termination_year >= 1970) AND (termination_year <= 2025)))
);


ALTER TABLE public.former_employee OWNER TO neondb_owner;

--
-- Name: procurements; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.procurements (
    supplier_code integer NOT NULL,
    product_code integer NOT NULL,
    branch_code integer NOT NULL
);


ALTER TABLE public.procurements OWNER TO neondb_owner;

--
-- Name: products; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.products (
    product_code integer NOT NULL,
    category character varying(100) NOT NULL,
    detail character varying(150),
    brand character varying(100),
    standard_price numeric(6,2) NOT NULL,
    department_code character(3) NOT NULL,
    CONSTRAINT products_standard_price_check CHECK ((standard_price > (0)::numeric))
);


ALTER TABLE public.products OWNER TO neondb_owner;

--
-- Name: purchases; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.purchases (
    loyalty_card_id integer NOT NULL,
    receipt_number integer NOT NULL
);


ALTER TABLE public.purchases OWNER TO neondb_owner;

--
-- Name: receipt_details; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.receipt_details (
    receipt_number integer NOT NULL,
    product_code integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(6,2) NOT NULL,
    CONSTRAINT receipt_details_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT receipt_details_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.receipt_details OWNER TO neondb_owner;

--
-- Name: receipts; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.receipts (
    receipt_number integer NOT NULL,
    receipt_hour integer NOT NULL,
    receipt_minute integer NOT NULL,
    receipt_second integer NOT NULL,
    total_amount numeric(8,2) DEFAULT 0.00,
    employee_code integer NOT NULL,
    receipt_day integer,
    receipt_month integer,
    receipt_year integer,
    CONSTRAINT receipts_receipt_hour_check CHECK (((receipt_hour >= 0) AND (receipt_hour <= 23))),
    CONSTRAINT receipts_receipt_minute_check CHECK (((receipt_minute >= 0) AND (receipt_minute <= 59))),
    CONSTRAINT receipts_receipt_second_check CHECK (((receipt_second >= 0) AND (receipt_second <= 59))),
    CONSTRAINT receipts_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE public.receipts OWNER TO neondb_owner;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.suppliers (
    supplier_code integer NOT NULL,
    vat_number character(13) NOT NULL,
    company_name character varying(150) NOT NULL,
    headquarter_city character varying(100) NOT NULL
);


ALTER TABLE public.suppliers OWNER TO neondb_owner;

--
-- Data for Name: availability; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: current_employee; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: customer_phones; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: former_employee; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: procurements; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: receipt_details; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: receipts; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_pkey PRIMARY KEY (branch_code, product_code);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (branch_code);


--
-- Name: customer_phones customer_phones_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.customer_phones
    ADD CONSTRAINT customer_phones_pkey PRIMARY KEY (loyalty_card_id, phone_number);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (loyalty_card_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_code);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_code);


--
-- Name: employees employees_ssn_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_ssn_key UNIQUE (ssn);


--
-- Name: current_employee pk_current_employee; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.current_employee
    ADD CONSTRAINT pk_current_employee PRIMARY KEY (employee_code);


--
-- Name: former_employee pk_former_employee; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.former_employee
    ADD CONSTRAINT pk_former_employee PRIMARY KEY (employee_code);


--
-- Name: procurements procurements_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_pkey PRIMARY KEY (supplier_code, product_code, branch_code);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_code);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (loyalty_card_id, receipt_number);


--
-- Name: purchases purchases_receipt_number_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_receipt_number_key UNIQUE (receipt_number);


--
-- Name: receipt_details receipt_details_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.receipt_details
    ADD CONSTRAINT receipt_details_pkey PRIMARY KEY (receipt_number, product_code);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (receipt_number);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_code);


--
-- Name: suppliers suppliers_vat_number_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_vat_number_key UNIQUE (vat_number);


--
-- Name: availability availability_branch_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_branch_code_fkey FOREIGN KEY (branch_code) REFERENCES public.branches(branch_code);


--
-- Name: availability availability_product_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_product_code_fkey FOREIGN KEY (product_code) REFERENCES public.products(product_code);


--
-- Name: customer_phones customer_phones_loyalty_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.customer_phones
    ADD CONSTRAINT customer_phones_loyalty_card_id_fkey FOREIGN KEY (loyalty_card_id) REFERENCES public.customers(loyalty_card_id);


--
-- Name: employees employees_branch_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_branch_code_fkey FOREIGN KEY (branch_code) REFERENCES public.branches(branch_code);


--
-- Name: employees employees_department_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_code_fkey FOREIGN KEY (department_code) REFERENCES public.departments(department_code);


--
-- Name: current_employee fk_current_employee; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.current_employee
    ADD CONSTRAINT fk_current_employee FOREIGN KEY (employee_code) REFERENCES public.employees(employee_code) ON DELETE CASCADE;


--
-- Name: former_employee fk_former_employee; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.former_employee
    ADD CONSTRAINT fk_former_employee FOREIGN KEY (employee_code) REFERENCES public.employees(employee_code) ON DELETE CASCADE;


--
-- Name: procurements procurements_branch_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_branch_code_fkey FOREIGN KEY (branch_code) REFERENCES public.branches(branch_code);


--
-- Name: procurements procurements_product_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_product_code_fkey FOREIGN KEY (product_code) REFERENCES public.products(product_code);


--
-- Name: procurements procurements_supplier_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_supplier_code_fkey FOREIGN KEY (supplier_code) REFERENCES public.suppliers(supplier_code);


--
-- Name: products products_department_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_department_code_fkey FOREIGN KEY (department_code) REFERENCES public.departments(department_code);


--
-- Name: purchases purchases_loyalty_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_loyalty_card_id_fkey FOREIGN KEY (loyalty_card_id) REFERENCES public.customers(loyalty_card_id);


--
-- Name: purchases purchases_receipt_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_receipt_number_fkey FOREIGN KEY (receipt_number) REFERENCES public.receipts(receipt_number);


--
-- Name: receipt_details receipt_details_product_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.receipt_details
    ADD CONSTRAINT receipt_details_product_code_fkey FOREIGN KEY (product_code) REFERENCES public.products(product_code);


--
-- Name: receipt_details receipt_details_receipt_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.receipt_details
    ADD CONSTRAINT receipt_details_receipt_number_fkey FOREIGN KEY (receipt_number) REFERENCES public.receipts(receipt_number);


--
-- Name: receipts receipts_employee_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_employee_code_fkey FOREIGN KEY (employee_code) REFERENCES public.employees(employee_code);


--
-- PostgreSQL database dump complete
--

\unrestrict vwVnLbu19MxQRNjgXTYN3CJn1WdSegDgOvsuCedwjx4UlXygFcGVtFs9LPh1bBd

