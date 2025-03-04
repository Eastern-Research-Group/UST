create or replace view "wv_release"."v_ust_release" as
 SELECT (a."Facility_ID")::character varying(50) AS facility_id,
    (a."Leak_ID")::character varying(50) AS release_id,
    (a."Current Facility Name")::character varying(200) AS site_name,
    (a."Address")::character varying(100) AS site_address,
    (a."City")::character varying(100) AS site_city,
    (a."Zip")::character varying(10) AS zipcode,
    (a."County")::character varying(100) AS county,
    'WV'::text AS state,
    3 AS epa_region,
    rs.release_status_id,
    (a."Confirmed Release")::date AS reported_date,
    (a."Closed Date")::date AS nfa_date,
        CASE
            WHEN (a."Priority" = '3-Soil contamination'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_soil,
        CASE
            WHEN (a."Priority" = '2-Groundwater contamination'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_groundwater
   FROM ((wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" a
     LEFT JOIN wv_release.erg_release_status b ON ((a."Leak_ID" = b.release_id)))
     LEFT JOIN wv_release.v_release_status_xwalk rs ON ((b.release_status = (rs.epa_value)::text)))
  WHERE (a."Suspected Release" <> 'Yes'::text);