CREATE TABLE public.oust_ust_value_mapping (
    "oust_ust_value_mapping_id" integer  NOT NULL generated always as identity,
    "ust_control_id" integer  NOT NULL ,
    "excel_tab_name" character varying(100)  NULL ,
    "organization_value" character varying(1000)  NOT NULL ,
    "epa_value" character varying(1000)  NULL ,
    "organization_table_name" character varying(100)  NULL ,
    "organization_column_name" character varying(100)  NULL ,
    "epa_notes" character varying(4000)  NULL );
