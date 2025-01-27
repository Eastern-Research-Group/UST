------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table me_ust.erg_piping_id
create table me_ust.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table me_ust.erg_piping_id

insert into me_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct "REGISTRATION NUMBER"::varchar(50), null, "TANK NUMBER"::int, null, "CHAMBER ID"::int from me_ust."tanks";

--Record new mapping in public.ust_element_mapping
--ust_piping.piping_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (31, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table me_ust.erg_piping_id
create table me_ust.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table me_ust.erg_piping_id

insert into me_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct "REGISTRATION NUMBER"::varchar(50), null, "TANK NUMBER"::int, null, "CHAMBER ID"::int from me_ust."tanks";

--Record new mapping in public.ust_element_mapping
--ust_piping.piping_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (31, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

