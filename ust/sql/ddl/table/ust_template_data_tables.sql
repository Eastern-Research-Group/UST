CREATE TABLE public.ust_template_data_tables (
    ust_template_data_tables_id integer  NOT NULL generated always as identity,
    table_name character varying(100)  NOT NULL ,
    view_name character varying(100)  NOT NULL ,
    template_tab_name character varying(100)  NULL ,
    sort_order integer  NULL );

ALTER TABLE public.ust_template_data_tables ADD CONSTRAINT ust_template_data_tables_pkey PRIMARY KEY (ust_template_data_tables_id);

CREATE UNIQUE INDEX ust_template_data_tables_pkey ON public.ust_template_data_tables USING btree (ust_template_data_tables_id)