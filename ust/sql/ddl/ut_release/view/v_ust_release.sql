create or replace view "ut_release"."v_ust_release" as
 SELECT DISTINCT (y."FACILITYID")::character varying(50) AS facility_id,
    (y."LUSTKEY")::character varying(50) AS release_id,
    (x."LOCNAME")::character varying(200) AS site_name,
    (x."LOCSTR")::character varying(100) AS site_address,
    (x."LOCCITY")::character varying(100) AS site_city,
    (x."LOCZIP")::character varying(10) AS zipcode,
    (x."LOCCOUNTY")::character varying(100) AS county,
    ft.facility_type_id,
    x."DDLat" AS latitude,
    x."DDLon" AS longitude,
    rs.release_status_id,
    (y."NOTIFICATI")::date AS reported_date,
    (y."DATECLOSE")::date AS nfa_date,
    8 AS epa_region,
    'UT'::text AS state,
    (((((((y."DEPTHGW" || ' - is the general depth to groundwater at the release site. '::text) || y."GWFLOWDIR1") || ' - is the groundwater flow direction at the release site.   '::text) || y."GWFLOWDIR2") || ' - An additional groundwater flow direction if it fluctuates seasonally.  '::text) || y."CAPH2OTREA") || ' - is a volume of groundwater treated by corrective action, generally used for pump and treat technologies.'::text) AS release_comment
   FROM (((ut_release.ut_lust y
     JOIN ut_release.fac x ON ((x."FacilityID" = y."FACILITYID")))
     LEFT JOIN ut_release.v_release_status_xwalk rs ON ((y."NFAFORM" = (rs.organization_value)::text)))
     LEFT JOIN ut_release.v_facility_type_xwalk ft ON ((x."FACILITYDE" = (ft.organization_value)::text)))
  WHERE (x."RELEASE" > 0);