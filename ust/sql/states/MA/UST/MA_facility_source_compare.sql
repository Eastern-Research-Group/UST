-- Compare MA facility source objects:
--   1) ma_ust.vw_ust_facilities_combined
--   2) ma_ust."Facility info"
--
-- This script checks:
--   A) IDs present in one source but not the other
--   B) Field-level conflicts for shared facility IDs
--   C) Duplicate/conflicting rows within each source

-- Shared normalized CTEs
with
combined as (
    select
        nullif(upper(regexp_replace(trim("UST Facility ID"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(upper(regexp_replace(trim("Facility Name"::text), '\\s+', ' ', 'g')), '') as facility_name,
        nullif(upper(regexp_replace(trim("Facility Address Line 1"::text), '\\s+', ' ', 'g')), '') as facility_address1,
        nullif(upper(regexp_replace(trim("Facility City"::text), '\\s+', ' ', 'g')), '') as facility_city,
        nullif(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g'), '') as facility_zip,
        nullif(upper(regexp_replace(trim(facility_status::text), '\\s+', ' ', 'g')), '') as facility_status
    from ma_ust.vw_ust_facilities_combined
),
info as (
    select
        nullif(upper(regexp_replace(trim("Facility ID#"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(upper(regexp_replace(trim("FAC NAME"::text), '\\s+', ' ', 'g')), '') as facility_name,
        nullif(upper(regexp_replace(trim("FAC ADD 1"::text), '\\s+', ' ', 'g')), '') as facility_address1,
        nullif(upper(regexp_replace(trim("FAC CITY"::text), '\\s+', ' ', 'g')), '') as facility_city,
        nullif(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g'), '') as facility_zip,
        nullif(upper(regexp_replace(trim("FAC STATUS"::text), '\\s+', ' ', 'g')), '') as facility_status
    from ma_ust."Facility info"
),
combined_ids as (
    select distinct facility_id from combined where facility_id is not null
),
info_ids as (
    select distinct facility_id from info where facility_id is not null
)

-- A) Presence/coverage check: IDs only in one source
select
    coalesce(c.facility_id, i.facility_id) as facility_id,
    case
        when c.facility_id is null then 'only_in_facility_info'
        when i.facility_id is null then 'only_in_combined_view'
    end as presence
from combined_ids c
full outer join info_ids i on c.facility_id = i.facility_id
where c.facility_id is null or i.facility_id is null
order by presence, facility_id;


-- B) Field-level conflicts for facility IDs present in both sources
with
combined as (
    select
        nullif(upper(regexp_replace(trim("UST Facility ID"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(upper(regexp_replace(trim("Facility Name"::text), '\\s+', ' ', 'g')), '') as facility_name,
        nullif(upper(regexp_replace(trim("Facility Address Line 1"::text), '\\s+', ' ', 'g')), '') as facility_address1,
        nullif(upper(regexp_replace(trim("Facility City"::text), '\\s+', ' ', 'g')), '') as facility_city,
        nullif(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g'), '') as facility_zip,
        nullif(upper(regexp_replace(trim(facility_status::text), '\\s+', ' ', 'g')), '') as facility_status
    from ma_ust.vw_ust_facilities_combined
),
info as (
    select
        nullif(upper(regexp_replace(trim("Facility ID#"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(upper(regexp_replace(trim("FAC NAME"::text), '\\s+', ' ', 'g')), '') as facility_name,
        nullif(upper(regexp_replace(trim("FAC ADD 1"::text), '\\s+', ' ', 'g')), '') as facility_address1,
        nullif(upper(regexp_replace(trim("FAC CITY"::text), '\\s+', ' ', 'g')), '') as facility_city,
        nullif(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g'), '') as facility_zip,
        nullif(upper(regexp_replace(trim("FAC STATUS"::text), '\\s+', ' ', 'g')), '') as facility_status
    from ma_ust."Facility info"
),
combined_rollup as (
    select
        facility_id,
        array_agg(distinct facility_name order by facility_name) filter (where facility_name is not null) as facility_name_vals,
        array_agg(distinct facility_address1 order by facility_address1) filter (where facility_address1 is not null) as facility_address1_vals,
        array_agg(distinct facility_city order by facility_city) filter (where facility_city is not null) as facility_city_vals,
        array_agg(distinct facility_zip order by facility_zip) filter (where facility_zip is not null) as facility_zip_vals,
        array_agg(distinct facility_status order by facility_status) filter (where facility_status is not null) as facility_status_vals
    from combined
    where facility_id is not null
    group by facility_id
),
info_rollup as (
    select
        facility_id,
        array_agg(distinct facility_name order by facility_name) filter (where facility_name is not null) as facility_name_vals,
        array_agg(distinct facility_address1 order by facility_address1) filter (where facility_address1 is not null) as facility_address1_vals,
        array_agg(distinct facility_city order by facility_city) filter (where facility_city is not null) as facility_city_vals,
        array_agg(distinct facility_zip order by facility_zip) filter (where facility_zip is not null) as facility_zip_vals,
        array_agg(distinct facility_status order by facility_status) filter (where facility_status is not null) as facility_status_vals
    from info
    where facility_id is not null
    group by facility_id
)
select
    c.facility_id,
    (c.facility_name_vals is distinct from i.facility_name_vals) as name_conflict,
    (c.facility_address1_vals is distinct from i.facility_address1_vals) as address1_conflict,
    (c.facility_city_vals is distinct from i.facility_city_vals) as city_conflict,
    (c.facility_zip_vals is distinct from i.facility_zip_vals) as zip_conflict,
    (c.facility_status_vals is distinct from i.facility_status_vals) as status_conflict,
    c.facility_name_vals as combined_name_vals,
    i.facility_name_vals as info_name_vals,
    c.facility_address1_vals as combined_address1_vals,
    i.facility_address1_vals as info_address1_vals,
    c.facility_city_vals as combined_city_vals,
    i.facility_city_vals as info_city_vals,
    c.facility_zip_vals as combined_zip_vals,
    i.facility_zip_vals as info_zip_vals,
    c.facility_status_vals as combined_status_vals,
    i.facility_status_vals as info_status_vals
from combined_rollup c
join info_rollup i on i.facility_id = c.facility_id
where
    c.facility_name_vals is distinct from i.facility_name_vals
    or c.facility_address1_vals is distinct from i.facility_address1_vals
    or c.facility_city_vals is distinct from i.facility_city_vals
    or c.facility_zip_vals is distinct from i.facility_zip_vals
    or c.facility_status_vals is distinct from i.facility_status_vals
order by c.facility_id;


-- C1) Duplicate ID counts within combined view
with combined as (
    select nullif(upper(regexp_replace(trim("UST Facility ID"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id
    from ma_ust.vw_ust_facilities_combined
)
select facility_id, count(*) as row_count
from combined
where facility_id is not null
group by facility_id
having count(*) > 1
order by row_count desc, facility_id;

-- C2) Duplicate ID counts within Facility info
with info as (
    select nullif(upper(regexp_replace(trim("Facility ID#"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id
    from ma_ust."Facility info"
)
select facility_id, count(*) as row_count
from info
where facility_id is not null
group by facility_id
having count(*) > 1
order by row_count desc, facility_id;
