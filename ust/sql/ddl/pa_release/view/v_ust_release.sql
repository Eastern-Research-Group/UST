create or replace view "pa_release"."v_ust_release" as
 SELECT DISTINCT (x."FACILITY_ID")::character varying(50) AS facility_id,
    (x."TANK")::character varying(50) AS tank_id_associated_with_release,
    (x."INCIDENT_ID")::character varying(50) AS release_id,
    (x."FACILITY_NAME")::character varying(200) AS site_name,
    (x."ADDRESS1")::character varying(100) AS site_address,
    (x."ADDRESS2")::character varying(100) AS site_address2,
    (x."CITY")::character varying(100) AS site_city,
    (x."ZIP")::character varying(10) AS zipcode,
    'PA'::text AS state,
    3 AS epa_region,
    x."LATITUDE" AS latitude,
    x."LONGITUDE" AS longitude,
    cs.coordinate_source_id,
    rs.release_status_id,
    (x."CONFIRMED_DATE")::date AS reported_date,
        CASE
            WHEN (x."STATUS_DESCRIPTION" = 'Cleanup Completed'::text) THEN (x."STATUS_DATE")::date
            ELSE NULL::date
        END AS nfa_date,
        CASE
            WHEN (x."IMPACT_DESCRIPTION" = 'Soil'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_soil,
        CASE
            WHEN (x."IMPACT_DESCRIPTION" = 'Ground Water'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_groundwater,
        CASE
            WHEN (x."IMPACT_DESCRIPTION" = 'Surface Water'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_surface_water,
    rd.release_discovered_id
   FROM (((pa_release."Tank_Cleanup_Incidents" x
     LEFT JOIN pa_release.v_coordinate_source_xwalk cs ON ((x."HOR_REF_DATUM" = (cs.organization_value)::text)))
     LEFT JOIN pa_release.v_release_status_xwalk rs ON ((x."STATUS_DESCRIPTION" = (rs.organization_value)::text)))
     LEFT JOIN pa_release.v_release_discovered_xwalk rd ON ((x."RELEASE_DISCOVERED" = (rd.organization_value)::text)))
  WHERE (x."INCIDENT_TYPE" <> 'AST'::text);