------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table dc_ust.erg_tank_id
create table dc_ust.erg_tank_id (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity);

--Populate table dc_ust.erg_tank_id
insert into dc_ust.erg_tank_id (facility_id, tank_name)
select distinct "FacilityID"::varchar(50), "TankID"::varchar(50)
from dc_ust."tank";

--Record new mapping in public.ust_element_mapping
--ust_tank.tank_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (30, 'ust_tank', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'tank', 'FacilityID', 'facility_id', 'TankID', 'tank_name', NULL, NULL);

--ust_tank_substance.tank_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (30, 'ust_tank_substance', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--ust_compartment.tank_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (30, 'ust_compartment', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--ust_piping.tank_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (30, 'ust_piping', 'tank_id', 'erg_tank_id', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'piping', 'TankID', NULL, NULL, NULL, NULL, NULL);

