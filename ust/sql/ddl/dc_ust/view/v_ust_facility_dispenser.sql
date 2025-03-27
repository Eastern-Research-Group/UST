create or replace view "dc_ust"."v_ust_facility_dispenser" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."Dispenser ID" AS dispenser_id,
    max(x."Dispenser UDC") AS dispenser_udc
   FROM dc_ust.dispenser x
  WHERE (NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM dc_ust.erg_unregulated_facilities)))
  GROUP BY x."FacilityID", x."Dispenser ID";