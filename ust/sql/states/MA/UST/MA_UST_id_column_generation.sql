------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table ma_ust.erg_compartment_id
create table ma_ust.erg_compartment_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity);

--Populate table ma_ust.erg_compartment_id

insert into ma_ust.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select
	a."Facility ID#"::varchar(50),
	null,
	a."TANK ID#"::int,
	null
from ma_ust."Tank info" a
where not exists (
	select 1
	from ma_ust.erg_unregulated_tanks unreg
	where a."Facility ID#"::varchar(50) = unreg.facility_id
	  and a."TANK ID#"::int = unreg.tank_id
)
order by a."Facility ID#"::varchar(50), a."TANK ID#"::int, a.ctid;

--Record new mapping in public.ust_element_mapping
--ust_compartment.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (42, 'ust_compartment', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'Tank info', 'Facility ID#', 'facility_id', 'TANK ID#', 'tank_id', NULL, NULL);

--ust_piping.compartment_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (42, 'ust_piping', 'compartment_id', 'erg_compartment_id', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.',
'Tank info', 'TANK ID#', NULL, NULL, NULL, NULL, NULL);

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table ma_ust.erg_piping_id

drop view ma_ust.v_ust_piping;

drop table ma_ust.erg_piping_id 
create table ma_ust.erg_piping_id 
(facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table ma_ust.erg_piping_id


insert into ma_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select facility_id, tank_name, tank_id, null, compartment_id from ma_ust.erg_compartment_id;

--Record new mapping in public.ust_element_mapping
--ust_piping.piping_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (42, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
'erg_compartment_id', 'facility_id', 'facility_id', 'tank_id', 'tank_id', 'compartment_id', 'compartment_id');

