create or replace view "sc_release"."v_lust_base" as
 SELECT a.site_num AS "FacilityID",
        CASE
            WHEN (a.release_num IS NOT NULL) THEN replace(((((('SC_'::text || "substring"(a.facil_name, 1, 35)) || '_'::text) || a.release_num) || '_'::text) || (nextval('sc_release.lustid_seq'::regclass))::text), '__'::text, '_'::text)
            ELSE replace(((('SC_'::text || "substring"(a.facil_name, 1, 40)) || '_'::text) || (nextval('sc_release.lustid_seq'::regclass))::text), '__'::text, '_'::text)
        END AS "LUSTID",
    a.facil_name AS "SiteName",
    a.facil_address AS "SiteAddress",
    a.facil_city AS "SiteCity",
    a.facil_zip AS "ZipCode",
    'SC'::text AS "State",
    4 AS "EPARegion",
    b.lat_decimal AS "Latitude",
    b.long_decimal AS "Longitude",
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
        CASE
            WHEN ((b.cleanup_complete_date IS NULL) AND (b.cleanup_compl_mcl_date IS NULL) AND (b.cnfa = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "ClosedWithContamination"
   FROM (sc_release.ustleak_20211013 a
     LEFT JOIN sc_release.lwmopc_20211013 b ON (((a.site_num = sc_release.convert_site_num_int(b.site_num)) AND (a.release_num = (b.release_num)::double precision))));