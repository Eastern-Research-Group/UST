------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 

--use insert_control.py to insert into public.ust_control
--the script above returned a new ust_control_id of 14 for this dataset:
select * from public.ust_control where ust_control_id = 14;

-- Update the control table 

--use insert_control.py to insert into public.ust_control
--the script above returned a new ust_control_id of 14 for this dataset:
select * from public.ust_control where ust_control_id = 14;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'AZ' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
ust_path = 'C:\Users\renae\Documents\Work\repos\ERG\UST\ust\sql\states\AZ\Releases' 
overwrite_table = False 

OR:
manually in the database, create schema az_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get an overview of what the state's data looks like. In this case, we have two tables 
select table_name from information_schema.tables 
where table_schema = 'az_ust' order by 1;
/*
2024.06.21.draft_AZ_UST_Compartment_data_v1
2024.06.21.draft_AZ_UST_Facility_data_v1
2024.06.21.draft_AZ_UST_Piping_data_v1
2024.06.21.draft_AZ_UST_Tank_data_v1
*/

/* These table names are hard to type, so let's rename them - remember that the only things we want 
   to alter in the state data are table and column names that will make it hard for us to write our SQL */
alter table az_ust."2024.06.21.draft_AZ_UST_Compartment_data_v1" rename to ust_compartment;
alter table az_ust."2024.06.21.draft_AZ_UST_Facility_data_v1" rename to ust_facility;
alter table az_ust."2024.06.21.draft_AZ_UST_Piping_data_v1" rename to ust_piping;
alter table az_ust."2024.06.21.draft_AZ_UST_Tank_data_v1" rename to ust_tank;
--now let's look at the data in each table to get an overview:
select * from az_ust.facility;
select * from az_ust.tank;
select * from az_ust.compartment;
select * from az_ust.piping;

alter table az_ust.compartment rename to ust_compartment;
alter table az_ust.facility rename to ust_facility;
alter table az_ust.piping rename to ust_piping;
alter table az_ust.tank rename to ust_tank;


--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'az_ust' and table_name = 'facility' 
order by ordinal_position;


--it might be helpful to create some indexes on the state data 
--(you can also do this as you go along in the processing and find the need to do do)
create index facility_facid_idx on az_ust.facility("FacilityID");
create index tank_facid_idx on az_ust.tank("FacilityID");
create index tank_tankname_idx on az_ust.tank("TankName");
create index tank_fk_idx on az_ust.tank("FacilityID","TankName");
create index compartment_tank_idx on az_ust.compartment("TankName");
create index compartment_comp_id_idx on az_ust.compartment("CompartmentName");
create index compartment_fk_idx on az_ust.compartment("FacilityID","TankName","CompartmentName");
create index piping_facid_idx on az_ust.piping("FacilityID");
create index piping_tankid_idx on az_ust.piping("TankName");
create index piping_compid_idx on az_ust.piping("CompartmentName");
create index piping_fk_idx on az_ust.piping("FacilityID","TankName","CompartmentName");




select 'insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values ({self.control_id}, ''' ||
	c.table_name || ''',''' || b.database_column_name || ''',''' || a.table_name || ''',''' || a.column_name || ''',''Direct mapping to EPA template per state'');'
from information_schema.columns a join ust_elements b on a.column_name = b.element_name 
	join ust_elements_tables c on b.element_id = c.element_id 
where table_schema = 'az_ust' and not exists
	(select 1 from ust_element_mapping c 
	where c.ust_control_id = 14 and a.table_name = c.organization_table_name and a.column_name = c.organization_column_name)
order by a.table_name, a.ordinal_position

select 'insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values ({self.control_id}, ''' ||
	epa_table_name || ''',''' || epa_column_name || ''',''' || org_table_name || ''',''' || org_column_name || ''',''Direct mapping to EPA template per state'');'
from 
	(select distinct c.table_name as epa_table_name, b.database_column_name as epa_column_name, 
		a.table_name as org_table_name, a.column_name as org_column_name, a.ordinal_position
	from information_schema.columns a join ust_elements b on a.column_name = b.element_name 
		join ust_elements_tables c on b.element_id = c.element_id 
	where table_schema = 'az_ust') x 
where not exists
	(select 1 from ust_element_mapping d 
	where d.ust_control_id = 14 and x.org_table_name = d.organization_table_name and x.org_column_name = d.organization_column_name)
order by org_table_name, ordinal_position;

select * from ust_element_mapping where ust_control_id = 14
and organization_column_name like '%Substance%'

delete from ust_element_mapping where ust_control_id = 14
and organization_column_name like '%Substance%'

select * from substances;


select * from ust_elements where element_name like '%Substance%'

select c.*, b.*
from ust_elements b join ust_elements_tables c on b.element_id = c.element_id 
where element_name like '%Substance%'


select state_value, epa_value 
from archive.v_ust_element_mapping 
where element_name like '%Substance%'
and lower(state_value) like lower('%transformer%')
order by 1, 2;


select table_name, column_name 
from information_schema.columns a
where table_schema = 'az_ust' and not exists 	
	(select 1 from ust_element_mapping b 
	where ust_control_id = 14 
	and a.table_name = b.organization_table_name
	and a.column_name = b.organization_column_name)
	
	select * from ust_elements where element_name like 'Associa%'
	
	select * from ust_element_value_mapping 
	
alter table ust_element_value_mapping add constraint ust_element_value_mapping_unique unique (ust_element_mapping_id, organization_value, epa_value);
alter table release_element_value_mapping add constraint release_element_value_mapping_unique unique (release_element_mapping_id, organization_value, epa_value);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Because AZ submitted templates in EPA format, run Python script process_populated_template.py 
--to insert rows into ust_element_mapping. 


/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/

select organization_table_name, organization_column_name
from 
	(select distinct organization_table_name, organization_column_name, epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_ust_needed_mapping 
	where ust_control_id = 14 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;

select distinct "FacilityCoordinateSource" from az_ust.ust_facility ;
select distinct "SpillBucketWallType" from az_ust.ust_compartment ;
select distinct "PipeTankTopSumpWallType" from az_ust.ust_piping ;
select distinct coordinate_source_id from az_ust.ust_facility ;
select distinct coordinate_source_id from az_ust.ust_facility ;
/*
ust_facility		owner_type_id
ust_facility		facility_type1
ust_tank			tank_status_id
ust_tank			tank_material_description_id
ust_tank_substance	substance_id
ust_compartment		compartment_status_id
*/


select 
from ust_element_mapping 
where ust_control_id = 14;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from az_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 14 and epa_column_name = 'owner_type_id';

select organization_table_name, organization_column_name
from v_ust_needed_mapping 
where ust_control_id = 14 and epa_column_name = 'owner_type_id';

select epa_table_name, epa_column_name, ust_element_mapping_id, organization_table_name, organization_column_name, database_lookup_table, database_lookup_column 
from v_ust_needed_mapping 
where ust_control_id = 14 order by table_sort_order, column_sort_order;

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "OwnerType" from az_ust."ust_facility" 
where "OwnerType" in (select owner_type from public.owner_types)
order by 1;
/*
City Government
Commercial
County Government
Federal Government
Private
School District
State Government
*/

select distinct a."FacilityType1", b.facility_type 
from az_ust."ust_facility" a left join public.facility_types b on a."FacilityType1"::text = b.facility_type 
where a."FacilityType1" is not null 
order by 1


select distinct "FacilityType1" from az_ust."ust_facility"
where "FacilityType1" is not null 
order by 1;

select distinct "FacilityType1"

select distinct "CompartmentSubstanceStored" from az_ust.ust_compartment order by 1;




------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'az_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_compartment_status_xwalk
v_coordinate_source_xwalk
v_facility_type_xwalk
v_owner_type_xwalk
v_pipe_tank_top_sump_wall_type_xwalk
v_piping_style_xwalk
v_piping_wall_type_xwalk
v_spill_bucket_wall_type_xwalk
v_state_xwalk
v_substance_xwalk
v_tank_location_xwalk
v_tank_material_description_xwalk
v_tank_secondary_containment_xwalk
v_tank_status_xwalk
*/

select * from az_ust.v_owner_type_xwalk;

--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 14
order by table_sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
ust_piping
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 14;

/*Step 4: work through the tables in order, using the information you collected 
to write views that can be used to populate the data tables 
NOTE! The view queried below (v_ust_table_population_sql) contains columns that help
      construct the select sql for the insertion views, but will require manual 
      oversight and manipulation by you! 
      In particular, check out the organization_join_table and organization_join_column 
      are used!!*/
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_facility'
order by column_sort_order;

/*Step 5: use the information from the queries above to create the view:
!!! NOTE look at the programmer_comments column to adjust the view if necessary
!!! NOTE also sometimes you need to explicitly cast data types so they match the EPA data tables
!!! NOTE also you may get errors related to data conversion when trying to compile the view
    you are creating here. This is good because it alerts you the data you are trying to
    insert is not compatible with the EPA format. Fix these errors before proceeding! 
!!! NOTE: Remember to do "select distinct" if necessary
!!! NOTE: Some states do not include State or EPA Region in their database, but it is generally
    safe for you to insert these yourself, so add them! (facility_state is a required field! */
create or replace view az_ust.v_ust_facility as 
select distinct 
	"FacilityID"::character varying(50) as facility_id,
	"FacilityName"::character varying(100) as facility_name,
	owner_type_id as owner_type_id,
	"FacilityAddress1"::character varying(100) as facility_address1,
	"FacilityAddress2"::character varying(100) as facility_address2,
	"FacilityCity"::character varying(100) as facility_city,
	"FacilityCounty"::character varying(100) as facility_county,
	"FacilityZipCode"::character varying(10) as facility_zip_code,
	"FacilityState" as facility_state,
	"FacilityEPARegion"::integer as facility_epa_region,
	"FacilityTribalSite"::character varying(3) as facility_tribal_site,
	"FacilityTribe"::character varying(200) as facility_tribe,
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
	"FinancialResponsibilityOtherMethod"::character varying(500) as financial_responsibility_other_method,
	"USTReportedRelease"::character varying(7) as ust_reported_release
from az_ust.ust_facility x 
	left join az_ust.v_owner_type_xwalk ot on x."OwnerType" = ot.organization_value;



--review: 
select * from az_ust.v_ust_facility;
select count(*) from az_ust.v_ust_facility;
--9749
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/
drop table  az_ust.erg_tank ;
create table az_ust.erg_tank (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);
insert into az_ust.erg_tank (facility_id, tank_name)
select distinct "FacilityID", "TankName" from az_ust.ust_tank;

select * from  az_ust.erg_tank ;

drop view az_ust.v_ust_tank;

create or replace view az_ust.v_ust_tank as 
select distinct 
	"FacilityID"::character varying(50) as facility_id, 
	"TankName"::integer as tank_id,
	"TankName"::character varying(50) as tank_name,
	tank_location_id as tank_location_id,
	tank_status_id as tank_status_id,
	"FederallyRegulated"::character varying(7) as federally_regulated,
	"FieldConstructed"::character varying(7) as field_constructed,
	"EmergencyGenerator"::character varying(7) as emergency_generator,
	"AirportHydrantSystem"::character varying(7) as airport_hydrant_system,
	"MultipleTanks"::character varying(7) as multiple_tanks,
	"TankClosureDate"::date as tank_closure_date,
	"TankInstallationDate"::date as tank_installation_date,
	"CompartmentalizedUST"::character varying(7) as compartmentalized_ust,
	"NumberOfCompartments"::integer as number_of_compartments,
	tank_material_description_id as tank_material_description_id,
	"TankCorrosionProtectionSacrificialAnode"::character varying(7) as tank_corrosion_protection_sacrificial_anode,
	"TankCorrosionProtectionImpressedCurrent"::character varying(7) as tank_corrosion_protection_impressed_current,
	"TankCorrosionProtectionCathodicNotRequired"::character varying(7) as tank_corrosion_protection_cathodic_not_required,
	"TankCorrosionProtectionInteriorLining"::character varying(7) as tank_corrosion_protection_interior_lining,
	"TankCorrosionProtectionOther"::character varying(7) as tank_corrosion_protection_other,
	"TankCorrosionProtectionUnknown"::character varying(7) as tank_corrosion_protection_unknown,
	tank_secondary_containment_id as tank_secondary_containment_id,
	"CertOfInstallationOther"::character varying(1000) as cert_of_installation_other
from az_ust.ust_tank x 
	left join az_ust.v_tank_location_xwalk tl on x."TankLocation" = tl.organization_value
	left join az_ust.v_tank_status_xwalk ts on x."TankStatus" = ts.organization_value
	left join az_ust.v_tank_material_description_xwalk md on x."TankMaterialDescription" = md.organization_value
	left join az_ust.v_tank_secondary_containment_xwalk sc on x."TankSecondaryContainment" = sc.organization_value;

select * from az_ust.v_ust_tank;
select count(*) from az_ust.v_ust_tank;
--29853

--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/

drop view az_ust.v_ust_tank_substance

create or replace view az_ust.v_ust_tank_substance as 
select distinct 
	"FacilityID"::character varying(50) as facility_id, 
	"TankName"::integer as tank_id,
	sx.substance_id as substance_id
from az_ust.ust_compartment x 
	left join az_ust.v_substance_xwalk sx on x."CompartmentSubstanceStored" = sx.organization_value
where x."CompartmentSubstanceStored" is not null; 

select * from az_ust.v_substance_xwalk;

select * from az_ust.v_ust_tank_substance;
select count(*) from az_ust.v_ust_tank_substance;
--30602

select * from ust_tank_substance;


select * from az_ust.v_substance_xwalk;


--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_compartment'
order by column_sort_order;

/* be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
NOTE: compartment_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the compartment, you must generate one. 
      In this case, the state does not store compartment data, so we will generate the compartment ID
      Prefix any tables you create in the state schema that did not come from the source data with "erg_"! */
drop table  az_ust.erg_compartment;

create table az_ust.erg_compartment (facility_id varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);
insert into az_ust.erg_compartment (facility_id, tank_id, compartment_name)
select distinct "FacilityID"::varchar, "TankName"::int, "CompartmentName" 
from az_ust.ust_compartment;

drop view az_ust.v_ust_compartment;

create or replace view az_ust.v_ust_compartment as 
select distinct 
	"FacilityID"::character varying(50) as facility_id, 
	"TankName"::integer as tank_id,
	compartment_id,
	"CompartmentName"::character varying(50) as compartment_name,
	compartment_status_id as compartment_status_id,
	"CompartmentCapacityGallons"::integer as compartment_capacity_gallons,
	"OverfillPreventionBallFloatValve"::character varying(7) as overfill_prevention_ball_float_valve,
	"OverfillPreventionFlowShutoffDevice"::character varying(7) as overfill_prevention_flow_shutoff_device,
	"OverfillPreventionHighLevelAlarm"::character varying(7) as overfill_prevention_high_level_alarm,
	"OverfillPreventionOther"::character varying(7) as overfill_prevention_other,
	"OverfillPreventionUnknown"::character varying(7) as overfill_prevention_unknown,
	"OverfillPreventionNotRequired"::character varying(7) as overfill_prevention_not_required,
	"SpillBucketInstalled"::character varying(3) as spill_bucket_installed,
	"ConcreteBermInstalled"::character varying(3) as concrete_berm_installed,
	"SpillPreventionOther"::character varying(3) as spill_prevention_other,
	"SpillPreventionNotRequired"::character varying(3) as spill_prevention_not_required,
	"TankInterstitialMonitoring"::character varying(7) as tank_interstitial_monitoring,
	"TankAutomaticTankGaugingReleaseDetection"::character varying(7) as tank_automatic_tank_gauging_release_detection,
	"AutomaticTankGaugingContinuousLeakDetection"::character varying(7) as automatic_tank_gauging_continuous_leak_detection,
	"TankManualTankGauging"::character varying(7) as tank_manual_tank_gauging,
	"TankStatisticalInventoryReconciliation"::character varying(7) as tank_statistical_inventory_reconciliation,
	"TankTightnessTesting"::character varying(7) as tank_tightness_testing,
	"TankInventoryControl"::character varying(7) as tank_inventory_control,
	"TankGroundwaterMonitoring"::character varying(7) as tank_groundwater_monitoring,
	"TankVaporMonitoring"::character varying(7) as tank_vapor_monitoring,
	"TankSubpartKTightnessTesting"::character varying(7) as tank_subpart_k_tightness_testing,
	"TankSubpartKOther"::character varying(7) as tank_subpart_k_other,
	"TankOtherReleaseDetection"::character varying(7) as tank_other_release_detection
from az_ust.ust_compartment  x 
	join az_ust.erg_compartment c on x."FacilityID" = c.facility_id and x."TankName"::int = c.tank_id and x."CompartmentName" = c.compartment_name
	 left join az_ust.v_compartment_status_xwalk cx on x."CompartmentStatus" = cx.organization_value;
	
	
select * from az_ust.v_ust_compartment order by 1, 2, 3;
select count(*) from az_ust.v_ust_compartment;
--30793

--------------------------------------------------------------------------------------------------------------------------
--ust_compartment_substance 

/*
If the state reports substances at the compartment level OR you can 
establish a one-to-one relationship between substance and compartment 
(for example, if the state considers all compartments to be unique 
tanks and only has one substance per tank), you must populate table 
ust_compartment_substance. 
In the case of AZ, they don't report at the compartment level and have
a one-to-many relationship between tanks and substances. 
*/
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_compartment_substance'
order by column_sort_order;

drop view az_ust.v_ust_compartment_substance

create or replace view az_ust.v_ust_compartment_substance as 
select distinct 
	"FacilityID"::character varying(50) as facility_id, 
	"TankName"::integer as tank_id,
	compartment_id,
	substance_id,
	organization_value as substance_comment
from az_ust.ust_compartment x 
	join az_ust.erg_compartment c on x."FacilityID" = c.facility_id and x."TankName"::int = c.tank_id and x."CompartmentName" = c.compartment_name
	left join az_ust.v_substance_xwalk sx on x."CompartmentSubstanceStored" = sx.organization_value
	where x."CompartmentSubstanceStored" is not null; 


select * from az_ust.v_substance_xwalk 

select * from  az_ust.v_ust_compartment_substance
where facility_id = '0-000066' and tank_id = 8 

select * from az_ust.ust_compartment where "FacilityID" =  '0-000066' and "TankName" = '8'

select * from az_ust.v_ust_compartment_substance order by 1, 2, 3;
select count(*) from az_ust.v_ust_compartment_substance;
--30745

select * from ust_compartment_substance 

--------------------------------------------------------------------------------------------------------------------------
--ust_piping
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_piping'
order by column_sort_order;


drop table  az_ust.erg_piping;
create table az_ust.erg_piping (facility_id varchar(50), tank_id int, compartment_id int, compartment_name varchar(50), piping_id int generated always as identity);
insert into az_ust.erg_piping (facility_id, tank_id, compartment_id, compartment_name)
select distinct "FacilityID", tank_id, compartment_id, "CompartmentName"
from az_ust.ust_piping a join az_ust.erg_compartment b on a."FacilityID" = b.facility_id 
	and a."TankName"::int = b.tank_id and a."CompartmentName" = b.compartment_name;

select * from  az_ust.erg_piping ;

drop view  az_ust.v_ust_piping

select * from information_schema.columns where table_schema = 'public'
and table_name = 'ust_piping'

create or replace view az_ust.v_ust_piping as 
select distinct 
	"FacilityID"::character varying(50) as facility_id, 
	"TankName"::integer as tank_id,
	compartment_id,
	piping_id::varchar(50) as piping_id,
	piping_style_id as piping_style_id,
	"SafeSuction"::character varying(7) as safe_suction,
	"AmericanSuction"::character varying(7) as american_suction,
	"HighPressureOrBulkPiping"::character varying(7) as high_pressure_or_bulk_piping,
	"PipingMaterialFRP"::character varying(3) as piping_material_frp,
	"PipingMaterialGalSteel"::character varying(3) as piping_material_gal_steel,
	"PipingMaterialStainlessSteel"::character varying(3) as piping_material_stainless_steel,
	"PipingMaterialSteel"::character varying(3) as piping_material_steel,
	"PipingMaterialCopper"::character varying(3) as piping_material_copper,
	"PipingMaterialFlex"::character varying(3) as piping_material_flex,
	"PipingMaterialNoPiping"::character varying(3) as piping_material_no_piping,
	"PipingMaterialOther"::character varying(3) as piping_material_other,
	"PipingMaterialUnknown"::character varying(3) as piping_material_unknown,
	"PipingFlexConnector"::character varying(7) as piping_flex_connector,
	"PipingCorrosionProtectionSacrificialAnode"::character varying(7) as piping_corrosion_protection_sacrificial_anode,
	"PipingCorrosionProtectionImpressedCurrent"::character varying(7) as piping_corrosion_protection_impressed_current,
	"PipingCorrosionProtectionCathodicNotRequired"::character varying(7) as piping_corrosion_protection_cathodic_not_required,
	"PipingCorrosionProtectionOther"::character varying(7) as piping_corrosion_protection_other,
	"PipingCorrosionProtectionUnknown"::character varying(7) as piping_corrosion_protection_unknown,
	"PipingLineLeakDetector"::character varying(7) as piping_line_leak_detector,
	"PipingAutomatedIntersticialMonitoring"::character varying(7) as piping_automated_intersticial_monitoring,
	"PipingLineTestAnnual"::character varying(7) as piping_line_test_annual,
	"PipingLineTest3yr"::character varying(7) as piping_line_test3yr,
	"PipingGroundwaterMonitoring"::character varying(7) as piping_groundwater_monitoring,
	"PipingVaporMonitoring"::character varying(7) as piping_vapor_monitoring,
	"PipingInterstitialMonitoring"::character varying(7) as piping_interstitial_monitoring,
	"PipingStatisticalInventoryReconciliation"::character varying(7) as piping_statistical_inventory_reconciliation,
	"PipingReleaseDetectionOther"::character varying(7) as piping_release_detection_other,
	"PipingSubpartKLineTest"::character varying(7) as piping_subpart_k_line_test,
	"PipingSubpartKOther"::character varying(7) as piping_subpart_k_other,
	"PipeTankTopSump"::character varying(7) as pipe_tank_top_sump,
	piping_wall_type_id as piping_wall_type_id,
	"PipeTrenchLiner"::character varying(7) as pipe_trench_liner,
	"PipeSecondaryContainmentOther"::character varying(7) as pipe_secondary_containment_other,
	"PipeSecondaryContainmentUnknown"::character varying(7) as pipe_secondary_containment_unknown
from az_ust.ust_piping x 
	left join az_ust.erg_piping p on x."FacilityID" = p.facility_id and x."TankName"::int = p.tank_id and x."CompartmentName" = p.compartment_name 
	left join az_ust.v_piping_style_xwalk ps on x."PipingStyle" = ps.organization_value
	left join az_ust.v_piping_wall_type_xwalk pw on x."PipingWallType" = pw.organization_value;
	
select * from az_ust.v_ust_piping order by 1, 2, 3;
select count(*) from az_ust.v_ust_piping;
--30793


--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 14
order by 1, 2;


delete from ust_element_mapping 
where ust_control_id = 14 
and epa_column_name like 'dispenser%';

delete from ust_element_mapping 
where ust_control_id = 14 
and epa_table_name = 'ust_compartment' 
and epa_column_name = 'spill_bucket_wall_type_id';

delete from ust_element_mapping 
where ust_control_id = 14 
and epa_table_name = 'ust_compartment_substance' 
and epa_column_name in ('compartment_id','tank_id');

delete from ust_element_mapping 
where ust_control_id = 14 
and epa_table_name = 'ust_facility' 
and epa_column_name in ('facility_type2');

delete from ust_element_mapping 
where ust_control_id = 14 
and epa_table_name = 'ust_piping' 
and epa_column_name in ('pipe_tank_top_sump_wall_type_id');

delete from ust_element_mapping 
where ust_control_id = 14 
and epa_table_name = 'ust_tank_substance' 
and epa_column_name in ('compartment_substance_casno');

delete from ust_element_mapping 
where ust_control_id = 14 
and epa_table_name = 'ust_tank' 
and epa_column_name in ('cert_of_installation');

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'ust' 
control_id = 14
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

This script will check the views you just created in the state schema for the following:
1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
   exist. 
2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
   every tank should have at least one compartment). 
3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
   to its parent tables. 
4) Missing required columns. 
5) Required columns that exist but contain null values. 
6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
   typos or other errors. 
7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
   Then check for bad joins.  
8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
   if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
   an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
9) Failed check constraints. 
10) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping 
   and ensure the epa_value exists in the associated lookup table. 

The script will also provide the counts of rows in az_ust.v_ust_facility, az_ust.v_ust_tank, az_ust.v_ust_compartment, and
   az_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'ust' 
control_id = 14
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 14 
order by sort_order;
/*
ust_facility				 9749
ust_tank					29853
ust_tank_substance			30519
ust_compartment				30793
ust_compartment_substance	30745
ust_piping					30793
*/

select * from ust_compartment_substance

select count(*) from v_ust_compartment_substance where ust_control_id = 14;
32232

select count(*) from ust_compartment_substance where ust_compartment_id in 
	(select ust_compartment_id from ust_compartment where ust_tank_id in 
		(select ust_tank_id from ust_tank where ust_facility_id in
			(select ust_facility_id from ust_facility where ust_control_id = 14)));
30745

select * from az_ust.v_ust_compartment_substance where  facility_id = '0-000138' and tank_id =  12;
1799	16	Diesel
8060	22	Premium Unleaded Gasoline

select * from v_ust_compartment_substance a where ust_control_id = 14 and not exists  
	(select 1 from  az_ust.v_ust_compartment_substance b join substances c on b.substance_id = c.substance_id
	where  a."FacilityID" = b.facility_id and a."TankID" = b.tank_id and a."CompartmentID" = b.compartment_id and a."Substance" = c.substance);
--these are wrong:
0-000138	12	12	1799	COMPARTMENT B	Ethanol blend gasoline (e-unknown)	
0-000138	12	12	8060	COMPARTMENT A	Diesel fuel (b-unknown)	

select * from ust_facility where facility_id = '0-000138'
557528

select * from ust_tank where ust_facility_id = 557528;
1924829

select * from ust_tank_substance where ust_tank_id = 1924829;
16
22

select * from ust_compartment where  ust_tank_id = 1924829;
1799	COMPARTMENT B
8060	COMPARTMENT A

select * from ust_compartment_substance where ust_compartment_id = 1081597;
select * from ust_compartment_substance where ust_compartment_id = 1081598;

select * from az_ust.ust_compartment where "FacilityID" = '0-000138' and "TankName" = '12'
COMPARTMENT A		Premium Unleaded Gasoline
COMPARTMENT B		Diesel

select count(*) from az_ust.ust_compartment 


select * From az_ust.erg_compartment
where  facility_id = '0-000138' and tank_id = 12;
0-000138	12	COMPARTMENT B	1799
0-000138	12	COMPARTMENT A	8060

select * from az_ust.v_ust_compartment where facility_id = '0-000138' and tank_id = 12;

select * from az_ust.ust_compartment where  "FacilityID"  = '0-000138' and "TankName" = '12'

--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 14
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 			# Set to False to export full template including mapping and reference tabs
template_only = False 		# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/


--------------------------------------------------------------------------------------------------------------------------
--export control table  summary

/*run script control_table_summary.py
set variables:
control_id = 14
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------

