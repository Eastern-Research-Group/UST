create or replace view "mp_ust"."v_ust_facility" as
 SELECT DISTINCT (x.deq_id)::character varying(50) AS facility_id,
    (x."FACILITY NAME")::character varying(100) AS facility_name,
    cs.facility_type_id AS facility_type1,
    (x."VILLAGE")::character varying(100) AS facility_address1,
    (x."ISLAND")::character varying(100) AS facility_city,
    (x."ISLAND")::character varying(100) AS facility_county,
    x."Latitude gearth" AS facility_latitude,
    x."Longitude gearth" AS facility_longitude,
    (x."OWNER")::character varying(100) AS facility_owner_company_name,
    (x."OPERATOR")::character varying(100) AS facility_operator_company_name,
        CASE
            WHEN (x.financial_resp ~~ '%Self-Assurance%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN ((x.former_lust = 'YES'::text) OR ((x."Current LUST")::text ~~ 'Y%'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    ('AKA/Former/Associated Facility Names: '::text || ((x.previous_name)::character varying(4000))::text) AS facility_comment,
    9 AS facility_epa_region,
    'MP'::text AS facility_state
   FROM (mp_ust.mp_ust x
     LEFT JOIN mp_ust.v_facility_type_xwalk cs ON ((x."FACILITY TYPE" = (cs.organization_value)::text)));