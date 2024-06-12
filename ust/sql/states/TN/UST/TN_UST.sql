----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'FacilityType', 'TN_UST', 'FACILITY_TYPE')
returning id;

select distinct "" from "TN_UST"."TN_UST" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, ''' || "FACILITY_TYPE" ||  ''', '''');'
from "TN_UST"."TN_UST"
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Aircraft Owner', 'Aviation/Airport');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Airline', 'Aviation/Airport');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Airport', 'Aviation/Airport');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Auto Dealership', 'Auto Dealership/Auto Maintenance & Repair');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Auto Rental', 'Rental Car');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Farm less than 1101 not regulated', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Federal Military', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Federal Non-Military', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Fleet_Fueling', 'Trucking/Transport/Fleet Operation');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Gas Station or Truck Stop', 'Retail Fuel Sales');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Hospital or Medical Facility', 'Hospital');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Industrial', 'Industrial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Local Government', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Marina', 'Marina');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Nursing Home or Assisted Living', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Office Building or Complex ', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Oil Changing Facility', 'Auto Dealership/Auto Maintenance & Repair');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Other or Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Petroleum Distributor', 'Bulk Plant Storage/Petroleum Distributor');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Railroad', 'Railroad');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Residential less than 1101 not regulated', 'Residential');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'State Government', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (192, 'Utilities', 'Utility');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'TankStatus', 'v_tank_status', 'COMPARTMENT_STATUS')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (193, ''' || "COMPARTMENT_STATUS" ||  ''', '''');'
from "TN_UST"."v_tank_status"
order by 1;

select * from "TN_UST"."v_tank_status"

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (193, 'Closed in Ground', 'Closed (in place)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (193, 'Currently in Use', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (193, 'Permanently Out of Use', 'Closed (general)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (193, 'Removed from Ground', 'Closed (removed from ground)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (193, 'Temporarily Out of Use', 'Temporarily out of service');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (193, 'unknown', 'Unknown');


select * from tank_status;

			case when "COMPARTMENT_STATUS" = 'Currently in Use' then 'Currently in use'
		     when "COMPARTMENT_STATUS" = 'Temporarily Out of Use' then 'Temporarily out of service'
			 when "COMPARTMENT_STATUS" = 'Permanently Out of Use' and "HOW_CLOSED" = 'Closed in Ground' then 'Closed (in place)'
			 when "COMPARTMENT_STATUS" = 'Permanently Out of Use' and "HOW_CLOSED" = 'Removed from Ground' then 'Closed (removed from ground)'
	    end as "TankStatus",		


select distinct "FACILITY_ID", "TANK_ID", "COMPARTMENT_STATUS", "HOW_CLOSED"
from "TN_UST"."TN_UST"


drop view  "TN_UST".v_tank_status
create or replace view "TN_UST".v_tank_status as 
select distinct "FACILITY_ID", "TANK_ID", "COMPARTMENT_ID",
	case when "HOW_CLOSED" is not null then "HOW_CLOSED" else "COMPARTMENT_STATUS" end as "COMPARTMENT_STATUS"
from "TN_UST"."TN_UST";
	    
	    
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'CompartmentSubstanceStored', 'TN_UST', 'FUEL_STORED')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, ''' || "FUEL_STORED" ||  ''', '''');'
from "TN_UST"."TN_UST"
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Avgas 100_LL', 'Aviation gasoline');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Biodiesel less than 100', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Ethanol Blend above E10', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Gasoline', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Gasoline_ULSDiesel', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Gear Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Jet Fuel', 'Jet Fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Kerosene', 'Kerosene');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Mineral Spirits', 'Solvent');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Mixture', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'New Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Not Listed', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Off Road Diesel High Sulfer', 'Off-road diesel/dyed diesel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Power Steering Fluid', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Racing Fuel', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Transmission Fluid Regulated', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'ULS Diesel', 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'ULSDiesel_Kerosene ', 'Kerosene');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Unknown Petroleum', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (194, 'Waste or Used Oil', '');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'TankWallType', 'TN_UST', 'TANK_WALL_TYPE')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (195, ''' || "TANK_WALL_TYPE" ||  ''', '''');'
from "TN_UST"."TN_UST"
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (195, 'Double Wall', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (195, 'Single Wall', 'Single');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'MaterialDescription', 'TN_UST', 'TANK_MATERIAL')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, ''' || "TANK_MATERIAL" ||  ''', '''');'
from "TN_UST"."TN_UST"
order by 1;	   
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, 'Cathodically Protected Steel-StiP3', 'Cathodically protected steel (without coating)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, 'Composite - Steel w/FRP', 'Composite/clad (steel w/fiberglass reinforced plastic)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, 'Concrete', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, 'Polyethylene Tank Jacket', 'Jacketed steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, 'Steel', 'Steel (undefined)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (196, 'Tank Construction Material Other or Unknown', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'PipingMaterialDescription', 'TN_UST', 'PIPING_MATERIAL')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, ''' || "PIPING_MATERIAL" ||  ''', '''');'
from "TN_UST"."TN_UST"
order by 1;	   
	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Copper', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Fiberglass FRP - (Ameron Dualoy - Smith Fibercast)', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Flexible Plastic (APT - OPW Pieces - Environ - etc)', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Gasoline', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Gasoline_ULSDiesel', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Hazardous Substance', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Kerosene', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'No Piping', 'No piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Rigid Plastic - (NUPI - Western Fiberglass -UPP - Brugg)', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (197, 'ULSDiesel_Kerosene ', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'TankCorrosionProtectionSacrificialAnode', 'TN_UST', 'TANK_CORR')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (198, ''' || "TANK_CORR" ||  ''', ''Yes'');'
from "TN_UST"."TN_UST" 
order by 1;	 
	         
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (198, 'Impressed Current', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (198, 'Sacrificial Anodes', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'TankCorrosionProtectionAnodeInstalledOrRetrofitted', 'TN_UST', 'TANK_CORR')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (199, ''' || "TANK_CORR" ||  ''', ''Yes'');'
from "TN_UST"."TN_UST" 
order by 1;	 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (199, 'Sacrificial Anodes', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'TankCorrosionProtectionImpressedCurrent', 'TN_UST', 'TANK_CORR')
returning id;         	
	         
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (200, 'Impressed Current', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (200, 'Sacrificial Anodes', 'No');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted', 'TN_UST', 'TANK_CORR')
returning id; 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (201, 'Impressed Current', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'PipingCorrosionProtectionSacrificialAnode', 'TN_UST', 'PIPING_CORR')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (202, ''' || "PIPING_CORR" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;	 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (202, 'Impressed Current', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (202, 'Sacrificial Anodes', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'PipingCorrosionProtectionAnodeInstalledOrRetrofitted', 'TN_UST', 'PIPING_CORR')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (203, 'Sacrificial Anodes', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'PipingCorrosionProtectionImpressedCurrent', 'TN_UST', 'PIPING_CORR')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (204, ''' || "PIPING_CORR" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;	 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (204, 'Impressed Current', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (204, 'Sacrificial Anodes', 'No');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted', 'TN_UST', 'PIPING_CORR')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (205, 'Impressed Current', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'FlowShutoffDevice', 'TN_UST', 'OVERFILL_TYPE')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (206, ''' || "OVERFILL_TYPE" ||  ''', ''Yes'');'
from "TN_UST"."TN_UST" 
order by 1;	 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (206, 'Automatic Shut Off Device', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (206, 'unknown', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'BallFloatValve', 'TN_UST', 'OVERFILL_TYPE')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (207, 'Ball Float Valves', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (207, 'unknown', 'Unknown');

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'HighLevellAlarm', 'TN_UST', 'OVERFILL_TYPE')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (208, ''' || "OVERFILL_TYPE" ||  ''', ''Yes'');'
from "TN_UST"."TN_UST" 
order by 1;	 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (208, 'Overfill Alarm', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (208, 'unknown', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'OverfillProtectionMeans', 'TN_UST', 'OVERFILL_TYPE')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (209, ''' || "OVERFILL_TYPE" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;	 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (209, 'Automatic Shut Off Device', 'Flow shutoff device (flapper)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (209, 'Ball Float Valves', 'Ball float valve');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (209, 'Not Required', 'Not required');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (209, 'Overfill Alarm', 'High level alarm ');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (209, 'unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (209, 'Vent Whistle', 'Other');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'SpillBucketInstalled', 'TN_UST', 'SPILL_BUCKET')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (210, ''' || "SPILL_BUCKET" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;	 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (210, 'Double walled', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (210, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (210, 'Single walled', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'AutomaticTankGauging', 'TN_UST', 'COMPARTMENT_RD')
returning id;

update ust_element_db_mapping set element_name = 'AutomaticTankGaugingReleaseDetection' where id = 212;
update ust_element_db_mapping set element_name = 'AutomaticTankGaugingContinuousLeakDetection' where id = 213;



select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (211, ''' || "COMPARTMENT_RD" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;		 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (211, 'Automatic Tank Gauging', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (212, 'Automatic Tank Gauging', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (213, 'Automatic Tank Gauging', 'Unknown');

select * from ust_element_value_mappings where element_db_mapping_id between 211 and 213;
select * from ust_element_db_mapping where id between 211 and 213;


----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'ManualTankGauging', 'TN_UST', 'COMPARTMENT_RD')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (214, 'Manual Tank Gauging', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'StatisticalInventoryReconciliation', 'TN_UST', 'COMPARTMENT_RD')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (215, 'Statistical Inventory Reconciliation (SIR)', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'TankTightnessTesting', 'TN_UST', 'COMPARTMENT_RD')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (216, 'Manual Tank Gauging and Tank Tightness Testing', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'GroundwaterMonitoring', 'TN_UST', 'COMPARTMENT_RD')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (217, 'Ground Water Monitoring', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'VaporMonitoring', 'TN_UST', 'LARGE_LEAK_RD')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (218, ''' || "LARGE_LEAK_RD" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;		
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (218, 'Vapor Monitoring', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'ElectronicLineLeak', 'TN_UST', 'PIPING_RD')
returning id;
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'MechanicalLineLeak', 'TN_UST', 'PIPING_RD')
returning id;

select * from ust_element_value_mappings where element_db_mapping_id = 219;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (220, ''' || "PIPING_RD" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;		
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (219, 'Electronic', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (220, 'Mechanical (Automatic)', 'Yes');

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'AutomatedIntersticialMonitoring', 'v_interstitial_monitoring', 'interstitial_monitoring')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (221, ''' || "LARGE_LEAK_RD" ||  ''', ''Yes'');'
from "TN_UST"."TN_UST" 
order by 1;		

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (221, 'Interstitial Monitoring', 'Yes');
	

	case when "LARGE_LEAK_RD" = 'Interstitial Monitoring for Piping' then 'Yes'
		     when "COMPARTMENT_RD" = 'Interstitial Monitoring' then 'Yes'
		     when "COMPARTMENT_RD" is not null then 'No' end as "AutomatedIntersticialMonitoring",
	
		     drop view  "TN_UST".v_interstitial_monitoring;
create view "TN_UST".v_interstitial_monitoring as	     
select distinct "FACILITY_ID", "TANK_ID",  "COMPARTMENT_ID",
"LARGE_LEAK_RD", "COMPARTMENT_RD", 'Interstitial Monitoring' as interstitial_monitoring
from "TN_UST"."TN_UST"   
where "LARGE_LEAK_RD" = 'Interstitial Monitoring for Piping' or "COMPARTMENT_RD" = 'Interstitial Monitoring';

		     

select distinct  "COMPARTMENT_RD" from "TN_UST"."TN_UST"   
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'SafeSuction', 'TN_UST', 'SUCTION_TYPE')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (222, ''' || "SUCTION_TYPE" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;		
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (222, 'Safe Suction', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'AmericanSuction', 'TN_UST', 'SUCTION_TYPE')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (223, ''' || "SUCTION_TYPE" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;				     
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (223, 'US Suction', '');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-03-30', 'PrimaryReleaseDetectionType', 'TN_UST', 'LARGE_LEAK_RD')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, ''' || "LARGE_LEAK_RD" ||  ''', '''');'
from "TN_UST"."TN_UST" 
order by 1;		
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, '3 Year LTT', 'Line test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'Annual LTT', 'Line test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'ELLD .1 Annual', 'Line test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'ELLD .2 Monthly', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'Groundwater Monitoring', 'Groundwater monitoring');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'Interstitial Monitoring for Piping', 'Interstitial monitoring');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'Other or No Method of Release Detection', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'Pipe Leak Detection Not Listed', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'Statistical Inventory Reconciliation', 'SIR');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (224, 'Vapor Monitoring', 'Vapor monitoring');
	  



select * from ust_element_db_mapping order by 1 desc;
select * from ust_element_value_mappings order by 1 desc;



----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

drop view "TN_UST".v_ust_base;
create or replace view "TN_UST".v_ust_base as 
select tn."FACILITY_ID" as "FacilityID",
       "FACILITY_NAME" as "FacilityName",
	    ft.epa_value as "FacilityType",
		"ADDRESS" as "FacilityAddress1",
		"ADDRESS2" as "FacilityAddress2",
		"CITY" as "FacilityCity",
		"STATE" as "FacilityState",
		"REGION" as "FacilityEPARegion",
		"LATITUDE" as "FacilityLatitude",
		"LONGITUDE" as "FacilityLongitude",
		tn."TANK_ID" as "TankID",
		tn."COMPARTMENT_ID" as "CompartmentID",
		ts.epa_value "TankStatus",
		case when num_tanks.num_tanks > 1 then 'Yes' else 'No' end as "MultipleTanks",
		to_timestamp("CLOSURE_DATE"/1000)::date as "ClosureDate",
		to_timestamp("INSTALL_DATE"/1000)::date as "InstallationDate",
		case when num_compartments.num_compartments > 1 then 'Yes' end as "CompartmentalizedUST",
		case when num_compartments.num_compartments > 1 then num_compartments.num_compartments end as "NumberofCompartments",
		css.epa_value as "CompartmentSubstanceStored",
		"CAPACITY" as "CompartmentCapacityGallons",
		twt.epa_value as "TankWallType",
		md.epa_value as "MaterialDescription",
		pmd.epa_value as "PipingMaterialDescription",
		tcpsa.epa_value as "TankCorrosionProtectionSacrificialAnode",
		tcpsair.epa_value as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
		tcpic.epa_value as "TankCorrosionProtectionImpressedCurrent",	
		tcpicir.epa_value as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",	
		pcpsa.epa_value as "PipingCorrosionProtectionSacrificialAnode",
		pcpsair.epa_value as "PipingCorrosionProtectionAnodesInstalledOrRetrofitted",
		pcpic.epa_value as "PipingCorrosionProtectionImpressedCurrent",	
		pcpicir.epa_value as "PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",	
		fsd.epa_value as "AutomaticShutoffDevice",
		hla.epa_value as "OverfillAlarm",
		bfv.epa_value as "BallFloatValve",
		opm.epa_value as "OverfillProtectionMeans",
		sbi.epa_value as "SpillBucketInstalled",
		atg.epa_value as "AutomaticTankGauging",
		atgrd.epa_value as "AutomaticTankGaugingReleaseDetection",
		atgcld.epa_value as "AutomaticTankGaugingContinuousLeakDetection",
		mtg.epa_value as "ManualTankGauging",
		sir.epa_value as "StatisticalInventoryReconciliation",
		ttt.epa_value as "TankTightnessTesting",
		gm.epa_value as "GroundwaterMonitoring",
		vm.epa_value as "VaporMonitoring",
		ell.epa_value as "ElectronicLineLeakDetector",
		mll.epa_value as "MechanicalLineLeakDetector",
		aim.epa_value as "AutomatedIntersticialMonitoring",
	    ss.epa_value as "SafeSuction",
	    ass.epa_value as "AmericanSuction",
        prdt.epa_value as "PrimaryReleaseDetectionType"
from "TN_UST"."TN_UST" tn 
	left join "TN_UST".v_tank_status vts on tn."FACILITY_ID" = vts."FACILITY_ID" and tn."TANK_ID" = vts."TANK_ID" and tn."COMPARTMENT_ID" = vts."COMPARTMENT_ID"
	left join "TN_UST".v_interstitial_monitoring vim on tn."FACILITY_ID" = vts."FACILITY_ID" and tn."TANK_ID" = vim."TANK_ID" and tn."COMPARTMENT_ID" = vim."COMPARTMENT_ID"
	join (select "FACILITY_ID", count(*) as num_tanks from (select distinct "FACILITY_ID", "TANK_ID" from "TN_UST"."TN_UST") x group by "FACILITY_ID") num_tanks
		on tn."FACILITY_ID" = num_tanks."FACILITY_ID"
	join (select "FACILITY_ID", "TANK_ID", count(*) as num_compartments 
		  from (select distinct "FACILITY_ID", "TANK_ID", "COMPARTMENT_ID" from "TN_UST"."TN_UST") x group by "FACILITY_ID", "TANK_ID") num_compartments
		on tn."FACILITY_ID" = num_compartments."FACILITY_ID" and tn."TANK_ID" = num_compartments."TANK_ID"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'FacilityType') ft on ft.state_value = tn."FACILITY_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'TankStatus') ts on ts.state_value = vts."COMPARTMENT_STATUS"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'CompartmentSubstanceStored') css on css.state_value = tn."FUEL_STORED"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'TankWallType') twt on twt.state_value = tn."TANK_WALL_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'MaterialDescription') md on md.state_value = tn."TANK_MATERIAL"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'PipingMaterialDescription') pmd on pmd.state_value = tn."PIPING_MATERIAL"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'TankCorrosionProtectionSacrificialAnode') tcpsa on tcpsa.state_value = tn."TANK_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'TankCorrosionProtectionAnodeInstalledOrRetrofitted') tcpsair on tcpsair.state_value = tn."TANK_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'TankCorrosionProtectionImpressedCurrent') tcpic on tcpic.state_value = tn."TANK_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted') tcpicir on tcpicir.state_value = tn."TANK_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'PipingCorrosionProtectionSacrificialAnode') pcpsa on pcpsa.state_value = tn."PIPING_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'PipingCorrosionProtectionAnodeInstalledOrRetrofitted') pcpsair on pcpsair.state_value = tn."PIPING_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'PipingCorrosionProtectionImpressedCurrent') pcpic on pcpic.state_value = tn."PIPING_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted') pcpicir on pcpicir.state_value = tn."PIPING_CORR"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'FlowShutoffDevice') fsd on fsd.state_value = tn."OVERFILL_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'HighLevellAlarm') hla on hla.state_value = tn."OVERFILL_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'BallFloatValve') bfv on bfv.state_value = tn."OVERFILL_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'OverfillProtectionMeans') opm on opm.state_value = tn."OVERFILL_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'SpillBucketInstalled') sbi on sbi.state_value = tn."SPILL_BUCKET"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'AutomaticTankGauging') atg on atg.state_value = tn."COMPARTMENT_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'AutomaticTankGaugingReleaseDetection') atgrd on atgrd.state_value = tn."COMPARTMENT_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'AutomaticTankGaugingContinuousLeakDetection') atgcld on atgcld.state_value = tn."COMPARTMENT_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'ManualTankGauging') mtg on mtg.state_value = tn."COMPARTMENT_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'StatisticalInventoryReconciliation') sir on sir.state_value = tn."COMPARTMENT_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'TankTightnessTesting') ttt on ttt.state_value = tn."COMPARTMENT_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'GroundwaterMonitoring') gm on gm.state_value = tn."COMPARTMENT_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'VaporMonitoring') vm on vm.state_value = tn."LARGE_LEAK_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'MechanicalLineLeak') mll on mll.state_value = tn."PIPING_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'ElectricLineLeak') ell on mll.state_value = tn."PIPING_RD"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'AutomatedIntersticialMonitoring') aim on aim.state_value = vim."interstitial_monitoring"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'SafeSuction') ss on ss.state_value = tn."SUCTION_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'AmericanSuction') ass on ass.state_value = tn."SUCTION_TYPE"
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TN' and element_name = 'PrimaryReleaseDetectionType') prdt on prdt.state_value = tn."LARGE_LEAK_RD"
order by tn."FACILITY_ID", tn."TANK_ID", tn."COMPARTMENT_ID";
	
	

select distinct element_db_mapping_id, element_name, state_table_name, state_column_name 
from  v_ust_element_mapping where state = 'TN'
order by 1;

create index tn_ust_facility_id on "TN_UST"."TN_UST"("FACILITY_ID");
create index tn_ust_tank_id on "TN_UST"."TN_UST"("TANK_ID");
create index tn_ust_compartment_id on "TN_UST"."TN_UST"("COMPARTMENT_ID");




create index tn_ust_factype on "TN_UST"."TN_UST"("FACILITY_TYPE");
create index tn_ust_comstatus on "TN_UST"."TN_UST"("COMPARTMENT_STATUS");
create index tn_ust_fuel on "TN_UST"."TN_UST"("FUEL_STORED");
create index tn_ust_tankwalltype on "TN_UST"."TN_UST"("TANK_WALL_TYPE");
create index tn_ust_tankmat on "TN_UST"."TN_UST"("TANK_MATERIAL");
create index tn_ust_pipingmat on "TN_UST"."TN_UST"("PIPING_MATERIAL");
create index tn_ust_tankcorr on "TN_UST"."TN_UST"("TANK_CORR");
create index tn_ust_pipingcorr on "TN_UST"."TN_UST"("PIPING_CORR");
create index tn_ust_overfilltype on "TN_UST"."TN_UST"("OVERFILL_TYPE");
create index tn_ust_spillbucket on "TN_UST"."TN_UST"("SPILL_BUCKET");
create index tn_ust_compartmentrd on "TN_UST"."TN_UST"("COMPARTMENT_RD");
create index tn_ust_lgleakrd on "TN_UST"."TN_UST"("LARGE_LEAK_RD");
create index tn_ust_pipingrd on "TN_UST"."TN_UST"("PIPING_RD");
create index tn_ust_suction on "TN_UST"."TN_UST"("SUCTION_TYPE");



vim."interstitial_monitoring"










create index ust_element_db_mapping_id on ust_element_db_mapping(id);
create index ust_element_db_mapping_state on ust_element_db_mapping(state);
create index ust_element_db_mapping_element_name on ust_element_db_mapping(element_name);
create index ust_element_value_mapping_id on ust_element_value_mappings(id);
create index ust_element_db_mapping_dbid on ust_element_value_mappings(element_db_mapping_id);
create index ust_element_db_mapping_state_value on ust_element_value_mappings(state_value);
create index ust_element_db_mapping_epa_value on ust_element_value_mappings(epa_value);

create index lust_element_db_mapping_id on lust_element_db_mapping(id);
create index lust_element_db_mapping_state on lust_element_db_mapping(state);
create index lust_element_db_mapping_element_name on lust_element_db_mapping(element_name);
create index lust_element_value_mapping_id on lust_element_value_mappings(id);
create index lust_element_db_mapping_dbid on lust_element_value_mappings(element_db_mapping_id);
create index lust_element_db_mapping_state_value on lust_element_value_mappings(state_value);
create index lust_element_db_mapping_epa_value on lust_element_value_mappings(epa_value);

create index ust_id on ust(id);
create index ust_control_id on ust(control_id);
create index ust_state on ust(state);

create index ust_facility_id on ust("FacilityID");

create index lust_id on lust(id);
create index lust_control_id on lust(control_id);
create index lust_state on lust(state);


create index lust_facility_id on lust("FacilityID");
create index lust_lust_id on lust("LUSTID");

analyze ust;
analyze lust;
analyze ust_element_db_mapping;
analyze ust_element_value_mappings;
analyze lust_element_value_mappings;
analyze lust_element_db_mapping;
