CREATE TABLE public.ust_compartment (
    ust_compartment_id integer  NOT NULL generated always as identity,
    ust_tank_id integer  NOT NULL ,
    compartment_id integer  NOT NULL ,
    compartment_name character varying(50)  NULL ,
    compartment_status_id integer  NOT NULL ,
    substance_id integer  NULL ,
    compartment_substance_casno character varying(12)  NULL ,
    compartment_capacity_gallons integer  NULL ,
    overfill_prevention_ball_float_valve character varying(7)  NULL ,
    overfill_prevention_flow_shutoff_device character varying(7)  NULL ,
    overfill_prevention_high_level_alarm character varying(7)  NULL ,
    overfill_prevention_other character varying(7)  NULL ,
    overfill_prevention_unknown character varying(7)  NULL ,
    overfill_prevention_not_required character varying(7)  NULL ,
    spill_bucket_installed character varying(3)  NULL ,
    concrete_berm_installed character varying(3)  NULL ,
    spill_prevention_other character varying(3)  NULL ,
    spill_prevention_not_required character varying(3)  NULL ,
    spill_bucket_wall_type_id integer  NULL ,
    tank_interstitial_monitoring character varying(7)  NULL ,
    tank_automatic_tank_gauging_release_detection character varying(7)  NULL ,
    automatic_tank_gauging_continuous_leak_detection character varying(7)  NULL ,
    tank_manual_tank_gauging character varying(7)  NULL ,
    tank_statistical_inventory_reconciliation character varying(7)  NULL ,
    tank_tightness_testing character varying(7)  NULL ,
    tank_inventory_control character varying(7)  NULL ,
    tank_groundwater_monitoring character varying(7)  NULL ,
    tank_vapor_monitoring character varying(7)  NULL ,
    tank_subpart_k_tightness_testing character varying(7)  NULL ,
    tank_subpart_k_other character varying(7)  NULL ,
    tank_other_release_detection character varying(7)  NULL );

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_automatic_tank_gauging_continuous_leak_detection_ch CHECK (((automatic_tank_gauging_continuous_leak_detection)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_compartment_status_fk FOREIGN KEY (compartment_status_id) REFERENCES compartment_statuses(compartment_status_id);

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_concrete_berm_installed_chk CHECK (((concrete_berm_installed)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_overfill_prevention_ball_float_valve_chk CHECK (((overfill_prevention_ball_float_valve)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_overfill_prevention_flow_shutoff_device_chk CHECK (((overfill_prevention_flow_shutoff_device)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_overfill_prevention_high_level_alarm_chk CHECK (((overfill_prevention_high_level_alarm)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_overfill_prevention_not_required_chk CHECK (((overfill_prevention_not_required)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_overfill_prevention_other_chk CHECK (((overfill_prevention_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_overfill_prevention_unknown_chk CHECK (((overfill_prevention_unknown)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_pkey PRIMARY KEY (ust_compartment_id);

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_spill_bucket_installed_chk CHECK (((spill_bucket_installed)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_spill_bucket_wall_type_fk FOREIGN KEY (spill_bucket_wall_type_id) REFERENCES spill_bucket_wall_types(spill_bucket_wall_type_id);

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_spill_prevention_not_required_chk CHECK (((spill_prevention_not_required)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_spill_prevention_other_chk CHECK (((spill_prevention_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_substance_fk FOREIGN KEY (substance_id) REFERENCES substances(substance_id);

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_automatic_tank_gauging_release_detection_chk CHECK (((tank_automatic_tank_gauging_release_detection)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_groundwater_monitoring_chk CHECK (((tank_groundwater_monitoring)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_id_fkey FOREIGN KEY (ust_tank_id) REFERENCES ust_tank(ust_tank_id);

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_interstitial_monitoring_chk CHECK (((tank_interstitial_monitoring)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_inventory_control_chk CHECK (((tank_inventory_control)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_manual_tank_gauging_chk CHECK (((tank_manual_tank_gauging)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_other_release_detection_chk CHECK (((tank_other_release_detection)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_statistical_inventory_reconciliation_chk CHECK (((tank_statistical_inventory_reconciliation)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_subpart_k_other_chk CHECK (((tank_subpart_k_other)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_subpart_k_tightness_testing_chk CHECK (((tank_subpart_k_tightness_testing)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_tightness_testing_chk CHECK (((tank_tightness_testing)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_compartment ADD CONSTRAINT compartment_tank_vapor_monitoring_chk CHECK (((tank_vapor_monitoring)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

CREATE UNIQUE INDEX compartment_pkey ON public.ust_compartment USING btree (ust_compartment_id)

CREATE INDEX ust_compartment_compartment_status_id_idx ON public.ust_compartment USING btree (compartment_status_id)

CREATE INDEX ust_compartment_spill_bucket_wall_type_id_idx ON public.ust_compartment USING btree (spill_bucket_wall_type_id)

CREATE INDEX ust_compartment_substance_id_idx ON public.ust_compartment USING btree (substance_id)

CREATE INDEX ust_compartment_ust_tank_id_idx ON public.ust_compartment USING btree (ust_tank_id)