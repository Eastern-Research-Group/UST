CREATE TABLE az_ust.erg_facility_type_mapping (
    "FacilityID" text  NOT NULL ,
    "FacilityName" text  NULL ,
    "FacilityType1" text  NULL ,
    "epa_value" character varying(1000)  NULL );

ALTER TABLE az_ust."az_ust.erg_facility_type_mapping" ADD CONSTRAINT erg_facility_type_mapping_pk PRIMARY KEY ("FacilityID");

CREATE UNIQUE INDEX erg_facility_type_mapping_pk ON az_ust.erg_facility_type_mapping USING btree ("FacilityID")