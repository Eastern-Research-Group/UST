CREATE TABLE public.ust_release_substance (
    ust_release_substance_id integer  NOT NULL generated always as identity,
    ust_release_id integer  NOT NULL ,
    substance_id integer  NOT NULL ,
    quantity_released double precision  NULL ,
    unit character varying(20)  NULL );