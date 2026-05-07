create or replace view "dc_ust"."v_ust_facility" as
 SELECT DISTINCT (x."FACILITYID")::character varying(50) AS facility_id,
    x."FacilityName" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    x."FacilityAddress1" AS facility_address1,
    x."FacilityCity" AS facility_city,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    s.facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    x."FacilityLatitude" AS facility_latitude,
    x."FacilityLongitude" AS facility_longitude,
    cs.coordinate_source_id,
    x."FacilityOwnerCompanyName" AS facility_owner_company_name,
    x."FacilityOperatorCompanyName" AS facility_operator_company_name,
        CASE
            WHEN ((x."FacilityType1" = 'Federal Government - Non Military'::text) AND (x."FinancialResponsibilitySelfInsuranceFinancialTest" = 'Yes'::text)) THEN 'N/A'::text
            ELSE x."FinancialResponsibilityObtained"
        END AS financial_responsibility_obtained,
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
    x."FinancialResponsibilityOtherMethod" AS financial_responsibility_other_method,
    x."USTReportedRelease" AS ust_reported_release,
    (x."AssociatedLUSTID")::text AS associated_ust_release_id
   FROM ((((dc_ust.facility x
     LEFT JOIN dc_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN dc_ust.v_facility_type_xwalk ft ON ((x."FacilityType1" = (ft.organization_value)::text)))
     LEFT JOIN dc_ust.v_state_xwalk s ON ((x."FacilityState" = (s.organization_value)::text)))
     LEFT JOIN dc_ust.v_coordinate_source_xwalk cs ON ((x."FacilityCoordinateSource" = (cs.organization_value)::text)))
  WHERE (NOT (((x."FACILITYID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM dc_ust.erg_unregulated_facilities)));