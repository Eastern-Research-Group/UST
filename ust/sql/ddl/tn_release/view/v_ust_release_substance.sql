create or replace view "tn_release"."v_ust_release_substance" as
 SELECT DISTINCT (r.release_id)::character varying(50) AS release_id,
    b.substance_id
   FROM (((tn_release."ust_all-tn-environmental-sites" a
     JOIN tn_release.erg_release_id r ON (((a."Facilityid" = r."Facilityid") AND (a."Sitenumber" = r."Sitenumber"))))
     JOIN tn_release.erg_productreleased_datarows_deagg d ON (((a."Facilityid" = d."Facilityid") AND (a."Sitenumber" = d."Sitenumber"))))
     JOIN tn_release.v_substance_xwalk b ON (((d."Productreleased")::text = (b.organization_value)::text)))
  WHERE ((b.epa_value IS NOT NULL) AND (a."Currentstatus" <> ALL (ARRAY['0a Suspected Release - Closed'::text, '0 Suspected Release - RD records'::text, '3 Release Investigation'::text])));