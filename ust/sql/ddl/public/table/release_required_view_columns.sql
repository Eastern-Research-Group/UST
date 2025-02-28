CREATE TABLE public.release_required_view_columns (
    "table_name" character varying(100)  NOT NULL ,
    "column_name" character varying(100)  NOT NULL ,
    "auto_create" character varying(1)  NULL ,
    "information_schema_table_name" character varying(100)  NULL ,
    "column_sort_order" integer  NULL );