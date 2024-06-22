CREATE TABLE public.substances (
    substance_id integer  NOT NULL generated always as identity,
    substance character varying(200)  NOT NULL ,
    substance_group character varying(30)  NOT NULL );