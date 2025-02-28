create or replace view "il_ust"."v_ust_facility_dispenser" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."DispenserID" AS dispenser_id,
    x."DispenserUDC" AS dispenser_udc
   FROM il_ust.facility_dispenser x;