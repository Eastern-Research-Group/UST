create or replace view "public"."v_ust_compartment_dispenser" as
 SELECT c.ust_control_id,
    c.facility_id AS "FacilityID",
    b.tank_id AS "TankID",
    b.tank_name AS "TankName",
    a.compartment_id AS "CompartmentID",
    a.compartment_name AS "CompartmentName",
    d.dispenser_id AS "DispenserID",
    d.dispenser_udc AS "DispenserUDC",
    dw.dispenser_udc_wall_type AS "DispenserUDCWallType"
   FROM ((((ust_compartment a
     JOIN ust_tank b ON ((a.ust_tank_id = b.ust_tank_id)))
     JOIN ust_facility c ON ((b.ust_facility_id = c.ust_facility_id)))
     JOIN ust_tank_dispenser d ON ((b.ust_tank_id = d.ust_tank_id)))
     LEFT JOIN dispenser_udc_wall_types dw ON ((d.dispenser_udc_wall_type_id = dw.dispenser_udc_wall_type_id)));