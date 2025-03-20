CREATE TABLE va_ust.erg_piping (
    "facility_id" character varying(50)  NULL ,
    "tank_id" integer  NULL ,
    "compartment_id" integer  NULL ,
    "piping_id" integer  NOT NULL generated always as identity);

CREATE INDEX ep_idx ON va_ust.erg_piping USING btree (tank_id, facility_id)