-- Remove only exact full-row duplicates from ma_ust."Facility info"
-- "True duplicate" here means every column value is identical.
--
-- This will NOT collapse rows that share Facility ID but differ in any other field.
-- Run in a transaction so you can inspect and then COMMIT/ROLLBACK.

begin;

-- 1) Pre-check: how many exact duplicate rows would be deleted?
with ranked as (
    select
        ctid,
        "Facility ID#"::text as facility_id,
        row_number() over (
            partition by to_jsonb(t)
            order by ctid
        ) as rn
    from ma_ust."Facility info" t
)
select
    count(*) as rows_that_would_be_deleted,
    count(distinct facility_id) as affected_facility_ids
from ranked
where rn > 1;

-- 2) Delete exact duplicates, keeping one copy of each identical row.
with ranked as (
    select
        ctid,
        row_number() over (
            partition by to_jsonb(t)
            order by ctid
        ) as rn
    from ma_ust."Facility info" t
)
delete from ma_ust."Facility info" d
using ranked r
where d.ctid = r.ctid
  and r.rn > 1;

-- 3) Post-check A: remaining duplicate groups by Facility ID (may still exist).
select
    "Facility ID#"::text as facility_id,
    count(*) as row_count
from ma_ust."Facility info"
group by "Facility ID#"
having count(*) > 1
order by row_count desc, facility_id;

-- 4) Post-check B: total row count after cleanup.
select count(*) as total_rows_after_dedupe
from ma_ust."Facility info";

-- Choose one after reviewing results:
-- commit;
-- rollback;

select * from ma_ust."Facility info" where "Facility ID#" = 1000140
