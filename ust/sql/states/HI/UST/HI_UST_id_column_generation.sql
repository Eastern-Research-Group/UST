------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table hi_ust.erg_tank_id

create table hi_ust.erg_tank_id (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);

--Populate table hi_ust.erg_tank_id

insert into hi_ust.erg_tank_id (facility_id, tank_name)
select distinct "FacilityID"::varchar(50), "TankID"::varchar(50)
from hi_ust."tank";

--Record new mapping in public.ust_element_mapping

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'tank', 'FacilityID', 'facility_id', 'TankID', 'tank_name', NULL, NULL);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_tank_substance', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'compartment', 'TankID', NULL, NULL, NULL, NULL, NULL);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_tank_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'piping', 'TankID', NULL, NULL, NULL, NULL, NULL);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_compartment_dispenser', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table hi_ust.erg_compartment_id

create table hi_ust.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table hi_ust.erg_compartment_id

insert into hi_ust.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct facility_id, tank_name, tank_id, null
from hi_ust.erg_tank_id;

--Record new mapping in public.ust_element_mapping

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'erg_tank_id', 'facility_id', 'facility_id', 'tank_id', 'tank_id', NULL, NULL);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_compartment_dispenser', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table hi_ust.erg_piping_id

create table hi_ust.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table hi_ust.erg_piping_id

insert into hi_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from hi_ust.erg_compartment_id;

--Record new mapping in public.ust_element_mapping

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, 
 programmer_comments, organization_join_table,
 organization_join_column, organization_join_column2, organization_join_column3,
 organization_join_fk, organization_join_fk2, organization_join_fk3)
 
values (24, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
'erg_compartment_id', 'facility_id', 'facility_id', 'tank_id', 'tank_id', 'compartment_id', 'compartment_id');

