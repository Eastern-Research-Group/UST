CREATE TABLE public.ust_element_lookup_tables (
    ust_element_lookup_table_id integer  NOT NULL generated always as identity,
    database_lookup_table character varying(100)  NOT NULL ,
    id_column_name character varying(100)  NOT NULL ,
    description_column_name character varying(100)  NOT NULL ,
    template_lookup_page character varying(1)  NULL );