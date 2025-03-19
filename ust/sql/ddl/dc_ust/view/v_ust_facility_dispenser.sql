create or replace view "dc_ust"."v_ust_facility_dispenser" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."Dispenser ID" AS dispenser_id,
    max(x."Dispenser UDC") AS dispenser_udc
   FROM dc_ust.dispenser x
  GROUP BY x."FacilityID", x."Dispenser ID";