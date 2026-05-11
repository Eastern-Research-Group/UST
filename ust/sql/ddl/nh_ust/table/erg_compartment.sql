CREATE TABLE nh_ust.erg_compartment (
    "facility_id" character varying(50)  NULL ,
    "tank_id" integer  NULL ,
    "compartment_id" integer  NOT NULL generated always as identity);