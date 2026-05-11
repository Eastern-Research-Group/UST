CREATE TABLE ca_ust.erg_compartment_id (
    "facility_id" character varying(50)  NOT NULL ,
    "tank_name" character varying(50)  NOT NULL ,
    "tank_id" integer  NOT NULL ,
    "compartment_id" integer  NOT NULL generated always as identity);