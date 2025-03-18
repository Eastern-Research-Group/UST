create or replace view "sc_release"."v_lust" as
 SELECT DISTINCT (a.site_num)::character varying AS "FacilityID",
    NULL::character varying AS "TankIDAssociatedwithRelease",
        CASE
            WHEN (a.release_num IS NOT NULL) THEN replace(((((('SC_'::text || "substring"(a.facil_name, 1, 35)) || '_'::text) || a.release_num) || '_'::text) || (nextval('sc_release.lustid_seq'::regclass))::text), '__'::text, '_'::text)
            ELSE replace(((('SC_'::text || "substring"(a.facil_name, 1, 40)) || '_'::text) || (nextval('sc_release.lustid_seq'::regclass))::text), '__'::text, '_'::text)
        END AS "LUSTID",
    NULL::character varying AS "FederallyReportableRelease",
    (a.facil_name)::character varying AS "SiteName",
    (a.facil_address)::character varying AS "SiteAddress",
    NULL::character varying AS "SiteAddress2",
    (a.facil_city)::character varying AS "SiteCity",
    NULL::character varying AS "Zipcode",
    NULL::character varying AS "County",
    'SC'::text AS "State",
    4 AS "EPARegion",
    NULL::character varying AS "FacilityType",
    NULL::character varying AS "TribalSite",
    NULL::character varying AS "Tribe",
    b.lat_decimal AS "Latitude",
    b.long_decimal AS "Longitude",
    NULL::character varying AS "CoordinateSource",
        CASE
            WHEN ((a.cleanup_complete_date IS NULL) AND (a.cleanup_compl_mcl_date IS NULL)) THEN 'Active'::text
            WHEN (((a.cleanup_complete_date IS NOT NULL) AND (a.cleanup_compl_mcl_date IS NULL)) OR ((a.cleanup_complete_date IS NULL) AND (a.cleanup_compl_mcl_date IS NOT NULL))) THEN 'No Further Action'::text
            ELSE 'Other'::text
        END AS "LUSTStatus",
    to_date(a.confirmed_date, 'DD-MON-YY'::text) AS "ReportedDate",
        CASE
            WHEN (a.suspect_nfaed_date IS NOT NULL) THEN to_date(a.suspect_nfaed_date, 'DD-MON-YY'::text)
            WHEN (a.cleanup_complete_date IS NOT NULL) THEN to_date(a.cleanup_complete_date, 'DD-MON-YY'::text)
            WHEN (a.cleanup_compl_mcl_date IS NOT NULL) THEN to_date(a.cleanup_compl_mcl_date, 'DD-MON-YY'::text)
            ELSE NULL::date
        END AS "NFADate",
        CASE
            WHEN ((b.soil_contam_present = 'Y'::text) OR (b.soil_contam_present_on = 'Y'::text)) THEN 'Yes'::text
            WHEN ((b.soil_contam_present = 'N'::text) OR (b.soil_contam_present_on = 'N'::text)) THEN 'No'::text
            ELSE NULL::text
        END AS "MediaImpactedSoil",
        CASE
            WHEN ((b.gw_contam_present = 'Y'::text) OR (b.gw_contam_present_on = 'Y'::text)) THEN 'Yes'::text
            WHEN ((b.gw_contam_present = 'N'::text) OR (b.gw_contam_present_on = 'N'::text)) THEN 'No'::text
            ELSE NULL::text
        END AS "MediaImpactedGroundwater",
        CASE
            WHEN ((b.sw_contam_present = 'Y'::text) OR (b.sw_contam_present_on = 'Y'::text)) THEN 'Yes'::text
            WHEN ((b.sw_contam_present = 'N'::text) OR (b.sw_contam_present_on = 'N'::text)) THEN 'No'::text
            ELSE NULL::text
        END AS "MediaImpactedSurfaceWater",
    'Petroleum product'::text AS "SubstanceReleased1",
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
    NULL::character varying AS "CorrectiveActionStrategy1",
    NULL::date AS "CorrectiveActionStrategy1StartDate",
    NULL::character varying AS "CorrectiveActionStrategy2",
    NULL::date AS "CorrectiveActionStrategy2StartDate",
    NULL::character varying AS "CorrectiveActionStrategy3",
    NULL::date AS "CorrectiveActionStrategy3StartDate",
        CASE
            WHEN ((b.cleanup_complete_date IS NULL) AND (b.cleanup_compl_mcl_date IS NULL) AND (b.cnfa = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "ClosedWithContamination",
    NULL::character varying AS "NoFurtherActionLetterURL",
    NULL::character varying AS "MilitaryDoDSite",
    NULL::double precision AS gc_latitude,
    NULL::double precision AS gc_longitude,
    NULL::character varying AS gc_coordinate_source,
    NULL::character varying AS gc_address_type
   FROM (sc_release.ustleak_20211013 a
     LEFT JOIN sc_release.lwmopc_20211013 b ON (((a.site_num = sc_release.convert_site_num_int(b.site_num)) AND (a.release_num = (b.release_num)::double precision))));