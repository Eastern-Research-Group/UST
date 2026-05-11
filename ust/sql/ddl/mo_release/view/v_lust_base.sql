create or replace view "mo_release"."v_lust_base" as
 SELECT f.facilityid AS "FacilityID",
    r.remid AS "LUSTID",
    g."NAME" AS "SiteName",
    g.address AS "SiteAddress",
    g.address2 AS "SiteAddress2",
    g.zip AS "Zipcode",
    c.countyname AS "County",
    'MO'::text AS "State",
    7 AS "EPARegion",
    ll.converted_lat AS "Latitude",
    ll.converted_long AS "Longitude",
        CASE
            WHEN (r.active = '-1'::integer) THEN 'Active: general'::text
            WHEN ((r.active = 0) AND (r.nofurtheraction IS NOT NULL)) THEN 'No Further Action'::text
            WHEN (r.active = 0) THEN 'Other'::text
            ELSE NULL::text
        END AS "LUSTStatus",
    r.releasedate AS "ReportedDate",
    r.nofurtheraction AS "NFADate",
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
        CASE
            WHEN ((t.remtechid)::text = '0'::text) THEN 'Air Sparging'::text
            WHEN ((t.remtechid)::text = '6'::text) THEN 'Excavation and Hauling'::text
            WHEN ((t.remtechid)::text = ANY ((ARRAY['7'::character varying, 'E'::character varying, 'F'::character varying])::text[])) THEN 'Other'::text
            WHEN ((t.remtechid)::text = '9'::text) THEN 'Soil Vapor Extraction'::text
            WHEN ((t.remtechid)::text = '8'::text) THEN 'Duel phase extraction'::text
            WHEN ((t.remtechid)::text = 'A'::text) THEN 'Pump and treat'::text
            WHEN ((t.remtechid)::text = 'B'::text) THEN 'Monitored natural attenuation'::text
            WHEN ((t.remtechid)::text = 'D'::text) THEN 'Landfarming'::text
            WHEN ((t.remtechid)::text = 'W'::text) THEN 'Vacuum vaporizing well'::text
            WHEN ((t.remtechid)::text = 'Z'::text) THEN 'Oxygen or oxydizer injection or placement in excavation'::text
            ELSE NULL::text
        END AS "CorrectiveActionStrategy1"
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