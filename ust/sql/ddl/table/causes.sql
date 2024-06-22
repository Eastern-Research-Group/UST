CREATE TABLE public.causes (
    cause_id integer  NOT NULL generated always as identity,
    cause character varying(200)  NOT NULL );