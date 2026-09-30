CREATE TABLE public.release_element_value_mapping (
    "release_element_value_mapping_id" integer  NOT NULL generated always as identity,
    "release_element_mapping_id" integer  NOT NULL ,
    "organization_value" character varying(4000)  NOT NULL ,
    "epa_value" character varying(1000)  NULL ,
    "epa_approved" character varying(1)  NULL ,
    "programmer_comments" text  NULL ,
    "epa_comments" text  NULL ,
    "organization_comments" text  NULL ,
    "exclude_from_query" character varying(1)  NULL ,
    "mapping_action" character varying(30) DEFAULT 'MAP'::character varying NOT NULL );

ALTER TABLE public.release_element_value_mapping ADD CONSTRAINT release_element_mapping_value_unique UNIQUE (release_element_mapping_id, organization_value);

ALTER TABLE public.release_element_value_mapping ADD CONSTRAINT release_element_value_map_no_empty_strings_chk CHECK (((epa_value)::text <> ''::text));

ALTER TABLE public.release_element_value_mapping ADD CONSTRAINT release_element_value_mapping_chk_map CHECK (((((mapping_action)::text = 'MAP'::text) AND (NULLIF(TRIM(BOTH FROM epa_value), ''::text) IS NOT NULL)) OR (((mapping_action)::text = ANY ((ARRAY['EXCLUDE'::character varying, 'INTENTIONALLY_NULL'::character varying])::text[])) AND (epa_value IS NULL))));

ALTER TABLE public.release_element_value_mapping ADD CONSTRAINT release_element_value_mapping_pkey PRIMARY KEY (release_element_value_mapping_id);

ALTER TABLE public.release_element_value_mapping ADD CONSTRAINT release_element_value_mapping_unique UNIQUE (release_element_mapping_id, organization_value, epa_value);

CREATE INDEX release_element_value_mapping_db_id ON public.release_element_value_mapping USING btree (release_element_mapping_id);

CREATE INDEX release_element_value_mapping_epa_value ON public.release_element_value_mapping USING btree (epa_value);

CREATE INDEX release_element_value_mapping_id ON public.release_element_value_mapping USING btree (release_element_value_mapping_id);

CREATE UNIQUE INDEX release_element_value_mapping_org_val_idex ON public.release_element_value_mapping USING btree (release_element_mapping_id, organization_value);

CREATE INDEX release_element_value_mapping_org_value ON public.release_element_value_mapping USING btree (organization_value);

CREATE INDEX release_element_value_mapping_release_element_mapping_id_idx ON public.release_element_value_mapping USING btree (release_element_mapping_id);

CREATE INDEX release_element_value_mapping_release_element_value_mapping_id_ ON public.release_element_value_mapping USING btree (release_element_value_mapping_id);
