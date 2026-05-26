


/*********** v_ust_release ***********/
--There are 0 rows in wv_release.v_ust_release that do not exist in public.v_ust_release

select * from wv_release.v_ust_release a
where not exists
	(select 1 from public.v_ust_release b
	where a.release_id = b."ReleaseID")
order by a.release_id;

--View definition for wv_release.v_ust_release:
 SELECT (a."Facility_ID")::character varying(50) AS facility_id,
    (a."Leak_ID")::character varying(50) AS release_id,
    (a."Current Facility Name")::character varying(200) AS site_name,
    (a."Address")::character varying(100) AS site_address,
    (a."City")::character varying(100) AS site_city,
    (a."Zip")::character varying(10) AS zipcode,
    (a."County")::character varying(100) AS county,
    u."Latitude" AS latitude,
    u."Longitude" AS longitude,
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
   FROM (((wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" a
     LEFT JOIN wv_release.erg_release_status b ON ((a."Leak_ID" = b.release_id)))
     LEFT JOIN wv_release.v_release_status_xwalk rs ON ((b.release_status = (rs.epa_value)::text)))
     LEFT JOIN wv_release.ustlustlocations u ON ((a."Facility_ID" = (u."Facility Id")::text)))
  WHERE (a."Suspected Release" <> 'Yes'::text);