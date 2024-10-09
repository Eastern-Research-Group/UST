create or replace view "public"."v_ust_facility_dispenser" as
 SELECT DISTINCT c.ust_control_id,
    c.facility_id AS "FacilityID",
    d.dispenser_id AS "DispenserID",
    d.dispenser_udc AS "DispenserUDC",
    dw.dispenser_udc_wall_type AS "DispenserUDCWallType",
    d.dispenser_comment AS "DispenserComment"
   FROM ((ust_facility c
     JOIN ust_facility_dispenser d ON ((c.ust_facility_id = d.ust_facility_id)))
     LEFT JOIN dispenser_udc_wall_types dw ON ((d.dispenser_udc_wall_type_id = dw.dispenser_udc_wall_type_id)));