CREATE TABLE az_ust.erg_compartment_id (
    "facility_id" character varying(50)  NULL ,
    "tank_name" character varying(50)  NULL ,
    "tank_id" integer  NULL ,
    "compartment_name" character varying(50)  NULL ,
    "compartment_id" integer  NOT NULL generated always as identity);

CREATE INDEX erg_compartment_id_idx ON az_ust.erg_compartment_id USING btree (facility_id, tank_name, compartment_name)