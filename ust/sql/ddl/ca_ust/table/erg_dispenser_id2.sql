CREATE TABLE ca_ust.erg_dispenser_id2 (
    "facility_id" character varying(50)  NULL ,
    "tank_name" character varying(200)  NULL ,
    "tank_id" integer  NULL ,
    "compartment_name" character varying(200)  NULL ,
    "compartment_id" integer  NULL ,
    "dispenser_id" integer  NOT NULL generated always as identity);