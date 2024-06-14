select * from ust_control;

select * from ust_element_mapping where ust_control_id = 8

select * from ust_element_value_mapping 
where ust_element_mapping_id = 55

select * from v_ust_element_mapping
where organization_id = 'VA' 
and epa_column_name like '%fuel%'
order by ;

select distinct contents from va_ust.tanks order by 1;

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (' || 55 || ', ''' || contents || ''', '''');'
from va_ust.tanks 
order by 1;
 
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where element_name like '%Substance%'
and lower(state_value) like '%jet%'
order by 1, 2;

select * from substances order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'ASPHALT', 'Other');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'DIESEL', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'DIESEL BIODIESEL', 'Biofuel/bioheat');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'DIESEL LOW SULFUR', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'DIESEL OFF-ROAD', 'Off-road diesel/dyed diesel');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'DIESEL ON-ROAD', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'DIESEL ULTRA LOW SULFUR', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'EMER GENERATOR', 'Heating/fuel oil # unknown');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'FUEL OIL', 'Heating/fuel oil # unknown');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'FUEL OIL 2', 'Heating oil/fuel oil 2');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'FUEL OIL 6', 'Heating oil/fuel oil 6');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE', 'Gasoline (unknown type)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE AVIATION GAS', 'Aviation gasoline');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE E85', 'E-85/Flex Fuel (E51-E83)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE GASOHOL', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE MID', 'Gasoline (unknown type)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'Gasoline Non Ethanol', 'Gasoline (unknown type)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE PREMIUM', 'Gasoline (unknown type)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE RACING', 'Racing fuel');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'GASOLINE REGULAR', 'Gasoline (unknown type)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'HAZARDOUS', 'Hazardous substance');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'HEATING OIL', 'Heating/fuel oil # unknown');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'HYDRAULIC OIL', 'Lube/motor oil (new)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'JET FUEL', 'Jet fuel A');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'KEROSENE', 'Kerosene');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'KEROSENE CLEAR', 'Kerosene');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'KEROSENE DYED', 'Kerosene');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'LUBE OIL', 'Lube/motor oil (new)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'MIXTURE', 'Other or mixture');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'MOTOR OIL', 'Lube/motor oil (new)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'OTHER', 'Other or mixture');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'UNKNOWN', 'Unknown');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (55, 'USED OIL', 'Used oil/waste oil');

select epa_value from ust_element_value_mapping
where ust_element_mapping_id = 55 and epa_value not in   
	(select substance from substances)
order by 1;

select substance
from substances 
where lower(substance) like '%other%'
order by 1;

update ust_element_value_mapping set epa_value = 'Other or mixture'
where ust_element_mapping_id = 55 and epa_value = 'Other';

select epa_table_name, epa_column_name  
from v_ust_available_mapping
where ust_control_id = 8 order by 1, 2;

select * from ust_element_mapping where ust_control_id = 8;

update ust_element_mapping set epa_column_name = 'facility_type'
where epa_column_name = 'facility_type_id1';

select database_lookup_table, epa_column_name
from v_ust_available_mapping where ust_control_id = 8;


select epa_table_name, epa_column_name 
from ust_element_mapping 
where ust_control_id = 8 and epa_column_name like '%_id'
order by 1, 2;

--update ust_element_mapping 
--set epa_table_name = 'compartment_statuses',
--	epa_column_name = 'compartment_status'
--where ust_control_id = 8 and epa_column_name = 'compartment_status_id';
--update ust_element_mapping 
--set epa_table_name = 'substances',
--	epa_column_name = 'substance'
--where ust_control_id = 8 and epa_column_name = 'substance_id';
--update ust_element_mapping 
--set epa_table_name = 'owner_types',
--	epa_column_name = 'owner_type'
--where ust_control_id = 8 and epa_column_name = 'owner_type_id';
--update ust_element_mapping 
--set epa_table_name = 'piping_styles',
--	epa_column_name = 'piping_style'
--where ust_control_id = 8 and epa_column_name = 'piping_style_id';
--update ust_element_mapping 
--set epa_table_name = 'tank_statuses',
--	epa_column_name = 'tank_status'
--where ust_control_id = 8 and epa_column_name = 'tank_status_id';


select 'update ust_element_mapping set epa_table_name = ''' || table_name || ''', epa_column_name = ''' || 
	database_column_name || ''' where ust_element_mapping_id = ' || ust_element_mapping_id || ';'
from 
	(select ust_element_mapping_id, epa_table_name, epa_column_name, database_column_name, table_name
	from ust_element_mapping a join ust_elements b on a.epa_table_name = b.database_lookup_table
		join ust_elements_tables c on b.element_id = c.element_id) x

update ust_element_mapping set epa_table_name = 'ust_facility', epa_column_name = 'owner_type_id' where ust_element_mapping_id = 7;
update ust_element_mapping set epa_table_name = 'ust_facility', epa_column_name = 'owner_type_id' where ust_element_mapping_id = 2;
update ust_element_mapping set epa_table_name = 'ust_compartment', epa_column_name = 'substance_id' where ust_element_mapping_id = 55;
update ust_element_mapping set epa_table_name = 'ust_tank', epa_column_name = 'tank_location_id' where ust_element_mapping_id = 3;
update ust_element_mapping set epa_table_name = 'ust_tank', epa_column_name = 'tank_status_id' where ust_element_mapping_id = 31;
update ust_element_mapping set epa_table_name = 'ust_piping', epa_column_name = 'piping_style_id' where ust_element_mapping_id = 59;
		
		

