alter table permitted_ust_tanks rename column "CERSID TANKIDNUMBER" to "CERSID";
alter table permitted_ust_tanks rename column "UNKNOWN_COLUMN" to "TANKIDNUMBER";

create table substance_xwalk (ca_substance varchar(100), epa_substance varchar(100));
insert into substance_xwalk values ('CA Values','Mapping');
insert into substance_xwalk values ('12','Unknown');
insert into substance_xwalk values ('13','Unknown');
insert into substance_xwalk values ('14','Unknown');
insert into substance_xwalk values ('15','Unknown');
insert into substance_xwalk values ('Aviation Gas','Aviation gasoline');
insert into substance_xwalk values ('Diesel','Diesel fuel (b-unknown)');
insert into substance_xwalk values ('Ethanol','Other'); --are we sure about this??
insert into substance_xwalk values ('Jet Fuel','Unknown aviation gas or jet fuel');
insert into substance_xwalk values ('Midgraded Unleaded','Gasoline (unknown type)');
insert into substance_xwalk values ('Other Non-petroleum','Other');
insert into substance_xwalk values ('Other Petroleum','Petroleum products');
insert into substance_xwalk values ('Petroleum Blend Fuel','Petroleum products');
insert into substance_xwalk values ('Premium Unleaded','Gasoline (unknown type)');
insert into substance_xwalk values ('Regular Unleaded','Gasoline (unknown type)');
----------------------------------------------------------------------------------------------------------------------------------

select * from ust_element_db_mapping ;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'OwnerType', 'permitted_ust_tanks', 'OWNER_TYPE');

select * from ust_element_db_mapping order by 1 desc;

select distinct "OWNER_TYPE" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (152, ''' || "OWNER_TYPE" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (152, 'County Agency', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (152, 'Federal Agency', 'Federal Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (152, 'Local Agency/District', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (152, 'Non-Government', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (152, 'State Agency', 'State Government - Non Military');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'FacilityType1', 'permitted_ust_tanks', 'FACILITY_TYPE')
returning id;

select * from ust_element_db_mapping order by 1 desc;

select distinct "FACILITY_TYPE" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (153, ''' || "FACILITY_TYPE" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (153, 'Farm', 'Agricultural/farm');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (153, 'Fuel Distribution', 'Bulk plant storage/petroleum distributor');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (153, 'Motor Vehicle Fueling', 'Retail fuel sales (non-marina)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (153, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (153, 'Processor', 'Other');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'TankStatus', 'permitted_ust_tanks', 'TANK_STATUS')
returning id;

select * from ust_element_db_mapping order by 1 desc;

select distinct "FACILITY_TYPE" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (154, ''' || "TANK_STATUS" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (154, 'Confirmed/Updated Information', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (154, 'New Permit', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (154, 'Renewal Permit', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (154, 'Temporary UST Closure', 'Temporarily out of service');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (154, 'UST Permanent Closure on Site', 'Closed (in place)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (154, 'UST Removal', 'Closed (removed from ground)');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'CompartmentalizedUST', 'permitted_ust_tanks', 'TANK_CONFIGURATION')
returning id;

select distinct "TANK_CONFIGURATION" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (155, ''' || "TANK_CONFIGURATION" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (155, 'One in a Compartmented Unit', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (155, 'Stand Alone Tank', 'No');

----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'TankSubstanceStored', 'permitted_ust_tanks', 'TANK_CONTENTS')
returning id;

select distinct "TANK_CONTENTS" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, ''' || ca_substance ||  ''', ''' || epa_substance ||  ''');'
from "CA_UST".substance_xwalk order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, '12', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, '13', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, '14', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, '15', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Aviation Gas', 'Aviation gasoline');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'CA Values', 'Mapping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Ethanol', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Jet Fuel', 'Unknown aviation gas or jet fuel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Midgraded Unleaded', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Other Non-petroleum', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Other Petroleum', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Petroleum Blend Fuel', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Premium Unleaded', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (156, 'Regular Unleaded', 'Gasoline (unknown type)');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'CompartmentSubstanceStored', 'permitted_ust_tanks', 'TANK_CONTENTS')
returning id;

select distinct "TANK_CONTENTS" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, ''' || ca_substance ||  ''', ''' || epa_substance ||  ''');'
from "CA_UST".substance_xwalk order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, '12', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, '13', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, '14', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, '15', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Aviation Gas', 'Aviation gasoline');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'CA Values', 'Mapping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Ethanol', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Jet Fuel', 'Unknown aviation gas or jet fuel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Midgraded Unleaded', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Other Non-petroleum', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Other Petroleum', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Petroleum Blend Fuel', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Premium Unleaded', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (157, 'Regular Unleaded', 'Gasoline (unknown type)');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'TankWallType', 'permitted_ust_tanks', 'TANK_TYPE')
returning id;

select distinct "TANK_TYPE" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (158, ''' || "TANK_TYPE" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (158, 'Double Wall', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (158, 'Single Wall', 'Single');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (158, 'Unknown', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'MaterialDescription', 'permitted_ust_tanks', 'TANK_PC_CONSTRUCTION')
returning id;

select distinct "TANK_PC_CONSTRUCTION" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (159, ''' || "TANK_PC_CONSTRUCTION" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (159, 'Fiberglass', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (159, 'Internal Bladder', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (159, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (159, 'Steel', 'Asphalt coated or bare steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (159, 'Steel + Internal Lining', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (159, 'Unknown', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'PipingMaterialDescription', 'permitted_ust_tanks', 'TANK_PWPIPING_CONSTRUCTION')
returning id;

select distinct "TANK_PWPIPING_CONSTRUCTION" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, ''' || "TANK_PWPIPING_CONSTRUCTION" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, 'Fiberglass', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, 'Flexible', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, 'None', 'No piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, 'Regid Plastic', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, 'Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (160, 'Unknown', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'PipingStyle', 'permitted_ust_tanks', 'TANK_PIPING_TYPE')
returning id;

select distinct "TANK_PIPING_TYPE" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (161, ''' || "TANK_PIPING_TYPE" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (161, '23 CCR S2636(a)(3) Suction', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (161, 'Conventional Suction', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (161, 'Gravity', 'Non-operational ( e.g., fill line, vent line, gravity)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (161, 'Pressure', 'Pressure');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'PipingWallType', 'permitted_ust_tanks', 'TANK_PIPING_CONSTRUCTION')
returning id;

select distinct "TANK_PIPING_CONSTRUCTION" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (162, ''' || "TANK_PIPING_CONSTRUCTION" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (162, 'Double Walled', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (162, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (162, 'Single Walled', 'Single walled');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'TankCorrosionProtectionSacrificialAnode', 'permitted_ust_tanks', 'TANK_SACRIFICIAL_ANODE')
returning id;

select distinct "TANK_SACRIFICIAL_ANODE" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (163, ''' || "TANK_SACRIFICIAL_ANODE" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;  

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (163, 'No', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (163, 'Yes', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'TankCorrosionProtectionImpressedCurrent', 'permitted_ust_tanks', 'TANK_CP_IMPRESSED_CURRENT')
returning id;

select distinct "TANK_CP_IMPRESSED_CURRENT" from "CA_UST".permitted_ust_tanks order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (164, ''' || "TANK_CP_IMPRESSED_CURRENT" ||  ''', '''');'
from "CA_UST".permitted_ust_tanks order by 1;  

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (164, 'No', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (164, 'Yes', 'Yes');


--insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (, '', '');


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

drop view  "CA_UST".v_ust_base;
create or replace view "CA_UST".v_ust_base as 
select  u."FACILITY_ID" as "FacilityID",
	    t."FACILITY_NAME" as "FacilityName",
	    ot.epa_value as "OwnerType",
	    ft.epa_value as "FacilityType1",
		t."FACILITY_STREET" as "FacilityAddress1",
		t."FACILITY_CITY" as "FacilityCity",
		u."COUNTY" as "FacilityCounty",
		t."FACILITY_ZIP" as "FacilityZipCode",
		t."FACILTIY_STATE" as "FacilityState",
		t."EPA_REGION" as "FacilityEPARegion",
		t."TRIBAL_LANDS" as "FacilityTribalSite",
		t."FACILITY_LATITUDE" as "FacilityLatitude",
		t."FACILITY_LONGITUDE" as "FacilityLongitude",
 	    t."TANK_OWNER_NAME" as "FacilityOwnerCompanyName",
		t."TANK_OWNER_MAILING_ADDRESS" as "FacilityOwnerAddress1",
		t."TANK_OWNER_MAILING_CITY" as "FacilityOwnerCity",
		t."TANK_OWNER_MAILING_ZIP" as "FacilityOwnerZipCode",
		t."TANK_OWNER_MAILING_STATE" as "FacilityOwnerState",
		t."TANK_OPERATOR_NAME" as "FacilityOwnerOperatorName",
		t."TANK_OPERATOR_MAILING_ADDRESS" as "FacilityOperatorAddress1",
		t."TANK_OPERATOR_MAILING_CITY" as "FacilityOperatorCity",
		t."TANK_OPERATOR_MAILING_ZIP" as "FacilityOperatorZipCode",
		t."TANK_OPERATOR_MAILING_STATE" as "FacilityOperatorState",
		t."TANKIDNUMBER" as "TankID",
		ts.epa_value as "TankStatus", --also values of "11" and "9"
        "TANK_CLOSURE_DATE" as "ClosureDate",	
		"TANK_INSTALLATION_DATE" as "InstallationDate",
		cu.epa_value as "CompartmentalizedUST",
		"TANK_NUM_OF_COMPARTMENTS" as "NumberofCompartments",
		case when "TANK_CONFIGURATION" = 'Stand Alone Tank' then tss.epa_value end as "TankSubstanceStored",
null as "CompartmentID", --there are no compartment IDs b/c CA treats each compartment as a separate tank	
		case when "TANK_CONFIGURATION" = 'One in a Compartmented Unit' then css.epa_value end as "CompartmentSubstanceStored",
		case when "TANK_CONFIGURATION" = 'Stand Alone Tank' then "TANK_CAPACITY_GALLONS" end as "TankCapacityGallons", 
		case when "TANK_CONFIGURATION" = 'One in a Compartmented Unit' then "TANK_CAPACITY_GALLONS" end as "CompartmentCapacityGallons", --not positive this is not the total tank capacity?
		twt.epa_value as "TankWallType",
		md.epa_value as "MaterialDescription",
		pmd.epa_value as "PipingMaterialDescription",
		ps.epa_value as "PipingStyle",
	    pwt.epa_value as "PipingWallType", 	   	
		tcpsa.epa_value as "TankCorrosionProtectionSacrificialAnode",
		case when tcpsa.epa_value is not null then 'Unknown' end as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
		tcpic.epa_value as "TankCorrosionProtectionImpressedCurrent",
		case when tcpic.epa_value is not null then 'Unknown' end as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
		null as "TankCorrosionProtectionOther",  --Can we map TANK_CP_SHUTOFF to this? Answer: NO
		"TANK_BALL_FLOAT" as "BallFloatValve",
		"TANK_ALARMS" as "HighLevelAlarm",
		"TANK_SPILL_BUCKET" as "SpillBucketInstalled"
from "CA_UST".permitted_ust u left join "CA_UST".permitted_ust_tanks t on u."CERSID" = t."CERSID"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'OwnerType') ot on t."OWNER_TYPE" = ot.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'FacilityType1') ft on t."FACILITY_TYPE" = ft.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'TankStatus') ts on t."TANK_STATUS" = ts.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'CompartmentalizedUST') cu on t."TANK_CONFIGURATION" = cu.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'TankSubstanceStored') tss on t."TANK_CONTENTS" = tss.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'CompartmentSubstanceStored') css on t."TANK_CONTENTS" = css.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'TankWallType') twt on t."TANK_TYPE" = twt.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'MaterialDescription') md on t."TANK_PC_CONSTRUCTION" = md.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'PipingMaterialDescription') pmd on t."TANK_PWPIPING_CONSTRUCTION" = pmd.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'PipingStyle') ps on t."TANK_PIPING_TYPE" = ps.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'PipingWallType') pwt on t."TANK_PIPING_CONSTRUCTION" = pwt.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'TankCorrosionProtectionSacrificialAnode') tcpsa on t."TANK_SACRIFICIAL_ANODE" = tcpsa.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'CA' and element_name = 'TankCorrosionProtectionImpressedCurrent') tcpic on t."TANK_CP_IMPRESSED_CURRENT" = tcpic.state_value
where u."FACILITY_ID" is not null and "TANKIDNUMBER" is not null	
order by u."FACILITY_ID", t."TANKIDNUMBER";


select count(*) from "CA_UST".permitted_ust where "FACILITY_ID" is null;
2757

select count(*) From "CA_UST".permitted_ust_tanks where "TANKIDNUMBER" is null;
7

select *  from v_ust_element_mapping where organization_id = 'CA' and element_name = 'TankStatus';

select count(*) from "CA_UST".permitted_ust
15447

select count(*) From "CA_UST".permitted_ust_tanks where "TANKIDNUMBER" is not null;
40117


select count(*) from "CA_UST".permitted_ust u left join "CA_UST".permitted_ust_tanks t on u."CERSID" = t."CERSID";
40969

select * from "CA_UST".permitted_ust where "FACILITY_ID" is null;

select "TANK_STATUS", count(*) from  "CA_UST".permitted_ust_tanks
group by "TANK_STATUS"
11	61
Confirmed/Updated Information	33284
UST Removal	2114
UST Permanent Closure on Site	414
Renewal Permit	3771
New Permit	309
9	55
Temporary UST Closure	116

select count(*) from "CA_UST".permitted_ust u left join "CA_UST".permitted_ust_tanks t on u."CERSID" = t."CERSID"
where u."FACILITY_ID" is not null and "TANKIDNUMBER" is not null	;
32923

select count(*) from "CA_UST".v_ust_base where "FacilityLatitude" is  null;

select count(*) 
from ust where control_id = 2 and 
	("FacilityLatitude" is null  or "FacilityLongitude" is null
    or length(split_part("FacilityLatitude"::text, '.', 2)::text) < 3
    or length(split_part("FacilityLongitude"::text, '.', 2)::text) < 3);

   select * from ust_control;
  
  select * from ust where state = 'CA' and "FacilityID" = '01-003-102101'
  
  select * from lust where state = 'NC';
   
select distinct element_db_mapping_id, element_name, state_table_name, state_column_name from v_ust_element_mapping where state = 'CA' order by 1;


select * from 

select * from "CA_UST".ca_ust_geocoded where gc_coordinate_source <> 'State'



update public.ust x
			set gc_latitude = y.gc_latitude::float, 
			gc_longitude = y.gc_longitude::float, 
			gc_coordinate_source = y.gc_coordinate_source, 
			gc_address_type = y.gc_address_type
		from "CA_UST".ca_ust_geocoded y 
where x."FacilityID" = y."FacilityID" and x."TankID" = y."TankID" and coalesce(x."CompartmentID",'X') = coalesce(y."CompartmentID"::text,'X')
 and x.state ='CA' and x.control_id = (select max(control_id) from public.ust_control where state = 'CA');
 
select * from ust where state = 'CA' order by "FacilityID" is null;

 

update public.ust x
			set gc_latitude = y.gc_latitude::float, 
			gc_longitude = y.gc_longitude::float, 
			gc_coordinate_source = y.gc_coordinate_source, 
			gc_address_type = y.gc_address_type
		from "CA_UST".ca_ust_geocoded y 
 where x."FacilityID" = y."FacilityID" and x."TankID" = y."TankID" and coalesce(x."CompartmentID",X) = coalesce(y."CompartmentID"::text,X) 
 and x.state = %s and x.control_id = (select max(control_id) from public.ust_control where state = %s)
 

 
 select * 
 from  public.ust x join "CA_UST".ca_ust_geocoded y on x."FacilityID" = y."FacilityID" and x."TankID" = y."TankID" 
 where x.state ='CA' and x.control_id = (select max(control_id) from public.ust_control where state = 'CA')

 
 select "CompartmentID" from "CA_UST".ca_ust_geocoded
 
 select "CompartmentID" from 