CREATE TABLE hi_ust.erg_tank_id (
    "facility_id" character varying(50)  NULL ,
    "tank_name" character varying(50)  NULL ,
    "tank_id" integer  NOT NULL generated always as identity);