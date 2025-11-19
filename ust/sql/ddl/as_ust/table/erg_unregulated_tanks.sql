CREATE TABLE as_ust.erg_unregulated_tanks (
    "facility_id" character varying(50)  NOT NULL ,
    "tank_id" integer  NOT NULL );

ALTER TABLE me_ust."me_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE tn_ust."tn_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE ut_ust."ut_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE ok_ust."ok_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE va_ust."va_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE vt_ust."vt_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE nj_ust."nj_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE de_ust."de_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE il_ust."il_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE wv_ust."wv_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE az_ust."az_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE as_ust."as_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE dc_ust."dc_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

ALTER TABLE nh_ust."nh_ust.erg_unregulated_tanks" ADD CONSTRAINT erg_unregulated_tanks_pk PRIMARY KEY (facility_id, tank_id);

CREATE UNIQUE INDEX erg_unregulated_tanks_pk ON as_ust.erg_unregulated_tanks USING btree (facility_id, tank_id)