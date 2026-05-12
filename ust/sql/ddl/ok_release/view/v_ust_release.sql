create or replace view "ok_release"."v_ust_release" as
 SELECT DISTINCT (y.facility_number)::character varying(50) AS facility_id,
    (y.case_number)::character varying(50) AS release_id,
    (y."Facility Name")::character varying(200) AS site_name,
    (y."Address")::character varying(100) AS site_address,
    (y."City")::character varying(100) AS site_city,
    (y."Zip Code")::character varying(10) AS zipcode,
    y."Latitude" AS latitude,
    y."Longitude" AS longitude,
    rs.release_status_id,
    (y."Release Date")::date AS reported_date,
    (y."Close Date")::date AS nfa_date,
    6 AS epa_region,
    'OK'::text AS state
   FROM (ok_release.ok_releases y
     JOIN ok_release.v_release_status_xwalk rs ON (((y."Case Status" = (rs.organization_value)::text) AND (TRIM(BOTH FROM y."Case Status") <> 'Deactivate'::text))));