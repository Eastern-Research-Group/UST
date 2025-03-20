create or replace view "mp_release"."v_ust_release" as
 SELECT DISTINCT (x.deq_id)::character varying(50) AS facility_id,
    (x.deq_id)::character varying(50) AS release_id,
    (x."FACILITY NAME")::character varying(200) AS site_name,
    (x."VILLAGE")::character varying(100) AS site_address,
    (x."ISLAND")::character varying(100) AS site_city,
    (x."ISLAND")::character varying(100) AS county,
    ft.facility_type_id,
    x."Latitude gearth" AS latitude,
    x."Longitude gearth" AS longitude,
    rs.release_status_id,
    9 AS epa_region,
    'MP'::text AS state
   FROM ((mp_release.mp_releases x
     LEFT JOIN mp_release.v_release_status_xwalk rs ON ((x.release_status = (rs.organization_value)::text)))
     LEFT JOIN mp_release.v_facility_type_xwalk ft ON ((x."FACILITY TYPE" = (ft.organization_value)::text)));