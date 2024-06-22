CREATE TABLE public.facility_types (
    facility_type_id integer  NOT NULL generated always as identity,
    facility_type character varying(100)  NOT NULL );