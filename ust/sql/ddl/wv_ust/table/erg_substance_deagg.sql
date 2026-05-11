CREATE TABLE wv_ust.erg_substance_deagg (
    "erg_substance_deagg_id" integer  NOT NULL generated always as identity,
    "Substance" text  NULL );

ALTER TABLE wv_ust."wv_ust.erg_substance_deagg" ADD CONSTRAINT erg_substance_deagg_pkey PRIMARY KEY (erg_substance_deagg_id);

ALTER TABLE wv_ust."wv_ust.erg_substance_deagg" ADD CONSTRAINT erg_substance_deagg_unique UNIQUE ("Substance");

CREATE UNIQUE INDEX erg_substance_deagg_pkey ON wv_ust.erg_substance_deagg USING btree (erg_substance_deagg_id)

CREATE UNIQUE INDEX erg_substance_deagg_unique ON wv_ust.erg_substance_deagg USING btree ("Substance")