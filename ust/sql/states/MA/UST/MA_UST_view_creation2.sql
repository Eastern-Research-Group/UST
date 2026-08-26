----------------------------------------------------------------------------------------------------------

create or replace view ma_ust.v_ust_facility as
with src as (
    select
        a."Facility ID#"::character varying(50) as facility_id,
        a."FAC NAME"::character varying(100) as facility_name,
        d.facility_type_id as facility_type1,
        a."FAC ADD 1"::character varying(100) as facility_address1,
        a."FAC ADD 2"::character varying(100) as facility_address2,
        a."FAC CITY"::character varying(100) as facility_city,
        a."FAC ZIP"::character varying(10) as facility_zip_code,
        case
            when a."FAC STATE" is not null then a."FAC STATE"::character varying(2)
            else 'MA'::character varying(2)
        end as facility_state,
        a."FAC LAT"::double precision as facility_latitude,
        a."FAC LONG"::double precision as facility_longitude,
        e.owner_type_id,
        b.fr_type_name
    from ma_ust."erg_facility_final" a
    left join ma_ust.erg_facility_info_fr_type b
        on a."Facility ID#"::character varying(50) = b.facility_id
    left join ma_ust.v_facility_type_xwalk d
        on a."FAC TYPE" = d.organization_value
    left join ma_ust.erg_facility_info_org_type c
        on a."Facility ID#"::character varying(50) = c.facility_id
    left join ma_ust.v_owner_type_xwalk e
        on c.org_type_name = e.organization_value
    where not exists (
        select 1
        from ma_ust.erg_unregulated_facilities unreg
        where a."Facility ID#"::character varying(50) = unreg.facility_id
    )
)
select
    facility_id,
    max(facility_name)::character varying(100) as facility_name,
    min(owner_type_id) as owner_type_id,
    min(facility_type1) as facility_type1,
    max(facility_address1)::character varying(100) as facility_address1,
    max(facility_address2)::character varying(100) as facility_address2,
    max(facility_city)::character varying(100) as facility_city,
    max(facility_zip_code)::character varying(10) as facility_zip_code,
    max(facility_state)::character varying(2) as facility_state,
    1::integer as facility_epa_region,
    max(facility_latitude) as facility_latitude,
    max(facility_longitude) as facility_longitude,
    case when bool_or(fr_type_name is not null) then 'Yes' end as financial_responsibility_obtained,
    case when bool_or(fr_type_name = 'Local Government Bond Rating Test') then 'Yes' end as financial_responsibility_bond_rating_test,
    case when bool_or(fr_type_name = 'Commercial Insurance') then 'Yes' end as financial_responsibility_commercial_insurance,
    case when bool_or(fr_type_name = 'Guarantee') then 'Yes' end as financial_responsibility_guarantee,
    case when bool_or(fr_type_name = 'Irrevocable Standby Letter of Credit') then 'Yes' end as financial_responsibility_letter_of_credit,
    case when bool_or(fr_type_name = 'Local Government Financial Test of Insurance') then 'Yes' end as financial_responsibility_local_government_financial_test,
    case when bool_or(fr_type_name = 'Risk Retention Group Coverage') then 'Yes' end as financial_responsibility_risk_retention_group,
    case when bool_or(fr_type_name = 'Financial Test of Insurance') then 'Yes' end as financial_responsibility_self_insurance_financial_test,
    case when bool_or(fr_type_name = 'Surety Bond') then 'Yes' end as financial_responsibility_surety_bond,
    case when bool_or(fr_type_name = 'Trust Fund"') then 'Yes' end as financial_responsibility_trust_fund,
    case when bool_or(fr_type_name in ('Local Government Fund', 'Local Government Guarantee')) then 'Yes' end as financial_responsibility_other_method
from src
group by facility_id
    
-- ADD ADDITIONAL SQL HERE IF NECESSARY
;

update ust_element_mapping 
set organization_table_name = 'erg_facility_final'
where ust_control_id = 42 and organization_table_name = 'Facility info'

----------------------------------------------------------------------------------------------------------

drop view   ma_ust.v_ust_tank

create or replace view ma_ust.v_ust_tank as
select distinct
	"Facility ID#"::varchar(50) as facility_id, 
    "TANK ID#"::integer as tank_id,
    tank_status_id as tank_status_id,
    case when "STATUS" = 'Tank Closure In-Place' then "STATUS DATE"::date end as tank_closure_date,
    "INSTALL DATE"::date as tank_installation_date,
     case when "NUMBER OF COMPARTMENT" > 1 then 'Yes'end as compartmentalized_ust,
    "NUMBER OF COMPARTMENT"::integer as number_of_compartments,
    tank_material_description_id as tank_material_description_id,
    case when "TANK CORROSION TYPE" in ('Manufactured Sacrificial Anode (Galvanic) System','Field Constructed Sacrificial Anode (Galvanic) System') then 'Yes' end as tank_corrosion_protection_sacrificial_anode ,
    case when "TANK CORROSION TYPE" = 'Field Constructed Impressed Current System' then 'Yes' end as tank_corrosion_protection_impressed_current,
    case when "TANK CONSTRUCT" like '%cathodic protection not required%' then 'Yes' end as tank_corrosion_protection_cathodic_not_required,
    tank_secondary_containment_id as tank_secondary_containment_id
from ma_ust."Tank info" a
    left join ma_ust.v_tank_material_description_xwalk b on a."TANK CONSTRUCT" = b.organization_value
    left join ma_ust.v_tank_secondary_containment_xwalk c on a."TANK CONSTRUCT" = c.organization_value
    left join ma_ust.v_tank_status_xwalk d on a."STATUS" = d.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id and a."TANK ID#"::int = unreg.tank_id)
 and exists 
 	(select 1 from ma_ust.erg_facility_final x where a."Facility ID#"::varchar(50) = x."Facility ID#"::varchar(50))
and not exists 
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id); 	

 	select count(*) from  ma_ust.v_ust_tank 
 	8138
 
 	select * from v_ust_tank where ust_control_id = 42;
 	
select * from ma_ust.v_ust_tank a where not exists 
	(select 1 from v_ust_tank b 
	where  ust_control_id = 42
	and a.facility_id = b."FacilityID" 
	and a.tank_id = b."TankID");
 	
40155	1
40155	2
40155	3

 
select * from v_ust_facility where ust_control_id = 42 and "FacilityID" = '40155'

select * from ma_ust.v_ust_facility where facility_id = '40155'

select * from ma_ust.erg_facility_final where "Facility ID#" =  '40155'

select * from ma_ust.erg_unregulated_facilities 
where facility_id =  '40155'

    
 	select * from  ma_ust.erg_facility_final
 	
    Double-walled metal tank (cathodic protection required)
    
  select distinct "TANK CONSTRUCT" from    ma_ust."Tank info"
    
-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

drop view ma_ust.v_ust_tank_substance

create or replace view ma_ust.v_ust_tank_substance as
select distinct
	"Facility ID#":: varchar(50) as facility_id, 
    "TANK ID#"::integer as tank_id,
    substance_id as substance_id
from ma_ust."Tank info" a
     join ma_ust.v_substance_xwalk b on a."CONTENT" = b.organization_value
where substance_id is not null and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id and a."TANK ID#"::int = unreg.tank_id)
  and exists 
 	(select 1 from ma_ust.erg_facility_final x where a."Facility ID#"::varchar(50) = x."Facility ID#"::varchar(50))
and not exists 
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id);


-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

select * from ust_element_mapping where ust_control_id = 42 and epa_column_name = 'tank_other_release_detection'

delete from ust_element_mapping where ust_element_mapping_id = 4212;

select distinct "TANK LEAK DETECT" from ma_ust."Tank info" order by 1;


select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Tank info' order by ordinal_position;

create or replace view ma_ust.v_ust_compartment as
with src as (
    select
        a.*,
        a."Facility ID#"::varchar(50) as facility_id,
        a."TANK ID#"::int as tank_id,
        row_number() over (
            partition by a."Facility ID#"::varchar(50), a."TANK ID#"::int
            order by a.ctid
        ) as rn
    from ma_ust."Tank info" a
    where not exists (
        select 1
        from ma_ust.erg_unregulated_tanks unreg
        where a."Facility ID#":: varchar(50) = unreg.facility_id
          and a."TANK ID#"::int = unreg.tank_id
    )
      and exists 
 	(select 1 from ma_ust.erg_facility_final x where a."Facility ID#"::varchar(50) = x."Facility ID#"::varchar(50))
and not exists 
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id)
),
id_map as (
    select
        facility_id,
        tank_id,
        compartment_id,
        row_number() over (
            partition by facility_id, tank_id
            order by compartment_id
        ) as rn
    from ma_ust.erg_compartment_id
),
status_xwalk as (
    select
        organization_value,
        min(compartment_status_id) as compartment_status_id
    from ma_ust.v_compartment_status_xwalk
    group by organization_value
)
select
    src.facility_id,
    src.tank_id,
    id_map.compartment_id,
    status_xwalk.compartment_status_id as compartment_status_id,
    src."CAPACITY"::integer as compartment_capacity_gallons,
    case when src."OVERFILL PROTECT TYPE" = 'Ball Float' then 'Yes' end as overfill_prevention_ball_float_valve,
    case when src."OVERFILL PROTECT TYPE" = 'Automatic shut-off valve' then 'Yes' end as overfill_prevention_flow_shutoff_device,
    case when src."OVERFILL PROTECT TYPE" = 'High level alarm' then 'Yes' end as overfill_prevention_high_level_alarm,
    case when src."SPILL BUCKET SENSOR" = 'Y' then 'Yes' end as spill_bucket_installed,
    case when src."TANK LEAK DETECT" = 'Continuous Interstitial Monitoring' then 'Yes' end as tank_interstitial_monitoring,
    case when src."TANK LEAK DETECT" in ('In-Tank Monitoring with Statistical Inventory Reconciliation Vendor','In-Tank Monitoring System','In tank monitor up to 2 gal per hour','In tank monitor w/ detection rate up to 1 gal/hr') then 'Yes' end as tank_automatic_tank_gauging_release_detection,
    case when src."TANK LEAK DETECT" = 'Continuous In-Tank Monitoring System' then 'Yes' end as automatic_tank_gauging_continuous_leak_detection,
    case when src."TANK LEAK DETECT" in ('Manual Tank Gauging (1,000G or less capacity tank)','Manual Tank Gauging (1,000G or more capacity tank)') then 'Yes' end as tank_manual_tank_gauging,
    case when src."TANK LEAK DETECT" = 'In-Tank Monitoring with Statistical Inventory Reconciliation Vendor' then 'Yes' end as tank_statistical_inventory_reconciliation,
    case when src."TANK LEAK DETECT" in ('Annual Bulk Tightness Test','Annual tightness test w/ detection rate 0.5 gal/hr') then 'Yes' end as tank_tightness_testing,
    case when src."TANK LEAK DETECT" = 'Soil Vapor Monitoring' then 'Yes' end as tank_vapor_monitoring
from src
join id_map
  on src.facility_id = id_map.facility_id
 and src.tank_id = id_map.tank_id
 and src.rn = id_map.rn
left join status_xwalk
  on src."STATUS" = status_xwalk.organization_value

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view ma_ust.v_ust_piping as
with src as (
    select
        a.*,
        a."Facility ID#"::varchar(50) as facility_id,
        a."TANK ID#"::int as tank_id,
        row_number() over (
            partition by a."Facility ID#"::varchar(50), a."TANK ID#"::int
            order by a.ctid
        ) as rn
    from ma_ust."Tank info" a
    where not exists (
        select 1
        from ma_ust.erg_unregulated_tanks unreg
        where a."Facility ID#":: varchar(50) = unreg.facility_id
          and a."TANK ID#"::int = unreg.tank_id
    )
      and exists 
 	(select 1 from ma_ust.erg_facility_final x where a."Facility ID#"::varchar(50) = x."Facility ID#"::varchar(50))
and not exists 
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id);

),
id_map as (
    select
        facility_id,
        tank_id,
        compartment_id,
        row_number() over (
            partition by facility_id, tank_id
            order by compartment_id
        ) as rn
    from ma_ust.erg_compartment_id
),
piping_map as (
    select
        facility_id,
        tank_id,
        compartment_id,
        piping_id,
        row_number() over (
            partition by facility_id, tank_id, compartment_id
            order by piping_id
        ) as rn
    from ma_ust.erg_piping_id
)
select
    src.facility_id,
    src.tank_id,
    id_map.compartment_id,
    piping_map.piping_id::character varying(50) as piping_id,
    piping_style_id as piping_style_id,
      !!! src."PIPE TYPE"::character varying(7) as safe_suction   -- "PIPE TYPE" = 'European suction system,
      !!! src."PIPE TYPE"::character varying(7) as american_suction   -- "PIPE TYPE" = 'Non-European suction System,
      !!! src."PIPE TYPE"::character varying(7) as high_pressure_or_bulk_piping   -- "PIPE TYPE" in ('Pressurized piping system with electronic automatic line leak detection','Pressurized piping system with mechanical automatic line leak detection',
      !!! src."PIPE CONSTRUCT"::character varying(7) as piping_corrosion_protection_sacrificial_anode   -- when "PIPE CONSTRUCT" = 'Single-walled metal (Corrosion protection required)' then 'Yes' else nul,
      !!! src."LEAK CORROSION TYPE"::character varying(7) as piping_corrosion_protection_impressed_current   -- "LEAK CORROSION TYPE" = 'Field Constructed Impressed Current Syste,
      !!! src."PIPE LEAK DETECT"::character varying(7) as piping_line_leak_detector   -- "PIPE LEAK DETECT" is not nul,
      !!! src."PIPE LEAK DETECT"::character varying(7) as piping_line_test_annual   -- "PIPE LEAK DETECT" = 'Annual Automatic Line Leak Detection Test,
      !!! src."PIPE LEAK DETECT"::character varying(7) as piping_interstitial_monitoring   -- "PIPE LEAK DETECT" = 'Continuous Interstitial Space Monitoring,
      !!! src."PIPE LEAK DETECT"::character varying(7) as piping_statistical_inventory_reconciliation   -- "PIPE LEAK DETECT" = 'In-tank monitoring with SIR (if installed prior to May 28, 1999),
      !!! src."PIPE LEAK DETECT"::character varying(7) as piping_release_detection_other   -- "PIPE LEAK DETECT" in ('Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without ','Annual Tightness Test of Single-Walled Pressurized Piping Systems','Quarterly visual inspection and annual product line tightness test (only if installed prior to 5/28/',
    src."pipe_tank_top_sump"::character varying(7) as pipe_tank_top_sump,
    piping_wall_type_id as piping_wall_type_id
from src
join id_map
  on src.facility_id = id_map.facility_id
 and src.tank_id = id_map.tank_id
 and src.rn = id_map.rn
join piping_map
  on id_map.facility_id = piping_map.facility_id
 and id_map.tank_id = piping_map.tank_id
 and id_map.compartment_id = piping_map.compartment_id
left join ma_ust.v_piping_style_xwalk c on src."PIPE TYPE" = c.organization_value
left join ma_ust.v_piping_wall_type_xwalk d on src."PIPE CONSTRUCT" = d.organization_value

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- No child join mapping found for ust_facility_dispenser; unregulated exclusion uses parent key only.

create or replace view ma_ust.v_ust_facility_dispenser as
select distinct
    "dispenser_number"::character varying(50) as dispenser_id
from ma_ust."Dispenser info" a
where not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id )

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
