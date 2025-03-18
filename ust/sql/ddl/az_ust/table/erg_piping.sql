CREATE TABLE az_ust.erg_piping (
    "facility_id" character varying(50)  NULL ,
    "tank_id" integer  NULL ,
    "compartment_id" integer  NULL ,
    "compartment_name" character varying(50)  NULL ,
    "piping_id" integer  NOT NULL generated always as identity);