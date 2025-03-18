create or replace view "mo_release"."v_lust" as
 SELECT DISTINCT NULL::integer AS lust_id,
    NULL::integer AS lust_location_id,
    (f.facilityid)::character varying AS "FacilityID",
    NULL::character varying AS "TankIDAssociatedwithRelease",
    (r.remid)::character varying AS "LUSTID",
    NULL::character varying AS "FederallyReportableRelease",
    (g."NAME")::character varying AS "SiteName",
    (g.address)::character varying AS "SiteAddress",
    (g.address2)::character varying AS "SiteAddress2",
    NULL::character varying AS "SiteCity",
    (g.zip)::character varying AS "Zipcode",
    (c.countyname)::character varying AS "County",
    'MO'::text AS "State",
    7 AS "EPARegion",
    NULL::character varying AS "FacilityType",
    NULL::character varying AS "TribalSite",
    NULL::character varying AS "Tribe",
    ll.converted_lat AS "Latitude",
    ll.converted_long AS "Longitude",
    NULL::character varying AS "CoordinateSource",
        CASE
            WHEN (r.active = '-1'::integer) THEN 'Active: general'::text
            WHEN ((r.active = 0) AND (r.nofurtheraction IS NOT NULL)) THEN 'No Further Action'::text
            WHEN (r.active = 0) THEN 'Other'::text
            ELSE NULL::text
        END AS "LUSTStatus",
    (r.releasedate)::date AS "ReportedDate",
    (r.nofurtheraction)::date AS "NFADate",
        CASE
            WHEN (soil.remid IS NOT NULL) THEN 'Yes'::text
            ELSE 'No'::text
        END AS "MediaImpactedSoil",
        CASE
            WHEN (gw.remid IS NOT NULL) THEN 'Yes'::text
            ELSE 'No'::text
        END AS "MediaImpactedGroundwater",
        CASE
            WHEN (sw.remid IS NOT NULL) THEN 'Yes'::text
            ELSE 'No'::text
        END AS "MediaImpactedSurfaceWater",
    NULL::character varying AS "SubstanceReleased1",
    NULL::character varying AS "QuantityReleased1",
    NULL::character varying AS "Unit1",
    NULL::character varying AS "SubstanceReleased2",
    NULL::character varying AS "QuantityReleased2",
    NULL::character varying AS "Unit2",
    NULL::character varying AS "SubstanceReleased3",
    NULL::character varying AS "QuantityReleased3",
    NULL::character varying AS "Unit3",
    NULL::character varying AS "SubstanceReleased4",
    NULL::character varying AS "QuantityReleased4",
    NULL::character varying AS "Unit4",
    NULL::character varying AS "SubstanceReleased5",
    NULL::character varying AS "QuantityReleased5",
    NULL::character varying AS "Unit5",
    NULL::character varying AS "SourceOfRelease1",
    NULL::character varying AS "CauseOfRelease1",
    NULL::character varying AS "SourceOfRelease2",
    NULL::character varying AS "CauseOfRelease2",
    NULL::character varying AS "SourceOfRelease3",
    NULL::character varying AS "CauseOfRelease3",
    NULL::character varying AS "HowReleaseDetected",
        CASE
            WHEN ((t.remtechid)::text = '0'::text) THEN 'Air Sparging'::text
            WHEN ((t.remtechid)::text = '6'::text) THEN 'Excavation and Hauling'::text
            WHEN ((t.remtechid)::text = ANY (ARRAY[('7'::character varying)::text, ('E'::character varying)::text, ('F'::character varying)::text])) THEN 'Other'::text
            WHEN ((t.remtechid)::text = '9'::text) THEN 'Soil Vapor Extraction'::text
            WHEN ((t.remtechid)::text = '8'::text) THEN 'Duel phase extraction'::text
            WHEN ((t.remtechid)::text = 'A'::text) THEN 'Pump and treat'::text
            WHEN ((t.remtechid)::text = 'B'::text) THEN 'Monitored natural attenuation'::text
            WHEN ((t.remtechid)::text = 'D'::text) THEN 'Landfarming'::text
            WHEN ((t.remtechid)::text = 'W'::text) THEN 'Vacuum vaporizing well'::text
            WHEN ((t.remtechid)::text = 'Z'::text) THEN 'Oxygen or oxydizer injection or placement in excavation'::text
            ELSE NULL::text
        END AS "CorrectiveActionStrategy1",
    NULL::date AS "CorrectiveActionStrategy1StartDate",
    NULL::character varying AS "CorrectiveActionStrategy2",
    NULL::date AS "CorrectiveActionStrategy2StartDate",
    NULL::character varying AS "CorrectiveActionStrategy3",
    NULL::date AS "CorrectiveActionStrategy3StartDate",
    NULL::character varying AS "ClosedWithContamination",
    NULL::character varying AS "NoFurtherActionLetterURL",
    NULL::character varying AS "MilitaryDoDSite"
   FROM ((((((((mo_ust.tblfacility f
     LEFT JOIN mo_ust.tblgeosite g ON (((f.facilityid)::text = (g.facilityid)::text)))
     LEFT JOIN mo_ust.tblgeosite_latlong ll ON (((f.facilityid)::text = (ll.facilityid)::text)))
     LEFT JOIN mo_ust.tblcounty c ON ((g.county = c.countycode)))
     JOIN mo_ust.tblremediation r ON (((f.facilityid)::text = (r.facilityid)::text)))
     LEFT JOIN ( SELECT DISTINCT tblremmediaaffected.remid
           FROM mo_ust.tblremmediaaffected
          WHERE ((tblremmediaaffected.mediaaffectedid)::text = '1'::text)) soil ON (((r.remid)::text = (soil.remid)::text)))
     LEFT JOIN ( SELECT DISTINCT tblremmediaaffected.remid
           FROM mo_ust.tblremmediaaffected
          WHERE ((tblremmediaaffected.mediaaffectedid)::text = '2'::text)) gw ON (((r.remid)::text = (gw.remid)::text)))
     LEFT JOIN ( SELECT DISTINCT tblremmediaaffected.remid
           FROM mo_ust.tblremmediaaffected
          WHERE ((tblremmediaaffected.mediaaffectedid)::text = '4'::text)) sw ON (((r.remid)::text = (sw.remid)::text)))
     LEFT JOIN ( SELECT DISTINCT tblremtech.remid,
            tblremtech.remtechid
           FROM mo_ust.tblremtech) t ON (((r.remid)::text = (t.remid)::text)));