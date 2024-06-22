CREATE TABLE public.owner_types (
    owner_type_id integer  NOT NULL generated always as identity,
    owner_type character varying(100)  NOT NULL );