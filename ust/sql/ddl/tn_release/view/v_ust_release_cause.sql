create or replace view "tn_release"."v_ust_release_cause" as
 SELECT DISTINCT (r.release_id)::character varying(50) AS release_id,
    rc.cause_id
   FROM ((tn_release."ust_all-tn-environmental-sites" x
     JOIN tn_release.erg_release_id r ON (((x."Facilityid" = r."Facilityid") AND (x."Sitenumber" = r."Sitenumber"))))
     JOIN tn_release.v_cause_xwalk rc ON ((x."Cause" = (rc.organization_value)::text)))
  WHERE ((x."Currentstatus" <> ALL (ARRAY['0a Suspected Release - Closed'::text, '0 Suspected Release - RD records'::text, '3 Release Investigation'::text])) AND (x."Discoverydate" IS NOT NULL));