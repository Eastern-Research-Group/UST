CREATE TABLE tn_release.erg_productreleased_deagg (
    "erg_productreleased_deagg_id" integer  NOT NULL generated always as identity,
    "Productreleased" text  NULL );

ALTER TABLE tn_release."tn_release.erg_productreleased_deagg" ADD CONSTRAINT erg_productreleased_deagg_pkey PRIMARY KEY (erg_productreleased_deagg_id);

ALTER TABLE tn_release."tn_release.erg_productreleased_deagg" ADD CONSTRAINT erg_productreleased_deagg_unique UNIQUE ("Productreleased");

CREATE UNIQUE INDEX erg_productreleased_deagg_pkey ON tn_release.erg_productreleased_deagg USING btree (erg_productreleased_deagg_id)

CREATE UNIQUE INDEX erg_productreleased_deagg_unique ON tn_release.erg_productreleased_deagg USING btree ("Productreleased")