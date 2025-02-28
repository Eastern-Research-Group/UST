create or replace view "hi_release"."v_ust_release" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."LUSTID")::character varying(50) AS release_id,
    (x."SiteName")::character varying(200) AS site_name,
    (x."SiteAddress")::character varying(100) AS site_address,
    (x."SiteAddress2")::character varying(100) AS site_address2,
    (x."SiteCity")::character varying(100) AS site_city,
    (x."Zipcode")::character varying(10) AS zipcode,
    (x."County")::character varying(100) AS county,
    'HI'::text AS state,
    (x."EPARegion")::integer AS epa_region,
    x."Latitude" AS latitude,
    x."Longitude" AS longitude,
    cs.coordinate_source_id,
    rs.release_status_id,
    (x."ReportedDate")::date AS reported_date,
    (x."DataCollectionDate")::date AS nfa_date,
    hrd.release_discovered_id,
    ft.facility_type_id,
    'Yes'::text AS federally_reportable_release,
        CASE
            WHEN (x."ClosedWithContamination" IS NULL) THEN NULL::text
            WHEN (x."ClosedWithContamination" = '`'::text) THEN NULL::text
            ELSE 'Yes'::text
        END AS closed_with_contamination
   FROM ((((hi_release.release x
     LEFT JOIN hi_release.v_coordinate_source_xwalk cs ON ((x."HorizontalCollectionMethodName" = (cs.organization_value)::text)))
     LEFT JOIN hi_release.v_release_status_xwalk rs ON ((x."LUSTLatestStatus" = (rs.organization_value)::text)))
     LEFT JOIN hi_release.v_release_discovered_xwalk hrd ON ((x."HowReleaseDetected" = (hrd.organization_value)::text)))
     LEFT JOIN hi_release.v_facility_type_xwalk ft ON ((x."FacilityType" = (ft.organization_value)::text)));