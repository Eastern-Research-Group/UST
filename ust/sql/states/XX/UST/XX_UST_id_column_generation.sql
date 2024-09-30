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
 organization_table_name, organization_column_name, programmer_comments,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Tanks', NULL, 'facility_id', 'tank_name', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL);

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
'Tanks', 'Tanks', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
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
'Tanks', 'Tanks', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, 'facility_id', NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'Facility Id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_dispenser_id

create table example.erg_dispenser_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity);

--Populate table example.erg_dispenser_id

insert into example.erg_dispenser_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'dispenser_id', 'erg_dispenser_id', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'Facility Id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', NULL, NULL, NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_dispenser_id

create table example.erg_dispenser_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity);

--Populate table example.erg_dispenser_id

insert into example.erg_dispenser_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'dispenser_id', 'erg_dispenser_id', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', NULL, NULL, NULL, 'facility_id', 'tank_id', NULL);

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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', NULL, NULL, NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_dispenser_id

create table example.erg_dispenser_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity);

--Populate table example.erg_dispenser_id

insert into example.erg_dispenser_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'dispenser_id', 'erg_dispenser_id', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', NULL, NULL, NULL, 'facility_id', 'tank_id', NULL);

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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'Facility Id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_dispenser_id

create table example.erg_dispenser_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity);

--Populate table example.erg_dispenser_id

insert into example.erg_dispenser_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'dispenser_id', 'erg_dispenser_id', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'Facility Id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', NULL, NULL, NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_dispenser_id

create table example.erg_dispenser_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity);

--Populate table example.erg_dispenser_id

insert into example.erg_dispenser_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'dispenser_id', 'erg_dispenser_id', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', NULL, NULL, NULL, 'facility_id', 'tank_id', NULL);

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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_dispenser_id

create table example.erg_dispenser_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity);

--Populate table example.erg_dispenser_id

insert into example.erg_dispenser_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'dispenser_id', 'erg_dispenser_id', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

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
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

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

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_dispenser_id

create table example.erg_dispenser_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity);

--Populate table example.erg_dispenser_id

insert into example.erg_dispenser_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'dispenser_id', 'erg_dispenser_id', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_compartment_id

create table example.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table example.erg_compartment_id

insert into example.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from example.erg_tank_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_compartment_id', 'tank_id', 'Row inserted automatically to map a required field from a child table.',
'erg_tank_id', 'facility_id', 'tank_id', NULL, 'facility_id', 'tank_id', NULL);

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
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

delete from example.ust_element_mapping
 
where ust_control_id = 1 and epa_table_name = 'ust_compartment' and epa_column_name = 'tank_id';

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table example.erg_piping_id

create table example.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table example.erg_piping_id

insert into example.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from example.erg_compartment_id;

--Record new mapping in example.ust_element_mapping

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
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
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (1, 'ust_compartment_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', NULL, 'facility_id', 'tank_name', NULL);

