create or replace view "ia_release"."v_ust_release" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."LUSTID")::character varying(50) AS release_id,
    (x."FederallyReportableRelease")::character varying(7) AS federally_reportable_release,
    (x."SiteName")::character varying(200) AS site_name,
    (x."SiteAddress")::character varying(100) AS site_address,
    (x."SiteAddress2")::character varying(100) AS site_address2,
    (x."SiteCity")::character varying(100) AS site_city,
    (x."Zipcode")::character varying(10) AS zipcode,
    (x."County")::character varying(100) AS county,
    'IA'::text AS state,
    (x."EPARegion")::integer AS epa_region,
    x."Latitude" AS latitude,
    x."Longitude" AS longitude,
    cs.coordinate_source_id,
    rs.release_status_id,
    (x."ReportedDate")::date AS reported_date,
    (x."NFADate")::date AS nfa_date,
    (x."MediaImpactedSoil")::character varying(3) AS media_impacted_soil,
    (x."MediaImpactedGroundwater")::character varying(3) AS media_impacted_groundwater,
    (x."MediaImpactedSurfaceWater")::character varying(3) AS media_impacted_surface_water,
    hrd.release_discovered_id,
    (x."ClosedWithContamination")::character varying(7) AS closed_with_contamination,
    (x."MilitaryDoDSite")::character varying(7) AS military_dod_site,
    20 AS facility_type_id
   FROM (((ia_release."Template" x
     LEFT JOIN ia_release.v_coordinate_source_xwalk cs ON ((x."CoordinateSource" = (cs.organization_value)::text)))
     LEFT JOIN ia_release.v_release_status_xwalk rs ON ((x."LUSTStatus" = (rs.organization_value)::text)))
     LEFT JOIN ia_release.v_release_discovered_xwalk hrd ON ((x."HowReleaseDetected" = (hrd.organization_value)::text)))
  WHERE (x."LUSTStatus" IS NOT NULL);