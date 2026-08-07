-- MA: normalize type fields out of ma_ust."Facility info" and dedupe parent rows.
--
-- Goal:
-- 1) Preserve many-per-facility values for:
--      - fr_type_name
--      - business_type_name
--      - org_type_name
--    in separate child tables.
-- 2) Remove duplicate rows from "Facility info" when those 3 fields are ignored.
--
-- Notes:
-- - This script keeps one parent row per identical non-type-column set.
-- - It does NOT require one row per Facility ID if other non-type fields differ.
-- - Run inside a transaction and review checks before COMMIT.

begin;

drop table ma_ust.facility_info_fr_type

-- 0) Child tables for one-to-many relationships.
create table if not exists ma_ust.erg_facility_info_fr_type (
    facility_id text not null,
    fr_type_name text not null,
    primary key (facility_id, fr_type_name)
);

create table if not exists ma_ust.erg_facility_info_business_type (
    facility_id text not null,
    business_type_name text not null,
    primary key (facility_id, business_type_name)
);

create table if not exists ma_ust.erg_facility_info_org_type (
    facility_id text not null,
    org_type_name text not null,
    primary key (facility_id, org_type_name)
);

-- 1) Load distinct type values into child tables.
insert into ma_ust.erg_facility_info_fr_type (facility_id, fr_type_name)
select distinct
    trim("Facility ID#"::text) as facility_id,
    trim(fr_type_name::text) as fr_type_name
from ma_ust."Facility info"
where nullif(trim("Facility ID#"::text), '') is not null
  and nullif(trim(fr_type_name::text), '') is not null
on conflict do nothing;

insert into ma_ust.erg_facility_info_business_type (facility_id, business_type_name)
select distinct
    trim("Facility ID#"::text) as facility_id,
    trim(business_type_name::text) as business_type_name
from ma_ust."Facility info"
where nullif(trim("Facility ID#"::text), '') is not null
  and nullif(trim(business_type_name::text), '') is not null
on conflict do nothing;

insert into ma_ust.erg_facility_info_org_type (facility_id, org_type_name)
select distinct
    trim("Facility ID#"::text) as facility_id,
    trim(org_type_name::text) as org_type_name
from ma_ust."Facility info"
where nullif(trim("Facility ID#"::text), '') is not null
  and nullif(trim(org_type_name::text), '') is not null
on conflict do nothing;

-- 2) Pre-check: duplicates that exist when type columns are ignored.
with ranked as (
    select
        ctid,
        "Facility ID#"::text as facility_id,
        row_number() over (
            partition by to_jsonb(t) - array['fr_type_name', 'business_type_name', 'org_type_name']
            order by ctid
        ) as rn
    from ma_ust."Facility info" t
)
select
    count(*) as rows_that_would_be_deleted,
    count(distinct facility_id) as affected_facility_ids
from ranked
where rn > 1;

-- 3) Delete duplicates while ignoring the 3 type columns.
with ranked as (
    select
        ctid,
        row_number() over (
            partition by to_jsonb(t) - array['fr_type_name', 'business_type_name', 'org_type_name']
            order by ctid
        ) as rn
    from ma_ust."Facility info" t
)
delete from ma_ust."Facility info" d
using ranked r
where d.ctid = r.ctid
  and r.rn > 1;

-- 4) Optional: clear type columns in parent table now that values are normalized out.
-- Uncomment if you want parent rows to carry only facility/address/location-style attributes.
-- update ma_ust."Facility info"
-- set fr_type_name = null,
--     business_type_name = null,
--     org_type_name = null
-- where fr_type_name is not null
--    or business_type_name is not null
--    or org_type_name is not null;

-- 5) Post-check A: remaining duplicates by Facility ID.
select
    "Facility ID#"::text as facility_id,
    count(*) as row_count
from ma_ust."Facility info"
group by "Facility ID#"
having count(*) > 1
order by row_count desc, facility_id;

-- 6) Post-check B: child table row counts.
select 'facility_info_fr_type' as table_name, count(*) as row_count from ma_ust.erg_facility_info_fr_type
union all
select 'facility_info_business_type', count(*) from ma_ust.erg_facility_info_business_type
union all
select 'facility_info_org_type', count(*) from ma_ust.erg_facility_info_org_type;

-- 7) Post-check C: total parent row count.
select count(*) as parent_rows_after_dedupe
from ma_ust."Facility info";

-- Choose one after review:
-- commit;
-- rollback;


select * from ma_ust."Facility info"