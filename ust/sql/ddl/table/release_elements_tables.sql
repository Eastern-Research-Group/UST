CREATE TABLE public.release_elements_tables (
    element_table_id integer  NOT NULL generated always as identity,
    element_id integer  NOT NULL ,
    table_name character varying(100)  NOT NULL ,
    sort_order integer  NULL );