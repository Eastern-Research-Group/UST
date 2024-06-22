CREATE TABLE public.sources (
    source_id integer  NOT NULL generated always as identity,
    source character varying(200)  NOT NULL );