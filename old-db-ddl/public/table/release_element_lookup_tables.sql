CREATE TABLE public.release_element_lookup_tables (
    "release_element_lookup_table_id" integer  NOT NULL generated always as identity,
    "database_lookup_table" character varying(100)  NULL ,
    "id_column_name" character varying(100)  NULL ,
    "description_column_name" character varying(100)  NULL ,
    "template_lookup_page" character varying(1)  NULL );
