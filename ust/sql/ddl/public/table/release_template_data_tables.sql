CREATE TABLE public.release_template_data_tables (
    "release_template_data_tables_id" integer  NOT NULL generated always as identity,
    "table_name" character varying(100)  NOT NULL ,
    "view_name" character varying(100)  NOT NULL ,
    "template_tab_name" character varying(100)  NULL ,
    "sort_order" integer  NULL );

ALTER TABLE public.release_template_data_tables ADD CONSTRAINT release_template_data_tables_pkey PRIMARY KEY (release_template_data_tables_id);

CREATE UNIQUE INDEX release_template_data_tables_pkey ON public.release_template_data_tables USING btree (release_template_data_tables_id)