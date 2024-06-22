CREATE TABLE public.ust_release_source (
    ust_release_source_id integer  NOT NULL generated always as identity,
    ust_release_id integer  NOT NULL ,
    source_id integer  NOT NULL );