CREATE TABLE ok_ust.erg_compartments_deduplicated (
    "FacilityID" bigint  NULL ,
    "TankNumber" double precision  NULL ,
    "CompartmentNumber" bigint  NULL ,
    "Substance" text  NULL ,
    "Capacity" bigint  NULL ,
    "CompartmentStatus" text  NULL );

CREATE INDEX ecd_idx1 ON ok_ust.erg_compartments_deduplicated USING btree ("FacilityID")

CREATE INDEX ecd_idx2 ON ok_ust.erg_compartments_deduplicated USING btree ("TankNumber")