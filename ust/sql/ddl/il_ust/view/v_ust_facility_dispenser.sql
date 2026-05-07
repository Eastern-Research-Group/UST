create or replace view "il_ust"."v_ust_facility_dispenser" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."DispenserID" AS dispenser_id,
    x."DispenserUDC" AS dispenser_udc
   FROM il_ust.facility_dispenser x
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE (((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text)))) AND (NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM il_ust.erg_unregulated_facilities))));