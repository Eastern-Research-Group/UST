create or replace view "public"."v_ust_release" as
 SELECT DISTINCT a.release_control_id,
    a.facility_id AS "FacilityID",
    a.tank_id_associated_with_release AS "TankIDAssociatedwithRelease",
    a.release_id AS "ReleaseID",
    a.federally_reportable_release AS "FederallyReportableRelease",
    a.site_name AS "SiteName",
    a.site_address AS "SiteAddress",
    a.site_address2 AS "SiteAddress2",
    a.site_city AS "SiteCity",
    a.zipcode AS "Zipcode",
    a.county AS "County",
    a.state AS "State",
    a.epa_region AS "EPARegion",
    ft.facility_type AS "FacilityType",
    a.tribal_site AS "TribalSite",
    a.tribe AS "Tribe",
    a.latitude AS "Latitude",
    a.longitude AS "Longitude",
    cs.coordinate_source AS "CoordinateSource",
    rs.release_status AS "USTReleaseStatus",
    a.reported_date AS "ReportedDate",
    a.nfa_date AS "NFADate",
    a.media_impacted_soil AS "MediaImpactedSoil",
    a.media_impacted_groundwater AS "MediaImpactedGroundwater",
    a.media_impacted_surface_water AS "MediaImpactedSurfaceWater",
    hrd.release_discovered AS "ReleaseDiscovered",
    a.closed_with_contamination AS "ClosedWithContamination",
    a.no_further_action_letter_url AS "NoFurtherActionLetterURL",
    a.military_dod_site AS "MilitaryDoDSite",
    a.release_comment AS "ReleaseComment",
    a.cui_flag AS "CuiFlag"
   FROM ((((ust_release a
     LEFT JOIN facility_types ft ON ((a.facility_type_id = ft.facility_type_id)))
     LEFT JOIN coordinate_sources cs ON ((a.coordinate_source_id = cs.coordinate_source_id)))
     LEFT JOIN release_statuses rs ON ((a.release_status_id = rs.release_status_id)))
     LEFT JOIN release_discovered hrd ON ((a.release_discovered_id = hrd.release_discovered_id)));