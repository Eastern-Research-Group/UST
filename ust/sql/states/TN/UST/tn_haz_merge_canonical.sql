-- Build canonical TN source tables from the main and hazardous-substance datasets.
-- Requires tn_haz_merge.sql to have been run first.
--
-- Output tables:
--   tn_ust.tn_facilities_merged
--   tn_ust.tn_compartments_merged
--
-- Main facility rows are retained unchanged when a facility exists in both sources.
-- Main compartment rows are retained only when Regulated Status is Regulated or NULL.
-- For the five client-approved same-tank matches, the main compartment row is
-- replaced by the hazardous-substance attributes. Conflicting/new haz tanks are
-- appended with generated Tank Id and Compartment Id values.

begin;

drop table if exists tn_ust.tn_facilities_merged;
drop table if exists tn_ust.tn_compartments_merged;

with haz_facilities as (
    select
        h.merged_facility_id,
        max(h.merged_facility_name) as facility_name,
        max(h.merged_facility_address1) as facility_address1,
        max(h.merged_facility_address2) as facility_address2,
        max(h.merged_facility_city) as facility_city,
        max(h.merged_facility_zip) as facility_zip,
        max(h.merged_facility_latitude) as facility_latitude,
        max(h.merged_facility_longitude) as facility_longitude,
        count(*)::bigint as tank_count
    from tn_ust.tn_haz_tanks_merged h
    where h.main_facility_id is null
    group by h.merged_facility_id
),
main_facility_ids as (
    select max("FACILITY_ID_UST") as max_facility_id
    from tn_ust.tn_facilities
),
assigned_haz_facilities as (
    select
        h.*,
        case
            when h.merged_facility_id ~ '^[0-9]+$'
                then h.merged_facility_id::bigint
            else f.max_facility_id + row_number() over (order by h.merged_facility_id)
        end as assigned_facility_id
    from haz_facilities h
    cross join main_facility_ids f
),
facility_rows as (
    select
        f."FACILITY_ID_UST",
        f."FACILITY_NAME",
        f."FACILITY_ADDRESS1",
        f."FACILITY_ADDRESS2",
        f."FACILITY_CITY",
        f."FACILITY_ZIP",
        f."FACILITY_TYPE",
        f."FACILITY_STATUS",
        f."CIU_CNT",
        f."TOU_CNT",
        f."POU_CNT",
        f."TANK_CNT",
        f."GIA_OWNER_ID",
        f."OWNER_NAME",
        f."OWNER_TYPE",
        null::text as merged_haz_location_id,
        'main'::text as merge_source
    from tn_ust.tn_facilities f
    union all
    select
        h.assigned_facility_id,
        h.facility_name,
        h.facility_address1,
        h.facility_address2,
        h.facility_city,
        h.facility_zip,
        null::text,
        null::text,
        null::double precision,
        null::double precision,
        null::double precision,
        h.tank_count,
        null::bigint,
        null::text,
        null::text,
        h.merged_facility_id,
        'haz_only'::text
    from assigned_haz_facilities h
)
select * into tn_ust.tn_facilities_merged from facility_rows;

with main_facility_ids as (
    select max("FACILITY_ID_UST") as max_facility_id
    from tn_ust.tn_facilities
), haz_facilities as (
    select distinct
        h.merged_facility_id,
        case
            when h.merged_facility_id ~ '^[0-9]+$'
                then h.merged_facility_id::bigint
            else f.max_facility_id + row_number() over (order by h.merged_facility_id)
        end as assigned_facility_id
    from tn_ust.tn_haz_tanks_merged h
    cross join main_facility_ids f
    where h.main_facility_id is null
), main_tank_ids as (
    select coalesce(max("Tank Id"), 0) as max_tank_id
    from tn_ust.tn_compartments
), append_tanks as (
    select
        h.merged_facility_id,
        btrim(h."Tank Name") as haz_tank_name,
        row_number() over (order by h.merged_facility_id, btrim(h."Tank Name")) as tank_row_number
    from tn_ust.tn_haz_tanks_merged h
    where h.merge_action <> 'merge_existing_main_tank'
    group by h.merged_facility_id, btrim(h."Tank Name")
), assigned_tanks as (
    select
        h.merged_facility_id,
        h.haz_tank_name,
        m.max_tank_id + h.tank_row_number as assigned_tank_id
    from append_tanks h
    cross join main_tank_ids m
), main_compartment_ids as (
    select coalesce(max("Compartment Id"), 0) as max_compartment_id
    from tn_ust.tn_compartments
), haz_compartment_rows as (
    select
        h.*,
        row_number() over (
            order by h.merged_facility_id, btrim(h."Tank Name"), btrim(h."Compartment Name"), h.ctid
        ) as appended_compartment_row_number
    from tn_ust.tn_haz_compartments_merged h
), haz_rows as (
    select
        h.*,
        case
            when h.main_facility_id is not null then h.main_facility_id
            when f.assigned_facility_id is not null then f.assigned_facility_id
            else null::bigint
        end as assigned_facility_id,
        case
            when h.merge_action = 'merge_existing_main_tank' then h.main_tank_id
            else t.assigned_tank_id
        end as assigned_tank_id,
        case
            when h.merge_action = 'merge_existing_main_tank' then h.main_compartment_id
            else c.max_compartment_id + h.appended_compartment_row_number
        end as assigned_compartment_id
    from haz_compartment_rows h
    left join haz_facilities f
        on f.merged_facility_id = h.merged_facility_id
    left join assigned_tanks t
        on t.merged_facility_id = h.merged_facility_id
       and t.haz_tank_name = btrim(h."Tank Name")
    cross join main_compartment_ids c
), retained_main as (
    select m.*
    from (
        select
            source_rows.*,
            row_number() over (
                partition by source_rows."Facility Id Ust", source_rows."Tank Id", source_rows."Compartment Id"
                order by source_rows.ctid
            ) as canonical_row_number
        from tn_ust.tn_compartments source_rows
    ) m
    where m.canonical_row_number = 1
      and (m."Regulated Status" = 'Regulated'::text
       or m."Regulated Status" is null)
        and not exists (
          select 1
          from tn_ust.tn_haz_compartments_merged h
          where h.merge_action = 'merge_existing_main_tank'
            and h.main_facility_id = m."Facility Id Ust"
            and h.main_compartment_id = m."Compartment Id"
      )
), canonical_rows as (
    select
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
    from retained_main m
    union all
    select
        h.assigned_facility_id,
        h."merged_facility_name",
        h."merged_facility_address1",
        h."merged_facility_address2",
        h."merged_facility_city",
        h."merged_facility_zip",
        null::text,
        case when h.merge_action = 'append_new_facility' then 'Regulated'::text else null::text end,
        null::text,
        null::text,
        h.assigned_tank_id,
        case when h."Tank Name" ~ '^(Tank|UST)\s+[0-9]+$' then regexp_replace(h."Tank Name", '^(Tank|UST)\s+', '', 'i')::bigint else null::bigint end,
        ht."Date Installed",
        null::text,
        null::text,
        null::text,
        h.assigned_compartment_id,
        h."Compartment Name",
        h."Compartment Capacity",
        h."Compartment Status Description",
        h."Substance Description",
        null::text,
        null::text,
        null::text,
        case when h."Overfill Installed" is true then 'Yes' when h."Overfill Installed" is false then 'No' end,
        null::text,
        h."Spill Installed",
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::bigint,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        null::text,
        'hazardous substance'::text
    from haz_rows h
    left join tn_ust.tn_haz_tanks_merged ht
        on ht."Location ID" = h."Location ID"
       and btrim(ht."Tank Name") = btrim(h."Tank Name")
)
select * into tn_ust.tn_compartments_merged from canonical_rows;

create index tn_facilities_merged_id_idx
    on tn_ust.tn_facilities_merged ("FACILITY_ID_UST");
create index tn_compartments_merged_keys_idx
    on tn_ust.tn_compartments_merged ("Facility Id Ust", "Tank Id", "Compartment Id");

-- Review counts before using these tables downstream.
select merge_source, count(*)
from tn_ust.tn_facilities_merged
group by merge_source
order by merge_source;

haz_only	2
main	20081

select merge_source, count(*)
from tn_ust.tn_compartments_merged
group by merge_source
order by merge_source;

hazardous substance	24
main	58144

commit;


select * from tn_ust.tn_facilities_merged;

select distinct "Regulated Status"
from tn_ust.tn_compartments_merged


Regulated

