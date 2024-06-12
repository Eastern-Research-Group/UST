select '	null as "' || element_name || '",'
from ust_elements order by element_position;

select * from "NE_UST".tanks;

select * from "NE_UST".facilities;


--------------------------------------------------------------------------------------------------------
select distinct "Tank Type" from "NE_UST".tanks order by 1;
Federally Regulated
Heating Oil

select "Facility ID", count(*) as cnt from "NE_UST".tanks where "Tank Type" = 'Federally Regulated' group by "Facility ID"

--------------------------------------------------------------------------------------------------------
select distinct "Tank Usage Status" from "NE_UST".tanks order by 1;
Currently in Use
Permanently Out of Use
Temporarily Out of Use

select * from tank_status order by 1;
Abandoned
Closed (general)
Closed (in place)
Closed (removed from ground)
Currently in use
Other
Temporarily out of service
Unknown

select * from ust_element_db_mapping order by 1 desc;

select * from ust_element_value_mappings;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-03-01', 'TankStatus', 'tanks', 'Tank Usage Status');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (108, 'Currently in Use', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (108, 'Permanently Out of Use', 'Closed (general)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (108, 'Temporarily Out of Use', 'Temporarily out of service');

--------------------------------------------------------------------------------------------------------
select distinct "Tank Sec Contain" from "NE_UST".tanks order by 1;
360 Excavation Liner
360 Excavation Liner, Double Walled
Double Walled


select * from ust_element_db_mapping order by 1 desc;

select * from ust_element_value_mappings;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-03-01', 'ExcavationLiner', 'tanks', 'Tank Sec Contain');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (109, '360 Excavation Liner', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (109, '360 Excavation Liner, Double Walled', 'Yes');
--------------------------------------------------------------------------------------------------------
select distinct "Tank Int Prot" from "NE_UST".tanks order by 1;
Double walled
DOUBLE WALLED

select * from ust_element_db_mapping order by 1 desc;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-03-01', 'TankWallType', 'tanks', 'Tank Int Prot');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (110, 'Double walled', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (110, 'DOUBLE WALLED', 'Double');
--------------------------------------------------------------------------------------------------------
select distinct "Tank Constr." from "NE_UST".tanks order by 1;
Composite
Fiberglass Reinforced Plastic
Jacketed
NEW INSTALL
Stainless Steel
Steel
Unknown

select * from material_description order by 1;
Asphalt coated or bare steel
Cathodically protected steel (without coating)
Coated and cathodically protected steel
Composite/clad (steel w/fiberglass reinforced plastic)
Concrete
Epoxy coated steel
Fiberglass reinforced plastic
Jacketed steel
Other
Steel (NEC)
Unknown

select * from ust_element_db_mapping order by 1 desc;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-03-01', 'MaterialDescription', 'tanks', 'Tank Constr.');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (111, 'Composite', 'Composite/clad (steel w/fiberglass reinforced plastic)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (111, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (111, 'Jacketed', 'Jacketed steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (111, 'Stainless Steel', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (111, 'Steel', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (111, 'NEW INSTALL', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
values (111, 'Unknown', 'Unknown');

--------------------------------------------------------------------------------------------------------
select distinct "Piping Const. Material" from "NE_UST".tanks order by 1;


select * from piping_material_description order by 1;


select * from ust_element_db_mapping order by 1 desc;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-03-01', 'PipingMaterialDescription', 'tanks', 'Piping Const. Material');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, '', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'And APT Flex, Fiberglass Reinforced Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'And APT Flex, Fiberglass Reinforced Plastic, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'APT', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'APT Flex pipe', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'APT, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'APT, Fiberglass Reinforced Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'APT, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'APT, Plastic, Steel', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Black pipe coated w/tar & wrapped', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'booted flex, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Booted Scotchcoat', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'coated steel - booted, Fiberglass Reinforced Plastic', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Coated Steel, Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'coated, Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Copper', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'COPPER IN CHASE', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Copper, Fiberglass Reinforced Plastic', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Copper, Fiberglass Reinforced Plastic, Steel', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Copper, Steel', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'CP''d steel to boiler/APT PermaFlex to generator, Plastic, Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'double wall flex, Fiberglass Reinforced Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'double wall flexible pipe, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'double wall flexible piping, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'double walled supply line, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'double walled, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double walled, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double Walled, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'DOUBLE WALLED, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'double walled, Fiberglass Reinforced Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double walled, Fiberglass Reinforced Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double Walled, Fiberglass Reinforced Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'DOUBLE WALLED, Fiberglass Reinforced Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'DOUBLE WALLED, Fiberglass Reinforced Plastic, Steel', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'double walled, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double walled, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double Walled, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'DOUBLE WALLED, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double walled, Plastic, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Double walled, Plastic, Steel', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Douible Walled, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Dual FRP x Steel', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'DW FLEX ADDED 2012, Fiberglass Reinforced Plastic, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Environ DW Hose', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Existing pipe add on, Fiberglass Reinforced Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, FLEX', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Flex connector, Steel', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, FRP - vents / Plastic - product, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, GALVANIZED STEEL', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Plastic, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Plastic, Section replaced with flex plastic in 2011', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Plastic, Siphon lines are FRP / double walled', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Plastic, Two kinds of piping is correct', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, plus APT Flex', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Fiberglass Reinforced Plastic, Steel', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Flex Pipe, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Flexible - double walled, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Flexible, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'galvanized steel', 'Galvanized steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'GALVANIZED STEEL', 'Galvanized steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'galvanized, Steel', 'Galvanized steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Oil drain line', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'OPW-Flex, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'OPW double wall flex works pipe, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'OPW FLEX, Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'OPW Pices, Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Pipe under building is copper, Steel', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'plastic composite - double wall', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Plastic, Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Plastic, Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Plastic, plastic composite - double wall', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Plastic, Steel', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Plastic, STEEL TO GENERATOR', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Plastic, Total Containment Omni Flex Dbl Wall', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'PVC', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'PVC - DOUBLE WALLED', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'scotch coat', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'scotch kote, Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'scotchcoat', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Scotchkote', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Scotchkote, Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Skotchkote', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Steel Coated', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Steel encased in FRP, Unknown', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Steel Isolated', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Steel, steel isolated from soil', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (112, 'UPP', 'Other');
--------------------------------------------------------------------------------------------------------
select distinct "Tank Contents" from "NE_UST".tanks 
order by 1;

select * from piping_material_description order by 1;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-03-01', 'TankSubstanceStored', 'tanks', 'Tank Contents');

select * from ust_element_db_mapping order by 1 desc;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '', '', 'Y');

delete from ust_element_value_mappings where element_db_mapping_id = 114;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, #2 Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->clear', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->dyed', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->DYED', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->dyed diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->Dyed diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->DYED DIESEL', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->OFF ROAD', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Other->RED DYED', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Regular Unleaded', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#1 Diesel, Unknown', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, E-85', ' E-85/Flex Fuel (E51-E83)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, E-95', '95% renewable diesel, 5% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Empty', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Heating Oil 6', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->#2 Dyed Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->15% BIODIESEL', 'Diesel blends containing greater than 5% and up to 20% or less biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->clear', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Clear', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->dyed', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Dyed', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->DYED', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->dyed diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Dyed diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Dyed Diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->DYED DIESEL', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Dyed red', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->field master', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->HALF SAND FILLED 1987', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->OFF ROAD', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->RED', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->roadmaster', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Roadmaster', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Roadmaster diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Roadmaster Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->RUBY CLEAR', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->RUBY DYED', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->Ruby Roadmaster', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Other->with ethanol', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, '#2 Diesel, Regular Unleaded', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Hazard->107-12-1, Other->Ethylene glycol (Antifreeze)', 'Antifreeze', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Hazard->1330-20-7, Other->Xylene (LUBRIZOL 9888)', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Hazard->1330-20-7, Other->Xylene (Ultrazol 9888)', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Hazard->7681-52-9, Other->Sodium Hypochlorite', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Hazard->Ethylhexyl Nitrate 27247-96-7, Other->OTR 8332G', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Hazard->Sodium Hypochlorite', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Hazard->Xylene 1330-20-7, Other->Ultrazol 9888', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->#2 Dyed Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->504 DIESEL', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->AFTRON OTR 8332G', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->AV Gas', 'Aviation gasoline', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->B-11', 'Diesel blends containing greater than 5% and up to 20% or less biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->B-2', 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->B-20', 'Diesel blends containing greater than 5% and up to 20% or less biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->B-99', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->B-99 (Diesel Soy Oil)', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->Clear diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->CLEAR SOY DIESEL', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->DEF', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->Dyed diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->Dyed Diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->DYED DIESEL', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->DYED SOY DIESEL', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->E-0', 'Gasoline (non-ethanol)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->E-100', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->E-15', 'Gasoline E-15 (E-11-E15)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->E-98', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->E-99', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->Hextane', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->Jet A', 'Jet fuel A', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->JET A', 'Jet fuel A', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->MINERAL OIL', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->OFF ROAD DIESEL', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->SOY OIL', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->ULTIMATE UNLEADED', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, ', Other->V grade', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'B-100', '100% biodiesel (not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'B-100, Other->B-99', '100% biodiesel (not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'B-5', 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-10', 'Gasoline E-10 (E1-E10)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-10, Other->Super Unleaded', 'Gasoline E-10 (E1-E10)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-15', 'Gasoline E-15 (E-11-E15)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-85', ' E-85/Flex Fuel (E51-E83)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-85, Mixed', ' E-85/Flex Fuel (E51-E83)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-85, Other->87% ethanol', ' E-85/Flex Fuel (E51-E83)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-85, Other->89% ethanol', ' E-85/Flex Fuel (E51-E83)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-87', 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-89', 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-95', 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-98', 'Racing fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'E-99', 'Racing fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty', '', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Heating Oil 1', 'Heating oil/fuel oil 1', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Heating Oil 2', 'Heating oil/fuel oil 2', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Kerosene', 'Kerosene', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Mixed', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Mixed, Regular Unleaded', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Other->TRANSFORMER OIL', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Regular Unleaded', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Empty, Used Oil', 'Used oil/waste oil', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Hazard->108-88-3, Other->TOLULENE', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Hazard->64742-49-0, Other->HEXANE/Naptha', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Hazard->64742-89-8, Other->TOLU-SOL ''A''', 'Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Heating Oil 1', 'Heating oil/fuel oil 1', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Heating Oil 2', 'Heating oil/fuel oil 2', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Heating Oil 5', 'Heating oil/fuel oil 5', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Heating Oil 6', 'Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Kerosene', 'Kerosene', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Kerosene, Other->WATER', 'Kerosene', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Mixed', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Mixed, Other->HALF SAND FILLED 1987', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Mixed, Regular Unleaded', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Mixed, Used Oil', 'Used oil/waste oil', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'New Oil', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other-># 2 Dyed Diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->#1 Dyed Diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->#2 Dyed diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->#2 Dyed Diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->#2 Dyed Soy Diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->15% BIODIESEL, Regular Unleaded', 'Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->AROMATIC 100 SOLVENT', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->AV Gas', 'Aviation gasoline', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->AvGas', 'Aviation gasoline', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Aviation Fuel', 'Unknown aviation gas or jet fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Aviation Fuel - 100LL', 'Unknown aviation gas or jet fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Aviation Fuel - Jet A', 'Jet fuel A', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Aviation Fuel, Regular Unleaded', 'Aviation gasoline', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Aviation Gas', 'Aviation gasoline', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->B-99', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Biodiesel B-35', 'Diesel blend containing greater than 20% and less than 99% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Boat Gas', 'Marine fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Boat Mix, Regular Unleaded', 'Marine fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->BULK OIL', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->BUTANE', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->CLEANING SOLV. AMSCO 140', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Clear Soy Diesel', 'Biofuel/bioheat', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->CLOSED, Regular Unleaded', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->DEF', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Denatured Alcohol', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Diesel Fuel Waste', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->dyed diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Dyed Soy Diesel', 'Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->E-100', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->E-100, Regular Unleaded', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->E-15, Regular Unleaded', 'Gasoline E-15 (E-11-E15)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->E-24, Regular Unleaded', 'Gasoline/ethanol blends E16-E50', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->E-40', 'Gasoline/ethanol blends E16-E50', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->E-98', 'Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Fuel Oil', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->HALF SAND FILLED 1987, Regular Unleaded', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->High Sulphur', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Jet A', 'Jet fuel A', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Jet Fuel', 'Jet fuel A', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Kerosene', 'Kerosene', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Low Sulphur', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Mineral Oil', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Premixed Boat Gas', 'Marine fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Racing Fuel', 'Racing fuel/leaded gasoline', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Solvent', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->Soy Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->STODDARD SOLVENT', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->unknown', 'Unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Other->WATER, Regular Unleaded', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Premium Unleaded', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Premium Unleaded, Unknown', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Regular Unleaded', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Regular Unleaded, Unknown', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Unknown', 'Unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (114, 'Used Oil', 'Used oil/waste oil', 'Y');

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

drop view  "NE_UST".v_ust_base;

create or replace view "NE_UST".v_ust_base as 
select distinct 
	t."Facility ID" as "FacilityID",
	t."Facility Name" as "FacilityName",
	t."Facility Address" as "FacilityAddress1",
	t."Facility City" as "FacilityCity",
	t."Facility County" as "FacilityCounty",
	t."Facility Zip" as "FacilityZipCode",
	'NE' as "FacilityState",
	'7'::int as "FacilityEPARegion",
	t."Owner Name" as "FacilityOwnerCompanyName",
	t."Owner Address" as "FacilityOwnerAddress1",
	t."Owner City" as "FacilityOwnerCity",
	t."Owner Zip" as "FacilityOwnerZipCode",
	t."Owner State" as "FacilityOwnerState",
	'Yes' as "FinancialResponsibilityTrustFund",
	t."Tank #" as "TankID",
	case when tt.cnt > 0 then 'Yes' else 'No' end as "FederallyRegulated",
	ts.epa_value as "TankStatus",
	t."Tank Installed" as "InstallationDate",
	tss.epa_value as "TankSubstanceStored",
	t."Tank Size" as "TankCapacityGallons",
	el.epa_value as "ExcavationLiner",
	wt.epa_value as "TankWallType",
	md.epa_value as "MaterialDescription",
	pmd.epa_value as "PipingMaterialDescription",
	case when lower(t."Piping Const. Material") like '%double%'	then 'Double walled' end as "PipingWallType",
	case when lower(t."Tank Ext Prot") like '%sacrificial%' then 'Yes' end as "TankCorrosionProtectionSacrificialAnode",
	case when lower(t."Tank Ext Prot") like '%sacrificial%' then 'Unknown' end as "TankCorrosionProtectionSacrificialAnodeInstalledOrRetrofitted",
    case when lower(t."Tank Ext Prot") like '%impressed%' then 'Yes' end as "TankCorrosionProtectionImpressedCurrent",
	case when lower(t."Tank Ext Prot") like '%impressed%' then 'Unknown' end as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted"
from "NE_UST".tanks t left join "NE_UST".facilities f on t."Facility ID" = f."Facility ID"
	left join (select "Facility ID", count(*) as cnt from "NE_UST".tanks
	           where "Tank Type" = 'Federally Regulated' group by "Facility ID") tt on t."Facility ID" = tt."Facility ID"
	left join (select state_value, epa_value from v_ust_element_mapping where organization_id = 'NE' and element_name = 'TankStatus') ts 
		on t."Tank Usage Status" = ts.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where organization_id = 'NE' and element_name = 'ExcavationLiner') el 
		on t."Tank Sec Contain" = el.state_value	    
	left join (select state_value, epa_value from v_ust_element_mapping where organization_id = 'NE' and element_name = 'TankWallType') wt
		on t."Tank Int Prot" = wt.state_value	    
	left join (select state_value, epa_value from v_ust_element_mapping where organization_id = 'NE' and element_name = 'MaterialDescription') md
		on t."Tank Constr." = md.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping where organization_id = 'NE' and element_name = 'PipingMaterialDescription') pmd
		on t."Piping Const. Material" = pmd.state_value			
	left join (select state_value, epa_value from v_ust_element_mapping where organization_id = 'NE' and element_name = 'TankSubstanceStored') tss
		on t."Tank Contents" = tss.state_value;	
		
select * from "NE_UST".v_ust_base order by "FacilityID", "TankID";	

select * from "NE_UST"."tanks" 

      

select element_name, state_value, epa_value
from  v_ust_element_mapping where state = 'NE'
order by 1, 2, 3;

select * from material_description order by 1;