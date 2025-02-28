create or replace view "nh_ust"."v_ust_facility" as
 SELECT DISTINCT (fac."FACILITY_ID")::character varying(50) AS facility_id,
    (fac."REGISTERED_NAME")::character varying(100) AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    (x."SITE_ADDRESS")::character varying(100) AS facility_address1,
    (x."SITE_CITY")::character varying(100) AS facility_city,
    y."GIS_LAT" AS facility_latitude,
    y."GIS_LON" AS facility_longitude,
    cs.coordinate_source_id,
    (fac."OWNER_NAME")::character varying(100) AS facility_owner_company_name,
    1 AS facility_epa_region,
    'NH'::text AS facility_state
   FROM (((((nh_ust.facilities fac
     LEFT JOIN nh_ust.site x ON ((x."SITE_NUMBER" = fac."SITE_NUMBER")))
     LEFT JOIN nh_ust.v_owner_type_xwalk ot ON ((fac."OWNER_TYPE" = (ot.organization_value)::text)))
     LEFT JOIN nh_ust."UST_V2_template_03_01_24_GISInfoUSTs" y ON ((x."SITE_NUMBER" = y."SITE_NUMBER")))
     LEFT JOIN nh_ust.v_coordinate_source_xwalk cs ON ((y."GIS_COLLECTION_METHOD" = (cs.organization_value)::text)))
     LEFT JOIN nh_ust.v_facility_type_xwalk ft ON ((fac."FACILITY_TYPE" = (ft.organization_value)::text)));