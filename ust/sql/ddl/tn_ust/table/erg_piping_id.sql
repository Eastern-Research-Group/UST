CREATE TABLE tn_ust.erg_piping_id (
    "facility_id" character varying(50)  NULL ,
    "tank_name" character varying(50)  NULL ,
    "tank_id" integer  NULL ,
    "compartment_name" character varying(50)  NULL ,
    "compartment_id" integer  NULL ,
    "piping_id" integer  NOT NULL generated always as identity);