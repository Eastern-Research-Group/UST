CREATE TABLE as_ust.erg_piping (
    "facility_id" text  NOT NULL ,
    "tank_name" text  NULL ,
    "tank_id" text  NOT NULL ,
    "compartment_id" integer  NULL ,
    "piping_id" integer  NULL ,
    "piping_style" text  NULL ,
    "safesuction" text  NULL ,
    "piping_material_frp" text  NULL ,
    "piping_material_steel" text  NULL ,
    "piping_material_flex" text  NULL ,
    "piping_flex_connector" text  NULL ,
    "piping_line_leak_detector" text  NULL ,
    "piping_line_test_annual" text  NULL ,
    "piping_line_test3yr" text  NULL ,
    "piping_release_detection_other" text  NULL ,
    "pipe_tank_topsump" text  NULL ,
    "pipe_tank_topsump_walltype" text  NULL ,
    "piping_wall_type" text  NULL );

ALTER TABLE as_ust."as_ust.erg_piping" ADD CONSTRAINT erg_piping_pkey PRIMARY KEY (facility_id, tank_id);

CREATE UNIQUE INDEX erg_piping_pkey ON as_ust.erg_piping USING btree (facility_id, tank_id)