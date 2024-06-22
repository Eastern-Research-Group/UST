CREATE TABLE public.coordinate_sources (
    coordinate_source_id integer  NOT NULL generated always as identity,
    coordinate_source character varying(100)  NOT NULL );