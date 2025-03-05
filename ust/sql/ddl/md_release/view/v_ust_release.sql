create or replace view "md_release"."v_ust_release" as
 SELECT DISTINCT (x."REG_NUMBER")::character varying(50) AS facility_id,
    (x."CASE_NO")::character varying(50) AS release_id,
    (x."SPILL_LOC")::character varying(200) AS site_name,
    (x."ADDRESS")::character varying(100) AS site_address,
    (x."CITY")::character varying(100) AS site_city,
    (x."ZIP")::character varying(10) AS zipcode,
    rs.release_status_id,
    (x."DATE_OPEN")::date AS reported_date,
    (x."DT_CLOSED")::date AS nfa_date,
    3 AS epa_region,
    'MD'::text AS state,
    vftx.facility_type_id
   FROM (((md_release.md_release_combined x
     LEFT JOIN md_release.md_supp_tank_data mstd ON ((x."REG_NUMBER" = (mstd."FacilityID")::text)))
     LEFT JOIN md_release.v_facility_type_xwalk vftx ON ((mstd."FacilityDesc" = (vftx.organization_value)::text)))
     LEFT JOIN md_release.v_release_status_xwalk rs ON ((x."STATUS" = (rs.organization_value)::text)))
  WHERE ((x."RELEASE" = 'YES'::text) AND (x."CODE" ~~ 'B%'::text));