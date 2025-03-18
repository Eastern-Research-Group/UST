CREATE TABLE ut_ust.erg_piping (
    "facility_id" integer  NULL ,
    "tank_id" integer  NULL ,
    "compartment_id" integer  NULL ,
    "piping_id" integer  NOT NULL generated always as identity);