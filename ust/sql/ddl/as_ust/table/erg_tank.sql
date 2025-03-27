CREATE TABLE as_ust.erg_tank (
    "facility_id" character varying(100)  NOT NULL ,
    "tank_name" character varying(100)  NOT NULL ,
    "tank_id" integer  NOT NULL ,
    "tank_location" character varying(100)  NULL ,
    "tank_status" character varying(100)  NULL ,
    "federally_regulated" character varying(7)  NULL ,
    "tank_installation_date" date  NULL ,
    "tank_material_description" character varying(100)  NULL ,
    "tank_secondary_containment" character varying(100)  NULL );

ALTER TABLE as_ust."as_ust.erg_tank" ADD CONSTRAINT tankfk FOREIGN KEY (facility_id) REFERENCES as_ust."Facility"("FacilityID");

ALTER TABLE as_ust."as_ust.erg_tank" ADD CONSTRAINT erg_tank_pkey PRIMARY KEY (tank_name);

CREATE UNIQUE INDEX erg_tank_pkey ON as_ust.erg_tank USING btree (tank_name)