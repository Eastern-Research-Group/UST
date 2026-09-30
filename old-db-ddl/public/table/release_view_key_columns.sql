CREATE TABLE public.release_view_key_columns (
    "view_name" character varying(100)  NOT NULL ,
    "column_name" character varying(100)  NOT NULL ,
    "sort_order" integer  NOT NULL );

ALTER TABLE public.release_view_key_columns ADD CONSTRAINT release_table_key_columns_pk PRIMARY KEY (view_name, column_name);
