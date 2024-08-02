CREATE TABLE public.ust_element_value_mapping (
    ust_element_value_mapping_id integer  NOT NULL generated always as identity,
    ust_element_mapping_id integer  NOT NULL ,
    organization_value character varying(4000)  NOT NULL ,
    epa_value character varying(1000)  NULL ,
    epa_approved character varying(1)  NULL ,
    programmer_comments text  NULL ,
    epa_comments text  NULL ,
    organization_comments text  NULL ,
    exclude_from_query character varying(1)  NULL );

ALTER TABLE public.ust_element_value_mapping ADD CONSTRAINT ust_element_value_mapping_pkey PRIMARY KEY (ust_element_value_mapping_id);

ALTER TABLE public.ust_element_value_mapping ADD CONSTRAINT ust_element_value_mapping_unique UNIQUE (ust_element_mapping_id, organization_value, epa_value);

CREATE UNIQUE INDEX ust_element_value_mapping_pkey ON public.ust_element_value_mapping USING btree (ust_element_value_mapping_id)

CREATE INDEX ust_element_value_mapping_dbid ON public.ust_element_value_mapping USING btree (ust_element_mapping_id)

CREATE INDEX ust_element_value_mapping_epa_value ON public.ust_element_value_mapping USING btree (epa_value)

CREATE INDEX ust_element_value_mapping_org_value ON public.ust_element_value_mapping USING btree (organization_value)

CREATE INDEX ust_element_value_mapping_id ON public.ust_element_value_mapping USING btree (ust_element_value_mapping_id)

CREATE INDEX ust_element_value_mapping_ust_element_mapping_id_idx ON public.ust_element_value_mapping USING btree (ust_element_mapping_id)

CREATE INDEX ust_element_value_mapping_ust_element_value_mapping_id_idx ON public.ust_element_value_mapping USING btree (ust_element_value_mapping_id)

CREATE UNIQUE INDEX ust_element_value_mapping_unique ON public.ust_element_value_mapping USING btree (ust_element_mapping_id, organization_value, epa_value)