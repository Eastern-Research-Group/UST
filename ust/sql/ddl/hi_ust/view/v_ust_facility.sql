create or replace view "hi_ust"."v_ust_facility" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."FacilityName")::character varying(100) AS facility_name,
    ft.facility_type_id AS facility_type1,
    ot.owner_type_id,
    (x."FacilityAddress1")::character varying(100) AS facility_address1,
    (x."FacilityAddress2")::character varying(100) AS facility_address2,
    (x."FacilityCity")::character varying(100) AS facility_city,
    (x."FacilityCounty")::character varying(50) AS facility_county,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    'HI'::text AS facility_state,
    9 AS facility_epa_region,
    x."LatitudeMeasure" AS facility_latitude,
    x."LongitudeMeasure" AS facility_longitude,
    cs.coordinate_source_id,
    fo."FacilityOwnerCompanyName" AS facility_owner_company_name,
    ar."AssociatedLUSTID" AS associated_ust_release_id,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Not Listed'::text) THEN 'Unknown'::text
            WHEN (x."FinancialResponsibilityObtained" = 'Exempt, Stage Agency'::text) THEN 'No'::text
            WHEN (x."FinancialResponsibilityObtained" = '/'::text) THEN NULL::text
            WHEN (x."FinancialResponsibilityObtained" IS NULL) THEN NULL::text
            ELSE 'Yes'::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'commercial insurance'::text) THEN 'Yes'::text
            WHEN (x."FinancialResponsibilityObtained" = 'Insurance'::text) THEN 'Yes'::text
            WHEN (x."FinancialResponsibilityObtained" = 'nsurance'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Guarantee'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Letter of Credit'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN (x."FinancialResponsibilityObtained" ~~ 'Local Gov_t Bond Rating'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Other'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_other_method,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Risk Retention Group'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_risk_retention_group,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Self Insured'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'State Fund'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_state_fund,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Surety Bond'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN (x."FinancialResponsibilityObtained" = 'Trust Fund'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_trust_fund
   FROM ((((((hi_ust.facility x
     LEFT JOIN hi_ust.v_facility_type_xwalk ft ON ((x."FacilityType1" = (ft.organization_value)::text)))
     LEFT JOIN hi_ust.erg_owner_type eot ON ((x."OwnerType" = (eot.epa_owner_type)::text)))
     LEFT JOIN hi_ust.v_owner_type_xwalk ot ON (((eot.epa_owner_type)::text = (ot.organization_value)::text)))
     LEFT JOIN hi_ust.v_coordinate_source_xwalk cs ON ((x."HorizontalCollectionMethodName" = (cs.organization_value)::text)))
     LEFT JOIN hi_ust.v_associated_release_id ar ON ((x."FacilityID" = ar."FacilityID")))
     LEFT JOIN hi_ust.v_facility_owner_company_name fo ON ((x."FacilityID" = fo."FacilityID")));