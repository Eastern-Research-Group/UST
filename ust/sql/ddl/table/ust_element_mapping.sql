CREATE TABLE public.ust_element_mapping (
    ust_element_mapping_id integer  NOT NULL generated always as identity,
    ust_control_id integer  NOT NULL ,
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
    deagg_column_name character varying(100)  NULL ,
    epa_comments character varying(4000)  NULL ,
    organization_join_fk character varying(100)  NULL ,
    organization_join_column2 character varying(100)  NULL ,
    organization_join_column3 character varying(100)  NULL ,
    organization_join_fk2 character varying(100)  NULL ,
    organization_join_fk3 character varying(100)  NULL ,
    query_logic character varying(4000)  NULL ,
    inferred_value_comment character varying(4000)  NULL );

ALTER TABLE public.ust_element_mapping ADD CONSTRAINT ust_element_mapping_unique UNIQUE (ust_control_id, epa_table_name, epa_column_name);

ALTER TABLE public.ust_element_mapping ADD CONSTRAINT ust_element_mapping_pkey PRIMARY KEY (ust_element_mapping_id);

ALTER TABLE example."example.ust_element_mapping" ADD CONSTRAINT ust_element_mapping_pkey PRIMARY KEY (ust_element_mapping_id);

CREATE UNIQUE INDEX ust_element_mapping_pkey ON public.ust_element_mapping USING btree (ust_element_mapping_id)

CREATE INDEX ust_element_mapping_table_name ON public.ust_element_mapping USING btree (epa_table_name)

CREATE INDEX ust_element_mapping_column_name ON public.ust_element_mapping USING btree (epa_column_name)

CREATE INDEX ust_element_mapping_tabcol ON public.ust_element_mapping USING btree (epa_table_name, epa_column_name)

CREATE INDEX ust_element_mapping_id ON public.ust_element_mapping USING btree (ust_element_mapping_id)

CREATE INDEX ust_element_mapping_ust_control_id_idx ON public.ust_element_mapping USING btree (ust_control_id)

CREATE INDEX ust_element_mapping_ust_element_mapping_id_idx ON public.ust_element_mapping USING btree (ust_element_mapping_id)

CREATE UNIQUE INDEX ust_element_mapping_unique ON public.ust_element_mapping USING btree (ust_control_id, epa_table_name, epa_column_name)