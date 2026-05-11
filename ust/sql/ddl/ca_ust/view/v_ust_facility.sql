create or replace view "ca_ust"."v_ust_facility" as
 SELECT DISTINCT (x."CERS ID")::character varying(50) AS facility_id,
    (x."Facility Name")::character varying(100) AS facility_name,
    ft.facility_type_id AS facility_type1,
    (x."Facility Street Address")::character varying(100) AS facility_address1,
    (x."Facility City")::character varying(100) AS facility_city,
    (x."Facility_ZIP Code")::character varying(10) AS facility_zip_code,
    'CA'::text AS facility_state,
    9 AS facility_epa_region,
    (x."Indian or _Trust Land")::character varying(3) AS facility_tribal_site,
    x."Latitude_Measure" AS facility_latitude,
    x."Longitude Measure" AS facility_longitude,
    (x."Organization Name")::character varying(100) AS facility_owner_company_name,
        CASE
            WHEN ((x."Insurance" = 'Yes'::text) OR (x."Guarantee" = 'Yes'::text) OR (x."Letter of _Credit" = 'Yes'::text) OR (x."Local_Government_Mechanism" = 'Yes'::text) OR (x."Self-_Insured" = 'Yes'::text) OR (x."State Fund _and _CFO letter" = 'Yes'::text) OR (x."State Fund _and _CD" = 'Yes'::text) OR (x."Surety_Bond" = 'Yes'::text) OR (x."Other" = 'Yes'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_obtained,
    (x."Insurance")::character varying(3) AS financial_responsibility_commercial_insurance,
    (x."Guarantee")::character varying(3) AS financial_responsibility_guarantee,
    (x."Letter of _Credit")::character varying(3) AS financial_responsibility_letter_of_credit,
    (x."Local_Government_Mechanism")::character varying(3) AS financial_responsibility_local_government_financial_test,
    (x."Self-_Insured")::character varying(3) AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN ((x."State Fund _and _CFO letter" = 'Yes'::text) OR (x."State Fund _and _CD" = 'Yes'::text)) THEN 'Yes'::text
            WHEN ((x."State Fund _and _CFO letter" = 'No'::text) OR (x."State Fund _and _CD" = 'No'::text)) THEN 'No'::text
            ELSE NULL::text
        END AS financial_responsibility_state_fund,
    (x."Surety_Bond")::character varying(3) AS financial_responsibility_surety_bond,
    (x."Other")::character varying(500) AS financial_responsibility_other_method
   FROM (ca_ust.facility x
     LEFT JOIN ca_ust.v_facility_type_xwalk ft ON ((x."UST Facility Type" = (ft.organization_value)::text)));