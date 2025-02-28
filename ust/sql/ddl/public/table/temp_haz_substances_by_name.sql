CREATE TABLE public.temp_haz_substances_by_name (
    "ust_control_id" integer  NULL ,
    "organization_id" character varying(10)  NULL ,
    "organization_table_name" character varying(100)  NULL ,
    "organization_column_name" character varying(100)  NULL ,
    "organization_value" character varying(4000)  NULL ,
    "epa_value" character varying(1000)  NULL ,
    "preferred_name" text  NULL ,
    "iupac_name" text  NULL ,
    "casrn" text  NULL );