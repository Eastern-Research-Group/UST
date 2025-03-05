create or replace view "tn_release"."v_ust_release" as
 SELECT DISTINCT (((x."Facilityid" || '-'::text) || x."Sitenumber"))::character varying(50) AS release_id,
    (x."Facilityid")::character varying(50) AS facility_id,
    (x."Facilityname")::character varying(200) AS site_name,
    (x."Facilityaddress1")::character varying(100) AS site_address,
    (x."Facilityaddress2")::character varying(100) AS site_address2,
    (x."Facilitycity")::character varying(100) AS site_city,
    (x."Facilityzip")::character varying(10) AS zipcode,
    (x."Facilitycounty")::character varying(100) AS county,
    'TN'::text AS state,
    4 AS epa_region,
    rs.release_status_id,
    (x."Discoverydate")::date AS reported_date,
    rd.release_discovered_id
   FROM ((tn_release."ust_all-tn-environmental-sites" x
     LEFT JOIN tn_release.v_release_status_xwalk rs ON ((x."Currentstatus" = (rs.organization_value)::text)))
     LEFT JOIN tn_release.v_release_discovered_xwalk rd ON ((x."Howdiscovered" = (rd.organization_value)::text)))
  WHERE ((rs.organization_value IS NOT NULL) AND (x."Currentstatus" <> ALL (ARRAY['0a Suspected Release - Closed'::text, '0 Suspected Release - RD records'::text, '3 Release Investigation'::text])) AND (x."Discoverydate" IS NOT NULL));