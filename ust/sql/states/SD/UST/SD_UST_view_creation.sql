----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_piping.piping_material_frp with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_gal_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_stainless_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_copper with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_flex with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_no_piping with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_unknown with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_corrosion_protection_sacrificial_anode with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_line_leak_detector with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_line_test_annual with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_groundwater_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_vapor_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_interstitial_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_statistical_inventory_reconciliation with standardized recipe SQL.
-- Overriding query_logic for ust_piping.pipe_secondary_containment_other with standardized recipe SQL.

drop view  sd_ust.v_ust_piping

create or replace view sd_ust.v_ust_piping as
select distinct
    nullif(trim(a."FacilityNumber"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(a."TankNumber"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TankNumber"::text), '')::integer else null::integer end as tank_id,
    case when nullif(trim(b."compartment_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."compartment_id"::text), '')::integer else null::integer end as compartment_id,
    b."piping_id"::character varying(50) as piping_id,
    piping_style_id as piping_style_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when nullif(trim(a."TankPipingType"::text), '') = 'Safe Suction'::text then 'Yes'::text
                else null::text
    end as safe_suction,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when nullif(trim(a."TankPipingType"::text), '') = 'Pressure'::text then 'Yes'::text
                else null::text
    end as high_pressure_or_bulk_piping,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) like '%fiberglass%' then 'Yes'::text else null::text end as piping_material_frp,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('galvanized steel', 'steel - bare/galv') then 'Yes'::text else null::text end as piping_material_gal_steel,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('stainless steel', 'pipingmaterialstainlesssteel') then 'Yes'::text else null::text end as piping_material_stainless_steel,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('black steel', 'cath. protection', 'cath. steel', 'coated steel', 'steel', 'steel/aboveground', 'steel/cont', 'bare steel', 'steel isolated') then 'Yes'::text else null::text end as piping_material_steel,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('copper', 'copper -corr. prot.', 'copper isolated') then 'Yes'::text else null::text end as piping_material_copper,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('dw ameron', 'dw apt', 'dw environ', 'dw flex', 'dw marinaflex', 'dw opw', 'dw poly', 'sw ameron', 'sw apt', 'sw flex', 'total containment', 'flexible', 'flexible plastic', 'flex piping') then 'Yes'::text else null::text end as piping_material_flex,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('none', 'not applicable', 'pipingmaterialnopiping', 'no piping') then 'Yes'::text else null::text end as piping_material_no_piping,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('unknown') then 'Yes'::text else null::text end as piping_material_unknown,
    case when lower(nullif(trim(a."TankPipingMaterial"::text), '')) in ('cath. protection', 'cath. steel') then 'Yes'::text else null::text end as piping_corrosion_protection_sacrificial_anode,
    case when lower(nullif(trim(a."TankPipingReleaseDetection"::text), '')) in ('campo/miller lld', 'electronic lld', 'incon lld', 'mechanical lld', 'ppm 4000') then 'Yes'::text else null::text end as piping_line_leak_detector,
    case when lower(nullif(trim(a."TankPipingReleaseDetection"::text), '')) in ('tightness testing') then 'Yes'::text else null::text end as piping_line_test_annual,
    case when lower(nullif(trim(a."TankPipingReleaseDetection"::text), '')) in ('groundwater monitoring') then 'Yes'::text else null::text end as piping_groundwater_monitoring,
    case when lower(nullif(trim(a."TankPipingReleaseDetection"::text), '')) in ('vapor monitoring') then 'Yes'::text else null::text end as piping_vapor_monitoring,
    case when lower(nullif(trim(a."TankPipingReleaseDetection"::text), '')) in ('secondary containment', 'sump sensor') then 'Yes'::text else null::text end as piping_interstitial_monitoring,
    case when lower(nullif(trim(a."TankPipingReleaseDetection"::text), '')) in ('s.i.r.') then 'Yes'::text else null::text end as piping_statistical_inventory_reconciliation,
    piping_wall_type_id as piping_wall_type_id,
    case when lower(nullif(trim(a."TankPipingReleaseDetection"::text), '')) in ('secondary containment', 'concrete containment') then 'Yes'::text else null::text end as pipe_secondary_containment_other
from sd_ust."tanks" a
    left join sd_ust."erg_piping" b on case when nullif(trim(a."TankNumber"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TankNumber"::text), '')::integer else null::integer end = b."tank_id" and nullif(trim(a."FacilityNumber"::text), '') = b."facility_id" 
    left join sd_ust.v_piping_style_xwalk c on a."TankPipingType" = c.organization_value
    left join sd_ust.v_piping_wall_type_xwalk d on a."TankPipingMaterial" = d.organization_value
where not exists
    (select 1 from sd_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."FacilityNumber"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from sd_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."FacilityNumber"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."TankNumber"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TankNumber"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from sd_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."FacilityNumber"::text), ''))

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;


select * from sd_ust.tanks 
where "FacilityNumber" = '62-00010'

select * from sd_ust.tanks a join sd_ust.v_ust_facility parent on  parent.facility_id = nullif(trim(a."FacilityNumber"::text), '')
where  "FacilityNumber"  not in (select facility_id from sd_ust.erg_compartment)

insert into sd_ust.erg_compartment (facility_id, tank_id)
select distinct "FacilityNumber", "TankNumber" 
from sd_ust.tanks a join sd_ust.v_ust_facility parent on  parent.facility_id = nullif(trim(a."FacilityNumber"::text), '')
where  "FacilityNumber"  not in (select facility_id from sd_ust.erg_compartment)
order by 1, 2;


select * from sd_ust.erg_compartment
where facility_id =  '62-00010'

select * from sd_ust.erg_piping 
where facility_id =  '62-00010'

select * from sd_ust.erg_compartment a 
where not exists 
	(select 1 from sd_ust.erg_piping b
	where a.facility_id = b.facility_id  and a.tank_id = b.tank_id)
	
select * from sd_ust.erg_compartment
where facility_id not in (select "FacilityNumber"  from sd_ust.tanks)
	
delete from sd_ust.erg_compartment
where facility_id not in (select "FacilityNumber"  from sd_ust.tanks)


select * from 	 sd_ust.tanks where "FacilityNumber" = '01-00479'
	
insert into  sd_ust.erg_piping  (facility_id, tank_id, compartment_id)
select distinct facility_id, tank_id, compartment_id 
from sd_ust.erg_compartment a 
where not exists 
	(select 1 from sd_ust.erg_piping b
	where a.facility_id = b.facility_id  and a.tank_id = b.tank_id)
	