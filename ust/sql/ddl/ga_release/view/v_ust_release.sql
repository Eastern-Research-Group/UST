create or replace view "ga_release"."v_ust_release" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
        CASE
            WHEN (x."LUSTID" IS NOT NULL) THEN ((x."LUSTID")::character varying(50))::text
            ELSE b.release_id
        END AS release_id,
    (x."SiteName")::character varying(200) AS site_name,
    (x."SiteAddress")::character varying(100) AS site_address,
    (x."SiteCity")::character varying(100) AS site_city,
    (x."Zipcode")::character varying(10) AS zipcode,
    (x."County")::character varying(100) AS county,
    s.state,
        CASE
            WHEN (x."EPARegion" = 'Region 4'::text) THEN 4
            ELSE NULL::integer
        END AS epa_region,
    ft.facility_type_id,
    x."Latitude" AS latitude,
    x."Longitude" AS longitude,
    rs.release_status_id,
    (x."ReportedDate")::date AS reported_date,
    (x."NFADate")::date AS nfa_date,
        CASE
            WHEN (x."MilitaryDoDSite" = 'YES'::text) THEN 'Yes'::text
            WHEN (x."MilitaryDoDSite" = 'NO'::text) THEN 'No'::text
            ELSE NULL::text
        END AS military_dod_site
   FROM ((((ga_release.release x
     LEFT JOIN ga_release.v_state_xwalk s ON ((x."State" = (s.organization_value)::text)))
     LEFT JOIN ga_release.v_release_status_xwalk rs ON ((x."LUSTStatus" = (rs.organization_value)::text)))
     LEFT JOIN ga_release.v_facility_type_xwalk ft ON ((x."FacilityType" = (ft.organization_value)::text)))
     LEFT JOIN ga_release.erg_release_id b ON ((x."FacilityID" = b.facility_id)));