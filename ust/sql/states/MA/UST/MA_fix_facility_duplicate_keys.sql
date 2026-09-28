-- Combine financial-responsibility methods without losing Yes flags or methods.
-- Reapply after generate-views, which can overwrite this custom aggregation.
begin;
set local lock_timeout = '5s';

create or replace view ma_ust.v_ust_facility as
with financial_responsibility as (
    -- Preserve all methods on one row per facility before joining the parent.
    select nullif(trim(c.facility_id::text), '') as facility_id,
        max(case when c."fr_type_name" is not null then 'Yes'::character varying(7) else null end) as financial_responsibility_obtained,
        max(case when c."fr_type_name" = 'Local Government Bond Rating Test' then 'Yes'::character varying(3) else null end) as financial_responsibility_bond_rating_test,
        max(case when c."fr_type_name" = 'Commercial Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_commercial_insurance,
        max(case when c."fr_type_name" = 'Guarantee' then 'Yes'::character varying(3) else null end) as financial_responsibility_guarantee,
        max(case when c."fr_type_name" = 'Irrevocable Standby Letter of Credit' then 'Yes'::character varying(3) else null end) as financial_responsibility_letter_of_credit,
        max(case when c."fr_type_name" = 'Local Government Financial Test of Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_local_government_financial_test,
        max(case when c."fr_type_name" = 'Risk Retention Group Coverage' then 'Yes'::character varying(3) else null end) as financial_responsibility_risk_retention_group,
        max(case when c."fr_type_name" = 'Financial Test of Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_self_insurance_financial_test,
        max(case when c."fr_type_name" = '' then 'Yes'::character varying(3) else null end) as financial_responsibility_state_fund,
        max(case when c."fr_type_name" = 'Surety Bond' then 'Yes'::character varying(3) else null end) as financial_responsibility_surety_bond,
        max(case when c."fr_type_name" = 'Trust Fund' then 'Yes'::character varying(3) else null end) as financial_responsibility_trust_fund,
        string_agg(distinct (case when c."fr_type_name" in ('Local Government Fund','Local Government Guarantee') then c."fr_type_name"::character varying(500) else null end)::text, '; ' order by (case when c."fr_type_name" in ('Local Government Fund','Local Government Guarantee') then c."fr_type_name"::character varying(500) else null end)::text) as financial_responsibility_other_method
    from ma_ust.erg_facility_info_fr_type c
    group by nullif(trim(c.facility_id::text), '')
)
select distinct
    a."Facility ID#"::character varying(50) as facility_id,
    a."FAC NAME"::character varying(100) as facility_name,
    owner_type_id as owner_type_id,
    facility_type_id as facility_type1,
    a."FAC ADD 1"::character varying(100) as facility_address1,
    a."FAC ADD 2"::character varying(100) as facility_address2,
    a."FAC CITY"::character varying(100) as facility_city,
    a."FAC ZIP"::character varying(10) as facility_zip_code,
    facility_state as facility_state,
    1::integer as facility_epa_region,
    a."FAC LAT"::double precision as facility_latitude,
    a."FAC LONG"::double precision as facility_longitude,
    c.financial_responsibility_obtained::character varying as financial_responsibility_obtained,
    c.financial_responsibility_bond_rating_test::character varying as financial_responsibility_bond_rating_test,
    c.financial_responsibility_commercial_insurance::character varying as financial_responsibility_commercial_insurance,
    c.financial_responsibility_guarantee::character varying as financial_responsibility_guarantee,
    c.financial_responsibility_letter_of_credit::character varying as financial_responsibility_letter_of_credit,
    c.financial_responsibility_local_government_financial_test::character varying as financial_responsibility_local_government_financial_test,
    c.financial_responsibility_risk_retention_group::character varying as financial_responsibility_risk_retention_group,
    c.financial_responsibility_self_insurance_financial_test::character varying as financial_responsibility_self_insurance_financial_test,
    c.financial_responsibility_state_fund::character varying as financial_responsibility_state_fund,
    c.financial_responsibility_surety_bond::character varying as financial_responsibility_surety_bond,
    c.financial_responsibility_trust_fund::character varying as financial_responsibility_trust_fund,
    c.financial_responsibility_other_method::character varying as financial_responsibility_other_method
from ma_ust."erg_facility_final" a
    left join ma_ust."erg_facility_info_org_type" b on nullif(trim(a."Facility ID#"::text), '') = nullif(trim(b."facility_id"::text), '') 
    left join financial_responsibility c on nullif(trim(a."Facility ID#"::text), '') = nullif(trim(c."facility_id"::text), '') 
    left join ma_ust.v_facility_type_xwalk d on a."FAC TYPE" = d.organization_value
    left join ma_ust.v_owner_type_xwalk e on b."org_type_name" = e.organization_value
    left join ma_ust.v_state_xwalk f on a."FAC STATE" = f.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg
    where nullif(trim(a."Facility ID#"::text), '') = unreg.facility_id)
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;

-- Expected for data checked on 2026-09-25: 5,022 rows and 5,022 facility IDs.
select count(*) as rows, count(distinct facility_id) as distinct_facility_ids
from ma_ust.v_ust_facility;

-- Expected: zero rows.
select facility_id, count(*) as row_count
from ma_ust.v_ust_facility
group by facility_id
having count(*) > 1;

-- Review QA, then choose one:
-- commit;
-- rollback;
