create or replace view "az_ust"."v_ust_facility" as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."FacilityName")::character varying(100) AS facility_name,
    d.owner_type_id,
    c.facility_type_id AS facility_type1,
    (a."FacilityAddress1")::character varying(100) AS facility_address1,
    (a."FacilityCity")::character varying(100) AS facility_city,
    (a."FacilityCounty")::character varying(100) AS facility_county,
    (a."FacilityZipCode")::character varying(10) AS facility_zip_code,
    e.facility_state,
    (a."FacilityEPARegion")::integer AS facility_epa_region,
    (a."FacilityTribalSite")::character varying(3) AS facility_tribal_site,
    a."FacilityLatitude" AS facility_latitude,
    a."FacilityLongitude" AS facility_longitude,
    (a."FacilityOwnerCompanyName")::character varying(100) AS facility_owner_company_name,
    (a."FacilityOperatorCompanyName")::character varying(100) AS facility_operator_company_name,
    (a."FinancialResponsibilityObtained")::character varying(7) AS financial_responsibility_obtained,
    (a."FinancialResponsibilityBondRatingTest")::character varying(3) AS financial_responsibility_bond_rating_test,
    (a."FinancialResponsibilityCommercialInsurance")::character varying(3) AS financial_responsibility_commercial_insurance,
    (a."FinancialResponsibilityGuarantee")::character varying(3) AS financial_responsibility_guarantee,
    (a."FinancialResponsibilityLetterOfCredit")::character varying(3) AS financial_responsibility_letter_of_credit,
    (a."FinancialResponsibilityLocalGovernmentFinancialTest")::character varying(3) AS financial_responsibility_local_government_financial_test,
    (a."FinancialResponsibilityRiskRetentionGroup")::character varying(3) AS financial_responsibility_risk_retention_group,
    (a."FinancialResponsibilitySelfInsuranceFinancialTest")::character varying(3) AS financial_responsibility_self_insurance_financial_test,
    (a."FinancialResponsibilityStateFund")::character varying(3) AS financial_responsibility_state_fund,
    (a."FinancialResponsibilitySuretyBond")::character varying(3) AS financial_responsibility_surety_bond,
    (a."FinancialResponsibilityTrustFund")::character varying(3) AS financial_responsibility_trust_fund,
    (a."FinancialResponsibilityOtherMethod")::character varying(500) AS financial_responsibility_other_method
   FROM ((((az_ust.ust_facility a
     LEFT JOIN az_ust.erg_facility_type_mapping b ON ((a."FacilityID" = b."FacilityID")))
     LEFT JOIN facility_types c ON (((b.epa_value)::text = (c.facility_type)::text)))
     LEFT JOIN az_ust.v_owner_type_xwalk d ON ((a."OwnerType" = (d.organization_value)::text)))
     LEFT JOIN az_ust.v_state_xwalk e ON ((a."FacilityState" = (e.organization_value)::text)))
  WHERE ((NOT (((a."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM az_ust.erg_unregulated_facilities))) AND (NOT (((a."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM az_ust.erg_unregulated_facilities))));