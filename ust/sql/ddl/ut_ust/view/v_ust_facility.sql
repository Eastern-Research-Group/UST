create or replace view "ut_ust"."v_ust_facility" as
 SELECT DISTINCT (x.facility_id)::character varying(50) AS facility_id,
    (x."LOCNAME")::character varying(100) AS facility_name,
    a.facility_type_id AS facility_type1,
    (x."LOCSTR")::character varying(100) AS facility_address1,
    (x."LOCCITY")::character varying(100) AS facility_city,
    (x."LOCCOUNTY")::character varying(100) AS facility_county,
    (x."LOCZIP")::character varying(10) AS facility_zip_code,
    x."DDLat" AS facility_latitude,
    x."DDLon" AS facility_longitude,
    b.coordinate_source_id,
    (x."OWNERNAME")::character varying(100) AS facility_owner_company_name,
    max(c."PST_FUND") AS financial_responsibility_state_fund,
    max(
        CASE
            WHEN (c."OTHERTYPE" = 'Insurance'::text) THEN 'Yes'::text
            ELSE NULL::text
        END) AS financial_responsibility_commercial_insurance,
    max(
        CASE
            WHEN (c."OTHERTYPE" ~~ 'Self-insurance%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END) AS financial_responsibility_self_insurance_financial_test,
    max(
        CASE
            WHEN (c."OTHERTYPE" = 'Guarantee'::text) THEN 'Yes'::text
            ELSE NULL::text
        END) AS financial_responsibility_guarantee,
    max(
        CASE
            WHEN ((c."OTHERTYPE" <> ALL (ARRAY['Exempt'::text, 'Not Required'::text])) AND (c."OTHERTYPE" IS NOT NULL)) THEN 'Yes'::text
            WHEN ((c."OTHERTYPE" = 'Exempt'::text) OR (c."OTHERTYPE" = 'Not Required'::text)) THEN 'N/A'::text
            ELSE NULL::text
        END) AS financial_responsibility_obtained,
        CASE
            WHEN (x."RELEASE" <> '0'::bigint) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    'UT'::text AS facility_state,
    8 AS facility_epa_region
   FROM (((ut_ust.ut_facility x
     LEFT JOIN ut_ust.v_facility_type_xwalk a ON (((a.organization_value)::text = x."FACILITYDE")))
     LEFT JOIN ut_ust.v_coordinate_source_xwalk b ON (((b.organization_value)::text = x."UTMDESC")))
     JOIN ut_ust.ut_tank c ON (((c.facility_id = x.facility_id) AND ((c."OTHERTYPE" IS NOT NULL) OR (c."PST_FUND" IS NOT NULL)))))
  WHERE ((x."TANK" = 1) AND (x."OPENREGAST" = 0) AND (x."REGAST" = 0) AND (NOT (((x.facility_id)::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM ut_ust.erg_unregulated_facilities))))
  GROUP BY x.facility_id, x."LOCNAME", a.facility_type_id, x."LOCSTR", x."LOCCITY", x."LOCCOUNTY", x."LOCZIP", x."DDLat", x."DDLon", b.coordinate_source_id, x."OWNERNAME", x."RELEASE";