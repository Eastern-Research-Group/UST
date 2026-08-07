-- MA facility source comparison: prioritized issue output
-- Sources:
--   A = ma_ust.vw_ust_facilities_combined
--   B = ma_ust."Facility info"
--
-- Output columns:
--   issue_priority, issue_type, facility_id, field_name, source_a_value, source_b_value, detail
--
-- Priority guide:
--   1 = ID present in only one source
--   2 = Duplicate IDs inside a source
--   3 = Field value conflict for matched IDs

drop table if exists ma_ust.temp_facility_compare_issues;

create  table ma_ust.temp_facility_compare_issues as
with
source_a as (
    select
        nullif(upper(regexp_replace(trim("UST Facility ID"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(upper(regexp_replace(trim("Facility Name"::text), '\\s+', ' ', 'g')), '') as facility_name,
        nullif(upper(regexp_replace(trim("Facility Address Line 1"::text), '\\s+', ' ', 'g')), '') as facility_address1,
        nullif(upper(regexp_replace(trim("Facility City"::text), '\\s+', ' ', 'g')), '') as facility_city,
        nullif(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g'), '') as facility_zip,
        nullif(upper(regexp_replace(trim(facility_status::text), '\\s+', ' ', 'g')), '') as facility_status
    from ma_ust.vw_ust_facilities_combined
),
source_b as (
    select
        nullif(upper(regexp_replace(trim("Facility ID#"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(upper(regexp_replace(trim("FAC NAME"::text), '\\s+', ' ', 'g')), '') as facility_name,
        nullif(upper(regexp_replace(trim("FAC ADD 1"::text), '\\s+', ' ', 'g')), '') as facility_address1,
        nullif(upper(regexp_replace(trim("FAC CITY"::text), '\\s+', ' ', 'g')), '') as facility_city,
        nullif(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g'), '') as facility_zip,
        nullif(upper(regexp_replace(trim("FAC STATUS"::text), '\\s+', ' ', 'g')), '') as facility_status
    from ma_ust."Facility info"
),

a_ids as (
    select distinct facility_id
    from source_a
    where facility_id is not null
),
b_ids as (
    select distinct facility_id
    from source_b
    where facility_id is not null
),

coverage_issues as (
    select
        1 as issue_priority,
        case
            when a.facility_id is null then 'missing_in_combined_view'
            when b.facility_id is null then 'missing_in_facility_info'
        end as issue_type,
        coalesce(a.facility_id, b.facility_id) as facility_id,
        'facility_id'::text as field_name,
        case when b.facility_id is null then 'present' else null end as source_a_value,
        case when a.facility_id is null then 'present' else null end as source_b_value,
        'Facility ID exists in only one source.'::text as detail
    from a_ids a
    full outer join b_ids b on a.facility_id = b.facility_id
    where a.facility_id is null or b.facility_id is null
),

a_dups as (
    select facility_id, count(*) as row_count
    from source_a
    where facility_id is not null
    group by facility_id
    having count(*) > 1
),
b_dups as (
    select facility_id, count(*) as row_count
    from source_b
    where facility_id is not null
    group by facility_id
    having count(*) > 1
),

duplicate_issues as (
    select
        2 as issue_priority,
        'duplicate_id_in_combined_view'::text as issue_type,
        facility_id,
        'facility_id'::text as field_name,
        row_count::text as source_a_value,
        null::text as source_b_value,
        'Duplicate rows for Facility ID in combined view.'::text as detail
    from a_dups

    union all

    select
        2 as issue_priority,
        'duplicate_id_in_facility_info'::text as issue_type,
        facility_id,
        'facility_id'::text as field_name,
        null::text as source_a_value,
        row_count::text as source_b_value,
        'Duplicate rows for Facility ID in Facility info.'::text as detail
    from b_dups
),

a_rollup as (
    select
        facility_id,
        array_agg(distinct facility_name order by facility_name) filter (where facility_name is not null) as facility_name_vals,
        array_agg(distinct facility_address1 order by facility_address1) filter (where facility_address1 is not null) as facility_address1_vals,
        array_agg(distinct facility_city order by facility_city) filter (where facility_city is not null) as facility_city_vals,
        array_agg(distinct facility_zip order by facility_zip) filter (where facility_zip is not null) as facility_zip_vals,
        array_agg(distinct facility_status order by facility_status) filter (where facility_status is not null) as facility_status_vals
    from source_a
    where facility_id is not null
    group by facility_id
),
b_rollup as (
    select
        facility_id,
        array_agg(distinct facility_name order by facility_name) filter (where facility_name is not null) as facility_name_vals,
        array_agg(distinct facility_address1 order by facility_address1) filter (where facility_address1 is not null) as facility_address1_vals,
        array_agg(distinct facility_city order by facility_city) filter (where facility_city is not null) as facility_city_vals,
        array_agg(distinct facility_zip order by facility_zip) filter (where facility_zip is not null) as facility_zip_vals,
        array_agg(distinct facility_status order by facility_status) filter (where facility_status is not null) as facility_status_vals
    from source_b
    where facility_id is not null
    group by facility_id
),

conflict_base as (
    select
        a.facility_id,
        a.facility_name_vals,
        b.facility_name_vals as b_facility_name_vals,
        a.facility_address1_vals,
        b.facility_address1_vals as b_facility_address1_vals,
        a.facility_city_vals,
        b.facility_city_vals as b_facility_city_vals,
        a.facility_zip_vals,
        b.facility_zip_vals as b_facility_zip_vals,
        a.facility_status_vals,
        b.facility_status_vals as b_facility_status_vals
    from a_rollup a
    join b_rollup b on b.facility_id = a.facility_id
),

conflict_issues as (
    select
        3 as issue_priority,
        'field_conflict'::text as issue_type,
        facility_id,
        'facility_name'::text as field_name,
        array_to_string(facility_name_vals, ' | ') as source_a_value,
        array_to_string(b_facility_name_vals, ' | ') as source_b_value,
        'Name differs between sources for same Facility ID.'::text as detail
    from conflict_base
    where facility_name_vals is distinct from b_facility_name_vals

    union all

    select
        3,
        'field_conflict',
        facility_id,
        'facility_address1',
        array_to_string(facility_address1_vals, ' | '),
        array_to_string(b_facility_address1_vals, ' | '),
        'Address line 1 differs between sources for same Facility ID.'
    from conflict_base
    where facility_address1_vals is distinct from b_facility_address1_vals

    union all

    select
        3,
        'field_conflict',
        facility_id,
        'facility_city',
        array_to_string(facility_city_vals, ' | '),
        array_to_string(b_facility_city_vals, ' | '),
        'City differs between sources for same Facility ID.'
    from conflict_base
    where facility_city_vals is distinct from b_facility_city_vals

    union all

    select
        3,
        'field_conflict',
        facility_id,
        'facility_zip',
        array_to_string(facility_zip_vals, ' | '),
        array_to_string(b_facility_zip_vals, ' | '),
        'ZIP differs between sources for same Facility ID.'
    from conflict_base
    where facility_zip_vals is distinct from b_facility_zip_vals

    union all

    select
        3,
        'field_conflict',
        facility_id,
        'facility_status',
        array_to_string(facility_status_vals, ' | '),
        array_to_string(b_facility_status_vals, ' | '),
        'Status differs between sources for same Facility ID.'
    from conflict_base
    where facility_status_vals is distinct from b_facility_status_vals
)
select * from coverage_issues
union all
select * from duplicate_issues
union all
select * from conflict_issues;

-- 1) Summary counts by issue type
select
    issue_priority,
    issue_type,
    count(*) as issue_count
from ma_ust.temp_facility_compare_issues
group by issue_priority, issue_type
order by issue_priority, issue_type;

1	missing_in_combined_view	11
1	missing_in_facility_info	6511
3	field_conflict	179

-- 2) Full prioritized detail rows
select *
from ma_ust.temp_facility_compare_issues
where issue_type not like 'missing%'
order by issue_priority, issue_type, facility_id, field_name;

select detail, count(*) 
from ma_ust.temp_facility_compare_issues
group by detail;

Name differs between sources for same Facility ID.	128
Status differs between sources for same Facility ID.	31




select * from ma_ust."Facility info" where "Facility ID#" = 1159;