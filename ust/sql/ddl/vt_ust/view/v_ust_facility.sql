create or replace view "vt_ust"."v_ust_facility" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."FacilityName")::character varying(100) AS facility_name,
    ft.facility_type_id AS facility_type1,
    ot.owner_type_id,
    (x."FacilityAddress1")::character varying(100) AS facility_address1,
    (x."FacilityCity")::character varying(100) AS facility_city,
    (x."FacilityCounty")::character varying(50) AS facility_county,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    s.facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
        CASE
            WHEN (l."FacilityID" IS NOT NULL) THEN l."Actual Lat"
            ELSE x."FacilityLatitude"
        END AS facility_latitude,
        CASE
            WHEN (l."FacilityID" IS NOT NULL) THEN l."Actual Long"
            ELSE x."FacilityLongitude"
        END AS facility_longitude,
    (x."FacilityOwnerCompanyName")::character varying(100) AS facility_owner_company_name,
    x."FacilityOperatorCompanyName" AS facility_operator_company_name,
    x."FinancialResponsibilityBondRatingTest" AS financial_responsibility_bond_rating_test,
    x."FinancialResponsibilityCommercialInsurance" AS financial_responsibility_commercial_insurance,
    x."FinancialResponsibilityGuarantee" AS financial_responsibility_guarantee,
    x."FinancialResponsibilityLetterOfCredit" AS financial_responsibility_letter_of_credit,
    x."FinancialResponsibilityLocalGovernmentFinancialTest" AS financial_responsibility_local_government_financial_test,
    x."FinancialResponsibilityRiskRetentionGroup" AS financial_responsibility_risk_retention_group,
    x."FinancialResponsibilitySelfInsuranceFinancialTest" AS financial_responsibility_self_insurance_financial_test,
    x."FinancialResponsibilityStateFund" AS financial_responsibility_state_fund,
    x."FinancialResponsibilitySuretyBond" AS financial_responsibility_surety_bond,
    x."FinancialResponsibilityTrustFund" AS financial_responsibility_trust_fund,
    x."USTReportedRelease" AS ust_reported_release
   FROM ((((vt_ust.facility x
     LEFT JOIN vt_ust.v_facility_type_xwalk ft ON ((x."FacilityType1" = (ft.organization_value)::text)))
     LEFT JOIN vt_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN vt_ust.v_state_xwalk s ON ((x."FacilityState" = (s.organization_value)::text)))
     LEFT JOIN vt_ust.latlong l ON ((x."FacilityID" = l."FacilityID")));