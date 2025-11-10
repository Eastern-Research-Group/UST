create or replace view "hi_ust"."v_ust_facility" as
 WITH release_id AS (
         SELECT l."FacilityId" AS facility_id,
            l."AltEventId",
            l."Date reported",
            l."LUSTLatestStatusDate",
            row_number() OVER (PARTITION BY l."FacilityId" ORDER BY l."Date reported" DESC, l."LUSTLatestStatusDate" DESC, l."AltEventId" DESC NULLS LAST) AS row_num
           FROM hi_ust."tblLUSTSite" l
        ), owner_type AS (
         SELECT ca."FacilityID" AS facility_id,
            ca."EndDate",
            ca."StartDate",
            ca."Owner Type:",
            row_number() OVER (PARTITION BY ca."FacilityID" ORDER BY ca."EndDate" DESC, ca."StartDate" DESC, ca."Owner Type:" DESC NULLS LAST) AS row_num
           FROM hi_ust."tblContactAffiliation" ca
        ), financial_responsibility AS (
         SELECT fr."FacilityID",
            max(
                CASE
                    WHEN (fr."FRType" = ANY (ARRAY['commercial insurance'::text, 'Insurance'::text, 'nsurance'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_commercial_insurance,
            max(
                CASE
                    WHEN (fr."FRType" = 'Guarantee'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_guarantee,
            max(
                CASE
                    WHEN (fr."FRType" = 'Letter of Credit'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_letter_of_credit,
            max(
                CASE
                    WHEN (fr."FRType" ~~ 'Local Gov_t Bond Rating'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_local_government_financial_test,
            max(
                CASE
                    WHEN (fr."FRType" = 'Risk Retention Group'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_risk_retention_group,
            max(
                CASE
                    WHEN (fr."FRType" = 'Self Insured'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_self_insurance_financial_test,
            max(
                CASE
                    WHEN (fr."FRType" = 'State Fund'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_state_fund,
            max(
                CASE
                    WHEN (fr."FRType" = 'Surety Bond'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_surety_bond,
            max(
                CASE
                    WHEN (fr."FRType" = 'Trust Fund'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_trust_fund,
            max(
                CASE
                    WHEN (fr."FRType" = 'Other'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_other_method
           FROM hi_ust."tblFacilityFR" fr
          GROUP BY fr."FacilityID"
        )
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."Facility Name" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
        CASE
            WHEN (x."FacilityID" = '9101061'::bigint) THEN 'Honolulu International Airport 200 Rodgers Blvd'::text
            ELSE x."Street Address"
        END AS facility_address1,
        CASE
            WHEN (z."City" = 'ZipCode Unknown'::text) THEN NULL::text
            ELSE z."City"
        END AS facility_city,
        CASE
            WHEN (z."City" = 'Zipcode Unknown'::text) THEN NULL::text
            ELSE z."County"
        END AS facility_county,
        CASE
            WHEN (z."ZIP Code" = '99999'::text) THEN NULL::text
            ELSE z."ZIP Code"
        END AS facility_zip_code,
        CASE
            WHEN (s.facility_state IS NULL) THEN 'HI'::character varying
            ELSE s.facility_state
        END AS facility_state,
    x."LatitudeMeasure" AS facility_latitude,
    x."LongitudeMeasure" AS facility_longitude,
    cs.coordinate_source_id,
    co."OrganizationFormalName" AS facility_owner_company_name,
        CASE
            WHEN ((fr_agg.financial_responsibility_commercial_insurance IS NOT NULL) OR (fr_agg.financial_responsibility_guarantee IS NOT NULL) OR (fr_agg.financial_responsibility_letter_of_credit IS NOT NULL) OR (fr_agg.financial_responsibility_local_government_financial_test IS NOT NULL) OR (fr_agg.financial_responsibility_risk_retention_group IS NOT NULL) OR (fr_agg.financial_responsibility_self_insurance_financial_test IS NOT NULL) OR (fr_agg.financial_responsibility_state_fund IS NOT NULL) OR (fr_agg.financial_responsibility_surety_bond IS NOT NULL) OR (fr_agg.financial_responsibility_trust_fund IS NOT NULL) OR (fr_agg.financial_responsibility_other_method IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_obtained,
    fr_agg.financial_responsibility_commercial_insurance,
    fr_agg.financial_responsibility_guarantee,
    fr_agg.financial_responsibility_letter_of_credit,
    fr_agg.financial_responsibility_local_government_financial_test,
    fr_agg.financial_responsibility_risk_retention_group,
    fr_agg.financial_responsibility_self_insurance_financial_test,
    fr_agg.financial_responsibility_state_fund,
    fr_agg.financial_responsibility_surety_bond,
    fr_agg.financial_responsibility_trust_fund,
    fr_agg.financial_responsibility_other_method,
        CASE
            WHEN (r."AltEventId" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    r."AltEventId" AS associated_ust_release_id
   FROM (((((((((hi_ust."tblFacility" x
     JOIN owner_type o ON (((x."FacilityID" = o.facility_id) AND (o.row_num = 1))))
     LEFT JOIN hi_ust.v_owner_type_xwalk ot ON ((o."Owner Type:" = (ot.organization_value)::text)))
     LEFT JOIN hi_ust.v_facility_type_xwalk ft ON ((x."Facility Description" = (ft.organization_value)::text)))
     LEFT JOIN hi_ust."tlkpZIP" z ON ((x."ZIP Linkage" = (z."ZIP ID")::double precision)))
     LEFT JOIN hi_ust.v_state_xwalk s ON ((z."State" = (s.organization_value)::text)))
     LEFT JOIN hi_ust."tblContactOrganization" co ON ((x."Owner ID" = (co."OwnerId")::double precision)))
     LEFT JOIN financial_responsibility fr_agg ON ((x."FacilityID" = fr_agg."FacilityID")))
     JOIN release_id r ON (((x."FacilityID" = r.facility_id) AND (r.row_num = 1))))
     LEFT JOIN hi_ust.v_coordinate_source_xwalk cs ON ((x."HorizontalCollectionMethodName" = (cs.organization_value)::text)));