CREATE TABLE public.cert_of_installations (
    cert_of_installation_id integer  NOT NULL generated always as identity,
    cert_of_installation character varying(100)  NULL );