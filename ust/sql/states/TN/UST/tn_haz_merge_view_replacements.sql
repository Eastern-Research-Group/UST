-- Replace TN mapping helper views after tn_haz_merge_canonical.sql has been run.
-- All compartment-derived views now use tn_compartments_merged, and all facility/
-- owner-derived views now use tn_facilities_merged.
-- The original v_tn_compartments view remains available until downstream QA confirms
-- it can be dropped.

begin;

create or replace view tn_ust.v_compartment_status as
select distinct
    c."Facility Id Ust",
    c."Tank Id",
    c."Tank Number",
    c."Compartment Id",
    c."Compartment Letter",
    (case when c."How Tank Closed" is not null
        then c."Status" || ' - ' || c."How Tank Closed"
        else c."Status" end)::text as "Status",
    m.epa_value
from tn_ust.tn_compartments_merged c
left join public.v_ust_element_mapping m
    on m.ust_control_id = 35
   and m.epa_column_name = 'compartment_status_id'
   and (case when c."How Tank Closed" is not null
        then c."Status" || ' - ' || c."How Tank Closed"
        else c."Status" end) = m.organization_value;

create or replace view tn_ust.v_facilities as
with gis_candidates as (
    select "FACILITY_ID"::text as facility_id, "LATITUDE" as latitude, "LONGITUDE" as longitude, 1 as source_priority
    from tn_ust.facilities_gis where "FACILITY_ID" is not null
    union all
    select "FACILITY_ID"::text, "LATITUDE", "LONGITUDE", 2
    from tn_ust.closed_facilities_gis where "FACILITY_ID" is not null
), gis_locations as (
    select facility_id, latitude, longitude
    from (select g.*, row_number() over (partition by facility_id order by source_priority) as row_number
          from gis_candidates g) ranked where row_number = 1
), haz_locations as (
    select merged_facility_id, max(merged_facility_latitude) as latitude,
           max(merged_facility_longitude) as longitude
    from tn_ust.tn_haz_tanks_merged group by merged_facility_id
)
select distinct
    f."FACILITY_ID_UST"::character varying(50) as facility_id,
    f."FACILITY_NAME"::character varying(100) as facility_name,
    f."FACILITY_ADDRESS1"::character varying(100) as facility_address1,
    f."FACILITY_ADDRESS2"::character varying(100) as facility_address2,
    f."FACILITY_CITY"::character varying(100) as facility_city,
    f."FACILITY_ZIP"::character varying(10) as facility_zip_code,
    'TN'::character varying(2) as facility_state,
    coalesce(g.latitude, h.latitude)::double precision as facility_latitude,
    coalesce(g.longitude, h.longitude)::double precision as facility_longitude
from tn_ust.tn_facilities_merged f
left join gis_locations g on g.facility_id = f."FACILITY_ID_UST"::text
left join haz_locations h on h.merged_facility_id = f.merged_haz_location_id;

create or replace view tn_ust.v_overfill_prevention_not_required as
select distinct "Facility Id Ust", "Tank Id", "Tank Number", "Compartment Id", "Compartment Letter",
    case when "Overfill Prevention" = 'Not Required' then 'Yes'
         when "Small Delivery" = 'Less than 25' then 'Yes'
         when "Overfill Prevention" is not null then 'No' end as overfill_prevention_not_required
from tn_ust.tn_compartments_merged;

create or replace view tn_ust.v_owner_types as
select distinct "FACILITY_ID_UST" as facility_id,
    case when "FACILITY_TYPE" = 'Federal Military' then 'Military' else "OWNER_TYPE" end as owner_type
from tn_ust.tn_facilities_merged;

create or replace view tn_ust.v_piping_line_leak_detector as
select distinct c."Facility Id Ust", c."Tank Id", c."Tank Number", c."Compartment Id", c."Compartment Letter",
    case when c."Leak Detection Periodic" in ('ELLD .1 Annual', 'ELLD .2 Monthly')
           or c."Leak Detection Cat" in ('Annual Line Leak Detector Test', 'Electronic', 'Mechanical (Automatic)')
         then 'Yes' else null end as piping_line_leak_detector
from tn_ust.tn_compartments_merged c;

create or replace view tn_ust.v_spill_bucket_installed as
select distinct "Facility Id Ust", "Tank Id", "Tank Number", "Compartment Id", "Compartment Letter",
    case when nullif(trim("Spill Prevention"), '') is not null then 'Yes' else null end as spill_bucket_installed
from tn_ust.tn_compartments_merged
where "Facility Id Ust" is not null and "Tank Id" is not null and "Compartment Id" is not null;

create or replace view tn_ust.v_spill_prevention_not_required as
select distinct "Facility Id Ust", "Tank Id", "Tank Number", "Compartment Id", "Compartment Letter",
    case when "Spill Prevention" = 'Not Required' then 'Yes'
         when "Small Delivery" = 'Less than 25' then 'Yes' end as spill_prevention_not_required
from tn_ust.tn_compartments_merged;

create or replace view tn_ust.v_tank_compartments as
select "Facility Id Ust", "Tank Id", "Tank Number", count(*) as number_of_compartments,
    case when count(*) > 1 then 'Yes' else 'No' end as compartmentalized_ust
from (select distinct "Facility Id Ust", "Tank Id", "Tank Number", "Compartment Id"
      from tn_ust.tn_compartments_merged) compartments
group by "Facility Id Ust", "Tank Id", "Tank Number";

create or replace view tn_ust.v_tank_status as
select distinct on (c."Facility Id Ust", c."Tank Id")
    c."Facility Id Ust", c."Tank Id", c."Tank Number", s.compartment_status::character varying(1000) as "Status", s.status_hierarchy
from tn_ust.v_compartment_status c
left join public.compartment_statuses s on s.compartment_status::text = c.epa_value::text
where s.compartment_status is not null
order by c."Facility Id Ust", c."Tank Id", s.status_hierarchy;

create or replace view tn_ust.v_tank_substance as
select distinct "Facility Id Ust"::character varying(50) as facility_id,
    "Tank Id"::integer as tank_id, "Tank Number"::character varying(50) as tank_name, "Product"
from tn_ust.tn_compartments_merged
where "Facility Id Ust" is not null and "Tank Id" is not null;

commit;
