CREATE TABLE public.ust_release (
    ust_release_id integer  NOT NULL generated always as identity,
    facility_id character varying(50)  NULL ,
    tank_id_associated_with_release character varying(50)  NULL ,
    release_id character varying(50)  NOT NULL ,
    federally_reportable_release character varying(7)  NULL ,
    site_name character varying(200)  NULL ,
    site_address character varying(100)  NULL ,
    site_address2 character varying(100)  NULL ,
    site_city character varying(100)  NULL ,
    zipcode character varying(10)  NULL ,
    county character varying(100)  NULL ,
    state character varying(2)  NULL ,
    epa_region integer  NULL ,
    facility_type_id integer  NULL ,
    tribal_site character varying(7)  NULL ,
    tribe character varying(50)  NULL ,
    latitude double precision  NULL ,
    longitude double precision  NULL ,
    coordinate_source_id integer  NULL ,
    release_status_id integer  NOT NULL ,
    reported_date date  NULL ,
    nfa_date date  NULL ,
    media_impacted_soil character varying(3)  NULL ,
    media_impacted_groundwater character varying(3)  NULL ,
    media_impacted_surface_water character varying(3)  NULL ,
    release_discovered_id integer  NULL ,
    closed_with_contamination character varying(7)  NULL ,
    no_further_action_letter_url character varying(2000)  NULL ,
    military_dod_site character varying(7)  NULL ,
    release_control_id integer  NOT NULL ,
    release_comment character varying(4000)  NULL );

ALTER TABLE public.ust_release ADD CONSTRAINT release_discovered_fk FOREIGN KEY (release_discovered_id) REFERENCES release_discovered(release_discovered_id);

ALTER TABLE public.ust_release ADD CONSTRAINT release_federally_reportable_release_chk CHECK (((federally_reportable_release)::text = ANY (ARRAY[('Yes'::character varying)::text, ('No'::character varying)::text, ('Unknown'::character varying)::text])));

ALTER TABLE public.ust_release ADD CONSTRAINT release_tribal_site_chk CHECK (((tribal_site)::text = ANY (ARRAY[('Yes'::character varying)::text, ('No'::character varying)::text, ('Unknown'::character varying)::text])));

ALTER TABLE public.ust_release ADD CONSTRAINT release_media_impacted_soil_chk CHECK (((media_impacted_soil)::text = ANY (ARRAY[('Yes'::character varying)::text, ('No'::character varying)::text])));

ALTER TABLE public.ust_release ADD CONSTRAINT release_media_impacted_groundwater_chk CHECK (((media_impacted_groundwater)::text = ANY (ARRAY[('Yes'::character varying)::text, ('No'::character varying)::text])));

ALTER TABLE public.ust_release ADD CONSTRAINT release_media_impacted_surface_water_chk CHECK (((media_impacted_surface_water)::text = ANY (ARRAY[('Yes'::character varying)::text, ('No'::character varying)::text])));

ALTER TABLE public.ust_release ADD CONSTRAINT release_epa_region_chk CHECK ((epa_region = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10])));

ALTER TABLE public.ust_release ADD CONSTRAINT release_closed_with_contamination_chk CHECK (((closed_with_contamination)::text = ANY (ARRAY[('Yes'::character varying)::text, ('No'::character varying)::text, ('Unknown'::character varying)::text])));

ALTER TABLE public.ust_release ADD CONSTRAINT release_military_dod_site_chk CHECK (((military_dod_site)::text = ANY (ARRAY[('Yes'::character varying)::text, ('No'::character varying)::text, ('Unknown'::character varying)::text])));

ALTER TABLE public.ust_release ADD CONSTRAINT ust_release_pkey PRIMARY KEY (ust_release_id);

ALTER TABLE public.ust_release ADD CONSTRAINT release_coordinate_source_fk FOREIGN KEY (coordinate_source_id) REFERENCES coordinate_sources(coordinate_source_id);

ALTER TABLE public.ust_release ADD CONSTRAINT release_facility_type_fk FOREIGN KEY (facility_type_id) REFERENCES facility_types(facility_type_id);

ALTER TABLE public.ust_release ADD CONSTRAINT release_state_fk FOREIGN KEY (state) REFERENCES states(state);

ALTER TABLE public.ust_release ADD CONSTRAINT release_release_status_fk FOREIGN KEY (release_status_id) REFERENCES release_statuses(release_status_id);

ALTER TABLE public.ust_release ADD CONSTRAINT ust_release_control_fk FOREIGN KEY (release_control_id) REFERENCES release_control(release_control_id);

CREATE UNIQUE INDEX ust_release_pkey ON public.ust_release USING btree (ust_release_id)

CREATE INDEX r_fac_idx ON public.ust_release USING btree (facility_id)

CREATE INDEX r_rel_idx ON public.ust_release USING btree (release_id)

CREATE INDEX ust_release_control_idx ON public.ust_release USING btree (release_control_id)

CREATE INDEX ust_release_coordinate_source_id_idx ON public.ust_release USING btree (coordinate_source_id)

CREATE INDEX ust_release_facility_id_idx ON public.ust_release USING btree (facility_id)

CREATE INDEX ust_release_facility_type_id_idx ON public.ust_release USING btree (facility_type_id)

CREATE INDEX ust_release_how_release_detected_id_idx ON public.ust_release USING btree (release_discovered_id)

CREATE INDEX ust_release_release_control_id_idx ON public.ust_release USING btree (release_control_id)

CREATE INDEX ust_release_release_id_idx ON public.ust_release USING btree (release_id)

CREATE INDEX ust_release_release_status_id_idx ON public.ust_release USING btree (release_status_id)

CREATE INDEX ust_release_ust_release_id_idx ON public.ust_release USING btree (ust_release_id)