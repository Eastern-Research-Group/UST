CREATE TABLE public.release_element_value_mapping (
    release_element_value_mapping_id integer  NOT NULL generated always as identity,
    release_element_mapping_id integer  NOT NULL ,
    organization_value character varying(4000)  NOT NULL ,
    epa_value character varying(1000)  NULL ,
    epa_approved character varying(1)  NULL ,
    programmer_comments text  NULL ,
    epa_comments text  NULL ,
    organization_comments text  NULL ,
    exclude_from_query character varying(1)  NULL );