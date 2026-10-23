-- TN-only rebuild of the EXISTING tn_compartments_merged table.
-- Prerequisites: the original hazardous merge/canonical scripts have already run.
-- This is not a bootstrap script: existing hazardous rows are the authoritative
-- snapshot of their assigned IDs and merged attributes. Do not rerun the old
-- canonical script first; it filters main rows and recalculates generated IDs.
--
-- Main source: tn_ust.tn_compartments, with NO regulatory-status filter.
-- Exact duplicate projected rows are collapsed; differing rows for the same key
-- are all retained and reported below. No ctid-based selection is performed.
-- Approved main compartments replaced by hazardous rows remain replaced, using
-- the complete facility/tank/compartment key and the recorded merge decisions.
-- Original source tables are never modified.
--
-- Exclusions belong in erg_unregulated_* and downstream view filters. This
-- script does NOT populate those tables or alter the views. Until compartment
-- exclusions are implemented there, restored unregulated rows can appear in
-- the template views. Existing hazardous null regulatory statuses are preserved;
-- they must not be classified using the main-source null-status rule.
--
-- Run this entire script in one session with stop-on-error enabled. Any failed
-- assertion aborts the transaction; issue ROLLBACK before retrying. The final
-- COMMIT publishes the rebuild. Use ROLLBACK instead for a preview.

begin;

-- Preserve the table object, dependent views, indexes, grants, and assigned IDs.
-- Lock inputs so the checks and the replacement see the same source records.
lock table tn_ust.tn_compartments_merged in access exclusive mode;
lock table tn_ust.tn_compartments,
           tn_ust.tn_haz_compartments_merged in share mode;

create temporary table tn_compartments_before_rebuild on commit drop as
select * from tn_ust.tn_compartments_merged;

-- Refuse to overwrite a table whose provenance differs from the known merge.
do $$
begin
    if exists (
        select 1 from tn_compartments_before_rebuild
        where merge_source is null
           or merge_source not in ('main', 'hazardous substance')
    ) then
        raise exception 'Unexpected merge_source in tn_compartments_merged; review before rebuilding';
    end if;

    if (select count(*) from tn_compartments_before_rebuild
        where merge_source = 'hazardous substance') <>
       (select count(*) from tn_ust.tn_haz_compartments_merged)
    then
        raise exception 'Hazardous row counts differ from staging; reconcile the existing merge before rebuilding';
    end if;

    if exists (
        select 1 from tn_compartments_before_rebuild
        where merge_source = 'hazardous substance'
          and ("Facility Id Ust" is null or "Tank Id" is null or "Compartment Id" is null)
    ) or exists (
        select 1 from tn_compartments_before_rebuild
        where merge_source = 'hazardous substance'
        group by "Facility Id Ust", "Tank Id", "Compartment Id"
        having count(*) > 1
    ) then
        raise exception 'Existing hazardous rows have missing or duplicate keys; reconcile before rebuilding';
    end if;

    if exists (
        select 1
        from tn_ust.tn_haz_compartments_merged h
        where h.merge_action = 'merge_existing_main_tank'
          and not exists (
              select 1 from tn_compartments_before_rebuild old
              where old.merge_source = 'hazardous substance'
                and old."Facility Id Ust" = h.main_facility_id
                and old."Tank Id" = h.main_tank_id
                and old."Compartment Id" = h.main_compartment_id
          )
    ) then
        raise exception 'An approved hazardous replacement is missing from the existing merged table';
    end if;
end $$;

create temporary table tn_compartments_rebuild
    (like tn_ust.tn_compartments_merged)
    on commit drop;

insert into tn_compartments_rebuild (
    "Facility Id Ust",
    "Facility Name",
    "Facility Address1",
    "Facility Address2",
    "Facility City",
    "Facility Zip",
    "Facility Type",
    "Regulated Status",
    "Red Tag Reason",
    "Red Tag Status",
    "Tank Id",
    "Tank Number",
    "Date Tank Installed",
    "Pipe Install Or Rep Date",
    "Tank Construction",
    "Category Of Construction",
    "Compartment Id",
    "Compartment Letter",
    "Compartment Capacity",
    "Status",
    "Product",
    "Emergency Generator",
    "Small Delivery",
    "Date Last Used",
    "Overfill Prevention",
    "Overfill Installation Date",
    "Spill Prevention",
    "Spill Bucket Installation Date",
    "Piping Material",
    "Piping Type",
    "Pipe Construction Type",
    "Leak Detection Cat",
    "Leak Detection Periodic",
    "How Tank Closed",
    "Date Tank Closed",
    "Compartment Release Detection",
    "Date Compartment Closed",
    "Gia Owner Id",
    "Owner Name",
    "Address Line 1",
    "Address Line 2",
    "City",
    "State",
    "Zip",
    "Owner Type",
    merge_source
)
select distinct
    m."Facility Id Ust",
    m."Facility Name",
    m."Facility Address1",
    m."Facility Address2",
    m."Facility City",
    m."Facility Zip",
    m."Facility Type",
    m."Regulated Status",
    m."Red Tag Reason",
    m."Red Tag Status",
    m."Tank Id",
    m."Tank Number",
    m."Date Tank Installed",
    m."Pipe Install Or Rep Date",
    m."Tank Construction",
    m."Category Of Construction",
    m."Compartment Id",
    m."Compartment Letter",
    m."Compartment Capacity",
    m."Status",
    m."Product",
    m."Emergency Generator",
    m."Small Delivery",
    m."Date Last Used",
    m."Overfill Prevention",
    m."Overfill Installation Date",
    m."Spill Prevention",
    m."Spill Bucket Installation Date",
    m."Piping Material",
    m."Piping Type",
    m."Pipe Construction Type",
    m."Leak Detection Cat",
    m."Leak Detection Periodic",
    m."How Tank Closed",
    m."Date Tank Closed",
    m."Compartment Release Detection",
    m."Date Compartment Closed",
    m."Gia Owner Id",
    m."Owner Name",
    m."Address Line 1",
    m."Address Line 2",
    m."City",
    m."State",
    m."Zip",
    m."Owner Type",
    'main'::text as merge_source
from tn_ust.tn_compartments m
where not exists (
    select 1
    from tn_ust.tn_haz_compartments_merged h
    where h.merge_action = 'merge_existing_main_tank'
      and h.main_facility_id = m."Facility Id Ust"
      and h.main_tank_id = m."Tank Id"
      and h.main_compartment_id = m."Compartment Id"
);

-- Copy the existing canonical hazardous rows verbatim, including generated IDs.
insert into tn_compartments_rebuild
select * from tn_compartments_before_rebuild
where merge_source = 'hazardous substance';

-- Every original main key must now be represented, either by its main rows or
-- by the approved hazardous replacement. Reject unusable source keys as well.
do $$
begin
    if exists (
        select 1 from tn_ust.tn_compartments
        where "Facility Id Ust" is null or "Tank Id" is null or "Compartment Id" is null
    ) then
        raise exception 'Main source has null facility/tank/compartment keys; review before rebuilding';
    end if;
    if exists (
        select "Facility Id Ust", "Tank Id", "Compartment Id"
        from tn_ust.tn_compartments
        except
        select "Facility Id Ust", "Tank Id", "Compartment Id"
        from tn_compartments_rebuild
    ) then
        raise exception 'Rebuild is missing main-source compartment keys';
    end if;
end $$;

-- Review summaries: status is displayed without treating hazardous NULLs as
-- equivalent to main-source NULLs.
select 'before' as version, merge_source, "Regulated Status", count(*) as rows
from tn_compartments_before_rebuild
group by merge_source, "Regulated Status"
union all
select 'after', merge_source, "Regulated Status", count(*)
from tn_compartments_rebuild
group by merge_source, "Regulated Status"
order by merge_source, "Regulated Status", version;

-- Differing source variants remain visible rather than silently discarded.
-- Multiple statuses across DIFFERENT compartments in a tank are permitted.
select "Facility Id Ust", "Tank Id", "Compartment Id", count(*) as source_variants,
       array_agg(distinct "Regulated Status") as regulatory_statuses,
       array_agg(distinct "Product") as products
from tn_compartments_rebuild
group by "Facility Id Ust", "Tank Id", "Compartment Id"
having count(*) > 1
order by "Facility Id Ust", "Tank Id", "Compartment Id";

-- Report prior main rows that are no longer present (e.g. edits to raw source).
select * from tn_compartments_before_rebuild where merge_source = 'main'
except
select * from tn_compartments_rebuild where merge_source = 'main';

-- DELETE/INSERT preserves dependent view definitions and the table identity.
-- Foreign-key constraints, if any, remain enforced; do not use CASCADE.
delete from tn_ust.tn_compartments_merged;
insert into tn_ust.tn_compartments_merged
select * from tn_compartments_rebuild;

analyze tn_ust.tn_compartments_merged;

-- Verify the reported facility now has its complete source inventory.
select "Facility Id Ust", "Tank Id", "Compartment Id", "Regulated Status",
       "Product", merge_source
from tn_ust.tn_compartments_merged
where "Facility Id Ust"::text = '2010203'
order by "Tank Id", "Compartment Id";

-- Newly restored compartments may need piping IDs. Apply the existing
-- TN_fix_piping_ids_for_merged_compartments.sql AFTER this rebuild if needed.
-- Reconcile erg_unregulated_* and view exclusions before exporting a template.
commit;
