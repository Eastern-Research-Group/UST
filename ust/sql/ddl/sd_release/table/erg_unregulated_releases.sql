CREATE TABLE sd_release.erg_unregulated_releases (
    "facility_id" character varying(50)  NOT NULL ,
    "release_id" character varying(50)  NOT NULL );

ALTER TABLE sd_release."sd_release.erg_unregulated_releases" ADD CONSTRAINT erg_unregulated_releases_pk PRIMARY KEY (facility_id, release_id);

ALTER TABLE tn_release."tn_release.erg_unregulated_releases" ADD CONSTRAINT erg_unregulated_releases_pk PRIMARY KEY (facility_id, release_id);

CREATE UNIQUE INDEX erg_unregulated_releases_pk ON sd_release.erg_unregulated_releases USING btree (facility_id, release_id)