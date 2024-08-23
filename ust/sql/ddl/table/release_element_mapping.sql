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
    deagg_column_name character varying(100)  NULL ,
    epa_comments character varying(4000)  NULL );

ALTER TABLE public.release_element_mapping ADD CONSTRAINT release_element_mapping_pkey PRIMARY KEY (release_element_mapping_id);

CREATE UNIQUE INDEX release_element_mapping_pkey ON public.release_element_mapping USING btree (release_element_mapping_id)

CREATE INDEX release_element_mapping_column_name ON public.release_element_mapping USING btree (epa_column_name)

CREATE INDEX release_element_mapping_id ON public.release_element_mapping USING btree (release_element_mapping_id)

CREATE INDEX release_element_mapping_tabcol ON public.release_element_mapping USING btree (epa_table_name, epa_column_name)

CREATE INDEX release_element_mapping_table_name ON public.release_element_mapping USING btree (epa_table_name)

CREATE INDEX release_element_mapping_release_control_id_idx ON public.release_element_mapping USING btree (release_control_id)

CREATE INDEX release_element_mapping_release_element_mapping_id_idx ON public.release_element_mapping USING btree (release_element_mapping_id)