CREATE TABLE public.ust_control (
    ust_control_id integer  NOT NULL generated always as identity,
    organization_id character varying(10)  NULL ,
    date_received date  NULL ,
    date_processed date  NULL ,
    data_source text  NULL ,
    comments text  NULL );