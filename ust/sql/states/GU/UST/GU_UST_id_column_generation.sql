------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table gu_ust.erg_compartment_id
create table gu_ust.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table gu_ust.erg_compartment_id

insert into gu_ust.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct "FacilityID"::varchar(50), "TankName"::varchar(50), "TankID"::int, null from gu_ust."Tank";

--Record new mapping in public.ust_element_mapping
--ust_compartment.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (38, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'Compartment', 'FacilityID', 'facility_id', 'TankID', 'tank_id', 'CompartmentID', NULL);

--ust_piping.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (38, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'Piping', 'CompartmentID', NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table gu_ust.erg_compartment_id
create table gu_ust.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table gu_ust.erg_compartment_id

insert into gu_ust.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct "FacilityID"::varchar(50), "TankName"::varchar(50), "TankID"::int, null from gu_ust."Tank";

--Record new mapping in public.ust_element_mapping
--ust_compartment.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (38, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'Compartment', 'FacilityID', 'facility_id', 'TankID', 'tank_id', 'CompartmentID', NULL);

--ust_piping.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (38, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'Piping', 'CompartmentID', NULL, NULL, NULL, NULL, NULL);

