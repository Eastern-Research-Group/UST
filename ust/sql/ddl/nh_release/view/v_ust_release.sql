create or replace view "nh_release"."v_ust_release" as
 SELECT DISTINCT
        CASE
            WHEN (ex.site_number IS NULL) THEN (x.facility_id)::character varying(50)
            ELSE NULL::character varying
        END AS facility_id,
    (x.site_number)::character varying(50) AS release_id,
    (x.site_name)::character varying(200) AS site_name,
    (x.site_address)::character varying(100) AS site_address,
    (x.site_city)::character varying(100) AS site_city,
        CASE
            WHEN (ext.site_number IS NULL) THEN rd.facility_type_id
            ELSE NULL::integer
        END AS facility_type_id,
    cs."GIS_LAT" AS latitude,
    cs."GIS_LON" AS longitude,
        CASE rs.release_status_id
            WHEN 6 THEN rs.release_status_id
            ELSE 1
        END AS release_status_id,
    (x.project_start_date)::date AS reported_date,
    'NH'::text AS state,
    1 AS epa_region
   FROM ((((((( SELECT nh_release.site_number,
            max(nh_release.project_start_date) AS project_start_date
           FROM nh_release.nh_release
          GROUP BY nh_release.site_number) a
     JOIN nh_release.nh_release x ON (((a.site_number = x.site_number) AND (a.project_start_date = x.project_start_date))))
     LEFT JOIN nh_release.nh_release_gis cs ON (((x.site_number = cs."SITE_NUMBER") AND (x.project_rsn = cs."PROJECT_HEADER_RSN"))))
     LEFT JOIN nh_release.v_release_status_xwalk rs ON ((x."LUSTstatusOrProjMgrName" = (rs.organization_value)::text)))
     LEFT JOIN nh_release.v_facility_type_xwalk rd ON ((x.facility_type = (rd.organization_value)::text)))
     LEFT JOIN nh_release.erg_multiple_facids_to_exclude ex ON ((x.site_number = ex.site_number)))
     LEFT JOIN nh_release.erg_multiple_factypes_to_exclude ext ON ((x.site_number = ex.site_number)));