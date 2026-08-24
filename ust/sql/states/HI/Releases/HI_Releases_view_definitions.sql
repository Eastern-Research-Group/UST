------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view "hi_release"."v_ust_release" as
 SELECT DISTINCT (x."FacilityId")::character varying(50) AS facility_id,
    (x."EventID")::character varying(50) AS release_id,
    f."Facility Name" AS site_name,
    f."Street Address" AS site_address,
    z."City" AS site_city,
    z."ZIP Code" AS zipcode,
    z."County" AS county,
    z."State" AS state,
    ft.facility_type_id,
    f."LatitudeMeasure" AS latitude,
    f."LongitudeMeasure" AS longitude,
    cs.coordinate_source_id,
    rs.release_status_id,
    (x."LUSTLatestStatusDate")::date AS reported_date,
        CASE
            WHEN (x."LUSTLatestStatus" ~~ 'Site Cleanup Completed%'::text) THEN (x."LUSTLatestStatusDate")::date
            ELSE NULL::date
        END AS nfa_date,
        CASE
            WHEN (x."SoilContaminated" IS TRUE) THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_soil,
        CASE
            WHEN (x."GwContaminated" IS TRUE) THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_groundwater,
    rd.release_discovered_id
   FROM ((((((hi_release."tblLUSTSite" x
     LEFT JOIN hi_release."tblFacility" f ON (((x."FacilityId")::text = (f."FacilityID")::text)))
     LEFT JOIN hi_release."tlkpZIP" z ON (((f."ZIP Linkage")::text = z."ZIP Code")))
     LEFT JOIN hi_release.v_facility_type_xwalk ft ON ((f."Facility Description" = (ft.organization_value)::text)))
     LEFT JOIN hi_release.v_coordinate_source_xwalk cs ON ((f."HorizontalCollectionMethodName" = (cs.organization_value)::text)))
     LEFT JOIN hi_release.v_release_status_xwalk rs ON ((x."LUSTLatestStatus" = (rs.organization_value)::text)))
     LEFT JOIN hi_release.v_release_discovered_xwalk rd ON ((x."HowDiscovered" = (rd.organization_value)::text)))
  WHERE (x."LUSTLatestStatus" <> 'Case Transferred to HW (unregulated)'::text)
 and not exists (select 1 from hi_release.erg_unregulated_releases unregparent where x."EventID"::varchar(50) = unregparent.release_id);



create or replace view "hi_release"."v_ust_release_source" as
 SELECT DISTINCT (x."EventID")::character varying(50) AS release_id,
    s.source_id
   FROM (hi_release."tblLUSTSite" x
     LEFT JOIN hi_release.v_source_xwalk s ON ((x."Source" = (s.organization_value)::text)))
  WHERE ((x."Source" IS NOT NULL) AND (x."LUSTLatestStatus" <> 'Case Transferred to HW (unregulated)'::text))
 and not exists (select 1 from hi_release.erg_unregulated_releases unregparent where x."EventID"::varchar(50) = unregparent.release_id);



create or replace view "hi_release"."v_ust_release_cause" as
 SELECT DISTINCT (x."EventID")::character varying(50) AS release_id,
    c.cause_id
   FROM (hi_release."tblLUSTSite" x
     LEFT JOIN hi_release.v_cause_xwalk c ON ((x."Suspected Cause" = (c.organization_value)::text)))
  WHERE ((x."Suspected Cause" IS NOT NULL) AND (x."LUSTLatestStatus" <> 'Case Transferred to HW (unregulated)'::text))
 and not exists (select 1 from hi_release.erg_unregulated_releases unregparent where x."EventID"::varchar(50) = unregparent.release_id);