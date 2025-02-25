CREATE TABLE public.ust_view_key_columns (
    "view_name" character varying(100)  NOT NULL ,
    "column_name" character varying(100)  NOT NULL ,
    "sort_order" integer  NOT NULL );

ALTER TABLE public.ust_view_key_columns ADD CONSTRAINT ust_view_key_columns_pk PRIMARY KEY (view_name, column_name);

CREATE UNIQUE INDEX ust_view_key_columns_pk ON public.ust_view_key_columns USING btree (view_name, column_name)