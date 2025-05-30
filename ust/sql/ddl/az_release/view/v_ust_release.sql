create or replace view "az_release"."v_ust_release" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankIDAssociatedwithRelease")::character varying(50) AS tank_id_associated_with_release,
    (x."LUSTID")::character varying(50) AS release_id,
    (x."FederallyReportableRelease")::character varying(7) AS federally_reportable_release,
    (x."SiteName")::character varying(200) AS site_name,
    (x."SiteAddress")::character varying(100) AS site_address,
    (x."SiteAddress2")::character varying(100) AS site_address2,
    (x."SiteCity")::character varying(100) AS site_city,
    (x."Zipcode")::character varying(10) AS zipcode,
    (x."County")::character varying(100) AS county,
    x."State" AS state,
    (x."EPARegion")::integer AS epa_region,
    (x."TribalSite")::character varying(7) AS tribal_site,
    (x."Tribe")::character varying(50) AS tribe,
    x."Latitude" AS latitude,
    x."Longitude" AS longitude,
    rs.release_status_id,
    (x."ReportedDate")::date AS reported_date,
    (x."NFADate")::date AS nfa_date,
    (x."MediaImpactedSoil")::character varying(3) AS media_impacted_soil,
    (x."MediaImpactedGroundwater")::character varying(3) AS media_impacted_groundwater,
    (x."MediaImpactedSurfaceWater")::character varying(3) AS media_impacted_surface_water,
    (x."ClosedWithContamination")::character varying(7) AS closed_with_contamination,
    (x."NoFurtherActionLetterURL")::character varying(2000) AS no_further_action_letter_url,
    (x."MilitaryDoDSite")::character varying(7) AS military_dod_site
   FROM (az_release.ust_release x
     LEFT JOIN az_release.v_release_status_xwalk rs ON ((x."LUSTStatus" = (rs.organization_value)::text)));