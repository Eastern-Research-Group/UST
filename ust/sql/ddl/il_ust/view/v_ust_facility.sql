create or replace view "il_ust"."v_ust_facility" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."FacilityName" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    x."FacilityAddress1" AS facility_address1,
    x."FacilityAddress2" AS facility_address2,
    x."FacilityCity" AS facility_city,
    x."FacilityCounty" AS facility_county,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    s.facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    x."FacilityLatitude" AS facility_latitude,
    x."FacilityLongitude" AS facility_longitude,
    cs.coordinate_source_id,
    x."FinancialResponsibilityObtained" AS financial_responsibility_obtained,
    x."FinancialResponsibilityBondRatingTest" AS financial_responsibility_bond_rating_test,
    x."FinancialResponsibilityCommercialInsurance" AS financial_responsibility_commercial_insurance,
    x."FinancialResponsibilityGuarantee" AS financial_responsibility_guarantee,
    x."FinancialResponsibilityLetterOfCredit" AS financial_responsibility_letter_of_credit,
    x."FinancialResponsibilityLocalGovernmentFinancialTest" AS financial_responsibility_local_government_financial_test,
    x."FinancialResponsibilityRiskRetentionGroup" AS financial_responsibility_risk_retention_group,
    x."FinancialResponsibilitySelfInsuranceFinancialTest" AS financial_responsibility_self_insurance_financial_test,
    x."FinancialResponsibilityTrustFund" AS financial_responsibility_trust_fund,
    x."FinancialResponsibilityOtherMethod" AS financial_responsibility_other_method,
    x."USTReportedRelease" AS ust_reported_release,
    x."AssociatedLUSTID" AS associated_ust_release_id
   FROM ((((il_ust.facility x
     LEFT JOIN il_ust.v_facility_type_xwalk ft ON ((x."FacilityType2" = (ft.organization_value)::text)))
     LEFT JOIN il_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN il_ust.v_state_xwalk s ON ((x." FacilityState" = (s.organization_value)::text)))
     LEFT JOIN il_ust.v_coordinate_source_xwalk cs ON ((x."FacilityCoordinateSource" = (cs.organization_value)::text)));