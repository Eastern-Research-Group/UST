-- Add generated piping IDs for merged hazardous-substance compartments.
-- The original erg_piping_id table predates the canonical merged compartments.

begin;

with existing_keys as (
    select facility_id, tank_id, compartment_id
    from tn_ust.erg_piping_id
), missing_keys as (
    select distinct
        c."Facility Id Ust"::character varying as facility_id,
        c."Tank Number"::character varying as tank_name,
        c."Tank Id"::integer as tank_id,
        c."Compartment Letter"::character varying as compartment_name,
        c."Compartment Id"::integer as compartment_id
    from tn_ust.tn_compartments_merged c
    left join existing_keys e
        on e.facility_id = c."Facility Id Ust"::character varying
       and e.tank_id = c."Tank Id"::integer
       and e.compartment_id = c."Compartment Id"::integer
    where e.facility_id is null
), numbered as (
    select
        m.*,
        coalesce((select max(piping_id) from tn_ust.erg_piping_id), 0)
            + row_number() over (order by m.facility_id, m.tank_id, m.compartment_id) as piping_id
    from missing_keys m
)
insert into tn_ust.erg_piping_id (
    facility_id, tank_name, tank_id, compartment_name, compartment_id, piping_id
)
overriding system value
select facility_id, tank_name, tank_id, compartment_name, compartment_id, piping_id
from numbered;

commit;
