CREATE TABLE nh_release.erg_multiple_factypes_to_exclude (
    "site_number" character varying(50)  NOT NULL );

ALTER TABLE nh_release."nh_release.erg_multiple_factypes_to_exclude" ADD CONSTRAINT erg_multiple_factypes_to_exclude_pkey PRIMARY KEY (site_number);

CREATE UNIQUE INDEX erg_multiple_factypes_to_exclude_pkey ON nh_release.erg_multiple_factypes_to_exclude USING btree (site_number)