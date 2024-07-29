----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-04-05', 'SubstanceReleased1', 'LUSTV2', 'SubstanceReleased1')
returning id;

select distinct "SubstanceReleased1" from "SD_LUST"."LUSTV2" order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, ''' || "SubstanceReleased1" ||  ''', '''');'
from "SD_LUST"."LUSTV2"
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, ' ', null);
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Antifreeze', 'Antifreeze');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Aviation Fuel', 'Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Aviation Fuel - 87 or 100 octane', 'Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'aviation gasoline', 'Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Bleach', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Chlorinated Solvents', 'Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Diesel  Fuel Oil', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Diesel  Gasoline', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Diesel  JP-4 Fuel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Diesel  oil & water mix', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Diesel #1', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Diesel #2', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'diesel and gasoline', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'diesel fuel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Dyed Diesel', 'Off-road diesel/dyed diesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'E-10 Gasoline', 'Gasoline E-10 (E1-E10)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'E-85', ' E-85/Flex Fuel (E51-E83)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Ethanol', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Ethanol gas', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Flammable Haz Waste', 'Hazardous substance');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Fuel', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'fuel oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Fuel Oil  Gasoline', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Fuel Oil #1', 'Heating oil/fuel oil 1');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Fuel Oil #2', 'Heating oil/fuel oil 2');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasohol', 'Gasoline E-10 (E1-E10)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline - Reg & Unl', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline  Fuel Oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline  Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline  Oil', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline  unleaded', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline  Waste Oil', 'Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline Leaded', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline Unleaded', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Gasoline Vapors', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Heating Fuel', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'heating oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (64, 'Jet A Aviation Fuel', 'Jet fuel A');


----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-04-05', 'CauseOfRelease1', 'LUSTV2', 'CauseOfRelease1')
returning id;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, ''' || "CauseOfRelease1" ||  ''', '''');'
from "SD_LUST"."LUSTV2"
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Accident', 'Motor vehicle accident');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Corrosion', 'Corrosion');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Damage', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Damaged Pipe', 'Damage to dispenser');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Disconnected Hose', 'Damage to dispenser');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Dispenser Leak', 'Damage to dispenser');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Equipment Activation', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Equipment Failure', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Fire Event', 'Weather/Natural Disaster (i.e., hurricane, flooding, fire, earthquake)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Floated', 'Weather/Natural Disaster (i.e., hurricane, flooding, fire, earthquake)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Handling', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Historical', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Immersed', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Leakage', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Leaks and Spills', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Line Leak', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'No Lab Results', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'No Release', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'No Tank Found', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Open Valve', 'Valve Failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Operational Error', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Operator Error', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Overfill', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Overfills/Spillage', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Overflow', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Overturned', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Past Practices', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Pump Leak', 'Damage to dispenser hose');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Spillage', 'Spill bucket failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Tank Failure', 'Tank damage');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Tank Leak', 'Corrosion');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Transport Accident', 'Motor vehicle accident');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Unattended Nozzle', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Uncontrolled Nozzle', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Unsecured Valve', 'Shear valve failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Valve Leak', 'Shear valve failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Vandalism', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (66, 'Venting', 'Other');

update lust_element_value_mappings set epa_approved = 'Y' where element_db_mapping_id in (64,66);

----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-04-05', 'LUSTStatus', 'LUSTV2', 'LUSTStatus')
returning id;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (67, ''' || "LUSTStatus" ||  ''', '''');'
from "SD_LUST"."LUSTV2"
order by 1;  

delete from lust_element_value_mappings where element_db_mapping_id = 67;
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (67, 'C', 'No further action', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (67, 'I', null, 'Y'); 
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (67, 'NFA', 'No further action', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (67, 'O', 'Active: general', 'Y'); 



select "LUSTStatus", count(*)
from "SD_LUST"."LUSTV2" 
group by "LUSTStatus" order by 1;


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

create or replace view "SD_LUST".v_lust_base as 
select 
	"Facility ID" as "FacilityID", 
	"LUSTID",
	"County",
	case when "State" = 'SOUTH DAKOTA' then 'SD' end as "State",
	"EPARegion"::int as "EPARegion",
	"Latitude",
	"Longitude",
	ls.epa_value as "LUSTStatus",
	"ReportedDate"::date,
	case when "NFADate" = ' ' then null else "NFADate"::date end as "NFADate",
	sr.epa_value as "SubstanceReleased1",
	"QuantityReleased1 (Gallons)" as "QuantityReleased1",
	'Gallons' as "Unit1",
	cr.epa_value as "CauseOfRelease1"
from "SD_LUST"."LUSTV2" l 
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'SD' and element_name =  'LUSTStatus') ls on l."LUSTStatus" = ls.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'SD' and element_name =  'SubstanceReleased1') sr on l."SubstanceReleased1" = sr.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'SD' and element_name =  'CauseOfRelease1') cr on l."CauseOfRelease1" = cr.state_value
order by "Facility ID", "LUSTID";