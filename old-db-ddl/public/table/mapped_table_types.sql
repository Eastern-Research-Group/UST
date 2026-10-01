CREATE TABLE public.mapped_table_types (
    "table_type" character varying(15)  NOT NULL ,
    "sort_order" integer  NULL );

ALTER TABLE public.mapped_table_types ADD CONSTRAINT mapped_table_types_pkey PRIMARY KEY (table_type);
