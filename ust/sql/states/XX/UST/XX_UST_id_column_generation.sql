------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_tank_id

create table example.erg_tank_id (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);

--Populate table example.erg_tank_id

insert into example.erg_tank_id (facility_id, tank_name)
select distinct "Facility Id"::varchar(50), "Tank Name"::varchar(50)
from example."Tanks";

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', NULL, 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_substance', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', NULL, 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', NULL, 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', NULL, 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', NULL, 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', NULL, 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_tank_id

create table example.erg_tank_id (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);

--Populate table example.erg_tank_id

insert into example.erg_tank_id (facility_id, tank_name)
select distinct "Facility Id"::varchar(50), "Tank Name"::varchar(50)
from example."Tanks";

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_substance', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_tank_id

create table example.erg_tank_id (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);

--Populate table example.erg_tank_id

insert into example.erg_tank_id (facility_id, tank_name)
select distinct "Facility Id"::varchar(50), "Tank Name"::varchar(50)
from example."Tanks";

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_substance', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_tank_id

create table example.erg_tank_id (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);

--Populate table example.erg_tank_id

insert into example.erg_tank_id (facility_id, tank_name)
select distinct "Facility Id"::varchar(50), "Tank Name"::varchar(50)
from example."Tanks";

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_substance', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_tank_id

create table example.erg_tank_id (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);

--Populate table example.erg_tank_id

insert into example.erg_tank_id (facility_id, tank_name)
select distinct "Facility Id"::varchar(50), "Tank Name"::varchar(50)
from example."Tanks";

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'facility_id', 'Tank Name', 'tank_name', NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_substance', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Tank Name', NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Tank Name', NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Dispensers', 'Tank name', NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tank Piping', 'Tank Name', NULL, NULL, NULL, NULL, NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

