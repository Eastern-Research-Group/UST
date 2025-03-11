------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'SD' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
ust_path = 'C:\Users\JChilton\repo\UST\ust\sql\states\SD\UST' 
overwrite_table = False 

OR:
manually in the database, create schema sd_ust if it does not exist, then manually upload the state data
*/

select * from public.ust_control 


insert into tanks ("FacilityAddress1Text",
"FacilityAddress2Text",
"FacilityCity",
"FacilityCounty",
"FacilityLatitudeValue",
"FacilityLongitudeValue",
"FacilityManagerName",
"FacilityMethodDescription",
"FacilityName",
"FacilityNumber",
"FacilityState",
"FacilityStatus",
"FacilityType",
"FacilityZipCode",
"OwnerAddress1",
"OwnerAddress2",
"OwnerCity",
"OwnerCounty",
"OwnerName",
"OwnerZip",
"StateName",
"StatusName",
"TankCapacityAmount",
"TankCompartmentNumber",
"TankConstructionName",
"TankEquipmentCitationIndicator",
"TankInspectedDate",
"TankInstalledYear",
"TankLeakDetectionCitationIndicator",
"TankLeakPreventionCitationIndicator",
"TankNewPipingInstalledYear",
"TankNumber",
"TankOldPipingMaterial",
"TankOldPipingMaterialRemovedYear",
"TankOverfillProtection",
"TankPipingMaterial",
"TankPipingReleaseDetection",
"TankPipingType",
"TankProduct",
"TankReleaseDetection",
"TankRemovedYear",
"TankSpillProtection" )
select "FacilityAddress1Text",
"FacilityAddress2Text",
"FacilityCity",
"FacilityCounty",
"FacilityLatitudeValue",
"FacilityLongitudeValue",
"FacilityManagerName",
"FacilityMethodDescription",
"FacilityName",
"FacilityNumber",
"FacilityState",
"FacilityStatus",
"FacilityType",
"FacilityZipCode",
"OwnerAddress1",
"OwnerAddress2",
"OwnerCity",
"OwnerCounty",
"OwnerName",
"OwnerZip",
"StateName",
"StatusName",
"TankCapacityAmount",
"TankCompartmentNumber",
"TankConstructionName",
"TankEquipmentCitationIndicator",
"TankInspectedDate",
"TankInstalledYear",
"TankLeakDetectionCitationIndicator",
"TankLeakPreventionCitationIndicator",
"TankNewPipingInstalledYear",
"TankNumber",
"TankOldPipingMaterial",
"TankOldPipingMaterialRemovedYear",
"TankOverfillProtection",
"TankPipingMaterial",
"TankPipingReleaseDetection",
"TankPipingType",
"TankProduct",
"TankReleaseDetection",
"TankRemovedYear",
"TankSpillProtection" from "Tanks-8_14_2024(62-00010)_(1)"  where "FacilityNumber"= '62-00010';

select * from tanks where "FacilityNumber"= '62-00010';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


select * from ust_element_mapping where ust_control_id = 8 ;

select * from ust_element_mapping where ust_control_id = 9 and ust_element_mapping_id='722'; --SD; merged VA in by accident




select * from ust_element_mapping where ust_control_id = 8 and ust_element_mapping_id='772'; --VA



select * from ust_element_value_mapping where ust_element_mapping_id=772;


update ust_element_value_mapping set ust_element_mapping_id = 772
where  ust_element_mapping_id=722
and ust_element_value_mapping_id ::int < 500;

select * from ust_element_value_mapping where ust_element_mapping_id=722 and ust_element_value_mapping_id ::int < 500;

select * from substances where lower(substance) like '%used%'

select * from public.ust_control where ust_control_id = 9;

drop table tanks cascade;

ALTER TABLE "Tanks-6_27_2024" RENAME TO sd_ust.tanks; 

create index tanks_idx on sd_ust.tanks ( "FacilityNumber" );
create index tanks_idx1 on sd_ust.tanks ( "FacilityNumber", "TankNumber" );
create index tanks_idx2 on sd_ust.tanks ( "TankConstructionName" );
create index tanks_idx3 on sd_ust.tanks ( "StatusName" );

analyze tanks;

--remove a few records where their columns aren't lined up properly so removed them for now, I put a comment to the state about these records to see how to handle
delete from sd_ust."tanks" where "Unnamed: 42" is not null;

--clean up some duplicates causing problems
delete  from tanks where "FacilityNumber" in ('27-00027','30-00030') and "FacilityLatitudeValue" is null;
delete from tanks where "FacilityNumber" in ('34-00004','37-00014') and "FacilityLatitudeValue" ='42';

--remove some bad date data
update tanks 
set "TankInstalledYear" = null
where "TankInstalledYear"  in ('0','8','9','10','64','11');

--remove padding on IDs
update tanks 
set "FacilityNumber" = trim("FacilityNumber");

--remove some bad tank data
delete from tanks where tanks."TankNumber" is null and "FacilityType" ='UST';

--Get an overview of what the state's data looks like. In this case, we have two tables 
select table_name from information_schema.tables 
where table_schema = 'sd_ust' order by 1;
/*
tanks
*/


select * from tanks;

select distinct "TankRemovedYear" from tanks order by 1;


tank_installation_date
select * from public.ust_tank order by tank_installation_date ;

--it might be helpful to create some indexes on the state data 
--(you can also do this as you go along in the processing and find the need to do do)
create index facilities_facid_idx on sd_ust.tanks("FacilityNumber");

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--get the EPA tables that we need to populate
select table_name
from public.ust_element_table_sort_order
order by sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
ust_compartment_substance
ust_piping
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Start with the first table, ust_facility 
--get the EPA columns we need to look for in the state data 
select database_column_name 
from ust_elements a join ust_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_facility' 
order by sort_order;
/*
facility_id
facility_name
owner_type_id
facility_type1
facility_type2
facility_address1
facility_address2
facility_city
facility_county
facility_zip_code
facility_state
facility_epa_region
facility_tribal_site
facility_tribe
facility_latitude
facility_longitude
coordinate_source_id
facility_owner_company_name
facility_operator_company_name
financial_responsibility_obtained
financial_responsibility_bond_rating_test
financial_responsibility_commercial_insurance
financial_responsibility_guarantee
financial_responsibility_letter_of_credit
financial_responsibility_local_government_financial_test
financial_responsibility_risk_retention_group
financial_responsibility_self_insurance_financial_test
financial_responsibility_state_fund
financial_responsibility_surety_bond
financial_responsibility_trust_fund
financial_responsibility_other_method
ust_reported_release
associated_ust_release_id
dispenser_id
dispenser_udc
dispenser_udc_wall_type
*/



--run queries looking for lookup table values 
select distinct "StatusName" from SD_ust.tanks;
select distinct "TankProduct" from SD_ust.tanks;




------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Generate SQL statements to do the inserts into ust_element_mapping. 
Run the query below, paste the results into your console, then do a global replace of 9 for the ust_control_id 
Next, go through each generated SQL statement and do the following:
If there is no matching column in the state's data, delete the SQL statement 
If there is a matching column in the state's data, update the tanks and ORG_COL_NAME variables to match the state's data 
If you have questions or comments, replace the "null" with your comment. 
After you have updated all the SQL statements, run them to update the database. 
*/
select * from public.v_ust_element_summary_sql;

/*you can run this SQL so you can copy and paste table and column names into the SQL statements generated by the query above
select table_name, column_name from information_schema.columns 
where table_schema = 'sd_ust' order by table_name, ordinal_position;
*/
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_id','tanks','FacilityNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_name','tanks','FacilityName',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_address1','tanks','FacilityAddress1Text',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_address2','tanks','FacilityAddress2Text',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_city','tanks','FacilityCity',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_county','tanks','FacilityCounty',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_zip_code','tanks','FacilityZipCode',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_state','tanks','FacilityState',null);
select * from ust_facility;
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_latitude','tanks','FacilityLatitudeValue',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_longitude','tanks','FacilityLongitudeValue',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','coordinate_source_id','tanks','FacilityMethodDescription',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_facility','facility_owner_company_name','tanks','OwnerName',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','facility_id','tanks','FacilityNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_id','tanks','TankNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_name','tanks','TankNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_location_id','tanks','TankPipingType',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_status_id','tanks','StatusName',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_closure_date','tanks','TankRemovedYear',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_installation_date','tanks','TankInstalledYear',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','compartmentalized_ust','tanks','TankCompartmentNumber','if > 1 then Yes');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','number_of_compartments','tanks','TankCompartmentNumber','max of TankCompartmentNumber for the facility + tank');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_material_description_id','tanks','TankConstructionName',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_secondary_containment_id','tanks','TankConstructionName',null);

select * from public.tank_secondary_containments tsc 

select * from ust_element_mapping where ust_element_mapping_id =
727

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_corrosion_protection_sacrificial_anode','tanks','TankConstructionName','where TankConstructionName in (DW/STIP3,DW/STIP3/Compart,STIP3,STIP3/Compart)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_corrosion_protection_impressed_current','tanks','TankConstructionName','where TankConstructionName = Lined w/ Impressed, Steel/Impressed');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank','tank_corrosion_protection_interior_lining','tanks','TankConstructionName','where TankConstructionName in (Lined Interior, Lined w/ Impressed,Painted Steel w/ Lining)');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank_substance','facility_id','tanks','FacilityNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_tank_substance','substance_id','tanks','TankProduct',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','facility_id','tanks','FacilityNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','compartment_name','tanks','TankCompartmentNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','compartment_capacity_gallons','tanks','TankCapacityAmount',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','overfill_prevention_ball_float_valve','tanks','TankOverfillProtection',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','overfill_prevention_flow_shutoff_device','tanks','TankOverfillProtection',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','overfill_prevention_high_level_alarm','tanks','TankOverfillProtection',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','overfill_prevention_other','tanks','TankOverfillProtection',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','spill_bucket_installed','tanks','TankSpillProtection',null);


/*
 * case when "TankReleaseDetection" in ('Secondary Containment','Double Walled','Interstitial Monitoring','Concrete Vault') then 'Yes' end tank_interstitial_monitoring,
case when "TankReleaseDetection" in ('In-Tank Monitor','Automatic Tank Gauging') then 'Yes' end tank_automatic_tank_gauging_release_detection,
null automatic_tank_gauging_continuous_leak_detection,
case "TankReleaseDetection" when 'Manual Gauging' then 'Yes' end tank_manual_tank_gauging,
case "TankReleaseDetection" when 'S.I.R.' then 'Yes' end tank_statistical_inventory_reconciliation,
case "TankReleaseDetection" when 'Tightness Testing' then 'Yes' end tank_tightness_testing,
case "TankReleaseDetection" when 'Inventory Control' then 'Yes' end tank_inventory_control,
case "TankReleaseDetection" when 'Groundwater Monitoring' then 'Yes' end tank_groundwater_monitoring,
case "TankReleaseDetection" when 'Other' then 'Yes' end tank_other_release_detection,
case "TankReleaseDetection" when 'Vapor Monitoring' then 'Yes' end tank_vapor_monitoring,
*/

delete from ust_element_mapping where ust_control_id=9 and organization_column_name='TankReleaseDetection';
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_interstitial_monitoring','tanks','TankReleaseDetection','where TankReleaseDetection in (TankInterstitialMonitoring,Double Walled,Concrete Vault)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_automatic_tank_gauging_release_detection','tanks','TankReleaseDetection','where TankReleaseDetection in (Automatic Tank Gauging, In-Tank Monitor)');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_manual_tank_gauging','tanks','TankReleaseDetection','where TankReleaseDetection = Manual Gauging ');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_statistical_inventory_reconciliation','tanks','TankReleaseDetection','where TankReleaseDetection = S.I.R. ');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_tightness_testing','tanks','TankReleaseDetection','where TankReleaseDetection = TankTightnessTesting');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_inventory_control','tanks','TankReleaseDetection','where TankReleaseDetection = Inventory Control');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_groundwater_monitoring','tanks','TankReleaseDetection','where TankReleaseDetection = Groundwater Monitoring');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_vapor_monitoring','tanks','TankReleaseDetection','where TankReleaseDetection = Vapor Monitoring ');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_compartment','tank_other_release_detection','tanks','TankReleaseDetection','where TankReleaseDetection = Other');


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','facility_id','tanks','FacilityNumber',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_style_id','tanks','TankPipingType',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','safe_suction','tanks','TankPipingType',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','american_suction','tanks','TankPipingType',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','high_pressure_or_bulk_piping','tanks','TankPipingType',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_frp','tanks','TankPipingMaterial','where TankPipingMaterial like %Fiberglass%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_gal_steel','tanks','TankPipingMaterial','where TankPipingMaterial = Galvanized Steel');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_stainless_steel','tanks','TankPipingMaterial','where TankPipingMaterial = PipingMaterialStainlessSteel');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_steel','tanks','TankPipingMaterial','where TankPipingMaterial in (Black Steel,Cath. Protection,Cath. Steel,Coated Steel,Steel,Steel/Aboveground,Steel/Cont');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_copper','tanks','TankPipingMaterial','where TankPipingMaterial = Copper');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_flex','tanks','TankPipingMaterial','where TankPipingMaterial in (DW Ameron,DW APT,DW Environ,DW Flex,DW MarinaFlex,DW OPW,DW Poly,SW Ameron,SW APT,SW Flex,Total Containment)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_no_piping','tanks','TankPipingMaterial','where TankPipingMaterial in (Not Applicable, PipingMaterialNoPiping)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_material_unknown','tanks','TankPipingMaterial','where TankPipingMaterial =Unknown');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_corrosion_protection_sacrificial_anode','tanks','TankPipingMaterial','where TankPipingMaterial in (Cath. Protection,Cath. Steel)');

select  * from tanks order by 1;
select * from tanks;



select * from ust_element_mapping where ust_control_id = 9 and organization_column_name = 'TankPipingReleaseDetection';

select distinct "TankPipingReleaseDetection"  from "tanks"
order by 1;

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_comment','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection  in (None, Not Applicable, Unknown)');


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_line_leak_detector','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection  in (Electronic LLD, Campo/Miller LLD,PPM 4000,Incon LLD,Mechanical LLD)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','pipe_secondary_containment_other','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection = Concrete Containment');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,organization_comments) values (9,'ust_piping','piping_release_detection_other','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection = Double Walled','The one suggested EPA value which that might not be appropriate would be the “Double Walled” product piping release detection description.  We have examples of tanks installed in the early 2000’s and 1990s that have double walled piping, but would not be subject to interstitial monitoring. In this case we suggest that for “Double Walled”, the PipingReleaseDetectionOther suggested value may be more appropriate.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,organization_comments) values (9,'ust_piping','piping_interstitial_monitoring','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection in (Secondary Containment,Sump Sensor )','SD confirmed Secondary Containment is accurate.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_groundwater_monitoring','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection = Groundwater Monitoring');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_statistical_inventory_reconciliation','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection = S.I.R.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_piping','piping_vapor_monitoring','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection = Vapor Monitoring');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,organization_comments) values (9,'ust_piping','piping_line_test_annual','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection = Tightness Testing','Confirmed by SD');


select piping_line_test_annual  from public.ust_piping;

select distinct "TankPipingReleaseDetection" from tanks order by 1;
select * from ust_piping;
select * from ust_element_mapping where epa_column_name = 'piping_wall_type_id' and ust_control_id=9;

update ust_element_mapping 
set organization_column_name = 'TankPipingMaterial'
where epa_column_name = 'piping_wall_type_id' and ust_control_id=9;


select distinct "TankPipingReleaseDetection" from tanks order by 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name
from v_ust_available_mapping 
where ust_control_id = 9
order by table_sort_order, column_sort_order;
/*
ust_facility	coordinate_source_id
ust_tank	tank_location_id
ust_tank	tank_status_id
ust_tank	tank_material_description_id
ust_tank_substance	substance_id
ust_piping	piping_style_id
ust_piping	piping_wall_type_id
*/

/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select epa_table_name, epa_column_name 
from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_ust_needed_mapping 
	where ust_control_id = 9 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
/*
ust_facility	coordinate_source_id
ust_tank	tank_location_id
ust_tank	tank_status_id
ust_tank	tank_material_description_id
ust_tank_substance	substance_id
ust_piping	piping_style_id
ust_piping	piping_wall_type_id
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from sd_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 9 and epa_column_name = 'facility_state';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "FacilityState" from sd_ust."tanks" order by 1;
/*
SOUTH DAKOTA
*/

--in this case there is only one value per row so we can begin mapping 

/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'facility_state';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 714 || ', ''' || "FacilityState" || ''', '''', null);'
from sd_ust."tanks" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (714, 'SOUTH DAKOTA', 'SD', null);

select * from ust_element_value_mapping where ust_element_mapping_id= 714;

--coordinate source
select distinct 'select distinct "' || organization_column_name || '" from sd_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 9 and epa_column_name = 'coordinate_source_id';

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!

select * from archive.v_ust_element_mapping 
where lower(element_name) like lower('%coordinate%');


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'coordinate_source_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 717 || ', ''' || "FacilityMethodDescription" || ''', '''', null);'
from sd_ust."tanks" order by 1;


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, ' MAPN2724 ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, '0', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'ARCGIS', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'ARCMAP', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'ArcMap    ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'ARCMAP    ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'DOQN8324  ', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GIS', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'gis       ', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GIS       ', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GIS ARCMAP', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GIS MAP', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'Gis map   ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GIS MAP   ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GOOD', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPAN83NA', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPS', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPS       ', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPS N83 24', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPS N83NA', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPS Unit  ', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSN83 NA', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSN83NA', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSN83NA  ', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSN84NA', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSN85NA', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSOTHNA', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSOTHNA  ', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'GPSUNKNA', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'LAT & LONG ARE ', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAP', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'map       ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'Map       ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAP       ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAP GIS   ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAP N83 24', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAP2724', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAP2724   ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAPN2724', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAPN2724  ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAPN274', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MapN27Othe', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAPN83 24', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAPN83 24 ', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAPN83OTHE', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'MAPNA83OTH', 'Map interpolation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (717, 'NAD27', 'Other', null);


--substance id

select distinct 'select distinct "' || organization_column_name || '" from sd_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 9 and epa_column_name = 'substance_id';

select distinct "TankProduct" from sd_ust."tanks" order by 1;

select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%substance_id%')
order by 1, 2;

select * from archive.v_ust_element_mapping 
where lower(element_name) like lower('%substance_id%');

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'substance_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 729 || ', ''' || "TankProduct" || ''', '''', null);'
from sd_ust."tanks" order by 1;


select * from substances order by 2;


select * from substances where lower(substance) like '%water%';


select * From ust_element_value_mapping where ust_element_mapping_id = '729' and organization_value ='Soy Biodiesel'; 

update ust_element_value_mapping
set epa_value = 'Diesel fuel (b-unknown)',programmer_comments=null
where ust_element_value_mapping_id = 504;

select state_value,epa_value 
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%substance%')
and lower(state_value) like '%water%';
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, '10% Ethanol', 'Gasoline E-10 (E1-E10)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'A.T. Fluid', 'Petroleum products', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Acetone', 'Solvent', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Additive', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Animal Fat/Vegetable Oil', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Anti Freeze', 'Antifreeze', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Asphalt', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Aviation Gas', 'Aviation gasoline', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Biodiesel', 'Biofuel/bioheat', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Caustic Soda', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Cleaning Solvent', 'Solvent', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Denaturant', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Denatured Ethanol', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Diesel/Diesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Diesel/Diesel clear', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Diesel/E85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Dye', 'Off-road diesel/dyed diesel', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'E-10%20%30%', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'E-15', 'Gasoline E-15 (E-11-E15)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'E-30', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'E-85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Empty', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Ethanol', 'Ethanol blend gasoline (e-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Fuel Oil', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Gas/Diesel', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Gas/E85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Gas/Gas', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Gasoline', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Hazardous Substance', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Heating Oil', 'Heating/fuel oil # unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Hexane', 'Solvent', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Hydraulic Fluid', 'Hydraulic oil', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Jet Fuel A', 'Jet fuel A', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'JP-10', 'Unknown aviation gas or jet fuel', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'JP-8', 'Unknown aviation gas or jet fuel', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Kerosene', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Lube Oil', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'M85', ' E-85/Flex Fuel (E51-E83)', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Magnesium Chloride', 'Other',  'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Methanol', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Mineral Oil', 'Solvent', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Mixture', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Motor Oil', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Paradyne', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Petroleum', 'Petroleum product', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Phosphoric acid', 'Hazardous substance', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Propylene Glycol', 'Solvent', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Quaternary Ammonium Compounds', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Road Oil', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Soap and Water', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Sodium hypochlorite', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Sodium Xylenesulfonate', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Soy Biodiesel', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Spent Solvent', 'Solvent', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Sulfuric Acid', 'Hazardous Substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Transmission Fluid', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Unknown', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Used Antifreeze', 'Antifreeze', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Used Oil', 'Used oil/waste oil', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Water', 'Other', 'Please verify.');


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (729, 'Hydraulic Fluid', 'Hydraulic oil', null);

update ust_element_value_mapping
set epa_value = 'Hydraulic oil'
where organization_value = 'Hydraulic Fluid' and  ust_element_mapping_id = 729;
--piping_style_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'piping_style_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 749 || ', ''' || "TankPipingType" || ''', '''', null);'
from sd_ust."tanks" order by 1;

select * from piping_styles;


select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%pip%style%')
and lower(state_Value) like '%siphon%'
order by 1, 2;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Above & Underground', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Aboveground', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Gravity Fed', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Gravity Feed', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Pressure', 'Pressure', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Safe Suction', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Siphon', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Suction', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Suction - Valve', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Underground', 'Other', 'Please verify.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (749, 'Unknown', 'Unknown', null);


--piping_wall_type_id


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'piping_wall_type_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 767 || ', ''' || "TankPipingMaterial" || ''', '''', null);'
from sd_ust."tanks" order by 1;

select * from piping_wall_types;
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW Ameron', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW APT', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW Environ', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW Fiberglass', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW Flex', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW MarinaFlex', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW OPW', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'DW Poly', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Fiberglass', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Fuel Hose', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Galvanized Steel', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Hydraulic Hose', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Plastic', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'PVC', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Rubber', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Stainless Steel', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Steel', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Steel/Aboveground', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Steel/Cont', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'SW Ameron', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'SW APT', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'SW Environ', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'SW Flex', 'Single walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Total Containment', 'Double walled', null);


select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%pip%wall%')
and lower(state_Value) like '%miller%'
order by 1, 2;
--other data in this field are for different fields
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (767, 'Double Walled', 'Double walled', null);



--tank_secondary_containment_id


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'tank_secondary_containment_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1221 || ', ''' || "TankConstructionName" || ''', '''', null);'
from sd_ust."tanks" where "FacilityType"='UST' order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'ACT-100-U', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Composite', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'DW/Composite', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'DW/Composite/Compart', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'DW/Fbrgls/Compart', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'DW/Fiberglass', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'DW/Steel', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'DW/STIP3', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'DW/STIP3/Compart', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Fiberglass', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Fiberglass/compart', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Lined Interior', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Lined w/ Impressed', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Perma Tank', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Steel', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Steel/Impressed', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'STIP3', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'STIP3/Compart', 'Single wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Total Containment', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Total Containment/Compart', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1221, 'Unknown', 'Single wall', null);



--tank_material_description_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'tank_material_description_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 727 || ', ''' || "TankConstructionName" || ''', '''', null);'
from sd_ust."tanks"  where "FacilityType" = 'UST' order by 1;

select "TankConstructionName" from  sd_ust."tanks" where "FacilityType" = 'UST';


select * from tank_material_descriptions  ;

select distinct state_value, epa_value,element_name
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%mat%')
and lower(state_Value) like '%miller%'
order by 1, 2;

select * From ust_element_value_mapping where ust_element_mapping_id = '727' and organization_value ='Total Containment/Compart'; 

update ust_element_value_mapping
set epa_value = 'Jacketed steel',programmer_comments=null
where ust_element_value_mapping_id = 575;

delete from ust_element_value_mapping where ust_element_mapping_id = 727;


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'ACT-100-U', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Composite', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'DW/Composite', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'DW/Composite/Compart', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'DW/Fbrgls/Compart', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'DW/Fiberglass', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'DW/Steel', 'Steel (NEC)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'DW/STIP3', 'Coated and cathodically protected steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'DW/STIP3/Compart', 'Coated and cathodically protected steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Fiberglass', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Fiberglass/compart', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Lined Interior', 'Steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Lined w/ Impressed', 'Steel (NEC)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Perma Tank', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Steel', 'Steel (NEC)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Steel/Impressed', 'Steel (NEC)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'STIP3', 'Coated and cathodically protected steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'STIP3/Compart', 'Coated and cathodically protected steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Total Containment', 'Jacketed steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Total Containment/Compart', 'Jacketed steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Unknown', 'Unknown', null);

update ust_element_value_mapping
set epa_value = 'Steel (NEC)'
where ust_element_mapping_id = 727
and organization_value = 'Lined Interior';

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (727, 'Lined Interior', 'Steel', null);


--tank_status_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 9 and epa_column_name = 'tank_status_id';
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 722 || ', ''' || "StatusName" || ''', '''', null);'
from sd_ust."tanks" order by 1;

select * from tank_statuses;



insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (722, 'Abandoned in Place', 'Abandoned', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (722, 'Current', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (722, 'Permanently Out Of Use', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (722, 'Removed', 'Closed (removed from ground)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (722, 'Temporarily Out Of Use', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (722, 'Temporary Closure', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (722, 'Unknown', 'Unknown', null);


select * from ust_element_value_mapping where epa_value in ('Other','Petroleum products','Hazardous Substance',' E-85/Flex Fuel (E51-E83)') and ust_element_mapping_id = '729';

update ust_element_value_mapping
set epa_value = 'E-85/Flex Fuel (E51-E83)'
where ust_element_mapping_id = '729'
and epa_value = ' E-85/Flex Fuel (E51-E83)';
 E-85/Flex Fuel (E51-E83)

select * from substances where substance like '%85%';

substances	 E-85/Flex Fuel (E51-E83)
substances	Hazardous Substance
substances	Other
substances	Petroleum products
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 9 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_ust_bad_mapping 
where ust_control_id = 9 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 


facility_state
database_lookup_table = states
database_lookup_column = state
view_name = sd_ust.v_state_xwalk

select epa_column_name, organization_table_name, organization_column_name,
					database_lookup_table, database_lookup_column 
			from {pop_view_name} 
			where {control_id_col} = %s and database_lookup_table is not null
			order by table_sort_order, column_sort_order
			
select * from states;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'sd_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_coordinate_source_xwalk
v_piping_style_xwalk
v_piping_wall_type_xwalk
v_state_xwalk
v_substance_xwalk
v_tank_material_description_xwalk
v_tank_status_xwalk
*/

--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 9
order by table_sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 9;

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
where ust_control_id = 9 and epa_table_name = 'ust_facility'
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

create or replace view sd_ust.v_ust_facility as 
select distinct 
		"FacilityNumber"::character varying(50) as facility_id,
"FacilityName"::character varying(100) as facility_name,
"FacilityAddress1Text"::character varying(100) as facility_address1,
"FacilityAddress2Text"::character varying(100) as facility_address2,
"FacilityCity"::character varying(100) as facility_city,
"FacilityCounty"::character varying(100) as facility_county,
"FacilityZipCode"::character varying(10) as facility_zip_code,
'SD' as facility_state,
"FacilityLatitudeValue"::double precision as facility_latitude,
"FacilityLongitudeValue"::double precision as facility_longitude,
"OwnerName"::character varying(100) as facility_owner_company_name,
8 as facility_epa_region,
coordinate_source_id 
from sd_ust.tanks x 
left join sd_ust.v_coordinate_source_xwalk cs on x."FacilityMethodDescription" = cs.organization_value 
where "FacilityType" = 'UST';


select facility_id from v_ust_facility group by facility_id having count(*) > 1;

select * from v_coordinate_source_xwalk;

--review: 
select * from sd_ust.v_ust_facility;
select count(*) from sd_ust.v_ust_facility;
--3274
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 9 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/




select distinct "TankInstalledYear" from  sd_ust.tanks where "TankInstalledYear" ='1899';

create or replace view sd_ust.v_ust_tank as 
select distinct 
"FacilityNumber"::character varying(50) as facility_id,
"TankNumber"::integer as tank_id,
"TankNumber"::character varying(50) as tank_name,
COALESCE (ts.tank_status_id,8) tank_status_id , 
case   when  "TankRemovedYear"  in ('04/10/1991','11/15/1989') then to_date("TankRemovedYear",'mm/dd/yyyy')   else to_date("TankRemovedYear"::varchar, 'yyyy') end as tank_closure_date,
case when "TankInstalledYear" = '1899' then null --remove placeholder values from 1899 per SD
else to_date("TankInstalledYear"::varchar, 'yyyy') end as tank_installation_date,
case when "TankCompartmentNumber" > 1 then 'Yes' else 'No' end as compartmentalized_ust,
getmaxcompartment("FacilityNumber","TankNumber") as number_of_compartments,
md.tank_material_description_id ,
case when "TankConstructionName" in ('DW/STIP3','DW/STIP3/Compart','STIP3','STIP3/Compart') then 'Yes' end tank_corrosion_protection_sacrificial_anode,
case when "TankConstructionName" in ('Lined w/ Impressed', 'Steel/Impressed') then 'Yes' end tank_corrosion_protection_impressed_current,
case when "TankConstructionName" in ('Lined Interior','Lined w/ Impressed','Painted Steel w/ Lining') then 'Yes' end tank_corrosion_protection_interior_lining,
sc.tank_secondary_containment_id as tank_secondary_containment_id
from sd_ust.tanks x 
left join sd_ust.v_tank_status_xwalk ts on x."StatusName" = ts.organization_value 
left join sd_ust.v_tank_material_description_xwalk md on x."TankConstructionName" = md.organization_value
left join sd_ust.v_tank_secondary_containment_xwalk sc on x."TankConstructionName" = sc.organization_value
where "FacilityType" = 'UST';

select count(*) from sd_ust.v_ust_tank;
--10649

--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 9 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;
/*
"tanks"	
"Substance"	
substance_id as substance_id,	
integer			
substances	
substance	
erg_substance_deagg	
Substance
*/

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/
create or replace view sd_ust.v_ust_tank_substance as 
select distinct 
	"FacilityNumber"::character varying(50) as facility_id,
	c.tank_id as tank_id,
	sx.substance_id as substance_id
from sd_ust.tanks x 
join sd_ust.v_ust_tank c on x."FacilityNumber" = c.facility_id  and x."TankNumber" = c.tank_name::int
left join sd_ust.v_substance_xwalk sx on x."TankProduct" = sx.organization_value
where x."TankProduct" is not null
and "FacilityType" = 'UST';


 

select count(*) from sd_ust.v_ust_tank_substance;
--10395


--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 9 and epa_table_name = 'ust_compartment'
order by column_sort_order;

/* be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
NOTE: compartment_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the compartment, you must generate one. 
      In this case, the state does not store compartment data, so we will generate the compartment ID
      Prefix any tables you create in the state schema that did not come from the source data with "erg_"! */

drop table sd_ust.erg_compartment;
create table sd_ust.erg_compartment (facility_id character varying(50), tank_id int, compartment_id int generated always as identity);
insert into sd_ust.erg_compartment (facility_id, tank_id)
select  facility_id,tank_id from sd_ust.v_ust_tank;

create or replace view sd_ust.v_ust_compartment as 
select distinct 
c.facility_id as facility_id,
c.tank_id,
c.compartment_id,
"TankCompartmentNumber"::character varying(50) as compartment_name,
"TankCapacityAmount"::integer as compartment_capacity_gallons,
case "TankOverfillProtection" when 'Ball Float Valves' then 'Yes' end overfill_prevention_ball_float_valve,
case "TankOverfillProtection" when 'Automatic Shutoff Device' then 'Yes' end overfill_prevention_flow_shutoff_device,
case "TankOverfillProtection" when 'Overfill Alarm' then 'Yes' end overfill_prevention_high_level_alarm,
case "TankOverfillProtection" when 'Other' then 'Yes' end overfill_prevention_other,
case "TankSpillProtection" when 'Spill Bucket' then 'Yes' end spill_bucket_installed,
case when "TankReleaseDetection" in ('Secondary Containment','Double Walled','Interstitial Monitoring','Concrete Vault') then 'Yes' end tank_interstitial_monitoring,
case when "TankReleaseDetection" in ('In-Tank Monitor','Automatic Tank Gauging') then 'Yes' end tank_automatic_tank_gauging_release_detection,
case "TankReleaseDetection" when 'Manual Gauging' then 'Yes' end tank_manual_tank_gauging,
case "TankReleaseDetection" when 'S.I.R.' then 'Yes' end tank_statistical_inventory_reconciliation,
case "TankReleaseDetection" when 'Tightness Testing' then 'Yes' end tank_tightness_testing,
case "TankReleaseDetection" when 'Inventory Control' then 'Yes' end tank_inventory_control,
case "TankReleaseDetection" when 'Groundwater Monitoring' then 'Yes' end tank_groundwater_monitoring,
case "TankReleaseDetection" when 'Other' then 'Yes' end tank_other_release_detection,
case "TankReleaseDetection" when 'Vapor Monitoring' then 'Yes' end tank_vapor_monitoring,
COALESCE (ts.tank_status_id,8) compartment_status_id 
from sd_ust.tanks x  
join sd_ust.erg_compartment c on x."FacilityNumber" = c.facility_id and x."TankNumber" = c.tank_id
left join sd_ust.v_tank_status_xwalk ts on x."StatusName" = ts.organization_value;

select * from v_ust_compartment;


select count(*) from v_ust_tank; 10645
select count(*) from v_ust_compartment;10647

select facility_id,tank_id
from  v_ust_compartment
where (facility_id,tank_id) not in (select facility_id,tank_id from v_ust_tank  )


--------------------------------------------------------------------------------------------------------------------------
--ust_piping

delete from sd_ust.erg_piping;

create table sd_ust.erg_piping (facility_id character varying(50), tank_id int, compartment_id int, piping_id int generated always as identity);
insert into sd_ust.erg_piping (facility_id, tank_id,compartment_id)
select facility_id,tank_id,compartment_id from sd_ust.v_ust_compartment;


select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 9 and epa_table_name = 'ust_piping'
order by column_sort_order;

drop view v_ust_piping;

create or replace view sd_ust.v_ust_piping as
select   distinct
c.piping_id::varchar(50) piping_id,
c.facility_id as facility_id,
c.tank_id,
c.compartment_id,
px.piping_style_id as piping_style_id,
case "TankPipingType" when 'Safe Suction' then 'Yes' end safe_suction,
case "TankPipingType" when 'Suction' then 'Yes' end american_suction,
case "TankPipingType" when 'Pressure' then 'Yes' end high_pressure_or_bulk_piping,
case  when  "TankPipingMaterial" like '%Fiberglass%' then 'Yes' end piping_material_frp,
case "TankPipingMaterial" when 'Galvanized Steel' then 'Yes' end piping_material_gal_steel,
case "TankPipingMaterial" when 'Stainless Steel' then 'Yes' end piping_material_stainless_steel,
case "TankPipingMaterial" when 'Copper' then 'Yes' end piping_material_copper,
case when "TankPipingMaterial" in ('None', 'Not Applicable') then 'Yes' end piping_material_no_piping,
case "TankPipingMaterial" when 'Unknown' then 'Yes' end piping_material_unknown,
case when "TankPipingMaterial" in ('Black Steel','Cath. Protection','Cath. Steel','Coated Steel','Steel','Steel/Aboveground','Steel/Cont') then 'Yes' end piping_material_steel,
case when "TankPipingMaterial" in ('DW Ameron','DW APT','DW Environ','DW Flex','DW MarinaFlex','DW OPW','DW Poly','SW Ameron','SW APT','SW Flex','Total Containment')  then 'Yes' end piping_material_flex,
case "TankPipingReleaseDetection" when 'Groundwater Monitoring' then 'Yes' end piping_groundwater_monitoring,
case "TankPipingReleaseDetection" when 'Vapor Monitoring' then 'Yes' end piping_vapor_monitoring,
case "TankPipingReleaseDetection" when 'S.I.R.' then 'Yes' end piping_statistical_inventory_reconciliation,
pwx.piping_wall_type_id as piping_wall_type_id,
case "TankPipingReleaseDetection" when 'Secondary Containment' then 'Yes' end pipe_secondary_containment_other,
case "TankPipingReleaseDetection" when 'Unknown' then 'Yes' end pipe_secondary_containment_unknown,
case when "TankPipingMaterial" in ('Cath. Protection','Cath. Steel') then 'Yes' end  piping_corrosion_protection_sacrificial_anode,
case when "TankPipingReleaseDetection" in ('None', 'Not Applicable', 'Unknown') then 'EPA has no acceptable mapping to the State Release Detection values for this piping data.' end piping_comment
from sd_ust.tanks x 
join sd_ust.erg_piping c on x."FacilityNumber" = c.facility_id  and x."TankNumber" = c.tank_id 
left join sd_ust.v_piping_style_xwalk px on x."TankProduct" = px.organization_value
left join sd_ust.v_piping_wall_type_xwalk pwx on x."TankProduct" = pwx.organization_value
where "FacilityType" = 'UST';


 values (9,'ust_piping','piping_comment','tanks','TankPipingReleaseDetection','where TankPipingReleaseDetection  in ()');



select * from sd_ust.v_ust_piping where piping_corrosion_protection_sacrificial_anode is not null;

select count(*) from sd_ust.v_ust_compartment;10647
select count(*) from sd_ust.v_ust_piping;10647



--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 9
order by 1, 2;

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'ust' 
control_id = 11
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

The script will also provide the counts of rows in sd_ust.v_ust_facility, sd_ust.v_ust_tank, sd_ust.v_ust_compartment, and
   sd_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */



--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'ust' 
control_id = 11
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 9 
order by sort_order;
/*
ust_facility	3270
ust_tank	10654
ust_tank_substance	10395
ust_compartment	10672
ust_piping	10680
*/


--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 9
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
control_id = 9
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------

