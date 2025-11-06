CREATE TABLE az_ust.erg_v_ust_tank (
    "facility_id" character varying(50)  NOT NULL ,
    "tank_id" integer  NOT NULL ,
    "tank_name" character varying(50)  NULL ,
    "tank_location_id" integer  NULL ,
    "tank_status_id" integer  NULL ,
    "federally_regulated" character varying(7)  NULL ,
    "field_constructed" character varying(7)  NULL ,
    "emergency_generator" character varying(7)  NULL ,
    "airport_hydrant_system" character varying(7)  NULL ,
    "tank_closure_date" date  NULL ,
    "tank_installation_date" date  NULL ,
    "compartmentalized_ust" character varying(7)  NULL ,
    "number_of_compartments" integer  NULL ,
    "tank_material_description_id" integer  NULL ,
    "tank_corrosion_protection_sacrificial_anode" character varying(7)  NULL ,
    "tank_corrosion_protection_impressed_current" character varying(7)  NULL ,
    "tank_corrosion_protection_interior_lining" character varying(7)  NULL ,
    "tank_secondary_containment_id" integer  NULL );

ALTER TABLE az_ust."az_ust.erg_v_ust_tank" ADD CONSTRAINT erg_v_ust_tank_pk PRIMARY KEY (facility_id, tank_id);

CREATE UNIQUE INDEX erg_v_ust_tank_pk ON az_ust.erg_v_ust_tank USING btree (facility_id, tank_id)