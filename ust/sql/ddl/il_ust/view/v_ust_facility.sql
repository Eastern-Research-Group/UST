create or replace view "il_ust"."v_ust_facility" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
        CASE
            WHEN ((x."FacilityID")::text = '2005219'::text) THEN 'Int"l Bank of Chicago, an Illinois Banking Corp., as Trustee under Trust No 2011'::text
            ELSE x."FacilityName"
        END AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    x."FacilityAddress1" AS facility_address1,
    x."FacilityAddress2" AS facility_address2,
    x."FacilityCity" AS facility_city,
    x."FacilityCounty" AS facility_county,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    'IL'::text AS facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    x."FacilityLatitude" AS facility_latitude,
    x."FacilityLongitude" AS facility_longitude,
    cs.coordinate_source_id,
    x."FinancialResponsibilityObtained" AS financial_responsibility_obtained,
    x."FinancialResponsibilityBondRatingTest" AS financial_responsibility_bond_rating_test,
    x."FinancialResponsibilityCommercialInsurance" AS financial_responsibility_commercial_insurance,
    frg."FinancialResponsibilityGuarantee" AS financial_responsibility_guarantee,
    x."FinancialResponsibilityLetterOfCredit" AS financial_responsibility_letter_of_credit,
    x."FinancialResponsibilityLocalGovernmentFinancialTest" AS financial_responsibility_local_government_financial_test,
    x."FinancialResponsibilityRiskRetentionGroup" AS financial_responsibility_risk_retention_group,
    frsift."FinancialResponsibilitySelfInsuranceFinancialTest" AS financial_responsibility_self_insurance_financial_test,
    x."FinancialResponsibilityTrustFund" AS financial_responsibility_trust_fund,
    x."FinancialResponsibilityOtherMethod" AS financial_responsibility_other_method,
    x."USTReportedRelease" AS ust_reported_release,
    x."AssociatedLUSTID" AS associated_ust_release_id
   FROM ((((((il_ust.facility x
     LEFT JOIN ( SELECT x_1."FacilityID",
            x_1."FinancialResponsibilityGuarantee",
            row_number() OVER (PARTITION BY x_1."FacilityID" ORDER BY x_1."FinancialResponsibilityGuarantee" DESC) AS row_num
           FROM il_ust.facility x_1) frg ON (((x."FacilityID" = frg."FacilityID") AND (frg.row_num = 1))))
     LEFT JOIN ( SELECT x_1."FacilityID",
            x_1."FinancialResponsibilitySelfInsuranceFinancialTest",
            row_number() OVER (PARTITION BY x_1."FacilityID" ORDER BY x_1."FinancialResponsibilitySelfInsuranceFinancialTest" DESC) AS row_num
           FROM il_ust.facility x_1) frsift ON (((x."FacilityID" = frsift."FacilityID") AND (frsift.row_num = 1))))
     LEFT JOIN il_ust.v_facility_type_xwalk ft ON ((x."FacilityType2" = (ft.organization_value)::text)))
     LEFT JOIN il_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN il_ust.v_state_xwalk s ON ((x." FacilityState" = (s.organization_value)::text)))
     LEFT JOIN il_ust.v_coordinate_source_xwalk cs ON ((x."FacilityCoordinateSource" = (cs.organization_value)::text)))
  WHERE ((NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM il_ust.erg_unregulated_facilities))) AND (NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM il_ust.erg_unregulated_facilities))));