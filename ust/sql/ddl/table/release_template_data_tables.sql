CREATE TABLE public.release_template_data_tables (
    release_template_data_tables_id integer  NOT NULL generated always as identity,
    table_name character varying(100)  NOT NULL ,
    view_name character varying(100)  NOT NULL ,
    template_tab_name character varying(100)  NULL ,
    sort_order integer  NULL );