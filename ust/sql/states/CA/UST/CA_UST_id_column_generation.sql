
------------------------------------------------------------------------------------------------------------------------------------
--Create table ca_ust.erg_tank_id2

create table ca_ust.erg_tank_id2 (facility_id varchar(50), tank_name varchar(200), tank_id int generated always as identity);

--Populate table ca_ust.erg_tank_id2

insert into ca_ust.erg_tank_id2 (facility_id, tank_name) select distinct "CERS ID"::varchar(50), "CERS TankID"::varchar(200) from ca_ust."tank";

--Record new mapping in public. ust_element_mapping

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_column_name, organization_table_name, programmer_comments)
		          values (18, 'ust_tank', 'tank_id', 'erg_tank_id2', 'tank_id', 'This required field is not present in the source data. Table erg_tank_id2 was created by ERG so the data can conform to the EPA template structure.');


------------------------------------------------------------------------------------------------------------------------------------
--Create table ca_ust.erg_compartment_id2

create table ca_ust.erg_compartment_id2 (facility_id varchar(50), tank_name varchar(200), tank_id int, compartment_name varchar(200), compartment_id int generated always as identity)

--Populate table ca_ust.erg_compartment_id2

insert into ca_ust.erg_compartment_id2 (facility_id, tank_name, tank_id, compartment_name) select distinct facility_id, tank_name, tank_id, null from ca_ust.erg_tank_id

--Record new mapping in public.ust_element_mapping

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
  values (18, 'ust_compartment', 'compartment_id', 'erg_compartment_id2', 'compartment_id', 'This required field is not present in the source data. Table erg_compartment_id2 was created by ERG so the data can conform to the EPA template structure.')


------------------------------------------------------------------------------------------------------------------------------------
--Create table ca_ust.erg_piping_id2


------------------------------------------------------------------------------------------------------------------------------------
--Create table ca_ust.erg_dispenser_id2


------------------------------------------------------------------------------------------------------------------------------------
--Create table ca_ust.erg_piping_id2

create table ca_ust.erg_piping_id2 (facility_id varchar(50), tank_name varchar(200), tank_id int, compartment_name varchar(200), compartment_id int, piping_id int generated always as identity)

--Populate table ca_ust.erg_piping_id2

insert into ca_ust.erg_piping_id2 (facility_id, tank_name, tank_id, compartment_name, compartment_id) select distinct facility_id, tank_name, tank_id, null, compartment_id from ca_ust.erg_compartment_id

--Record new mapping in public.ust_element_mapping

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
  values (18, 'ust_piping', 'piping_id', 'erg_piping_id2', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id2 was created by ERG so the data can conform to the EPA template structure.')


------------------------------------------------------------------------------------------------------------------------------------
--Create table ca_ust.erg_dispenser_id2


------------------------------------------------------------------------------------------------------------------------------------
--Create table ca_ust.erg_dispenser_id2

create table ca_ust.erg_dispenser_id2 (facility_id varchar(50), tank_name varchar(200), tank_id int, compartment_name varchar(200), compartment_id int, dispenser_id int generated always as identity)

--Populate table ca_ust.erg_dispenser_id2

insert into ca_ust.erg_dispenser_id2 (facility_id, tank_name, tank_id, compartment_name, compartment_id) select distinct facility_id, tank_name, tank_id, null, compartment_id from ca_ust.erg_compartment_id

--Record new mapping in public.ust_element_mapping

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
  values (18, 'ust_compartment_dispenser', 'dispenser_id', 'erg_dispenser_id2', 'dispenser_id', 'This required field is not present in the source data. Table erg_dispenser_id2 was created by ERG so the data can conform to the EPA template structure.')

