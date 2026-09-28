-- Source conflicts: 17870 / 5 and 9953 / 2 contain both Yes and No.
-- Do not infer containment from installation date or arbitrarily prefer Yes/No.
-- Conflicting known values become NULL; source records are retained unchanged.
-- Reapply after generate-views, which can overwrite this custom aggregation.
begin;
set local lock_timeout = '5s';

create or replace view ma_ust.v_ust_facility_dispenser as
with dispenser_values as (
select distinct
    nullif(trim(a."Facility ID#"::text), '')::character varying(50) as facility_id,
    a."dispenser_number"::character varying(50) as dispenser_id,
    case when lower(nullif(trim(a."dispenser_sump_ind"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."dispenser_sump_ind"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as dispenser_udc
from ma_ust."Dispenser info" a
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility ID#"::text), '') = unreg_fac.facility_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility ID#"::text), ''))

)
select facility_id,
    dispenser_id,
    -- Keep an agreed known value; contradictory Yes/No records remain unknown.
    case when count(distinct dispenser_udc) = 1 then max(dispenser_udc)
         else null::text end as dispenser_udc
from dispenser_values
group by facility_id, dispenser_id;

-- Expected for data checked on 2026-09-25: 10,639 rows and unique keys.
select count(*) as rows, count(distinct (facility_id, dispenser_id)) as distinct_keys
from ma_ust.v_ust_facility_dispenser;

-- Expected: zero rows.
select facility_id, dispenser_id, count(*) as row_count
from ma_ust.v_ust_facility_dispenser
group by facility_id, dispenser_id
having count(*) > 1;

-- Source records for unresolved Yes/No conflicts among included dispensers.
select a.*
from ma_ust."Dispenser info" a
where exists (
    select 1 from ma_ust.v_ust_facility_dispenser v
    where v.facility_id = nullif(trim(a."Facility ID#"::text), '')
      and v.dispenser_id = a.dispenser_number::varchar(50)
)
and (a."Facility ID#", a.dispenser_number) in (
    select "Facility ID#", dispenser_number
    from ma_ust."Dispenser info"
    group by "Facility ID#", dispenser_number
    having count(distinct dispenser_sump_ind) > 1
)
order by a."Facility ID#", a.dispenser_number, a.install_date;

-- Review QA, then choose one:
-- commit;
-- rollback;
