--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)

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

--
-- Name: nira; Type: SCHEMA; Schema: -; Owner: dev
--

CREATE SCHEMA nira;


ALTER SCHEMA nira OWNER TO dev;

--
-- Name: totalhourtrigger_function(); Type: FUNCTION; Schema: nira; Owner: admin
--

CREATE FUNCTION nira.totalhourtrigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    lastrecord time;
BEGIN
    SELECT INTO lastrecord total_hours
    FROM nira.main_attendances
    WHERE users_id = NEW.users_id
        AND date = NEW.date
    ORDER BY id DESC
    LIMIT 1 OFFSET 1;

    IF NEW.status = false THEN
        IF lastrecord IS NOT NULL THEN
            NEW.total_hours = (NEW.check_out - NEW.check_in) + lastrecord;
        ELSE
            NEW.total_hours = NEW.check_out - NEW.check_in;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION nira.totalhourtrigger_function() OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: main_attendances; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_attendances (
    id integer NOT NULL,
    users_id integer,
    employee_name character varying(50),
    reporting_manager_id integer,
    date date,
    check_in timestamp without time zone,
    check_out timestamp without time zone,
    first_check_in timestamp without time zone,
    last_check_out timestamp without time zone,
    total_hours time without time zone,
    new_first_check_in timestamp without time zone,
    new_last_check_out timestamp without time zone,
    new_total_hours time without time zone,
    check_in_location character varying(250),
    check_out_location character varying(250),
    check_in_device character varying(50),
    check_out_device character varying(50),
    payable_hours character varying(50),
    status boolean,
    shifts_id integer,
    reason text,
    description text,
    regularization_check_in timestamp without time zone,
    regularization_check_out timestamp without time zone,
    regularization_total_hours time without time zone,
    regularization_status character varying(50),
    attendance_status character varying(50),
    is_regularized boolean,
    comment text,
    color_code character varying(25),
    leave_duration text,
    old_attendance_status text,
    old_payable_hours text,
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone
);


ALTER TABLE nira.main_attendances OWNER TO admin;

--
-- Name: main_attendances_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_attendances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_attendances_id_seq OWNER TO admin;

--
-- Name: main_attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_attendances_id_seq OWNED BY nira.main_attendances.id;


--
-- Name: main_business_units; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_business_units (
    id integer NOT NULL,
    departments_id integer NOT NULL,
    orgs_id integer NOT NULL,
    unit_name character varying(255) NOT NULL,
    unit_code character varying(50),
    description text,
    start_date date,
    country character varying(150),
    state character varying(150),
    city character varying(150),
    address_1 text,
    address_2 text,
    address_3 text,
    time_zone integer,
    unit_head character varying(255),
    service_desk_flag boolean,
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone,
    is_active boolean
);


ALTER TABLE nira.main_business_units OWNER TO admin;

--
-- Name: main_business_units_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_business_units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_business_units_id_seq OWNER TO admin;

--
-- Name: main_business_units_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_business_units_id_seq OWNED BY nira.main_business_units.id;


--
-- Name: main_currencies; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_currencies (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    name character varying(50) NOT NULL,
    symbol character varying(10),
    exchange_rate numeric(10,4),
    created_by integer,
    modified_by integer,
    createddate timestamp without time zone,
    modifieddate timestamp without time zone
);


ALTER TABLE nira.main_currencies OWNER TO admin;

--
-- Name: main_currencies_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_currencies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_currencies_id_seq OWNER TO admin;

--
-- Name: main_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_currencies_id_seq OWNED BY nira.main_currencies.id;


--
-- Name: main_departments; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_departments (
    id integer NOT NULL,
    orgs_id integer NOT NULL,
    business_units_id integer NOT NULL,
    dept_name character varying(150) NOT NULL,
    dept_code character varying(20),
    description character varying(255),
    start_date date,
    country character varying(150),
    state character varying(150),
    city character varying(150),
    address_1 text NOT NULL,
    address_2 text,
    address_3 text,
    time_zone character varying(250),
    dept_head integer,
    unit_id integer,
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone,
    is_active boolean DEFAULT true
);


ALTER TABLE nira.main_departments OWNER TO admin;

--
-- Name: main_departments_id_seq1; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_departments_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_departments_id_seq1 OWNER TO admin;

--
-- Name: main_departments_id_seq1; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_departments_id_seq1 OWNED BY nira.main_departments.id;


--
-- Name: main_designations; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_designations (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone
);


ALTER TABLE nira.main_designations OWNER TO admin;

--
-- Name: main_designations_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_designations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_designations_id_seq OWNER TO admin;

--
-- Name: main_designations_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_designations_id_seq OWNED BY nira.main_designations.id;


--
-- Name: main_employees; Type: TABLE; Schema: nira; Owner: dev
--

CREATE TABLE nira.main_employees (
    id integer NOT NULL,
    user_id integer,
    date_of_joining date,
    date_of_leaving date,
    reporting_manager integer,
    emp_status_id integer,
    business_unit_id integer,
    department_id integer,
    job_title_id integer,
    position_id integer,
    years_exp character varying(20),
    holiday_group integer,
    prefix_id integer,
    extension_number character varying(20),
    office_number character varying(100),
    office_fax_number character varying(100),
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone,
    is_active boolean,
    is_org_head boolean
);


ALTER TABLE nira.main_employees OWNER TO dev;

--
-- Name: main_holidays; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_holidays (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    holiday date NOT NULL,
    is_deleted boolean,
    is_optional boolean,
    "from" character varying(20),
    "to" character varying(20),
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone
);


ALTER TABLE nira.main_holidays OWNER TO admin;

--
-- Name: main_holidays_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_holidays_id_seq OWNER TO admin;

--
-- Name: main_holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_holidays_id_seq OWNED BY nira.main_holidays.id;


--
-- Name: main_modules; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_modules (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    is_active boolean,
    is_aienabled boolean,
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone
);


ALTER TABLE nira.main_modules OWNER TO admin;

--
-- Name: main_modules_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_modules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_modules_id_seq OWNER TO admin;

--
-- Name: main_modules_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_modules_id_seq OWNED BY nira.main_modules.id;


--
-- Name: main_org_details; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_org_details (
    id integer NOT NULL,
    organization_name character varying(255),
    org_image character varying(255),
    domain character varying(255),
    website character varying(255),
    org_description text,
    total_employees character varying(150),
    registration_number character varying(255),
    org_start_date timestamp with time zone,
    phone_number character varying(255),
    secondary_phone character varying(255),
    email character varying(255),
    secondary_email character varying(255),
    fax_number character varying(255),
    country character varying(150),
    state character varying(150),
    city character varying(150),
    address_1 text,
    address_2 text,
    address_3 text,
    description text,
    org_head character varying(255),
    designation character varying[],
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone,
    is_active boolean DEFAULT true
);


ALTER TABLE nira.main_org_details OWNER TO admin;

--
-- Name: main_org_details_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_org_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_org_details_id_seq OWNER TO admin;

--
-- Name: main_org_details_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_org_details_id_seq OWNED BY nira.main_org_details.id;


--
-- Name: main_roles; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_roles (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    permissions text NOT NULL,
    role_type character varying(256),
    is_deleted boolean,
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone
);


ALTER TABLE nira.main_roles OWNER TO admin;

--
-- Name: main_shifts; Type: TABLE; Schema: nira; Owner: dev
--

CREATE TABLE nira.main_shifts (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    "from" character varying(50) NOT NULL,
    "to" character varying(50) NOT NULL,
    reason text,
    is_deleted boolean,
    financial_year character varying(20),
    created_by integer,
    modified_by integer,
    createddate timestamp without time zone,
    modifieddate timestamp without time zone
);


ALTER TABLE nira.main_shifts OWNER TO dev;

--
-- Name: main_shifts_id_seq; Type: SEQUENCE; Schema: nira; Owner: dev
--

CREATE SEQUENCE nira.main_shifts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_shifts_id_seq OWNER TO dev;

--
-- Name: main_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: dev
--

ALTER SEQUENCE nira.main_shifts_id_seq OWNED BY nira.main_shifts.id;


--
-- Name: main_sitepreferences; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_sitepreferences (
    id integer NOT NULL,
    emp_code character varying(255),
    nationality_id character varying(255),
    date_format_id character varying(255),
    time_format_id character varying(255),
    time_zone_id character varying(255),
    currency_id character varying(255),
    password_id character varying(255),
    description character varying(255),
    font_type character varying(255),
    font_size character varying(255),
    colour_primary character varying(255),
    colour_secondry character varying(255),
    colour_tertiary character varying(255),
    login_image character varying(255),
    login_message character varying(255),
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone,
    is_active boolean,
    org_modules jsonb,
    employment_status character varying[],
    country character varying(255),
    state character varying(255),
    city character varying(255),
    orgs_id integer NOT NULL
);


ALTER TABLE nira.main_sitepreferences OWNER TO admin;

--
-- Name: main_sitepreferences_id_seq1; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_sitepreferences_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_sitepreferences_id_seq1 OWNER TO admin;

--
-- Name: main_sitepreferences_id_seq1; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_sitepreferences_id_seq1 OWNED BY nira.main_sitepreferences.id;


--
-- Name: main_users; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.main_users (
    id integer NOT NULL,
    employee_id character varying(20),
    salutation character varying(10),
    first_name character varying(50),
    last_name character varying(50),
    dob date,
    doj date,
    email_address character varying(50),
    contact_number character varying(20),
    password character varying(256),
    reporting_manager_id character varying(50),
    designations_id integer,
    user_type character varying(50),
    user_status character varying(50),
    address text,
    gender text,
    marital_status text,
    emergency_mobile character varying(30),
    blood_group character varying(20),
    work_experience character varying(50),
    roles_id integer,
    departments_id integer,
    profile_image text,
    total_experience text,
    permanent_address text,
    primary_skill text,
    secondary_skill text,
    source_of_hire text,
    seating_location character varying(30),
    employee_status character varying(30),
    date_of_contract date,
    employee_exit_status text,
    notice_period text,
    team_name text,
    personal_email_id text,
    date_of_confirmation date,
    client character varying(30),
    probation_status character varying(30),
    probation_extended_date date,
    probation_period character varying(10),
    probation_due_date date,
    joining_day character varying(20),
    joining_status character varying(20),
    contract_end_date date,
    invalid_attempt boolean,
    lock_time boolean,
    password_history text,
    user_full_name character varying(50),
    emp_role character varying(30),
    emp_ip_address character varying(50),
    background_chk_status character varying(30),
    job_title_id character varying(30),
    tour_flag character varying(30),
    themes character varying(30),
    mode_of_entry character varying(30),
    other_mode_of_entry character varying(30),
    entry_comments character varying(30),
    rc_candidate_name character varying(30),
    selected_date character varying(30),
    candidate_referred_by character varying(30),
    company_id character varying(30),
    emp_temp_lock character varying(255),
    emp_reason_locked character varying(255),
    emp_locked_date date,
    created_by integer,
    modified_by integer,
    created_date timestamp without time zone,
    modified_date timestamp without time zone,
    phone_otp integer
);


ALTER TABLE nira.main_users OWNER TO admin;

--
-- Name: main_users_id_seq; Type: SEQUENCE; Schema: nira; Owner: admin
--

CREATE SEQUENCE nira.main_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nira.main_users_id_seq OWNER TO admin;

--
-- Name: main_users_id_seq; Type: SEQUENCE OWNED BY; Schema: nira; Owner: admin
--

ALTER SEQUENCE nira.main_users_id_seq OWNED BY nira.main_users.id;


--
-- Name: session; Type: TABLE; Schema: nira; Owner: admin
--

CREATE TABLE nira.session (
    sid character varying,
    sess json,
    expire timestamp with time zone
);


ALTER TABLE nira.session OWNER TO admin;

--
-- Name: main_attendances id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_attendances ALTER COLUMN id SET DEFAULT nextval('nira.main_attendances_id_seq'::regclass);


--
-- Name: main_business_units id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_business_units ALTER COLUMN id SET DEFAULT nextval('nira.main_business_units_id_seq'::regclass);


--
-- Name: main_currencies id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_currencies ALTER COLUMN id SET DEFAULT nextval('nira.main_currencies_id_seq'::regclass);


--
-- Name: main_departments id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_departments ALTER COLUMN id SET DEFAULT nextval('nira.main_departments_id_seq1'::regclass);


--
-- Name: main_designations id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_designations ALTER COLUMN id SET DEFAULT nextval('nira.main_designations_id_seq'::regclass);


--
-- Name: main_holidays id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_holidays ALTER COLUMN id SET DEFAULT nextval('nira.main_holidays_id_seq'::regclass);


--
-- Name: main_modules id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_modules ALTER COLUMN id SET DEFAULT nextval('nira.main_modules_id_seq'::regclass);


--
-- Name: main_org_details id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_org_details ALTER COLUMN id SET DEFAULT nextval('nira.main_org_details_id_seq'::regclass);


--
-- Name: main_shifts id; Type: DEFAULT; Schema: nira; Owner: dev
--

ALTER TABLE ONLY nira.main_shifts ALTER COLUMN id SET DEFAULT nextval('nira.main_shifts_id_seq'::regclass);


--
-- Name: main_sitepreferences id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_sitepreferences ALTER COLUMN id SET DEFAULT nextval('nira.main_sitepreferences_id_seq1'::regclass);


--
-- Name: main_users id; Type: DEFAULT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_users ALTER COLUMN id SET DEFAULT nextval('nira.main_users_id_seq'::regclass);


--
-- Data for Name: main_attendances; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_attendances (id, users_id, employee_name, reporting_manager_id, date, check_in, check_out, first_check_in, last_check_out, total_hours, new_first_check_in, new_last_check_out, new_total_hours, check_in_location, check_out_location, check_in_device, check_out_device, payable_hours, status, shifts_id, reason, description, regularization_check_in, regularization_check_out, regularization_total_hours, regularization_status, attendance_status, is_regularized, comment, color_code, leave_duration, old_attendance_status, old_payable_hours, created_by, modified_by, created_date, modified_date) FROM stdin;
332	17	Vipul Viswanathan	\N	2023-09-27	2023-09-27 12:17:52.906	2023-09-27 12:18:02.764	\N	\N	00:00:09.858	\N	\N	\N	\N	\N	desktop	desktop	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2023-09-27 12:17:52.931	2023-09-27 12:18:02.765
333	17	Vipul Viswanathan	\N	2023-09-27	2023-09-27 13:06:30.985	2023-09-27 13:06:37.243	\N	\N	00:00:16.116	\N	\N	\N	\N	Ward 12, Pune, Pune District, Maharashtra, 411014, India	desktop	desktop	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2023-09-27 13:06:30.986	2023-09-27 13:06:37.244
\.


--
-- Data for Name: main_business_units; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_business_units (id, departments_id, orgs_id, unit_name, unit_code, description, start_date, country, state, city, address_1, address_2, address_3, time_zone, unit_head, service_desk_flag, created_by, modified_by, created_date, modified_date, is_active) FROM stdin;
1	1	1				2023-09-21							\N		f	\N	\N	\N	2023-09-21 17:01:23.781	f
\.


--
-- Data for Name: main_currencies; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_currencies (id, code, name, symbol, exchange_rate, created_by, modified_by, createddate, modifieddate) FROM stdin;
\.


--
-- Data for Name: main_departments; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_departments (id, orgs_id, business_units_id, dept_name, dept_code, description, start_date, country, state, city, address_1, address_2, address_3, time_zone, dept_head, unit_id, created_by, modified_by, created_date, modified_date, is_active) FROM stdin;
191	1	1	name_test2	Dept012	this is department testing2	\N	\N	\N	\N	Wadgaon-sheri	\N	\N	\N	\N	\N	\N	\N	2023-09-13 08:24:24.757	2023-09-13 08:24:24.757	t
192	1	1	name_test3	Dept0123	this is department2 testing	\N	\N	\N	\N	chandan-nagar	\N	\N	\N	\N	\N	\N	\N	2023-09-13 08:24:24.767	2023-09-13 08:24:24.767	t
\.


--
-- Data for Name: main_designations; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_designations (id, name, created_by, modified_by, created_date, modified_date) FROM stdin;
\.


--
-- Data for Name: main_employees; Type: TABLE DATA; Schema: nira; Owner: dev
--

COPY nira.main_employees (id, user_id, date_of_joining, date_of_leaving, reporting_manager, emp_status_id, business_unit_id, department_id, job_title_id, position_id, years_exp, holiday_group, prefix_id, extension_number, office_number, office_fax_number, created_by, modified_by, created_date, modified_date, is_active, is_org_head) FROM stdin;
\.


--
-- Data for Name: main_holidays; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_holidays (id, name, holiday, is_deleted, is_optional, "from", "to", created_by, modified_by, created_date, modified_date) FROM stdin;
1	eid	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:38:06.512	2023-09-28 09:38:06.512
2	eid	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:39:31.874	2023-09-28 09:39:31.874
3	diwali	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:39:31.946	2023-09-28 09:39:31.946
4	eid	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:42:28.369	2023-09-28 09:42:28.369
5	diwali	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:42:28.477	2023-09-28 09:42:28.477
6	eid	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:45:36.846	2023-09-28 09:45:36.846
7	diwali	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:45:36.906	2023-09-28 09:45:36.906
8	eid	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:46:49.989	2023-09-28 09:46:49.989
9	diwali	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:46:50.106	2023-09-28 09:46:50.106
10	eid	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:56:58.599	2023-09-28 09:56:58.599
11	diwali	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:56:58.652	2023-09-28 09:56:58.652
12	Moharam	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 09:59:16.464	2023-09-28 09:59:16.464
13	moharam2	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 10:22:45.634	2023-09-28 10:22:45.634
14	moharam24	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 10:24:06.705	2023-09-28 10:24:06.705
15	moharam24	1970-01-01	\N	\N	\N	\N	\N	\N	2023-09-28 10:25:16.702	2023-09-28 10:25:16.702
16	moharam21111	2023-09-09	\N	\N	\N	\N	\N	\N	2023-09-28 10:29:17.356	2023-09-28 10:29:17.356
17	shubhamtest	2023-09-09	\N	\N	\N	\N	\N	\N	2023-09-28 10:30:45.953	2023-09-28 10:30:45.953
18	shubhamtest	2023-09-09	\N	\N	\N	\N	\N	\N	2023-09-28 10:33:38.354	2023-09-28 10:33:38.354
19	shubhamtest	2023-09-09	\N	\N	\N	\N	\N	\N	2023-09-28 11:02:08.088	2023-09-28 11:02:08.088
20	BB ki Vines	2023-09-09	\N	\N	\N	\N	\N	\N	2023-09-28 11:58:20.446	2023-09-28 11:58:20.446
21	duplicates	2023-09-09	\N	\N	\N	\N	\N	\N	2023-09-29 09:01:07.481	2023-09-29 09:01:07.481
22	duplicates	2023-09-09	\N	f	\N	\N	\N	\N	2023-09-29 09:02:29.899	2023-09-29 09:02:29.899
23	No duplicates	2023-09-09	\N	f	\N	\N	\N	\N	2023-09-29 09:05:35.825	2023-09-29 09:05:35.825
24	No duplicates	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 09:09:02.803	2023-09-29 09:09:02.803
25	Sanjay Sah	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 09:15:36.479	2023-09-29 09:15:36.479
26	Sanjay Sah	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 09:20:59.331	2023-09-29 09:20:59.331
27	Sanjay Sah	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 09:26:57.488	2023-09-29 09:26:57.488
28	Sanjay Sah	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 09:29:17.195	2023-09-29 09:29:17.195
29	Sanjay Sah	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 09:33:34.776	2023-09-29 09:33:34.776
30	Bedang G testing	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 13:44:02.812	2023-09-29 13:44:02.812
31	Bedang 404err	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 13:45:11.668	2023-09-29 13:45:11.668
32	Bedang 404err	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 13:48:30.665	2023-09-29 13:48:30.665
33	Bedang 404err	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 13:48:36.709	2023-09-29 13:48:36.709
34	Bedang 404err	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 13:52:28.937	2023-09-29 13:52:28.937
35	Shubham Deshmukh	2023-09-09	f	f	03/09/2023	09/09/2023	\N	\N	2023-09-29 14:15:36.992	2023-09-29 14:15:36.992
\.


--
-- Data for Name: main_modules; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_modules (id, name, description, is_active, is_aienabled, created_by, modified_by, created_date, modified_date) FROM stdin;
1	Attendance	\N	\N	\N	\N	\N	\N	\N
2	Leaves	\N	\N	\N	\N	\N	\N	\N
3	Timesheet/Logs	\N	\N	\N	\N	\N	\N	\N
4	Rewards and Recognition	\N	\N	\N	\N	\N	\N	\N
5	Performance Management System	\N	\N	\N	\N	\N	\N	\N
6	Talent Acquisition	\N	\N	\N	\N	\N	\N	\N
7	Analysis	\N	\N	\N	\N	\N	\N	\N
8	Expenses	\N	\N	\N	\N	\N	\N	\N
9	Notification	\N	\N	\N	\N	\N	\N	\N
10	Templates	\N	\N	\N	\N	\N	\N	\N
11	Global AI features	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: main_org_details; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_org_details (id, organization_name, org_image, domain, website, org_description, total_employees, registration_number, org_start_date, phone_number, secondary_phone, email, secondary_email, fax_number, country, state, city, address_1, address_2, address_3, description, org_head, designation, created_by, modified_by, created_date, modified_date, is_active) FROM stdin;
1	AIT Global New	ln38qupp_hidden.png	 yahoo.com	http://www.google.co	Development	3	 12345	2023-01-17 05:30:00+05:30	+91 84518 90905	+91 97859 90621	rita.jagtap@aitglobalinc.com	rit@gmail.com	+91 4578 909 093	IN	MH	Pune	 yahoo.com	 Pune,Maharastra	 Wadgon sheri,It Park	 test	            jhjjh  jhhj	{" NodeJs"," React"}	\N	\N	\N	2023-09-29 16:11:36.447	f
\.


--
-- Data for Name: main_roles; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_roles (id, name, permissions, role_type, is_deleted, created_by, modified_by, created_date, modified_date) FROM stdin;
\.


--
-- Data for Name: main_shifts; Type: TABLE DATA; Schema: nira; Owner: dev
--

COPY nira.main_shifts (id, name, "from", "to", reason, is_deleted, financial_year, created_by, modified_by, createddate, modifieddate) FROM stdin;
\.


--
-- Data for Name: main_sitepreferences; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_sitepreferences (id, emp_code, nationality_id, date_format_id, time_format_id, time_zone_id, currency_id, password_id, description, font_type, font_size, colour_primary, colour_secondry, colour_tertiary, login_image, login_message, created_by, modified_by, created_date, modified_date, is_active, org_modules, employment_status, country, state, city, orgs_id) FROM stdin;
1	AIT430	 	MM-DD-YYYY	hh:mm a	(GMT-11:00) Alofi	INR	Alphanumeric + Special Charecters	desc testing	Georgia	12px	 red	 blue	 green	lmyvg0qq_3d-render-low-poly-plexus-design-network-communications.jpg	hello its me redux	\N	\N	\N	2023-09-28 07:24:54.096	f	{"ta_module": {"name": "TA Module", "enable_ai": false, "org_access": false}, "pms_module": {"name": "PMS Module", "enable_ai": false, "org_access": false}, "rnr_module": {"name": "RNR Module", "enable_ai": false, "org_access": true}, "time_module": {"name": "Time Module", "enable_ai": false, "org_access": false}, "leaves_module": {"name": "Leaves Module", "enable_ai": false, "org_access": false}, "expense_module": {"name": "Expense Module", "enable_ai": false, "org_access": false}, "analytics_module": {"name": "Analytics Module", "enable_ai": false, "org_access": false}, "templates_module": {"name": "Templates Module", "enable_ai": false, "org_access": false}, "attendance_module": {"name": "Attendance Module", "enable_ai": false, "org_access": true}, "notification_module": {"name": "Notification Module", "enable_ai": false, "org_access": false}, "employee_profile_module": {"name": "Employee Profile Module", "enable_ai": false, "org_access": true}, "Onboarding_Offboarding_module": {"name": "Onboarding/Offboarding Module", "enable_ai": false, "org_access": false}}	{"Full Time","Part Time",Probation,Contract,Deputation,Left,Permanent,Probationary}	AF	BDS	Ashkāsham	1
\.


--
-- Data for Name: main_users; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.main_users (id, employee_id, salutation, first_name, last_name, dob, doj, email_address, contact_number, password, reporting_manager_id, designations_id, user_type, user_status, address, gender, marital_status, emergency_mobile, blood_group, work_experience, roles_id, departments_id, profile_image, total_experience, permanent_address, primary_skill, secondary_skill, source_of_hire, seating_location, employee_status, date_of_contract, employee_exit_status, notice_period, team_name, personal_email_id, date_of_confirmation, client, probation_status, probation_extended_date, probation_period, probation_due_date, joining_day, joining_status, contract_end_date, invalid_attempt, lock_time, password_history, user_full_name, emp_role, emp_ip_address, background_chk_status, job_title_id, tour_flag, themes, mode_of_entry, other_mode_of_entry, entry_comments, rc_candidate_name, selected_date, candidate_referred_by, company_id, emp_temp_lock, emp_reason_locked, emp_locked_date, created_by, modified_by, created_date, modified_date, phone_otp) FROM stdin;
22	AIT200	Mr.	John	Doe	1995-12-25	2019-05-06	john.doe@aitglobalinc.com	7047382340	\N	AIT403	\N	Permanent	Active	\N	\N	Single	\N	O+ve	3 year(s) 8 month(s)	12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
2	AIT810	Mr.	Shantesh	Varnal	1996-06-11	2022-03-01	shantesh.varnal@aitglobalinc.com	8983177227	$2b$10$aRzz7vNAV0hSOqg3vkZHO.iYVYJox27fwbgiJHH9.1i3D0dTaq882	AIT584	\N	Permanent	Active	97/6 B, Vishal Colony,Dhere Bangla, Manjri-Bk,Hadpsar,Pune-412307\nCity:Pune\nCountry:India\nState:Maharashra\nPin: 412307"	Male	Single	9423337227	A +ve	1 year(s)	12	6		1 year(s)	239, Laxmi Nagar, Hatture Nagar,Near Airport,Solapur\nCity:Solapur\nCountry:India\nState: Maharashra\nPin:413224"	React JS		Vendor	Pune PDC		\N	Active		AIT Internal	sdvarnal@gmail.com	\N	AIT Global India	Confirmed	2022-09-30	180	2022-08-28			\N	f	f	,$2b$10$aRzz7vNAV0hSOqg3vkZHO.iYVYJox27fwbgiJHH9.1i3D0dTaq882	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
1	AIT857	Ms.	Nisha	Bhalerao	1997-11-21	2022-05-05	nisha.bhalerao@aitglobalinc.com	7972373661		AIT182	\N	Permanent	Active	69, Santosh Bunglow, Adhyapak Colony, Sahakarnagar no 1, Near Gangdhar Sweets.\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411009	Female	Married	9960607350	O +ve	10 month(s)	12	6		10 month(s)	69, Santosh Bunglow, Adhyapak Colony, Sahakarnagar no 1, Near Gangdhar Sweets.\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411009			Referral	Pune PDC		\N	Active		AIT Internal	nishapillay24@gmail.com	\N	AIT Global India		\N		\N			2023-03-30	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
3	AIT841	Ms.	Krishna	Savaliya	1992-05-06	2022-04-01	krishna.savaliya@aitglobalinc.com	7405162390		AIT388	\N	Permanent	Active	"A-6, Saurashtra Soc-2, Near g.g. jadafiya school, A.k. road\nCity: Surat\nCountry: India\nState: Gujarat\nPin: 395008"	Female	Married	9601362687	AB +ve	11 month(s)	12	6		11 month(s)	"A-6, Saurashtra Soc-2, Near g.g. jadafiya school, A.k. road\nCity: Surat\nCountry: India\nState: Gujarat\nPin: 395008"	DotNet		Vendor	Pune PDC		\N	Active		Dotnet Team	krishnakorat1992@yahoo.com	\N	Broadridge	Confirmed	\N	180	2022-09-28			\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
4	AIT846	Mr.	Shubham	Mahanubhav	1994-10-02	2022-04-18	shubham.mahanubhav@aitglobalinc.com	9209002567		AIT768	\N	Permanent	Active	74/3 Belatgawhan Deolali Camp, Nashik-422401\nCity: Nashik\nCountry: India\nState: Maharashtra\nPin: 422401	Male	Married	9373443684	O +ve	11 month(s)	12	6		11 month(s)	74/3 Belatgawhan Deolali Camp, Nashik-422401\nCity: Nashik\nCountry: India\nState: Maharashtra\nPin: 422401	QA		Recruiter	Pune PDC		\N	Active		QA	sbmahanubhav02@gmail.com	\N	Vindow	Confirmed	\N	180	2022-10-15		Joined	\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
5	AIT813	Mr.	Prathmesh	Patil	1994-12-27	2022-03-01	prathamesh.patil@aitglobalinc.com	7385475797	$2b$10$wJIdn.Vl2zdky7LIiHfcUOBKMpFSJyXGE01fHTI/1XSreUyL9DcKe	AIT319	\N	Permanent	Active	Samarth Krupa, Tukaram Nagar, Kharadi, Pune\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411014	Male	Single	9175297951	AB+ve	1 year(s)	12	6		1 year(s)	57, Sundar Nagar, Walvadi, Wadibhokar Road, Dhule\nCity: Dhule\nCountry: India\nState: Maharashtra\nPin: 424002	Fresher - DevOps	DevOps Training		Pune PDC		\N	Active		AIT Internal	patilprathm6601@gmail.com	\N	AIT Global India	Confirmed	2022-11-30	180	2022-08-28			\N	f	f	,$2b$10$wJIdn.Vl2zdky7LIiHfcUOBKMpFSJyXGE01fHTI/1XSreUyL9DcKe	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
6	AIT786	Mr.	Hamid	Obaid	1998-02-04	2022-02-21	hamid.obaid@aitglobalinc.com	9546135933	$2b$10$3DYrUUvNtZjRB3BOCapdL.GdZhqggwcuSH4h5h.jk3.H.AQoK.DAC	AIT403	8	Permanent	Active	A-18 SECOND FLOOR NEW DELHI-110025\nCity: DELHI\nCountry: INDIA\nState :DELHI\nPin:110025	Male	Single	9546135933		1 year(s) 1 month(s)	14	6	https://aitportaluat.aitglobalindia.com:8086/likfa0kr_Untitled.jpeg	1 year(s) 1 month(s)	Address: AT+PS+PS=PHENHARA DIST EAST CHAMPARAN BIHAR-845430\nCity: EAST CHAMPARAN (MOTIHARI)\nCountry: INDIA\nState: BIHAR\nPin: 845430	Python	Python	Vendor	Pune PDC		\N	Active		AIT Internal	mdhamidobaid@gmail.com	\N	AIT Global India	Confirmed	2022-11-30	180	2022-08-20			\N	f	f	,$2b$10$3DYrUUvNtZjRB3BOCapdL.GdZhqggwcuSH4h5h.jk3.H.AQoK.DAC	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
7	AIT747	Mr.	Rizwan	Ali	1996-10-10	2022-01-10	rizwan.ali@aitglobalinc.com	7529949866	$2b$10$UO87g2VLg/LvVtmHKMUuGePxylblUr4m4fKamux/VXeC3sMgOE7ZW	AIT508	\N	Permanent	Active	H No B 134 Ambedkar Colony Chatter Pur N.D-110074\nCity:Delhi\nCountry:India\nState:Delhi\nPin:110074	Male	Married	9871953975		1 year(s) 2 month(s)	12	6		1 year(s) 2 month(s)	Address: H No B 134 Ambedkar Colony Chatter Pur N.D-110074\nCity:Delhi\nCountry:India\nState:Delhi\nPin:110074	Angular		Recruiter	Pune PDC		\N	Active		UI	rizwan786ali10@gmail.com	\N	AIT Global India	Confirmed	\N	180	2022-07-08		Joined	\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2023-09-08 10:34:30.929	1234
8	AIT729	Ms.	Rita	Jagtap	1989-06-07	2021-12-27	rita.jagtap@aitglobalinc.com	8451802141		AIT403	\N	Permanent	Active	B-702, Bluewoods, Pimple Soudagar, Pune\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411027	Female	Married	9730741509	B +ve	1 year(s) 2 month(s)	12	6		1 year(s) 2 month(s)	B-702, Bluewoods, Pimple Soudagar, Pune\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411027	Angular		Recruiter	Pune PDC		\N	Active		Data Analytics	rit.shimpi7689@gmail.com	\N	AIT Global India	Confirmed	2022-08-24	180	2022-06-24		Joined	\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
9	AIT725	Ms.	Sapana	Pohare	1989-06-07	2021-12-20	sapana.pohare@aitglobalinc.com	8263979267	$2b$10$EXQhfJWu5VChkZ69.Nio3OQqZSiX15Zl7KYWlNfy4geJ9sSzWQJCK	AIT584	\N	Permanent	Active	Bhosale avenue, Bhagyodaya colony, Karvenagar\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411052	Female	Single	8369284369	A +ve	1 year(s) 3 month(s)	12	6		1 year(s) 3 month(s)	j2,ND , hudco, Vaibhav Nagar, Nanded\nCity: Nanded\nCountry: India\nState: Maharastra\nPin: 431603	QA		Recruiter	Pune PDC		\N	Active		Data Access	sapanapohare267@gmail.com	\N	AIT Global India	Confirmed	\N	180	2022-06-17		Joined	\N	f	f	,$2b$10$EXQhfJWu5VChkZ69.Nio3OQqZSiX15Zl7KYWlNfy4geJ9sSzWQJCK	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
11	AIT711	Mr.	Sanjay Kumar	Sah	1989-10-01	2021-12-01	sanjay.sah@aitglobalinc.com	9785990682	$2b$10$vrLo0xG6nQEd7heZw2os.OPIoWjD7Lx.NEm5bNnSuyzZj6SdJbUam	AIT403	\N	Permanent	Active	Village+Post-Jitpur,Jitpur,East Champaran,Bihar \n Village:Jitpur\nCountry: India\nState: Bihar\nPin:845302	Male	Married			1 year(s) 3 month(s)	12	6		1 year(s) 3 month(s)	Village+Post-Jitpur,Jitpur,East Champaran,Bihar \n  Village:Jitpur\nCountry: India\nState: Bihar\nPin:845302	NodeJs			Pune PDC		\N	Active		Vindow	sanjaykumarsah.sks@gmail.com	\N	AIT Global India	Confirmed	\N	180	2022-05-30			\N	f	f	,$2b$10$qPS5TzsWbtaUvw0L7WI3eOfEJsQ6qVfoBkgZWraTLN4XYgSyX6LLa	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2023-09-05 12:24:35.998	1234
10	AIT722	Mr.	Saurabh	Bhalerao	1989-12-19	2021-12-16	saurabh.bhalerao@aitglobalinc.com	9960607350	$2b$10$XbWgmzZs7DAm2YgCD2ACUO3LtLqIAeRrka.iNeYo5HSV2M0KazLGa	AIT403	\N	Permanent	Active	69, Santosh Bunglow, Adhyapak Colony, Sahakarnagar no – 1\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411009	Male	Married	9665119751		1 year(s) 3 month(s)	13	6		1 year(s) 3 month(s)	69, Santosh Bunglow, Adhyapak Colony, Sahakarnagar no – 1\nCity: Pune\nCountry: India\nState: Maharashtra\nPin: 411009	Customer Support		Referral	Pune PDC		\N	Active		Vindow	saurabhbhalerao1989@gmail.com	\N	Vindow	Confirmed	\N	180	2022-06-14		Joined	\N	f	f	,$2b$10$Y48Bptt6j5lyp87xIZmw.uXRMRSkX1HcQgmE3Z/4BVLB/As1nfwTm	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2023-09-25 12:49:52.272	1234
12	AIT707	Ms.	Yasoda	Rebba	1986-05-12	2021-11-29	yasoda.rebba@aitglobalinc.com	9182457674	$2b$10$xv5mu9JzoHpStFhFLANJ7eFjiqqr.pOHAXZRy7wIb8k7ZQeuQmC7K	AIT403	\N	Permanent	Active	saraswathi complex society, flat no-14,3rd floor,thulaja bhavani nagar, lane no-2 kharadi,pune-411014  city:pune country:india state:maharashtra pin:411014	Female	Married	8411009551		1 year(s) 3 month(s)	4	6		1 year(s) 3 month(s)	1-18, dorasanipadu, dwaraka tirumala,west godavari, andhra citi:dwaraka thirumala country:india state:ANDHRA PRADESH PIN :534426	QA		Vendor	Pune PDC		\N	Active		Cloud	ryasoda2021@gmail.com	\N	AIT Global India	Confirmed	\N	180	2022-05-27		Joined	\N	f	f	$2b$10$Iz.IZa/Us0C9ksb6QDM89.AEPpRMvqGUXwUo4h0sF/wDPGys2y6iK,$2b$10$.88/ddoTMUlZgO6kx2d7qum11mhuAHHCFfP99sRUCATLcB1RwymKK,$2b$10$xv5mu9JzoHpStFhFLANJ7eFjiqqr.pOHAXZRy7wIb8k7ZQeuQmC7K	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
13	AIT703	Mr.	Manoj	Ahirwar	1990-01-10	2021-11-22	manoj.ahirwar@aitglobalinc.com	7828894709		AIT584	\N	Permanent	Active	620/5 kanchanpura,near primary school ,niwari city: niwari country:india state:madhya pradesh(mp) pin:472442	Male	Married	7987004057	O +ve	1 year(s) 4 month(s)	12	6		1 year(s) 4 month(s)	620/5 kanchanpura,near primary school ,niwari city: niwari country:india state:madhya pradesh(mp) pin:472442	NodeJs		Recruiter	Pune PDC		\N	Active		Vindow	manoj0725028@gmail.com	\N	Cognizant	Confirmed	\N	180	2022-05-20		Joined	\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
14	AIT689	Mr.	Shubham	Deshmukh	1995-09-03	2021-11-15	shubham.deshmukh@aitglobalinc.com	8446212747	$2b$10$wZQMy1/cCBXGBCDfQqtgo.qgbPD1HktiVia6BKLZa0IS2wQpykhZq	AIT403	\N	Permanent	Active	Flat 504, Delta 5, Windsor Estate, Wadgaon Sheri, Pune. 411014	Male	Single	9767792792		1 year(s) 4 month(s)	12	6		1 year(s) 4 month(s)	PLOT 26 MANISH LAYOT SWAVLAMBI NAGAR  NAGPUR MAHARASTRA 440022	Full Stack			Pune PDC		\N	Active		JAVA	shubhamdeshmukh627627@gmail.com	\N	AIT Global India		\N		\N			2022-12-31	f	f	,$2b$10$wZQMy1/cCBXGBCDfQqtgo.qgbPD1HktiVia6BKLZa0IS2wQpykhZq	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
15	AIT653	Mr.	Ankit	Shukla	2000-11-01	2021-11-10	ankit.shukla@aitglobalinc.com	7039878542		AIT584	\N	Permanent	Active	SAI SHAKTI COLONY 9/5 KAILASH NAGAR  SHANKAR PAWSHE ROAD VITHALWADI KALYAN (EAST) City:KALYAN\nCountry:INDIA\nState:MAHARASHTRA\nPin:421306	Male	Single	7039878542	O -ve	1 year(s) 4 month(s)	12	6		1 year(s) 4 month(s)	SAI SHAKTI COLONY 9/5 KAILASH NAGAR  SHANKAR PAWSHE ROAD VITHALWADI KALYAN (EAST) City:KALYAN\nCountry:INDIA\nState:MAHARASHTRA\nPin:421306	Java			Pune PDC		\N	Active		XPP	ankitshukla78146@gmail.com	\N	AIT Global India	Confirmed	\N	180	2022-05-09		Joined	\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
16	AIT615	Mr.	Amol	Funde	1995-07-21	2021-08-16	amol.funde@aitglobalinc.com	7020788515	$2b$10$KUmq1Ipf/bkYuq76C8iHjei85jw228BaGHn5ffQLb48wO6fYhRdfm	AIT319	\N	Permanent	Active	Anandnagar Pathardi Ahmednagar-414102	Male	Single	9405273467	B +ve	1 year(s) 7 month(s)	12	6		1 year(s) 7 month(s)	Anandnagar Pathardi Ahmednagar-414102	DevOps			Pune PDC		\N	Active		AIT Internal	amol2929funde@gmail.com	\N	AIT Global India	Confirmed	\N	180	2022-02-11			\N	f	f	,$2b$10$KUmq1Ipf/bkYuq76C8iHjei85jw228BaGHn5ffQLb48wO6fYhRdfm	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
17	AIT182	Mr.	Vipul	Viswanathan	1991-05-18	2018-03-19	vipul@aitglobalinc.com	91-9920549654		AIT211	\N	Permanent	Active	Morya Park Lane No 1, Sai Residency, Pimple Gurav, Pune-411027	Male	Married	9820512706/ 9819147275	A +ve	5 year(s)	12	6		5 year(s)	105/8 SRI KRISHNA JYOT,GARODIA NAGAR BEHIND SATI KRUPA SHOPPING CENTER,GHATKOPAR EAST,MUMBAI MAHARASHTRA PIN:400077	Scrum Master		WalkIn	Pune		\N	Active		UI	vipulvish91@gmail.com	\N	AIT Global India	Confirmed	\N		\N			\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
18	AIT540	Ms.	Karishma	Bais	1996-04-21	2021-03-15	karishma.bais@aitglobalinc.com	8793497096		AIT388	\N	Permanent	Active	Civil Ward, Sakoli\nCity: Sakoli\nCountry: India\nState: Maharashtra\nPin: 441802	Female	Single	9422832379		2 year(s)	12	6		2 year(s)	Civil Ward, Sakoli\nCity: Sakoli\nCountry: India\nState: Maharashtra\nPin: 441802	Angular			Pune - PDC		\N	Active		AIT Internal	karishmabais9697@gmail.com	\N	Broadridge	Confirmed	\N		\N			\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
19	AIT403	Mr.	Harsh	Joshi	1991-02-26	2020-09-02	harsh.joshi@aitglobalinc.com	8989697117	$2b$10$3pSCFGe6v0jmqB6KrgQjkepzbDqEohzzI8r5mDTCYXYoCHnb1C.GS	AIT182	84	Permanent	Active	1102, Parkland Society, Borhadewadi, Moshi, Pimpri Chinchwad, Pune, 412105	Male	Married	9109067191		2 year(s) 6 month(s)	4	6		2 year(s) 6 month(s)	14, ABHISHEK NAGAR, NANAKHEDA,UJJAIN India 456010 Madhya Pradesh	Angular			Pune - PDC		\N	Active		UI	harshjoshi262@gmail.com	\N	AIT Global India	Confirmed	\N		\N			\N	f	f	$2b$10$WY/Vas9WoBafWHuUEsd6e.KrWnGnqF3.QSyLr1g2Zq3P.dQD/bAH.,$2b$10$9IEIHY.nkHqFUFaQ2hxYseq145ZLH54fHfbt2RBRc572tC1JnjuUG,$2b$10$3pSCFGe6v0jmqB6KrgQjkepzbDqEohzzI8r5mDTCYXYoCHnb1C.GS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
20	AIT271	Ms.	Reshma	Hole	1990-01-01	2019-05-06	reshma.hole@aitglobalinc.com	9766881839		AIT707	\N	Permanent	Active	Ivy Apartment, Flat no. 1102,F-3 Building Ivy Estate  near Lexicon SchoolWagholiPuneIndia412207Maharashtra	Female	Married	9730985479	O+ve	3 year(s) 10 month(s)	12	6		3 year(s) 10 month(s)	Near  sadan Ganesh Mandir,Hole Niwas, Mahajan PlotUmrgaIndia413606Maharashtra	QA			Pune - PDC		\N	Active		Mobile team		\N	AIT Global India	Confirmed	\N		\N			\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234
21	AIT266	Mr.	Bhuvan	Bhaskar	1995-12-25	2019-07-01	bhuwan.bhaskar@aitglobalinc.com	7047382340	$2b$10$d76dWKy9LlxxyW3VTeTKy.GvOvhcPFP7Py9XHfe/c5CUlOfGfQBAW	AIT584	8	Permanent	Active	ladkatwadi boys hostel ,behind somnath hallpune stationpuneIndia411001Maharashtra	Male	Single	9981785544		3 year(s) 8 month(s)	12	6		3 year(s) 8 month(s)	C-18Cluster 1SingrolliIndia486884Maharashtra	React JS			Pune - PDC		\N	Active		UI	bhuwanbhaskar10@gmail.com	\N	AIT Global India	Confirmed	\N		\N			\N	f	f		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2023-09-07 10:41:20.862	1234
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: nira; Owner: admin
--

COPY nira.session (sid, sess, expire) FROM stdin;
\.


--
-- Name: main_attendances_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_attendances_id_seq', 333, true);


--
-- Name: main_business_units_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_business_units_id_seq', 1, false);


--
-- Name: main_currencies_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_currencies_id_seq', 1, false);


--
-- Name: main_departments_id_seq1; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_departments_id_seq1', 192, true);


--
-- Name: main_designations_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_designations_id_seq', 1, false);


--
-- Name: main_holidays_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_holidays_id_seq', 35, true);


--
-- Name: main_modules_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_modules_id_seq', 1, true);


--
-- Name: main_org_details_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_org_details_id_seq', 1, false);


--
-- Name: main_shifts_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: dev
--

SELECT pg_catalog.setval('nira.main_shifts_id_seq', 1, false);


--
-- Name: main_sitepreferences_id_seq1; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_sitepreferences_id_seq1', 1, true);


--
-- Name: main_users_id_seq; Type: SEQUENCE SET; Schema: nira; Owner: admin
--

SELECT pg_catalog.setval('nira.main_users_id_seq', 1, false);


--
-- Name: main_attendances main_attendances_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_attendances
    ADD CONSTRAINT main_attendances_pkey PRIMARY KEY (id);


--
-- Name: main_business_units main_business_units_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_business_units
    ADD CONSTRAINT main_business_units_pkey PRIMARY KEY (id);


--
-- Name: main_currencies main_currencies_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_currencies
    ADD CONSTRAINT main_currencies_pkey PRIMARY KEY (id);


--
-- Name: main_departments main_departments_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_departments
    ADD CONSTRAINT main_departments_pkey PRIMARY KEY (id);


--
-- Name: main_designations main_designations_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_designations
    ADD CONSTRAINT main_designations_pkey PRIMARY KEY (id);


--
-- Name: main_employees main_employees_pk; Type: CONSTRAINT; Schema: nira; Owner: dev
--

ALTER TABLE ONLY nira.main_employees
    ADD CONSTRAINT main_employees_pk PRIMARY KEY (id);


--
-- Name: main_holidays main_holidays_pk; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_holidays
    ADD CONSTRAINT main_holidays_pk PRIMARY KEY (id);


--
-- Name: main_modules main_modules_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_modules
    ADD CONSTRAINT main_modules_pkey PRIMARY KEY (id);


--
-- Name: main_org_details main_org_details_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_org_details
    ADD CONSTRAINT main_org_details_pkey PRIMARY KEY (id);


--
-- Name: main_roles main_roles_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_roles
    ADD CONSTRAINT main_roles_pkey PRIMARY KEY (id);


--
-- Name: main_shifts main_shifts_pkey; Type: CONSTRAINT; Schema: nira; Owner: dev
--

ALTER TABLE ONLY nira.main_shifts
    ADD CONSTRAINT main_shifts_pkey PRIMARY KEY (id);


--
-- Name: main_sitepreferences main_sitepreferences_pk; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_sitepreferences
    ADD CONSTRAINT main_sitepreferences_pk PRIMARY KEY (id);


--
-- Name: main_users main_users_pkey; Type: CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_users
    ADD CONSTRAINT main_users_pkey PRIMARY KEY (id);


--
-- Name: main_attendances totalhourtrigger; Type: TRIGGER; Schema: nira; Owner: admin
--

CREATE TRIGGER totalhourtrigger BEFORE UPDATE ON nira.main_attendances FOR EACH ROW EXECUTE FUNCTION nira.totalhourtrigger_function();


--
-- Name: main_attendances main_attendances_fk; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_attendances
    ADD CONSTRAINT main_attendances_fk FOREIGN KEY (users_id) REFERENCES nira.main_users(id);


--
-- Name: main_attendances main_attendances_fk_1; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_attendances
    ADD CONSTRAINT main_attendances_fk_1 FOREIGN KEY (created_by) REFERENCES nira.main_users(id);


--
-- Name: main_attendances main_attendances_fk_2; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_attendances
    ADD CONSTRAINT main_attendances_fk_2 FOREIGN KEY (modified_by) REFERENCES nira.main_users(id);


--
-- Name: main_attendances main_attendances_fk_3; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_attendances
    ADD CONSTRAINT main_attendances_fk_3 FOREIGN KEY (reporting_manager_id) REFERENCES nira.main_users(id);


--
-- Name: main_attendances main_attendances_fk_4; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_attendances
    ADD CONSTRAINT main_attendances_fk_4 FOREIGN KEY (shifts_id) REFERENCES nira.main_shifts(id);


--
-- Name: main_business_units main_business_units_fk; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_business_units
    ADD CONSTRAINT main_business_units_fk FOREIGN KEY (orgs_id) REFERENCES nira.main_org_details(id);


--
-- Name: main_departments main_departments_fk; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_departments
    ADD CONSTRAINT main_departments_fk FOREIGN KEY (orgs_id) REFERENCES nira.main_org_details(id);


--
-- Name: main_departments main_departments_fk1; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_departments
    ADD CONSTRAINT main_departments_fk1 FOREIGN KEY (business_units_id) REFERENCES nira.main_business_units(id);


--
-- Name: main_holidays main_holidays_fk; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_holidays
    ADD CONSTRAINT main_holidays_fk FOREIGN KEY (created_by) REFERENCES nira.main_users(id);


--
-- Name: main_holidays main_holidays_fk_1; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_holidays
    ADD CONSTRAINT main_holidays_fk_1 FOREIGN KEY (modified_by) REFERENCES nira.main_users(id);


--
-- Name: main_sitepreferences main_sitepreferences_fk; Type: FK CONSTRAINT; Schema: nira; Owner: admin
--

ALTER TABLE ONLY nira.main_sitepreferences
    ADD CONSTRAINT main_sitepreferences_fk FOREIGN KEY (orgs_id) REFERENCES nira.main_org_details(id);


--
-- Name: SCHEMA nira; Type: ACL; Schema: -; Owner: dev
--

GRANT USAGE ON SCHEMA nira TO nira_dev;


--
-- Name: TABLE main_attendances; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_attendances TO nira_dev;


--
-- Name: TABLE main_business_units; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_business_units TO nira_dev;


--
-- Name: TABLE main_currencies; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_currencies TO nira_dev;


--
-- Name: TABLE main_departments; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_departments TO nira_dev;


--
-- Name: TABLE main_employees; Type: ACL; Schema: nira; Owner: dev
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_employees TO nira_dev;


--
-- Name: TABLE main_modules; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_modules TO nira_dev;


--
-- Name: TABLE main_org_details; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_org_details TO nira_dev;


--
-- Name: TABLE main_roles; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_roles TO nira_dev;


--
-- Name: TABLE main_shifts; Type: ACL; Schema: nira; Owner: dev
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_shifts TO nira_dev;


--
-- Name: TABLE main_sitepreferences; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_sitepreferences TO nira_dev;


--
-- Name: TABLE main_users; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.main_users TO nira_dev;


--
-- Name: TABLE session; Type: ACL; Schema: nira; Owner: admin
--

GRANT SELECT,INSERT,UPDATE ON TABLE nira.session TO nira_dev;


--
-- PostgreSQL database dump complete
--

