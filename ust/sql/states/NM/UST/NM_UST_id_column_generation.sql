------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table nm_ust.erg_compartment_id
create table nm_ust.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table nm_ust.erg_compartment_id

insert into nm_ust.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct "FACILITY_ID"::varchar(50), null, "TANK_ID"::int, null from nm_ust."Info";

--Record new mapping in public.ust_element_mapping
--ust_compartment.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (39, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'Info', 'FACILITY_ID', 'facility_id', 'TANK_ID', 'tank_id', NULL, NULL);

--ust_piping.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (39, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table nm_ust.erg_piping_id
create table nm_ust.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table nm_ust.erg_piping_id

insert into nm_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct facility_id, tank_name, tank_id, null, compartment_id from nm_ust.erg_compartment_id;

--Record new mapping in public.ust_element_mapping
--ust_piping.piping_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (39, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
'erg_compartment_id', 'facility_id', 'facility_id', 'tank_id', 'tank_id', 'compartment_id', 'compartment_id');

