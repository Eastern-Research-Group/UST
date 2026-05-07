CREATE TABLE pa_release.erg_source_cause_of_release_deagg (
    "erg_source_cause_of_release_deagg_id" integer  NOT NULL generated always as identity,
    "SOURCE_CAUSE_OF_RELEASE" text  NULL );

ALTER TABLE pa_release."pa_release.erg_source_cause_of_release_deagg" ADD CONSTRAINT erg_source_cause_of_release_deagg_pkey PRIMARY KEY (erg_source_cause_of_release_deagg_id);

ALTER TABLE pa_release."pa_release.erg_source_cause_of_release_deagg" ADD CONSTRAINT erg_source_cause_of_release_deagg_unique UNIQUE ("SOURCE_CAUSE_OF_RELEASE");

CREATE UNIQUE INDEX erg_source_cause_of_release_deagg_pkey ON pa_release.erg_source_cause_of_release_deagg USING btree (erg_source_cause_of_release_deagg_id)

CREATE UNIQUE INDEX erg_source_cause_of_release_deagg_unique ON pa_release.erg_source_cause_of_release_deagg USING btree ("SOURCE_CAUSE_OF_RELEASE")