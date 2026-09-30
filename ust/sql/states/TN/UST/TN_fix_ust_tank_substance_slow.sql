-- Avoid expanding v_ust_facility inside the tank-substance mapping view.
-- v_tank_substance is already sourced from tn_compartments_merged, so the
-- canonical merged facility table is sufficient for the parent existence check.

begin;

create or replace view tn_ust.v_ust_tank_substance as
select distinct
    a."facility_id"::character varying(50) as facility_id,
    a."tank_id"::integer as tank_id,
    b.substance_id as substance_id
from tn_ust."v_tank_substance" a
left join tn_ust.v_substance_xwalk b
    on a."Product" = b.organization_value
where b.substance_id is not null
and not exists (
    select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where a."facility_id"::text = unreg_fac.facility_id::text
)
and not exists (
    select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where a."facility_id"::text = unreg_tank.facility_id::text
      and a."tank_id"::integer = unreg_tank.tank_id
)
and exists (
    select 1 from tn_ust.tn_facilities_merged parent
    where parent."FACILITY_ID_UST"::text = a."facility_id"::text
)
and coalesce(b.exclude_from_query, 'N') <> 'Y';

commit;