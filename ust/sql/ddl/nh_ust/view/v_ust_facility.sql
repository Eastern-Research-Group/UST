create or replace view "nh_ust"."v_ust_facility" as
 SELECT DISTINCT (a."FACILITY_ID")::character varying(50) AS facility_id,
    (a."REGISTERED_NAME")::character varying(100) AS facility_name,
    f.owner_type_id,
    e.facility_type_id AS facility_type1,
    (st."SITE_ADDRESS")::character varying(100) AS facility_address1,
    (st."SITE_CITY")::character varying(100) AS facility_city,
    gis."GIS_LAT" AS facility_latitude,
    gis."GIS_LON" AS facility_longitude,
    d.coordinate_source_id,
    (a."OWNER_NAME")::character varying(100) AS facility_owner_company_name,
    1 AS facility_epa_region,
    'NH'::text AS facility_state
   FROM (((((((nh_ust.facilities a
     LEFT JOIN nh_ust.site st ON ((a."SITE_NUMBER" = st."SITE_NUMBER")))
     LEFT JOIN nh_ust."UST_V2_template_03_01_24_GISInfoUSTs" gis ON ((a."FACILITY_ID" = gis."UST_FACILITY_ID")))
     LEFT JOIN nh_ust.v_coordinate_source_xwalk d ON ((gis."GIS_COLLECTION_METHOD" = (d.organization_value)::text)))
     LEFT JOIN nh_ust.erg_facility_owner_type_mapping y ON ((a."FACILITY_ID" = y."FACILITY_ID")))
     LEFT JOIN nh_ust.v_facility_type_xwalk e ON ((y.facility_type_data = (e.organization_value)::text)))
     LEFT JOIN nh_ust.erg_facility_owner_type_mapping z ON ((a."FACILITY_ID" = z."FACILITY_ID")))
     LEFT JOIN nh_ust.v_owner_type_xwalk f ON ((z.owner_type_data = (f.organization_value)::text)))
  WHERE ((a."FACILITY_TYPE" <> 'PROPOSED FACILITY'::text) AND (NOT (((a."FACILITY_ID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM nh_ust.erg_unregulated_facilities))));