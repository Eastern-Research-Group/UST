CREATE TABLE public.ust_piping (
    ust_piping_id integer  NOT NULL generated always as identity,
    ust_compartment_id integer  NOT NULL ,
    piping_id character varying(50)  NOT NULL ,
    piping_style_id integer  NULL ,
    safe_suction character varying(7)  NULL ,
    american_suction character varying(7)  NULL ,
    high_pressure_or_bulk_piping character varying(7)  NULL ,
    piping_material_frp character varying(3)  NULL ,
    piping_material_gal_steel character varying(3)  NULL ,
    piping_material_stainless_steel character varying(3)  NULL ,
    piping_material_steel character varying(3)  NULL ,
    piping_material_copper character varying(3)  NULL ,
    piping_material_flex character varying(3)  NULL ,
    piping_material_no_piping character varying(3)  NULL ,
    piping_material_other character varying(3)  NULL ,
    piping_material_unknown character varying(3)  NULL ,
    piping_flex_connector character varying(7)  NULL ,
    piping_corrosion_protection_sacrificial_anode character varying(7)  NULL ,
    piping_corrosion_protection_impressed_current character varying(7)  NULL ,
    piping_corrosion_protection_cathodic_not_required character varying(7)  NULL ,
    piping_corrosion_protection_other character varying(7)  NULL ,
    piping_corrosion_protection_unknown character varying(7)  NULL ,
    piping_line_leak_detector character varying(7)  NULL ,
    piping_automated_intersticial_monitoring character varying(7)  NULL ,
    piping_line_test_annual character varying(7)  NULL ,
    piping_line_test3yr character varying(7)  NULL ,
    piping_groundwater_monitoring character varying(7)  NULL ,
    piping_vapor_monitoring character varying(7)  NULL ,
    piping_interstitial_monitoring character varying(7)  NULL ,
    piping_statistical_inventory_reconciliation character varying(7)  NULL ,
    piping_release_detection_other character varying(7)  NULL ,
    piping_subpart_k_line_test character varying(7)  NULL ,
    piping_subpart_k_other character varying(7)  NULL ,
    pipe_tank_top_sump character varying(7)  NULL ,
    pipe_tank_top_sump_wall_type_id integer  NULL ,
    piping_wall_type_id integer  NULL ,
    pipe_trench_liner character varying(7)  NULL ,
    pipe_secondary_containment_other character varying(7)  NULL ,
    pipe_secondary_containment_unknown character varying(7)  NULL );

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_american_suction_chk CHECK (((american_suction)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_compartment_id_fkey FOREIGN KEY (ust_compartment_id) REFERENCES ust_compartment(ust_compartment_id);

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_high_pressure_or_bulk_piping_chk CHECK (((high_pressure_or_bulk_piping)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_pipe_secondary_containment_other_chk CHECK (((pipe_secondary_containment_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_pipe_secondary_containment_unknown_chk CHECK (((pipe_secondary_containment_unknown)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_pipe_tank_top_sump_chk CHECK (((pipe_tank_top_sump)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_pipe_trench_liner_chk CHECK (((pipe_trench_liner)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_automated_intersticial_monitoring_chk CHECK (((piping_automated_intersticial_monitoring)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_corrosion_protection_cathodic_not_required_chk CHECK (((piping_corrosion_protection_cathodic_not_required)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_corrosion_protection_impressed_current_chk CHECK (((piping_corrosion_protection_impressed_current)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_corrosion_protection_other_chk CHECK (((piping_corrosion_protection_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_corrosion_protection_sacrificial_anode_chk CHECK (((piping_corrosion_protection_sacrificial_anode)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_corrosion_protection_unknown_chk CHECK (((piping_corrosion_protection_unknown)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_flex_connector_chk CHECK (((piping_flex_connector)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_groundwater_monitoring_chk CHECK (((piping_groundwater_monitoring)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_interstitial_monitoring_chk CHECK (((piping_interstitial_monitoring)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_line_leak_detector_chk CHECK (((piping_line_leak_detector)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_line_test3yr_chk CHECK (((piping_line_test3yr)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_line_test_annual_chk CHECK (((piping_line_test_annual)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_copper_chk CHECK (((piping_material_copper)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_flex_chk CHECK (((piping_material_flex)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_frp_chk CHECK (((piping_material_frp)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_gal_steel_chk CHECK (((piping_material_gal_steel)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_no_piping_chk CHECK (((piping_material_no_piping)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_other_chk CHECK (((piping_material_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_stainless_steel_chk CHECK (((piping_material_stainless_steel)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_steel_chk CHECK (((piping_material_steel)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_material_unknown_chk CHECK (((piping_material_unknown)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_release_detection_other_chk CHECK (((piping_release_detection_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_statistical_inventory_reconciliation_chk CHECK (((piping_statistical_inventory_reconciliation)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_style_fk FOREIGN KEY (piping_style_id) REFERENCES piping_styles(piping_style_id);

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_subpart_k_line_test_chk CHECK (((piping_subpart_k_line_test)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_subpart_k_other_chk CHECK (((piping_subpart_k_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_piping_vapor_monitoring_chk CHECK (((piping_vapor_monitoring)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_pkey PRIMARY KEY (ust_piping_id);

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_safe_suction_chk CHECK (((safe_suction)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_tank_top_sump_fk FOREIGN KEY (pipe_tank_top_sump_wall_type_id) REFERENCES pipe_tank_top_sump_wall_types(pipe_tank_top_sump_wall_type_id);

ALTER TABLE public.ust_piping ADD CONSTRAINT piping_wall_type_fk FOREIGN KEY (piping_wall_type_id) REFERENCES piping_wall_types(piping_wall_type_id);

CREATE UNIQUE INDEX piping_pkey ON public.ust_piping USING btree (ust_piping_id)

CREATE INDEX ust_piping_pipe_tank_top_sump_wall_type_id_idx ON public.ust_piping USING btree (pipe_tank_top_sump_wall_type_id)

CREATE INDEX ust_piping_piping_style_id_idx ON public.ust_piping USING btree (piping_style_id)

CREATE INDEX ust_piping_piping_wall_type_id_idx ON public.ust_piping USING btree (piping_wall_type_id)

CREATE INDEX ust_piping_ust_compartment_id_idx ON public.ust_piping USING btree (ust_compartment_id)