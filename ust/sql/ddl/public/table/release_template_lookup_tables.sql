CREATE TABLE public.release_template_lookup_tables (
    "release_template_lookup_tables_id" integer  NOT NULL generated always as identity,
    "table_name" character varying(100)  NOT NULL ,
    "id_column_name" character varying(100)  NOT NULL ,
    "desc_column_name" character varying(100)  NOT NULL ,
    "sort_order" integer  NULL );