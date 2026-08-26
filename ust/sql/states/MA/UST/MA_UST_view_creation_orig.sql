----------------------------------------------------------------------------------------------------------

select * from ust_element_mapping where ust_control_id = 42 
and epa_column_name = 'facility_state'

create or replace view ma_ust.v_ust_facility as
select distinct
    "Facility ID#"::character varying(50) as facility_id,
    "FAC NAME"::character varying(100) as facility_name,
    owner_type_id as owner_type_id,
    facility_type_id as facility_type1,
    "FAC ADD 1"::character varying(100) as facility_address1,
    "FAC ADD 2"::character varying(100) as facility_address2,
    "FAC CITY"::character varying(100) as facility_city,
    "FAC ZIP"::character varying(10) as facility_zip_code,
    case when "FAC STATE" is not null then "FAC STATE"::character varying(2) else 'MA'::character varying(2) end as facility_state,
    1::integer as facility_epa_region,
    "FAC LAT"::double precision as facility_latitude,
    "FAC LONG"::double precision as facility_longitude,
    case when b."fr_type_name" is not null then 'Yes'end as financial_responsibility_obtained,  
   	case when b.fr_type_name = 'Local Government Bond Rating Test' then 'Yes' end  as financial_responsibility_bond_rating_test,
    case when b.fr_type_name = 'Commercial Insurance' then 'Yes' end as financial_responsibility_commercial_insurance,
    case when b.fr_type_name = 'Guarantee' then 'Yes' end as financial_responsibility_guarantee,
    case when b.fr_type_name = 'Irrevocable Standby Letter of Credit' then 'Yes' end as financial_responsibility_letter_of_credit,
    case when b.fr_type_name = 'Local Government Financial Test of Insurance' then 'Yes' end as financial_responsibility_local_government_financial_test ,
    case when b.fr_type_name = 'Risk Retention Group Coverage' then 'Yes' end as financial_responsibility_risk_retention_group,
    case when b.fr_type_name = 'Financial Test of Insurance' then 'Yes' end as financial_responsibility_self_insurance_financial_test,
    case when b.fr_type_name = 'Surety Bond' then 'Yes' end as financial_responsibility_surety_bond ,
    case when b.fr_type_name = 'Trust Fund"' then 'Yes' end as financial_responsibility_trust_fund ,
    case when b.fr_type_name in ('Local Government Fund','Local Government Guarantee') then 'Yes' end as financial_responsibility_other_method   
from ma_ust.erg_facility_final a
	left join ma_ust.erg_facility_info_fr_type b on a. "Facility ID#"::character varying(50) = b."facility_id"
    left join ma_ust.v_facility_type_xwalk d on a."FAC TYPE" = d.organization_value
    left join ma_ust.erg_facility_info_org_type c on a. "Facility ID#"::character varying(50) = c."facility_id"
    left join ma_ust.v_owner_type_xwalk e on c."org_type_name" = e.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id )

    select count(*) from ma_ust.v_ust_facility
    
    select * from ust_element_mapping where ust_control_id = 42
    and organization_table_name = 'erg_facility_final'
    
    update ust_element_mapping set organization_table_name = 'Facility info'
    where  ust_control_id = 42
    and organization_table_name = 'erg_facility_final'
    
    select distinct fr_type_name from ma_ust.erg_facility_info_fr_type 
    
    select * from ma_ust.erg_facility_info_org_type 
    
    select * from ma_ust.v_owner_type_xwalk
    
    
create or replace view ma_ust.v_ust_facility as
with fr as
(
    select
        facility_id,

        'Yes' as financial_responsibility_obtained,

        max(case when fr_type_name = 'Local Government Bond Rating Test'
                 then 'Yes' end) as financial_responsibility_bond_rating_test,

        max(case when fr_type_name = 'Commercial Insurance'
                 then 'Yes' end) as financial_responsibility_commercial_insurance,

        max(case when fr_type_name = 'Guarantee'
                 then 'Yes' end) as financial_responsibility_guarantee,

        max(case when fr_type_name = 'Irrevocable Standby Letter of Credit'
                 then 'Yes' end) as financial_responsibility_letter_of_credit,

        max(case when fr_type_name = 'Local Government Financial Test of Insurance'
                 then 'Yes' end) as financial_responsibility_local_government_financial_test,

        max(case when fr_type_name = 'Risk Retention Group Coverage'
                 then 'Yes' end) as financial_responsibility_risk_retention_group,

        max(case when fr_type_name = 'Financial Test of Insurance'
                 then 'Yes' end) as financial_responsibility_self_insurance_financial_test,

        max(case when fr_type_name = 'Surety Bond'
                 then 'Yes' end) as financial_responsibility_surety_bond,

        max(case when fr_type_name = 'Trust Fund'
                 then 'Yes' end) as financial_responsibility_trust_fund,

        max(case when fr_type_name in ('Local Government Fund',
                                       'Local Government Guarantee')
                 then 'Yes' end) as financial_responsibility_other_method

    from ma_ust.erg_facility_info_fr_type
    group by facility_id
)

select
    a."Facility ID#"::varchar(50) as facility_id,
    a."FAC NAME"::varchar(100) as facility_name,
    e.owner_type_id,
    d.facility_type_id as facility_type1,
    a."FAC ADD 1"::varchar(100) as facility_address1,
    a."FAC ADD 2"::varchar(100) as facility_address2,
    a."FAC CITY"::varchar(100) as facility_city,
    a."FAC ZIP"::varchar(10) as facility_zip_code,
    case
        when a."FAC STATE" is not null
            then a."FAC STATE"::varchar(2)
        else 'MA'::varchar(2)
    end as facility_state,
    1::integer as facility_epa_region,
    a."FAC LAT"::double precision as facility_latitude,
    a."FAC LONG"::double precision as facility_longitude,

    fr.financial_responsibility_obtained,
    fr.financial_responsibility_bond_rating_test,
    fr.financial_responsibility_commercial_insurance,
    fr.financial_responsibility_guarantee,
    fr.financial_responsibility_letter_of_credit,
    fr.financial_responsibility_local_government_financial_test,
    fr.financial_responsibility_risk_retention_group,
    fr.financial_responsibility_self_insurance_financial_test,
    fr.financial_responsibility_surety_bond,
    fr.financial_responsibility_trust_fund,
    fr.financial_responsibility_other_method

from ma_ust."erg_facility_final" a
left join fr
    on a."Facility ID#" = fr.facility_id
left join ma_ust.v_facility_type_xwalk d
    on a."FAC TYPE" = d.organization_value
left join ma_ust.erg_facility_info_org_type c
    on a."Facility ID#" = c.facility_id
left join ma_ust.v_owner_type_xwalk e
    on c.org_type_name = e.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id )
    
    
-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
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
and not exists 
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id);

    
    Double-walled metal tank (cathodic protection required)
    
  select distinct "TANK CONSTRUCT" from    ma_ust."Tank info"
    
-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

drop view  ma_ust.v_ust_tank_substance

create or replace view ma_ust.v_ust_tank_substance as
select distinct
	"Facility ID#"::varchar(50) as facility_id, 
    "TANK ID#"::integer as tank_id,
    substance_id as substance_id
from ma_ust."Tank info" a
     join ma_ust.v_substance_xwalk b on a."CONTENT" = b.organization_value
where substance_id is not null and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id and a."TANK ID#"::int = unreg.tank_id)


-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

select * from ust_element_mapping where ust_control_id = 42 and epa_column_name = 'tank_other_release_detection'

delete from ust_element_mapping where ust_element_mapping_id = 4212;

select distinct "TANK LEAK DETECT" from ma_ust."Tank info" order by 1;


select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Tank info' order by ordinal_position;

drop view  ma_ust.v_ust_compartment

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




-- ma_ust.v_ust_compartment source

CREATE OR REPLACE VIEW ma_ust.v_ust_compartment
AS WITH src AS (
         SELECT a."Facility ID#",
            a."TANK ID#",
            a."INSTALL DATE",
            a."LONG",
            a."LAT",
            a."NUMBER OF COMPARTMENT",
            a."CAPACITY",
            a."USE TYPE",
            a."CONTENT",
            a."STATUS",
            a."STATUS DATE",
            a."TANK CONSTRUCT",
            a."TANK LEAK DETECT",
            a."PIPE INSTALL DATE",
            a."PIPE TYPE",
            a."PIPE CONSTRUCT",
            a."PIPE LEAK DETECT",
            a."PIPE LEAK INSTALL",
            a."SUBMERSIBLE SUMP",
            a."SUBMERSIBLE SUMP INSTALL",
            a."TURBINE SUMP",
            a."TURBINE SUMP SENSOR",
            a."INTERMEDIATE SUMP",
            a."INTERMEDIATE SUMP SENSOR",
            a."SPILL BUCKET INSTALLED",
            a."SPILL BUCKET SENSOR",
            a."OVERFILL PROTECT INSTALLED",
            a."OVERFILL PROTECT TYPE",
            a."AUTOMATIC LINE LEAK DTECT",
            a."TANK CORROSION TYPE",
            a."LEAK CORROSION TYPE",
            a."Facility ID#"::character varying(50) AS facility_id,
            a."TANK ID#"::integer AS tank_id,
            row_number() OVER (PARTITION BY (a."Facility ID#"::character varying(50)), (a."TANK ID#"::integer) ORDER BY a.ctid) AS rn
           FROM ma_ust."Tank info" a
          WHERE NOT (EXISTS ( SELECT 1
                   FROM ma_ust.erg_unregulated_tanks unreg
                  WHERE a."Facility ID#"::character varying(50)::text = unreg.facility_id::text AND a."TANK ID#"::integer = unreg.tank_id))
        ), id_map AS (
         SELECT erg_compartment_id.facility_id,
            erg_compartment_id.tank_id,
            erg_compartment_id.compartment_id,
            row_number() OVER (PARTITION BY erg_compartment_id.facility_id, erg_compartment_id.tank_id ORDER BY erg_compartment_id.compartment_id) AS rn
           FROM ma_ust.erg_compartment_id
        ), status_xwalk AS (
         SELECT v_compartment_status_xwalk.organization_value,
            min(v_compartment_status_xwalk.compartment_status_id) AS compartment_status_id
           FROM ma_ust.v_compartment_status_xwalk
          GROUP BY v_compartment_status_xwalk.organization_value
        )
 SELECT s.facility_id,
    s.tank_id,
    x.compartment_id,
    b.compartment_status_id,
    s."CAPACITY"::integer AS compartment_capacity_gallons,
        CASE
            WHEN s."OVERFILL PROTECT TYPE" = 'Ball Float'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN s."OVERFILL PROTECT TYPE" = 'Automatic shut-off valve'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN s."OVERFILL PROTECT TYPE" = 'High level alarm'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN s."SPILL BUCKET SENSOR" = 'Y'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN s."TANK LEAK DETECT" = 'Continuous Interstitial Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN s."TANK LEAK DETECT" = ANY (ARRAY['In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'::text, 'In-Tank Monitoring System'::text, 'In tank monitor up to 2 gal per hour'::text, 'In tank monitor w/ detection rate up to 1 gal/hr'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN s."TANK LEAK DETECT" = 'Continuous In-Tank Monitoring System'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN s."TANK LEAK DETECT" = ANY (ARRAY['Manual Tank Gauging (1,000G or less capacity tank)'::text, 'Manual Tank Gauging (1,000G or more capacity tank)'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN s."TANK LEAK DETECT" = 'In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN s."TANK LEAK DETECT" = ANY (ARRAY['Annual Bulk Tightness Test'::text, 'Annual tightness test w/ detection rate 0.5 gal/hr'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN s."TANK LEAK DETECT" = 'Soil Vapor Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring
   FROM src s
     JOIN id_map x ON s.facility_id::text = x.facility_id::text AND s.tank_id = x.tank_id AND s.rn = x.rn
     LEFT JOIN status_xwalk b ON s."STATUS" = b.organization_value::text;
----------------------------------------------------------------------------------------------------------

select * from ust_element_mapping where ust_control_id = 42 and epa_column_name = 'pipe_tank_top_sump'

select * from  ma_ust.vw_erg_pipe_tank_top_sump

update ust_element_mapping 
set organization_join_table = 'Tank info', 
	organization_join_column = 'Facility ID#',
	organization_join_column2 = 'TANK ID#'
where ust_element_mapping_id = 4230;

drop view  ma_ust.v_ust_piping


	

	select * from ma_ust.erg_piping_id;
	
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
),
tank_top_sump as (
    select
        "Facility ID#",
        "TANK ID#",
        min("pipe_tank_top_sump")::character varying(7) as pipe_tank_top_sump
    from ma_ust.vw_erg_pipe_tank_top_sump
    group by "Facility ID#", "TANK ID#"
)
select
	src.facility_id,
    src.tank_id,
    id_map.compartment_id,
    piping_map.piping_id::varchar(50) as piping_id,
    piping_style_id as piping_style_id,
    case when src."PIPE TYPE" = 'European suction system' then 'Yes' end as safe_suction,
    case when src."PIPE TYPE" = 'Non-European suction System' then 'Yes' end as american_suction,
    case when src."PIPE TYPE" in ('Pressurized piping system with electronic automatic line leak detection','Pressurized piping system with mechanical automatic line leak detection') then 'Yes' end as high_pressure_or_bulk_piping,
    case when src."PIPE CONSTRUCT" = 'Single-walled metal (Corrosion protection required)' then 'Yes' end as piping_corrosion_protection_sacrificial_anode,
    case when src."LEAK CORROSION TYPE" = 'Field Constructed Impressed Current System' then 'Yes' end as piping_corrosion_protection_impressed_current,
    case when src."PIPE LEAK DETECT" is not null then 'Yes' end as piping_line_leak_detector,
    case when src."PIPE LEAK DETECT" = 'Annual Automatic Line Leak Detection Test' then 'Yes' end as piping_line_test_annual,
    case when src."PIPE LEAK DETECT" = 'Continuous Interstitial Space Monitoring' then 'Yes' end as piping_interstitial_monitoring,
    case when src."PIPE LEAK DETECT" = 'In-tank monitoring with SIR (if installed prior to May 28, 1999)' then 'Yes' end as piping_statistical_inventory_reconciliation,
    case when src."PIPE LEAK DETECT" in ('Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without ','Annual Tightness Test of Single-Walled Pressurized Piping Systems','Quarterly visual inspection and annual product line tightness test (only if installed prior to 5/28/') then 'Yes' end as piping_release_detection_other,
    tank_top_sump.pipe_tank_top_sump,
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
left join tank_top_sump on src."Facility ID#" = tank_top_sump."Facility ID#" and src."TANK ID#" = tank_top_sump."TANK ID#"

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- No child join mapping found for ust_facility_dispenser; unregulated exclusion uses parent key only.


select * from  ma_ust."Dispenser info" 

create or replace view ma_ust.v_ust_facility_dispenser as
select distinct
	a."Facility ID#":: varchar(50) as facility_id, 
    "dispenser_number"::character varying(50) as dispenser_id
from ma_ust."Dispenser info" a
where not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg
    where a."Facility ID#":: varchar(50) = unreg.facility_id )

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
