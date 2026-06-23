----------------------------------------------------------------------------------------------------------

create or replace view sd_release.v_ust_release_substance as
select distinct
    substance_id as substance_id, 
    "amount"::double precision as quantity_released, 
    "units"::character varying(20) as unit 
from sd_release."erg_material_datarows_deagg" a
    left join sd_release.v_substance_xwalk c on a."material" = c.organization_value
where substance_id is not null and not exists
    (select 1 from sd_release.erg_unregulated_substances unreg
    where a."id":: varchar(50) = unreg.release_id and a."material"::varchar() = unreg.substance_id)

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
