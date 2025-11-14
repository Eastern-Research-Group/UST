create or replace view "md_ust"."v_ust_facility" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."LocName")::character varying(100) AS facility_name,
    (x."LocStr")::character varying(100) AS facility_address1,
    (x."City")::character varying(100) AS facility_city,
    (x."County")::character varying(100) AS facility_county,
    (x."ZIP")::character varying(10) AS facility_zip_code,
    (mo."Name")::character varying(100) AS facility_owner_company_name,
        CASE
            WHEN (x."Finance" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN (x."LocGovBondRating" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_bond_rating_test,
        CASE
            WHEN (x."Insurance" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN (x."Guarantee" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN (x."LtrCredit" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN (x."LocGovFinancialTest" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN (x."RiskRetention" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_risk_retention_group,
        CASE
            WHEN (x."SelfInsurance" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN (x."StateFunds" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_state_fund,
        CASE
            WHEN (x."SuretyBond" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN (x."StandByTrustFund" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_trust_fund,
    (x."FinanceOther")::character varying(500) AS financial_responsibility_other_method,
        CASE
            WHEN (rl.ust_facility_id IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    (md_ust.get_latest_release_id((rl.ust_facility_id)::character varying))::character varying(40) AS associated_ust_release_id,
    'MD'::text AS facility_state,
    3 AS facility_epa_region,
    ft.facility_type_id AS facility_type1
   FROM ((((md_ust.md_facility_combined x
     LEFT JOIN md_ust.md_supp_tank_data z ON ((x."FacilityID" = z."FacilityID")))
     LEFT JOIN md_ust.v_facility_type_xwalk ft ON ((z."FacilityDesc" = (ft.organization_value)::text)))
     LEFT JOIN md_ust.md_owner mo ON ((x."OwnerID" = mo."OwnerID")))
     LEFT JOIN md_ust.md_release_linkages rl ON ((((x."FacilityID")::character varying)::text = ((rl.ust_facility_id)::character varying)::text)));