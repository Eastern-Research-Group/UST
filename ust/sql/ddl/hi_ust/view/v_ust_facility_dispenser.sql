create or replace view "hi_ust"."v_ust_facility_dispenser" as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
        CASE
            WHEN (a."DispenserID" IS NOT NULL) THEN a."DispenserID"
            ELSE (b.dispenser_id)::text
        END AS dispenser_id,
        CASE
            WHEN (a."UDCInstalled" = true) THEN 'Yes'::text
            WHEN (a."UDCInstalled" = false) THEN 'No'::text
            ELSE NULL::text
        END AS dispenser_udc
   FROM (hi_ust.dispenser a
     LEFT JOIN hi_ust.erg_dispenser_id b ON ((a."FacilityID" = (b.facility_id)::text)));