CREATE TABLE public.compartment_statuses (
    compartment_status_id integer  NOT NULL generated always as identity,
    compartment_status character varying(100)  NULL );