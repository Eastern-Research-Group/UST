CREATE TABLE public.ust_tank (
    ust_tank_id integer  NOT NULL generated always as identity,
    ust_facility_id integer  NOT NULL ,
    tank_id integer  NOT NULL ,
    tank_name character varying(50)  NULL ,
    tank_location_id integer  NULL ,
    tank_status_id integer  NOT NULL ,
    federally_regulated character varying(7)  NULL ,
    field_constructed character varying(7)  NULL ,
    emergency_generator character varying(7)  NULL ,
    airport_hydrant_system character varying(7)  NULL ,
    multiple_tanks character varying(7)  NULL ,
    tank_closure_date date  NULL ,
    tank_installation_date date  NULL ,
    compartmentalized_ust character varying(7)  NULL ,
    number_of_compartments integer  NULL ,
    tank_material_description_id integer  NULL ,
    tank_corrosion_protection_sacrificial_anode character varying(7)  NULL ,
    tank_corrosion_protection_impressed_current character varying(7)  NULL ,
    tank_corrosion_protection_cathodic_not_required character varying(7)  NULL ,
    tank_corrosion_protection_interior_lining character varying(7)  NULL ,
    tank_corrosion_protection_other character varying(7)  NULL ,
    tank_corrosion_protection_unknown character varying(7)  NULL ,
    tank_secondary_containment_id integer  NULL ,
    cert_of_installation_id integer  NULL ,
    cert_of_installation_other character varying(1000)  NULL ,
    tank_comment character varying(4000)  NULL );

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_location_fk FOREIGN KEY (tank_location_id) REFERENCES tank_locations(tank_location_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_status_fk FOREIGN KEY (tank_status_id) REFERENCES tank_statuses(tank_status_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_material_description_fk FOREIGN KEY (tank_material_description_id) REFERENCES tank_material_descriptions(tank_material_description_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_secondary_containment_fk FOREIGN KEY (tank_secondary_containment_id) REFERENCES tank_secondary_containments(tank_secondary_containment_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT ust_tank_fac_id_fk FOREIGN KEY (ust_facility_id) REFERENCES ust_facility(ust_facility_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_pkey PRIMARY KEY (ust_tank_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_facility_id_fkey FOREIGN KEY (ust_facility_id) REFERENCES ust_facility(ust_facility_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_cert_of_installation_fk FOREIGN KEY (cert_of_installation_id) REFERENCES cert_of_installations(cert_of_installation_id);

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_federally_regulated_chk CHECK (((federally_regulated)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_field_constructed_chk CHECK (((field_constructed)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_emergency_generator_chk CHECK (((emergency_generator)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_airport_hydrant_system_chk CHECK (((airport_hydrant_system)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_multiple_tanks_chk CHECK (((multiple_tanks)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_compartmentalized_ust_chk CHECK (((compartmentalized_ust)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_corrosion_protection_sacrificial_anode_chk CHECK (((tank_corrosion_protection_sacrificial_anode)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_corrosion_protection_impressed_current_chk CHECK (((tank_corrosion_protection_impressed_current)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_corrosion_protection_cathodic_not_required_chk CHECK (((tank_corrosion_protection_cathodic_not_required)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_corrosion_protection_interior_lining_chk CHECK (((tank_corrosion_protection_interior_lining)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_corrosion_protection_other_chk CHECK (((tank_corrosion_protection_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_tank ADD CONSTRAINT tank_tank_corrosion_protection_unknown_chk CHECK (((tank_corrosion_protection_unknown)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

CREATE UNIQUE INDEX tank_pkey ON public.ust_tank USING btree (ust_tank_id)

CREATE INDEX ust_tank_cert_of_installation_id_idx ON public.ust_tank USING btree (cert_of_installation_id)

CREATE INDEX ust_tank_tank_location_id_idx ON public.ust_tank USING btree (tank_location_id)

CREATE INDEX ust_tank_tank_material_description_id_idx ON public.ust_tank USING btree (tank_material_description_id)

CREATE INDEX ust_tank_tank_secondary_containment_id_idx ON public.ust_tank USING btree (tank_secondary_containment_id)

CREATE INDEX ust_tank_tank_status_id_idx ON public.ust_tank USING btree (tank_status_id)

CREATE INDEX ust_tank_ust_facility_id_idx ON public.ust_tank USING btree (ust_facility_id)