-- Fix v_ust_facility fan-out from multiple environmental-site rows per facility.
-- The view must remain one row per facility_id for QA and downstream mappings.

begin;

create or replace view tn_ust.v_ust_facility as
select distinct
    a."facility_id"::character varying(50) as facility_id,
    a."facility_name"::character varying(100) as facility_name,
    f.owner_type_id as owner_type_id,
    e.facility_type_id as facility_type1,
    a."facility_address1"::character varying(100) as facility_address1,
    a."facility_address2"::character varying(100) as facility_address2,
    a."facility_city"::character varying(100) as facility_city,
    a."facility_zip_code"::character varying(10) as facility_zip_code,
    a.facility_state as facility_state,
    4::integer as facility_epa_region,
    a."facility_latitude"::double precision as facility_latitude,
    a."facility_longitude"::double precision as facility_longitude,
    c."OWNER_NAME"::character varying(100) as facility_owner_company_name,
    case when d."Facilityid" is not null then 'Yes' end as ust_reported_release,
    d."release_id"::character varying(40) as associated_ust_release_id
from tn_ust."v_facilities" a
left join tn_ust."v_owner_types" b
    on a."facility_id"::text = b."facility_id"::text
left join (
    select "FACILITY_ID_UST", max("OWNER_NAME") as "OWNER_NAME", max("FACILITY_TYPE") as "FACILITY_TYPE"
    from tn_ust."tn_facilities_merged"
    group by "FACILITY_ID_UST"
) c
    on a."facility_id"::text = c."FACILITY_ID_UST"::text
left join (
    select "Facilityid", max("release_id") as "release_id"
    from tn_ust."tn_environmental_sites"
    group by "Facilityid"
) d
    on a."facility_id"::text = d."Facilityid"::text
left join tn_ust.v_facility_type_xwalk e on c."FACILITY_TYPE" = e.organization_value
left join tn_ust.v_owner_type_xwalk f on b.owner_type = f.organization_value
left join tn_ust.v_state_xwalk g on a.facility_state = g.organization_value
where not exists (
    select 1 from tn_ust.erg_unregulated_facilities unreg
    where a."facility_id"::text = unreg.facility_id::text
)
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'
and coalesce(g.exclude_from_query, 'N') <> 'Y';

select facility_id, count(*) as row_count
from tn_ust.v_ust_facility
group by facility_id
having count(*) > 1;

commit;