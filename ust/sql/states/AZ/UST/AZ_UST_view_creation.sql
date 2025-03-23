----------------------------------------------------------------------------------------------------------
drop view az_ust.v_ust_facility

create or replace view az_ust.v_ust_facility as
select distinct
    a."FacilityID"::character varying(50) as facility_id, 
    a."FacilityName"::character varying(100) as facility_name, 
    owner_type_id as owner_type_id, 
    facility_type_id as facility_type1, 
    "FacilityAddress1"::character varying(100) as facility_address1, 
    "FacilityCity"::character varying(100) as facility_city, 
    "FacilityCounty"::character varying(100) as facility_county, 
    "FacilityZipCode"::character varying(10) as facility_zip_code, 
    facility_state as facility_state, 
    "FacilityEPARegion"::integer as facility_epa_region, 
    "FacilityTribalSite"::character varying(3) as facility_tribal_site, 
    "FacilityLatitude"::double precision as facility_latitude, 
    "FacilityLongitude"::double precision as facility_longitude, 
    "FacilityOwnerCompanyName"::character varying(100) as facility_owner_company_name, 
    "FacilityOperatorCompanyName"::character varying(100) as facility_operator_company_name, 
    "FinancialResponsibilityObtained"::character varying(7) as financial_responsibility_obtained, 
    "FinancialResponsibilityBondRatingTest"::character varying(3) as financial_responsibility_bond_rating_test, 
    "FinancialResponsibilityCommercialInsurance"::character varying(3) as financial_responsibility_commercial_insurance, 
    "FinancialResponsibilityGuarantee"::character varying(3) as financial_responsibility_guarantee, 
    "FinancialResponsibilityLetterOfCredit"::character varying(3) as financial_responsibility_letter_of_credit, 
    "FinancialResponsibilityLocalGovernmentFinancialTest"::character varying(3) as financial_responsibility_local_government_financial_test, 
    "FinancialResponsibilityRiskRetentionGroup"::character varying(3) as financial_responsibility_risk_retention_group, 
    "FinancialResponsibilitySelfInsuranceFinancialTest"::character varying(3) as financial_responsibility_self_insurance_financial_test, 
    "FinancialResponsibilityStateFund"::character varying(3) as financial_responsibility_state_fund, 
    "FinancialResponsibilitySuretyBond"::character varying(3) as financial_responsibility_surety_bond, 
    "FinancialResponsibilityTrustFund"::character varying(3) as financial_responsibility_trust_fund, 
    "FinancialResponsibilityOtherMethod"::character varying(500) as financial_responsibility_other_method 
from az_ust."ust_facility" a
     left join az_ust."erg_facility_type_mapping" b on a."FacilityID" = b."FacilityID"
     left join public.facility_types c on b.epa_value = c.facility_type
     left join az_ust."v_owner_type_xwalk" d on a."OwnerType" = d.organization_value::text
     left join az_ust."v_state_xwalk" e on a."FacilityState" = e.organization_value::text

;
select * from az_ust.erg_facility_type_mapping;


select * from az_ust.v_facility_type_xwalk 

----------------------------------------------------------------------------------------------------------

create or replace view az_ust.v_ust_facility as
select distinct
    "FacilityID"::character varying(50) as facility_id, 
    "FacilityName"::character varying(100) as facility_name, 
    owner_type_id as owner_type_id, 
    facility_type_id as facility_type1, 
    "FacilityAddress1"::character varying(100) as facility_address1, 
    "FacilityCity"::character varying(100) as facility_city, 
    "FacilityCounty"::character varying(100) as facility_county, 
    "FacilityZipCode"::character varying(10) as facility_zip_code, 
    facility_state as facility_state, 
    "FacilityEPARegion"::integer as facility_epa_region, 
    "FacilityTribalSite"::character varying(3) as facility_tribal_site, 
    "FacilityLatitude"::double precision as facility_latitude, 
    "FacilityLongitude"::double precision as facility_longitude, 
    "FacilityOwnerCompanyName"::character varying(100) as facility_owner_company_name, 
    "FacilityOperatorCompanyName"::character varying(100) as facility_operator_company_name, 
    "FinancialResponsibilityObtained"::character varying(7) as financial_responsibility_obtained, 
    "FinancialResponsibilityBondRatingTest"::character varying(3) as financial_responsibility_bond_rating_test, 
    "FinancialResponsibilityCommercialInsurance"::character varying(3) as financial_responsibility_commercial_insurance, 
    "FinancialResponsibilityGuarantee"::character varying(3) as financial_responsibility_guarantee, 
    "FinancialResponsibilityLetterOfCredit"::character varying(3) as financial_responsibility_letter_of_credit, 
    "FinancialResponsibilityLocalGovernmentFinancialTest"::character varying(3) as financial_responsibility_local_government_financial_test, 
    "FinancialResponsibilityRiskRetentionGroup"::character varying(3) as financial_responsibility_risk_retention_group, 
    "FinancialResponsibilitySelfInsuranceFinancialTest"::character varying(3) as financial_responsibility_self_insurance_financial_test, 
    "FinancialResponsibilityStateFund"::character varying(3) as financial_responsibility_state_fund, 
    "FinancialResponsibilitySuretyBond"::character varying(3) as financial_responsibility_surety_bond, 
    "FinancialResponsibilityTrustFund"::character varying(3) as financial_responsibility_trust_fund, 
    "FinancialResponsibilityOtherMethod"::character varying(500) as financial_responsibility_other_method 
from az_ust."ust_facility" a
     left join az_ust."erg_facility_type_mapping" b on a."" = b.""
     left join az_ust."v_facility_type_xwalk" c on a."" = b.organization_value::text
     left join az_ust."v_owner_type_xwalk" d on a."" = b.organization_value::text
     left join az_ust."v_state_xwalk" e on a."" = b.organization_value::text

where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (14,'ust_tank','facility_id','ust_tank','FacilityID',null,null);




create or replace view az_ust.v_ust_tank as
select distinct
	"FacilityID"::varchar(50) as facility_id,
    "TankName"::integer as tank_id, 
    "TankName"::character varying(50) as tank_name, 
    tank_location_id as tank_location_id, 
    tank_status_id as tank_status_id, 
    "FederallyRegulated"::character varying(7) as federally_regulated, 
    "FieldConstructed"::character varying(7) as field_constructed, 
    "EmergencyGenerator"::character varying(7) as emergency_generator, 
    "AirportHydrantSystem"::character varying(7) as airport_hydrant_system, 
    "TankClosureDate"::date as tank_closure_date, 
    "TankInstallationDate"::date as tank_installation_date, 
    "CompartmentalizedUST"::character varying(7) as compartmentalized_ust, 
    "NumberOfCompartments"::integer as number_of_compartments, 
    tank_material_description_id as tank_material_description_id, 
    "TankCorrosionProtectionSacrificialAnode"::character varying(7) as tank_corrosion_protection_sacrificial_anode, 
    "TankCorrosionProtectionImpressedCurrent"::character varying(7) as tank_corrosion_protection_impressed_current, 
    "TankCorrosionProtectionInteriorLining"::character varying(7) as tank_corrosion_protection_interior_lining, 
    tank_secondary_containment_id as tank_secondary_containment_id 
from az_ust."ust_tank" a
     left join az_ust."v_tank_location_xwalk" b on a."TankLocation" = b.organization_value::text
     left join az_ust."v_tank_material_description_xwalk" c on a."TankMaterialDescription" = c.organization_value::text
     left join az_ust."v_tank_secondary_containment_xwalk" d on a."TankSecondaryContainment" = d.organization_value::text
     left join az_ust."v_tank_status_xwalk" e on a."TankStatus" = e.organization_value::text;

    
    
    
select * from az_ust.ust_tank;
    
select * from az_ust."ust_tank_OLD"

select * from ust_element_mapping where ust_control_id = 14 and epa_table_name = 'ust_tank'

update ust_element_mapping set organization_column_name = 'TankName' where ust_element_mapping_id = 670;

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

select * from az_ust.v_ust_compartment

create or replace view az_ust.v_ust_compartment as
select distinct
	"FacilityID"::varchar(50) as facility_id,
    "TankName"::integer as tank_id, 
    "TankName"::character varying(50) as tank_name, 	
    "CompartmentName"::integer as compartment_id, 
    "CompartmentName"::character varying(50) as compartment_name, 
    compartment_status_id as compartment_status_id, 
    "CompartmentCapacityGallons"::integer as compartment_capacity_gallons, 
    "OverfillPreventionBallFloatValve"::character varying(7) as overfill_prevention_ball_float_valve, 
    "OverfillPreventionFlowShutoffDevice"::character varying(7) as overfill_prevention_flow_shutoff_device, 
    "OverfillPreventionHighLevelAlarm"::character varying(7) as overfill_prevention_high_level_alarm, 
    "SpillBucketInstalled"::character varying(3) as spill_bucket_installed, 
    "ConcreteBermInstalled"::character varying(3) as concrete_berm_installed, 
    "TankInterstitialMonitoring"::character varying(7) as tank_interstitial_monitoring, 
    "TankAutomaticTankGaugingReleaseDetection"::character varying(7) as tank_automatic_tank_gauging_release_detection, 
    "TankManualTankGauging"::character varying(7) as tank_manual_tank_gauging, 
    "TankStatisticalInventoryReconciliation"::character varying(7) as tank_statistical_inventory_reconciliation, 
    "TankTightnessTesting"::character varying(7) as tank_tightness_testing, 
    "TankInventoryControl"::character varying(7) as tank_inventory_control, 
    "TankGroundwaterMonitoring"::character varying(7) as tank_groundwater_monitoring, 
    "TankVaporMonitoring"::character varying(7) as tank_vapor_monitoring 
from az_ust."ust_compartment" a
	
     left join az_ust."v_compartment_status_xwalk" b on a."CompartmentStatus" = b.organization_value::text
;

select * from az_ust.ust_compartment ;

select distinct epa_column_name, organization_table_name, organization_column_name,
	organization_join_column, organization_join_fk, table_sort_order, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 14 and epa_table_name = 'ust_compartment'
and epa_column_name like 'compartment%'
order by table_sort_order, column_sort_order;

update ust_element_mapping set organization_column_name = 'CompartmentName' where ust_element_mapping_id = 523;

select * from az_ust.erg_compartment_id ;

select * from az_ust.ust_facility where "FacilityID" not in (select facility_id from az_ust.erg_compartment_id)

select * from az_ust.ust_facility where "FacilityID" not in (select "FacilityID" from az_ust.ust_tank)

select * from az_ust.ust_facility where "FacilityID" not in (select "FacilityID" from az_ust.ust_compartment)


drop view  az_ust.v_ust_compartment_substance;
drop view  az_ust.v_ust_compartment;

drop table az_ust.erg_compartment ;

select * from 





----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

create or replace view az_ust.v_ust_compartment as
select distinct
	"FacilityID"::varchar(50) as facility_id,
    "TankName"::integer as tank_id, 
    "TankName"::character varying(50) as tank_name, 	
    a."compartment_id"::integer as compartment_id, 
    "CompartmentName"::character varying(50) as compartment_name, 
    compartment_status_id as compartment_status_id, 
    "CompartmentCapacityGallons"::integer as compartment_capacity_gallons, 
    "OverfillPreventionBallFloatValve"::character varying(7) as overfill_prevention_ball_float_valve, 
    "OverfillPreventionFlowShutoffDevice"::character varying(7) as overfill_prevention_flow_shutoff_device, 
    "OverfillPreventionHighLevelAlarm"::character varying(7) as overfill_prevention_high_level_alarm, 
    "SpillBucketInstalled"::character varying(3) as spill_bucket_installed, 
    "ConcreteBermInstalled"::character varying(3) as concrete_berm_installed, 
    "TankInterstitialMonitoring"::character varying(7) as tank_interstitial_monitoring, 
    "TankAutomaticTankGaugingReleaseDetection"::character varying(7) as tank_automatic_tank_gauging_release_detection, 
    "TankManualTankGauging"::character varying(7) as tank_manual_tank_gauging, 
    "TankStatisticalInventoryReconciliation"::character varying(7) as tank_statistical_inventory_reconciliation, 
    "TankTightnessTesting"::character varying(7) as tank_tightness_testing, 
    "TankInventoryControl"::character varying(7) as tank_inventory_control, 
    "TankGroundwaterMonitoring"::character varying(7) as tank_groundwater_monitoring, 
    "TankVaporMonitoring"::character varying(7) as tank_vapor_monitoring 
from az_ust."erg_compartment_id" a
     left join az_ust."ust_compartment" b on b."FacilityID" = a."facility_id" and b."TankName"::text = a.tank_name::text
     left join az_ust."v_compartment_status_xwalk" c on b."CompartmentStatus" = c.organization_value
;



select * from az_ust."erg_compartment_id"

----------------------------------------------------------------------------------------------------------


drop view  az_ust.v_ust_piping;

create or replace view az_ust.v_ust_piping as
select distinct
	"FacilityID"::varchar(50) as facility_id,
    "TankName"::integer as tank_id, 
    "TankName"::character varying(50) as tank_name, 	
    d."compartment_id"::integer as compartment_id, 
    "CompartmentName"::character varying(50) as compartment_name, 
    piping_id::character varying(50) as piping_id, 
    piping_style_id as piping_style_id, 
    "PipingMaterialFRP"::character varying(3) as piping_material_frp, 
    "PipingMaterialSteel"::character varying(3) as piping_material_steel, 
    "PipingMaterialCopper"::character varying(3) as piping_material_copper, 
    "PipingMaterialFlex"::character varying(3) as piping_material_flex, 
    "PipingMaterialNoPiping"::character varying(3) as piping_material_no_piping, 
    "PipingMaterialOther"::character varying(3) as piping_material_other, 
    "PipingMaterialUnknown"::character varying(3) as piping_material_unknown, 
    "PipingCorrosionProtectionSacrificialAnode"::character varying(7) as piping_corrosion_protection_sacrificial_anode, 
    "PipingCorrosionProtectionImpressedCurrent"::character varying(7) as piping_corrosion_protection_impressed_current, 
    "PipingLineLeakDetector"::character varying(7) as piping_line_leak_detector, 
    "PipingLineTestAnnual"::character varying(7) as piping_line_test_annual, 
    "PipingGroundwaterMonitoring"::character varying(7) as piping_groundwater_monitoring, 
    "PipingVaporMonitoring"::character varying(7) as piping_vapor_monitoring, 
    "PipingInterstitialMonitoring"::character varying(7) as piping_interstitial_monitoring, 
    "PipingStatisticalInventoryReconciliation"::character varying(7) as piping_statistical_inventory_reconciliation, 
    "PipingReleaseDetectionOther"::character varying(7) as piping_release_detection_other, 
    piping_wall_type_id as piping_wall_type_id 
from az_ust."ust_piping" a
	join az_ust.erg_piping_id d on a."FacilityID" = d.facility_id and a."TankName"::text = d.tank_name::text
		and a."CompartmentName"::text = d.compartment_name::text
     left join az_ust.v_piping_style_xwalk b on a."PipingStyle" = b.organization_value
     left join az_ust.v_piping_wall_type_xwalk c on a."PipingWallType" = c.organization_value

;


select count(*) from public.ust_element_mapping 
where ust_control_id = 14 and organization_table_name = 'erg_compartment_id'

insert into az_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct a.facility_id, a.tank_name, a.tank_id, a.compartment_name, a.compartment_id 
from az_ust.erg_compartment_id a left join az_ust.ust_piping b 
	on a.facility_id = b."FacilityID" and a.tank_name::text = b."TankName"::text and a.compartment_name::text = b."CompartmentName"::text;


select * from az_ust.ust_piping

select * from az_ust.erg_piping_id;


select * from az_ust.ust_piping;

select * from az_ust.erg_compartment_id;

update az_ust.erg_compartment_id set tank_id = tank_name::int;



select * from v_ust_element_mapping_joins 
where ust_control_id = 14 and epa_table_name = 'ust_tank_substance'

select * from v_ust_element_mapping 
where ust_control_id = 14 and epa_table_name = 'ust_tank_substance'


create view az_ust.v_ust_compartment_substance as 
select distinct 
	"FacilityID"::text as facility_id, 
       "TankName"::int as tank_id, 
       "TankName"::text as tank_name,
		compartment_id, 
		"CompartmentName"::text as compartment_name, 
		substance_id
from az_ust.ust_compartment a
	join az_ust.erg_compartment_id b on a."FacilityID" = b.facility_id  and a."TankName"::text = b.tank_name
		and a."CompartmentName"::text = b.compartment_name
	left join az_ust.v_substance_xwalk c on a."CompartmentSubstanceStored" = c.organization_value 

	drop view az_ust.v_ust_tank_substance

create or replace view az_ust.v_ust_tank_substance as 
select distinct 
	"FacilityID"::varchar(50) as facility_id, 
       "TankName"::int as tank_id, 
       "TankName" as tank_name,
       substance_id
from az_ust.ust_compartment a
	join az_ust.erg_compartment_id b on a."FacilityID" = b.facility_id  and a."TankName"::text = b.tank_name
		and a."CompartmentName"::text = b.compartment_name
	left join az_ust.v_substance_xwalk c on a."CompartmentSubstanceStored" = c.organization_value 


select * from az_ust.ust_compartment 





				
select * from az_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;	


select * 
into temp_state
from az_ust.v_ust_tank_substance 


select * from public.v_ust_tank_substance

select * 
into temp_public
from public.v_ust_tank_substance b join public.substances  c on b."Substance" = c.substance

select * from temp_public;

create index temp_public_subid_idx on temp_public(substance_id);
create index temp_public_facid_idx on temp_public("FacilityID");
create index temp_public_tankid_idx on temp_public("TankID");;
create index temp_public_factankid_idx on temp_public("FacilityID","TankID");

select * from temp_state;

create index temp_state_facid_idx on temp_state(facility_id);
create index temp_state_tankid_idx on temp_state(tank_id);
create index temp_state_factankid_idx on temp_state(facility_id,tank_id);
create index temp_state_subid_idx on temp_state(substance_id);
create index temp_state_factanksubid_idx on temp_state(facility_id,tank_id,substance_id);


select *from temp_state a join substances sub on a.substance_id = sub.substance_id 
where not exists 
	(select 1 from temp_public b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = b."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;	

0-010651	3	16	16	Diesel fuel (b-unknown)


select * from v_ust_tank 
where ust_control_id = 14 and "FacilityID" = '0-010651'

select * from az_ust.ust_tank 


select * from az_ust.ust_facility where "FacilityID" not in (select "FacilityID" from az_ust.ust_tank)


select distinct "FacilityID", "FacilityName" 
from az_ust.ust_facility where "FacilityID" not in (select "FacilityID" from az_ust.ust_compartment)
order by 1



