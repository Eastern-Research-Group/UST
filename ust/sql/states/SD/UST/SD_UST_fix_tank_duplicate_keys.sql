-- One row per identified tank; omit source rows that contain facility data only.
-- Resolve status using the minimum compartment_statuses.status_hierarchy,
-- matching tank and compartment statuses by label. Conflicting dates remain NULL.
-- Source conflicts, including removed/abandoned combinations, remain reviewable.
-- Regenerating views can overwrite this custom resolution.
begin;
set local lock_timeout = '5s';

create or replace view sd_ust.v_tank_source_conflicts as
with mapped as (
SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
    a."TankNumber"::integer AS tank_id,
    a."TankNumber"::character varying(50) AS tank_name,
    COALESCE(ts.tank_status_id, 8) AS tank_status_id,
        CASE
            WHEN a."TankRemovedYear" = ANY (ARRAY['04/10/1991'::text, '11/15/1989'::text]) THEN to_date(a."TankRemovedYear", 'mm/dd/yyyy'::text)
            ELSE to_date(a."TankRemovedYear"::character varying::text, 'yyyy'::text)
        END AS tank_closure_date,
        CASE
            WHEN a."TankInstalledYear" = 1899::double precision THEN NULL::date
            ELSE to_date(a."TankInstalledYear"::character varying::text, 'yyyy'::text)
        END AS tank_installation_date,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) ~ '^[+-]?\d+(\.0+)?$'::text AND NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text)::numeric > 1::numeric THEN 'Yes'::text
            WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) ~ '^[+-]?\d+(\.0+)?$'::text THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    n.number_of_compartments,
    b.tank_material_description_id,
        CASE
            WHEN a."TankConstructionName" = ANY (ARRAY['DW/STIP3'::text, 'DW/STIP3/Compart'::text, 'STIP3'::text, 'STIP3/Compart'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN a."TankConstructionName" = ANY (ARRAY['Lined w/ Impressed'::text, 'Steel/Impressed'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN a."TankConstructionName" = ANY (ARRAY['Lined Interior'::text, 'Lined w/ Impressed'::text, 'Painted Steel w/ Lining'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    c.tank_secondary_containment_id
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.v_tank_material_description_xwalk b ON a."TankConstructionName" = b.organization_value::text
     LEFT JOIN sd_ust.v_tank_secondary_containment_xwalk c ON a."TankConstructionName" = c.organization_value::text
     LEFT JOIN sd_ust.v_tank_status_xwalk ts ON a."StatusName" = ts.organization_value::text
     LEFT JOIN sd_ust.erg_number_of_compartments n ON a."FacilityNumber" = n."FacilityNumber" AND a."TankNumber" = n."TankNumber"
  WHERE NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(c.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(ts.exclude_from_query, 'N'::character varying)::text <> 'Y'::text
)
select facility_id, tank_id,
    array_agg(distinct tank_status_id order by tank_status_id) as source_status_ids,
    array_agg(distinct tank_installation_date order by tank_installation_date) as source_installation_dates,
    array_agg(distinct tank_closure_date order by tank_closure_date) as source_closure_dates,
    count(distinct tank_status_id) > 1 and bool_or(tank_status_id in (
        select ts.tank_status_id from public.tank_statuses ts
        where ts.tank_status in ('Closed (removed from ground)', 'Abandoned')
    )) as status_data_error
from mapped
where tank_id is not null
group by facility_id, tank_id
having count(*) > 1;

create or replace view sd_ust.v_ust_tank as
with mapped as (
SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
    a."TankNumber"::integer AS tank_id,
    a."TankNumber"::character varying(50) AS tank_name,
    COALESCE(ts.tank_status_id, 8) AS tank_status_id,
        CASE
            WHEN a."TankRemovedYear" = ANY (ARRAY['04/10/1991'::text, '11/15/1989'::text]) THEN to_date(a."TankRemovedYear", 'mm/dd/yyyy'::text)
            ELSE to_date(a."TankRemovedYear"::character varying::text, 'yyyy'::text)
        END AS tank_closure_date,
        CASE
            WHEN a."TankInstalledYear" = 1899::double precision THEN NULL::date
            ELSE to_date(a."TankInstalledYear"::character varying::text, 'yyyy'::text)
        END AS tank_installation_date,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) ~ '^[+-]?\d+(\.0+)?$'::text AND NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text)::numeric > 1::numeric THEN 'Yes'::text
            WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) ~ '^[+-]?\d+(\.0+)?$'::text THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    n.number_of_compartments,
    b.tank_material_description_id,
        CASE
            WHEN a."TankConstructionName" = ANY (ARRAY['DW/STIP3'::text, 'DW/STIP3/Compart'::text, 'STIP3'::text, 'STIP3/Compart'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN a."TankConstructionName" = ANY (ARRAY['Lined w/ Impressed'::text, 'Steel/Impressed'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN a."TankConstructionName" = ANY (ARRAY['Lined Interior'::text, 'Lined w/ Impressed'::text, 'Painted Steel w/ Lining'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    c.tank_secondary_containment_id
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.v_tank_material_description_xwalk b ON a."TankConstructionName" = b.organization_value::text
     LEFT JOIN sd_ust.v_tank_secondary_containment_xwalk c ON a."TankConstructionName" = c.organization_value::text
     LEFT JOIN sd_ust.v_tank_status_xwalk ts ON a."StatusName" = ts.organization_value::text
     LEFT JOIN sd_ust.erg_number_of_compartments n ON a."FacilityNumber" = n."FacilityNumber" AND a."TankNumber" = n."TankNumber"
  WHERE NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(c.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(ts.exclude_from_query, 'N'::character varying)::text <> 'Y'::text
), preferred_status as (
    select distinct on (m.facility_id, m.tank_id)
        m.facility_id, m.tank_id, m.tank_status_id
    from mapped m
    join public.tank_statuses ts on ts.tank_status_id = m.tank_status_id
    join public.compartment_statuses cs on cs.compartment_status = ts.tank_status
    order by m.facility_id, m.tank_id, cs.status_hierarchy nulls last, m.tank_status_id
)
select
    facility_id,
    tank_id,
    (case when count(distinct tank_name) <= 1 then max(tank_name) else null end)::character varying(50) as tank_name,
    (select ps.tank_status_id from preferred_status ps
     where ps.facility_id = mapped.facility_id and ps.tank_id = mapped.tank_id) as tank_status_id,
    (case when count(distinct tank_closure_date) <= 1 then max(tank_closure_date) else null end)::date as tank_closure_date,
    (case when count(distinct tank_installation_date) <= 1 then max(tank_installation_date) else null end)::date as tank_installation_date,
    (case when count(distinct compartmentalized_ust) <= 1 then max(compartmentalized_ust) else null end)::text as compartmentalized_ust,
    (case when count(distinct number_of_compartments) <= 1 then max(number_of_compartments) else null end)::integer as number_of_compartments,
    (case when count(distinct tank_material_description_id) <= 1 then max(tank_material_description_id) else null end)::integer as tank_material_description_id,
    (case when count(distinct tank_corrosion_protection_sacrificial_anode) <= 1 then max(tank_corrosion_protection_sacrificial_anode) else null end)::text as tank_corrosion_protection_sacrificial_anode,
    (case when count(distinct tank_corrosion_protection_impressed_current) <= 1 then max(tank_corrosion_protection_impressed_current) else null end)::text as tank_corrosion_protection_impressed_current,
    (case when count(distinct tank_corrosion_protection_interior_lining) <= 1 then max(tank_corrosion_protection_interior_lining) else null end)::text as tank_corrosion_protection_interior_lining,
    (case when count(distinct tank_secondary_containment_id) <= 1 then max(tank_secondary_containment_id) else null end)::integer as tank_secondary_containment_id
from mapped
where tank_id is not null
group by facility_id, tank_id;

select count(*) as rows, count(distinct (facility_id,tank_id)) as unique_keys,
       count(*) filter(where tank_id is null) as null_tank_ids
from sd_ust.v_ust_tank;
select * from sd_ust.v_tank_source_conflicts order by facility_id, tank_id;

-- Review QA, then choose one:
-- commit;
-- rollback;
