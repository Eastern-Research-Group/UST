CREATE TABLE public.release_element_mapping (
    release_element_mapping_id integer  NOT NULL generated always as identity,
    release_control_id integer  NOT NULL ,
    mapping_date date DEFAULT CURRENT_DATE NOT NULL ,
    epa_table_name character varying(100)  NOT NULL ,
    epa_column_name character varying(100)  NOT NULL ,
    organization_table_name character varying(100)  NOT NULL ,
    organization_column_name character varying(100)  NOT NULL ,
    organization_join_table character varying(100)  NULL ,
    organization_join_column character varying(100)  NULL ,
    programmer_comments text  NULL ,
    organization_comments text  NULL ,
    deagg_table_name character varying(100)  NULL ,
    deagg_column_name character varying(100)  NULL );