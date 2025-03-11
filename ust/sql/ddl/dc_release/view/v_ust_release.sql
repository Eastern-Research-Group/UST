create or replace view "dc_release"."v_ust_release" as
 SELECT DISTINCT (x."Facility ID")::text AS facility_id,
        CASE
            WHEN ((x."LUSTID" = 2017009) AND (x."Facility ID" = 5005491)) THEN '2025005'::text
            ELSE (x."LUSTID")::text
        END AS release_id,
    x."Federally Reportable Release" AS federally_reportable_release,
    x."Site Name" AS site_name,
    x."Site Address" AS site_address,
    x."Site City" AS site_city,
    (x."Zipcode")::text AS zipcode,
    s.state,
    (x."EPARegion")::integer AS epa_region,
    x."Latitude" AS latitude,
    x."Longitude" AS longitude,
    cs.coordinate_source_id,
    rs.release_status_id,
    (x."Reported Date")::date AS reported_date,
    (x."NFADate")::date AS nfa_date,
    x."Media Impacted Soil" AS media_impacted_soil,
    x."Media Impacted Groundwater" AS media_impacted_groundwater,
    x."Media Impacted Surface Water" AS media_impacted_surface_water,
    x."Military Do DSite" AS military_dod_site
   FROM (((dc_release.release x
     LEFT JOIN dc_release.v_state_xwalk s ON ((x."State" = (s.organization_value)::text)))
     LEFT JOIN dc_release.v_coordinate_source_xwalk cs ON ((x."Coordinate Source" = (cs.organization_value)::text)))
     LEFT JOIN dc_release.v_release_status_xwalk rs ON ((x."LUSTStatus" = (rs.organization_value)::text)));