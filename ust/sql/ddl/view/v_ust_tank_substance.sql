create or replace view "public"."v_ust_tank_substance" as
 SELECT f.ust_control_id,
    f.facility_id AS "FacilityID",
    t.tank_id AS "TankID",
    t.tank_name AS "TankName",
    s.substance AS "Substance",
    ts.substance_casno AS "SubstanceCASNO",
    ts.substance_comment AS "SubstanceComment"
   FROM (((ust_tank t
     JOIN ust_facility f ON ((t.ust_facility_id = f.ust_facility_id)))
     LEFT JOIN ust_tank_substance ts ON ((t.ust_tank_id = ts.ust_tank_id)))
     LEFT JOIN substances s ON ((ts.substance_id = s.substance_id)));