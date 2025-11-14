CREATE TABLE as_ust.erg_compartment (
    "facility_id" character varying(100)  NOT NULL ,
    "tank_name" character varying(100)  NULL ,
    "tank_id" integer  NOT NULL ,
    "compartment_id" integer  NULL ,
    "overfill_prevention_high_level_alarm" character varying(7)  NULL ,
    "spill_bucket_installed" character varying(7)  NULL ,
    "concrete_berm_installed" character varying(7)  NULL ,
    "tank_automatic_tank_gauging_release_detection" character varying(7)  NULL ,
    "automatic_tank_gauging_continuous_leak_detection" character varying(7)  NULL ,
    "tank_manual_tank_gauging" character varying(7)  NULL ,
    "tank_tightness_testing" character varying(7)  NULL ,
    "tank_inventory_control" character varying(7)  NULL ,
    "compartment_status" character varying(10)  NULL );

ALTER TABLE as_ust."as_ust.erg_compartment" ADD CONSTRAINT erg_compartment_pkey PRIMARY KEY (facility_id, tank_id);

CREATE UNIQUE INDEX erg_compartment_pkey ON as_ust.erg_compartment USING btree (facility_id, tank_id)