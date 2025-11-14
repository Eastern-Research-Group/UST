CREATE TABLE tn_release.erg_release_discovered_deagg (
    "erg_release_discovered_deagg_id" integer  NOT NULL generated always as identity,
    "RELEASE_DISCOVERED" text  NULL );

ALTER TABLE pa_release."pa_release.erg_release_discovered_deagg" ADD CONSTRAINT erg_release_discovered_deagg_pkey PRIMARY KEY (erg_release_discovered_deagg_id);

ALTER TABLE tn_release."tn_release.erg_release_discovered_deagg" ADD CONSTRAINT erg_release_discovered_deagg_pkey PRIMARY KEY (erg_release_discovered_deagg_id);

ALTER TABLE pa_release."pa_release.erg_release_discovered_deagg" ADD CONSTRAINT erg_release_discovered_deagg_unique UNIQUE ("RELEASE_DISCOVERED");

ALTER TABLE tn_release."tn_release.erg_release_discovered_deagg" ADD CONSTRAINT erg_release_discovered_deagg_unique UNIQUE ("RELEASE_DISCOVERED");

CREATE UNIQUE INDEX erg_release_discovered_deagg_pkey ON tn_release.erg_release_discovered_deagg USING btree (erg_release_discovered_deagg_id)

CREATE UNIQUE INDEX erg_release_discovered_deagg_unique ON tn_release.erg_release_discovered_deagg USING btree ("RELEASE_DISCOVERED")