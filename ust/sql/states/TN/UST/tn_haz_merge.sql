-- Merge the supplemental hazardous-substance dataset with the TN main dataset.
--
-- Client rules implemented here:
--   * Facility names/addresses come from tn_facilities when a main facility exists.
--   * The two confirmed bad haz IDs use the manually confirmed main facility IDs.
--   * A haz tank is the same tank only when capacity matches and the main substance is Other.
--   * Capacity or substance conflicts are retained as new hazardous-substance tanks.
--   * Tank/compartment attributes remain sourced from the hazardous-substance rows.
--
-- The original haz_tanks, haz_compartments, tn_facilities, and tn_compartments tables
-- are not modified. The output tables retain every current haz row and add merge metadata.

begin;

create table if not exists tn_ust.tn_haz_merge_resolution (
    haz_location_id text not null,
    haz_tank_name text not null,
    haz_tank_number text,
    haz_id_stripped text,
    main_facility_id bigint,
    merged_facility_id text not null,
    facility_match_method text not null,
    main_tank_id bigint,
    main_tank_number bigint,
    main_tank_capacity bigint,
    main_product text,
    tank_match_method text not null,
    merge_action text not null,
    primary key (haz_location_id, haz_tank_name)
);

truncate table tn_ust.tn_haz_merge_resolution;


insert into tn_ust.tn_haz_merge_resolution (
    haz_location_id,
    haz_tank_name,
    haz_tank_number,
    haz_id_stripped,
    main_facility_id,
    merged_facility_id,
    facility_match_method,
    main_tank_id,
    main_tank_number,
    main_tank_capacity,
    main_product,
    tank_match_method,
    merge_action
)
with suggested_id_xwalk (haz_id_stripped, suggested_facility_id, suggested_basis) as (
    values
        ('22630', 5950272, 'Client-confirmed Costco facility ID correction'),
        ('5-830374', 5830374, 'Client-confirmed Costco facility ID correction')
),
haz_tanks as (
    select
        t."Location ID" as haz_location_id,
        btrim(t."Tank Name") as haz_tank_name,
        nullif(regexp_replace(btrim(t."Tank Name"), '^(Tank|UST)\s+', '', 'i'), '') as haz_tank_number,
        nullif(btrim(regexp_replace(t."Location ID", '^\s*TNHS[-\s]*', '')), '') as haz_id_stripped,
        t."Tank Capacity" as haz_tank_capacity,
        btrim(t."Substance Description") as haz_substance
    from tn_ust.haz_tanks t
),
gis_candidates as (
    select
        g."FACILITY_ID"::text as facility_id,
        g."LATITUDE" as latitude,
        g."LONGITUDE" as longitude,
        1 as source_priority
    from tn_ust.facilities_gis g
    where g."FACILITY_ID" is not null
    union all
    select
        g."FACILITY_ID"::text,
        g."LATITUDE",
        g."LONGITUDE",
        2
    from tn_ust.closed_facilities_gis g
    where g."FACILITY_ID" is not null
),
gis_locations as (
    select facility_id, latitude, longitude
    from (
        select
            g.*,
            row_number() over (partition by g.facility_id order by g.source_priority) as row_number
        from gis_candidates g
    ) ranked
    where row_number = 1
),
main_tanks as (
    select
        c."Facility Id Ust" as main_facility_id,
        c."Tank Number" as main_tank_number,
        min(c."Tank Id") as main_tank_id,
        sum(c."Compartment Capacity") as main_tank_capacity,
        count(distinct c."Product") as product_count,
        max(c."Product") as main_product
    from tn_ust.tn_compartments c
    group by c."Facility Id Ust", c."Tank Number"
),
resolved_facilities as (
    select
        h.*,
        f_direct."FACILITY_ID_UST" as direct_facility_id,
        x.suggested_facility_id,
        coalesce(f_direct."FACILITY_ID_UST", x.suggested_facility_id) as main_facility_id,
        case
            when f_direct."FACILITY_ID_UST" is not null
                then 'main facility matched by normalized haz Location ID'
            when x.suggested_facility_id is not null
                then 'client-confirmed manual facility ID correction'
            else 'haz facility not present in main dataset'
        end as facility_match_method
    from haz_tanks h
    left join tn_ust.tn_facilities f_direct
        on f_direct."FACILITY_ID_UST"::text = h.haz_id_stripped
    left join suggested_id_xwalk x
        on x.haz_id_stripped = h.haz_id_stripped
       and f_direct."FACILITY_ID_UST" is null
),
resolved_tanks as (
    select
        r.*,
        m.main_tank_id,
        m.main_tank_number,
        m.main_tank_capacity,
        case when m.product_count = 1 then m.main_product end as main_product,
        case
            when m.main_tank_id is null
                then 'no main tank with this facility/tank number'
            when r.haz_tank_capacity is not distinct from m.main_tank_capacity
                 and m.product_count = 1
                 and m.main_product = 'Other'
                then 'capacity matches and main substance is Other'
            when r.haz_tank_capacity is distinct from m.main_tank_capacity
                then 'capacity differs; retain as new tank'
            else 'substance differs; retain as new tank'
        end as tank_match_method,
        case
            when r.main_facility_id is null then 'append_new_facility'
            when m.main_tank_id is not null
                 and r.haz_tank_capacity is not distinct from m.main_tank_capacity
                 and m.product_count = 1
                 and m.main_product = 'Other'
                then 'merge_existing_main_tank'
            else 'append_new_tank'
        end as merge_action
    from resolved_facilities r
    left join main_tanks m
        on m.main_facility_id = r.main_facility_id
       and m.main_tank_number::text = r.haz_tank_number
)
select
    haz_location_id,
    haz_tank_name,
    haz_tank_number,
    haz_id_stripped,
    main_facility_id,
    coalesce(main_facility_id::text, haz_id_stripped, haz_location_id) as merged_facility_id,
    facility_match_method,
    main_tank_id,
    main_tank_number,
    main_tank_capacity,
    main_product,
    tank_match_method,
    merge_action
from resolved_tanks;

drop table if exists tn_ust.tn_haz_tanks_merged;

create table tn_ust.tn_haz_tanks_merged as
with facility_info as (
    select
        r.*,
        f."FACILITY_NAME" as main_facility_name,
        f."FACILITY_ADDRESS1" as main_facility_address1,
        f."FACILITY_ADDRESS2" as main_facility_address2,
        f."FACILITY_CITY" as main_facility_city,
        f."FACILITY_ZIP" as main_facility_zip,
        g.latitude as main_facility_latitude,
        g.longitude as main_facility_longitude
    from tn_ust.tn_haz_merge_resolution r
    left join tn_ust.tn_facilities f
        on f."FACILITY_ID_UST" = r.main_facility_id
    left join (
        select facility_id, latitude, longitude
        from (
            select candidates.*,
                row_number() over (partition by candidates.facility_id order by candidates.source_priority) as row_number
            from (
                select "FACILITY_ID"::text as facility_id, "LATITUDE" as latitude, "LONGITUDE" as longitude, 1 as source_priority
                from tn_ust.facilities_gis
                union all
                select "FACILITY_ID"::text, "LATITUDE", "LONGITUDE", 2
                from tn_ust.closed_facilities_gis
            ) candidates
        ) ranked_gis
        where row_number = 1
    ) g
        on g.facility_id = r.main_facility_id::text
)
select
    h.*,
    i.merged_facility_id,
    i.main_facility_id,
    i.facility_match_method,
    i.tank_match_method,
    i.merge_action,
    i.main_tank_id,
    i.main_tank_number,
    i.main_tank_capacity,
    i.main_product,
    coalesce(i.main_facility_name, h."Facility Name") as merged_facility_name,
    coalesce(i.main_facility_address1, h."Street Address") as merged_facility_address1,
    i.main_facility_address2 as merged_facility_address2,
    coalesce(i.main_facility_city, h."City") as merged_facility_city,
    coalesce(i.main_facility_zip, h."Zip"::text) as merged_facility_zip,
    coalesce(i.main_facility_latitude, h."Latitude") as merged_facility_latitude,
    coalesce(i.main_facility_longitude, h."Longitude") as merged_facility_longitude
from tn_ust.haz_tanks h
join facility_info i
    on i.haz_location_id = h."Location ID"
   and i.haz_tank_name = btrim(h."Tank Name");

drop table if exists tn_ust.tn_haz_compartments_merged;

create table tn_ust.tn_haz_compartments_merged as
with haz_compartment_rows as (
    select
        c.*,
        row_number() over (
            partition by c."Location ID", btrim(c."Tank Name")
            order by btrim(c."Compartment Name"), c.ctid
        ) as haz_compartment_row_number
    from tn_ust.haz_compartments c
),
main_compartment_rows as (
    select
        c."Facility Id Ust" as main_facility_id,
        c."Tank Number" as main_tank_number,
        c."Compartment Id" as main_compartment_id,
        row_number() over (
            partition by c."Facility Id Ust", c."Tank Number"
            order by c."Compartment Id"
        ) as main_compartment_row_number
    from tn_ust.tn_compartments c
),
facility_info as (
    select
        r.*,
        f."FACILITY_NAME" as main_facility_name,
        f."FACILITY_ADDRESS1" as main_facility_address1,
        f."FACILITY_ADDRESS2" as main_facility_address2,
        f."FACILITY_CITY" as main_facility_city,
        f."FACILITY_ZIP" as main_facility_zip
    from tn_ust.tn_haz_merge_resolution r
    left join tn_ust.tn_facilities f
        on f."FACILITY_ID_UST" = r.main_facility_id
)
select
    c.*,
    i.merged_facility_id,
    i.main_facility_id,
    i.facility_match_method,
    i.tank_match_method,
    i.merge_action,
    i.main_tank_id,
    case
        when i.merge_action = 'merge_existing_main_tank' then m.main_compartment_id
        else null::bigint
    end as main_compartment_id,
    case
        when i.merge_action = 'merge_existing_main_tank'
            then 'main:' || m.main_compartment_id::text
        else 'haz:' || c."Location ID" || ':' || btrim(c."Tank Name") || ':' || btrim(c."Compartment Name")
    end as merged_compartment_key,
    coalesce(i.main_facility_name, c."Facility Name") as merged_facility_name,
    coalesce(i.main_facility_address1, c."Street Address") as merged_facility_address1,
    i.main_facility_address2 as merged_facility_address2,
    coalesce(i.main_facility_city, c."City") as merged_facility_city,
    coalesce(i.main_facility_zip, c."Zip"::text) as merged_facility_zip
from haz_compartment_rows c
join facility_info i
    on i.haz_location_id = c."Location ID"
   and i.haz_tank_name = btrim(c."Tank Name")
left join main_compartment_rows m
    on m.main_facility_id = i.main_facility_id
   and m.main_tank_number::text = i.haz_tank_number
   and m.main_compartment_row_number = c.haz_compartment_row_number
;

create index if not exists tn_haz_merge_resolution_facility_idx
    on tn_ust.tn_haz_merge_resolution (merged_facility_id);
create index if not exists tn_haz_tanks_merged_facility_idx
    on tn_ust.tn_haz_tanks_merged (merged_facility_id);
create index if not exists tn_haz_compartments_merged_facility_idx
    on tn_ust.tn_haz_compartments_merged (merged_facility_id);

-- Review counts and actions before using these tables downstream.
select merge_action, count(*)
from tn_ust.tn_haz_merge_resolution
group by merge_action
order by merge_action;

append_new_facility	3
append_new_tank	16
merge_existing_main_tank	5

select count(*) as haz_tank_rows,
       count(*) filter (where merge_action = 'merge_existing_main_tank') as merged_tank_rows,
       count(*) filter (where merge_action = 'append_new_tank') as new_tank_rows,
       count(*) filter (where merge_action = 'append_new_facility') as new_facility_rows
from tn_ust.tn_haz_tanks_merged;

select count(*) as haz_compartment_rows
from tn_ust.tn_haz_compartments_merged;

commit;

select * from tn_ust.tn_haz_compartments_merged

select * from tn_ust.haz_compartments
TNHS 22630		Costco 1686
TNHS 2470923	Knoxville Transit
TNHS 2471498	Costco #1116
TNHS 3331311	Volkswagen Chattanooga 
TNHS 3331311	Volkswagen Chattanooga 
TNHS 5-830374	Costco 1659
TNHS 5191824	Costco #630


