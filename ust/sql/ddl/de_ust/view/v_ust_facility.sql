create or replace view "de_ust"."v_ust_facility" as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    x."FacilityName" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    x."FacilityAddress1" AS facility_address1,
    x."FacilityAddress2" AS facility_address2,
    x."FacilityCity" AS facility_city,
    x."FacilityCounty" AS facility_county,
    x."FacilityZipCode" AS facility_zip_code,
    'DE'::text AS facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    x."FacilityLatitude" AS facility_latitude,
    x."FacilityLongitude" AS facility_longitude,
    cs.coordinate_source_id,
    x."FacilityOwnerCompanyName" AS facility_owner_company_name,
    x."FacilityOperatorCompanyName" AS facility_operator_company_name,
        CASE
            WHEN (max(
            CASE
                WHEN (x."FinancialResponsibilityObtained" = 'Yes'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY x."FacilityID") = 1) THEN 'Yes'::text
            WHEN (max(
            CASE
                WHEN (x."FinancialResponsibilityObtained" = 'No'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY x."FacilityID") = 1) THEN 'No'::text
            WHEN (max(
            CASE
                WHEN (x."FinancialResponsibilityObtained" = 'Unknown'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY x."FacilityID") = 1) THEN 'Unknown'::text
            ELSE 'N/A'::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN (x."FinancialResponsibilityBondRatingTest" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_bond_rating_test,
        CASE
            WHEN (x."FinancialResponsibilityCommercialInsurance" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN (x."FinancialResponsibilityGuarantee" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN (x."FinancialResponsibilityLetterOfCredit" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN (x."FinancialResponsibilityLocalGovernmentFinancialTest" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN (x."FinancialResponsibilitySelfInsuranceFinancialTest" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN (x."FinancialResponsibilityStateFund" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_state_fund,
        CASE
            WHEN (x."FinancialResponsibilitySuretyBond" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN (x."FinancialResponsibilityTrustFund" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_trust_fund,
        CASE
            WHEN (x."USTReportedRelease" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'Unknown'::text
        END AS ust_reported_release,
    x."AssociatedLUSTID" AS associated_ust_release_id
   FROM ((((de_ust.facility x
     LEFT JOIN de_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN de_ust.v_facility_type_xwalk ft ON ((x."FacilityType1" = (ft.organization_value)::text)))
     LEFT JOIN de_ust.v_state_xwalk s ON ((x."FacilityState" = (s.organization_value)::text)))
     LEFT JOIN de_ust.v_coordinate_source_xwalk cs ON ((x."FacilityCoordinateSource" = (cs.organization_value)::text)));