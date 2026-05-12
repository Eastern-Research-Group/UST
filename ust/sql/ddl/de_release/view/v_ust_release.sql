create or replace view "de_release"."v_ust_release" as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    x."LUSTID" AS release_id,
    x."FederallyReportableRelease" AS federally_reportable_release,
    x."SiteName" AS site_name,
    x."SiteAddress" AS site_address,
    x."SiteAddress2" AS site_address2,
    x."Zipcode" AS zipcode,
    x."State" AS state,
    x."CoordinateSource" AS coordinate_source_id,
    x."LUSTStatus" AS release_status_id,
    x."ReportedDate" AS reported_date,
    x."NFADate" AS nfa_date,
    x."MediaImpactedSoil" AS media_impacted_soil,
    x."MediaImpactedGroundwater" AS media_impacted_groundwater,
    x."HowReleaseDetected" AS release_discovered_id,
    x."ClosedWithContamination" AS closed_with_contamination,
    x."MilitaryDoDSite" AS military_dod_site
   FROM (de_release."Template" x
     LEFT JOIN de_release.v_coordinate_source_xwalk cs ON ((x."CoordinateSource" = (cs.organization_value)::text)));