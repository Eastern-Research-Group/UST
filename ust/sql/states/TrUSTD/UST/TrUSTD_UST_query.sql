
select * from v_ust_element_mapping where organization_id = 'TRUSTD';

select * from ust_control where organization_id = 'TRUSTD';

insert into ust_control(organization_id, date_received, date_processed, data_source, comments)
values ('TRUSTD','2023-07-21','2023-07-21','TrUSTD Oracle database on EPA server','exported required tables using Python script; redoing for OUST performance measures due to too many rows');



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 left join (select land_location_id, land_use_type_desc from 
				(select a.land_location_id, b.land_use_type_desc,
					row_number() over (partition by a.land_location_id order by a.date_observed) rn 
			     from "TRUSTD_UST".ut_land_use_hist a join "TRUSTD_UST".ut_land_use_type b on a.land_use_type_id = b.land_use_type_id
			     where a.end_date is null) w where rn = 2) luh2 on ll.land_location_id = luh2.land_location_id

select land_location_id , count(*)
from "TRUSTD_UST".ut_land_use_hist 
where end_date is null 	     
group by land_location_id having count(*) > 1;			     

select b.land_use_type_desc, a.* 
from "TRUSTD_UST".ut_land_use_hist  a join "TRUSTD_UST".ut_land_use_type b on a.land_use_type_id = b.land_use_type_id
where land_location_id in  
	(select land_location_id from "TRUSTD_UST".ut_land_use_hist 
	where end_date is null 	     
	group by land_location_id having count(*) > 1)
and end_date is null order by land_location_id ;
--there are very few facilities with multiple current land uses, and of those few, many are actually both the same (gas station usually) so not going to do a FacilityType2


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Views to combine multiple columns or deagg delimited columns:

create or replace view "TRUSTD_UST".v_most_recent_land_use_type as
select b.land_location_id, b.land_use_type_id 
from 
	(select land_location_id, max(coalesce(date_observed,'2023-01-01')) as date_observed from "TRUSTD_UST".ut_land_use_hist 
	where end_date is null group by land_location_id) a 
	join "TRUSTD_UST".ut_land_use_hist b 
		on a.land_location_id = b.land_location_id 
			and coalesce(a.date_observed,'2023-01-01') = coalesce(b.date_observed,'2023-01-01')
			and b.end_date is null;

create or replace view "TRUSTD_UST".v_ut_tank_system as 
select b.* from 
(select facility_id, tank_name, max(coalesce(date_installed,current_date::text)) date_installed 
from "TRUSTD_UST".ut_tank_system group by facility_id, tank_name) a join "TRUSTD_UST".ut_tank_system b  
	on a.facility_id = b.facility_id and a.tank_name = b.tank_name and a.date_installed = coalesce(b.date_installed,current_date::text);	
		
create or replace view "TRUSTD_UST".v_tank_status as 
select distinct facility_id, tank_name, 
	case when tank_status = 'Permanently Out of Use' then 
		case when closure_status_desc in ('Tank closed in place','Tank removed','Tank removed from ground') then closure_status_desc end 
	else tank_status end as tank_status
from "TRUSTD_UST".v_ut_tank_system ;

drop view "TRUSTD_UST".v_tank_attributes cascade;
create or replace view "TRUSTD_UST".v_tank_attributes as 
select tank_system_id, ut_tank_attribute_type_id
from "TRUSTD_UST".v_ut_tank_system, unnest(string_to_array(tank_attributes, ':')) ut_tank_attribute_type_id;

drop view "TRUSTD_UST".v_piping_attributes cascade;
create view "TRUSTD_UST".v_piping_attributes as 
select tank_system_comp_id, ut_piping_attribute_type_id
from "TRUSTD_UST".ut_tank_system_comp, unnest(string_to_array(piping_attributes, ':')) ut_piping_attribute_type_id;

drop view "TRUSTD_UST".v_overfill_protections cascade;
create view "TRUSTD_UST".v_overfill_protections as 
select tank_system_comp_id, ut_overfill_protection_type_id
from "TRUSTD_UST".ut_tank_system_comp, unnest(string_to_array(overfill_protections, ':')) ut_overfill_protection_type_id;

drop view "TRUSTD_UST".v_piping_deliveries cascade;
create view "TRUSTD_UST".v_piping_deliveries as 
select tank_system_comp_id, ut_piping_delivery_type_id
from "TRUSTD_UST".ut_tank_system_comp, unnest(string_to_array(piping_deliveries, ':')) ut_piping_delivery_type_id;

drop view "TRUSTD_UST".v_tank_release_detections cascade;
create view "TRUSTD_UST".v_tank_release_detections as 
select tank_system_comp_id, ut_release_detection_type_id
from "TRUSTD_UST".ut_tank_system_comp, unnest(string_to_array(tank_release_detections, ':')) ut_release_detection_type_id;

drop view "TRUSTD_UST".v_pipe_release_detections cascade;
create view "TRUSTD_UST".v_pipe_release_detections as 
select tank_system_comp_id, ut_pipe_release_detection_type_id
from "TRUSTD_UST".ut_tank_system_comp, unnest(string_to_array(pipe_release_detections, ':')) ut_pipe_release_detection_type_id;

drop view "TRUSTD_UST".v_substances cascade;
create view "TRUSTD_UST".v_substances as 
select tank_system_comp_id, ut_substance_type_id
from "TRUSTD_UST".ut_tank_system_comp, unnest(string_to_array(substances, ':')) ut_substance_type_id;

create or replace view "TRUSTD_UST".v_compartments as
select tank_system_id, num_compartments, case when compartmentalized is not null or num_compartments > 1 then 'Yes' end as compartmentalized
from 
	(select a.tank_system_id, case when b.tank_system_id is not null then 'Yes' end as compartmentalized, num_compartments
	from (select tank_system_id, count(*) as num_compartments from "TRUSTD_UST".ut_tank_system_comp group by tank_system_id) a 
		left join 
		(select tank_system_id 
		 from "TRUSTD_UST".v_tank_attributes x 
		 	join "TRUSTD_UST".ut_tank_attribute_type y on x.ut_tank_attribute_type_id::int = y.ut_tank_attribute_type_id
		 where ut_tank_attribute_desc = 'Compartmentalized') b on a.tank_system_id = b.tank_system_id) c;

 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column)
values (18, '2023-03-28', 'OwnerType', 'ut_land_use_type', 'land_use_type_desc', 'v_most_recent_land_use_type', 'land_use_type_id')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, ''' || land_use_type_desc ||  ''', '''');'
from "TRUSTD_UST".ut_land_use_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Aircraft Owner', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Auto Dealership', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Casino', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Commercial', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Commercial Airport or Airline', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Contractor', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Farm', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Federal Military', 'Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Federal Non-Military', 'Federal Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Gas Station', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Hospital', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Industrial', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Local Government', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Marina', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Petroleum Distributor', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Private', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Railroad', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'State Government', 'State Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Truck/Transporter', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (306, 'Utilities', 'Commercial');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column)
values (18, '2023-03-28', 'FacilityType1', 'ut_land_use_type', 'land_use_type_desc', 'v_most_recent_land_use_type', 'land_use_type_id')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, ''' || land_use_type_desc ||  ''', '''');'
from "TRUSTD_UST".ut_land_use_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Aircraft Owner', 'Aviation/airport');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Auto Dealership', 'Auto dealership/auto maintenance & repair');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Casino', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Commercial', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Commercial Airport or Airline', 'Aviation/airport');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Contractor', 'Contractor');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Farm', 'Agricultural/farm');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Federal Military', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Federal Non-Military', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Gas Station', 'Retail fuel sales');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Hospital', 'Hospital');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Industrial', 'Industrial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Local Government', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Marina', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Not Listed', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Petroleum Distributor', 'Bulk plant storage/petroleum distributor');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Private', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Railroad', 'Railroad');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Residential', 'Residential');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'School', 'School');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'State Government', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Truck/Transporter', 'Trucking/transport/fleet operation');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (307, 'Utilities', 'Utility');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column)
values (18, '2023-03-28', 'FacilityCoordinateSource', 'ut_land_location', 'lat_lon_source', null,  null)
returning 'select distinct
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, ''' || lat_lon_source || ''', '''');'
from "TRUSTD_UST".ut_land_location order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'Estimated', 'Map interpolation');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'Geocode', 'Geocoded address');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'GPS_EPA', 'GPS');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'GPS_State', 'GPS');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'GPS_Tribe', 'GPS');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'Legacy Verified', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'OnlineMapGoogle', 'Map interpolation');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'OnlineMapMS', 'Map interpolation');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'Site Assessment Report by MCE Environmental dated 2/12/2003', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'Trimble, collected 5/3/2010', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'Trimble, collected 5/4/2010', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (313, 'Trimble, collected 5/5/2010', 'Other');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column)
values (18, '2023-03-28', 'TankStatus', 'v_tank_status', 'tank_status', null,  null)
returning 'select distinct
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (315, ''' || tank_status || ''', '''');'
from "TRUSTD_UST".v_tank_status order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (315, 'Abandoned', 'Abandoned');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (315, 'Currently in Use', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (315, 'Tank closed in place', 'Closed (in place)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (315, 'Tank removed', 'Closed (removed from ground)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (315, 'Tank removed from ground', 'Closed (removed from ground)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (315, 'Temporarily Out of Use', 'Temporarily out of service');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'ManifoldedTanks', 'ut_tank_attribute_type', 'ut_tank_attribute_type_desc', 'v_tank_attributes', 'tank_attribute', 'ut_tank_attribute_type_id')
returning 'select distinct
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (318, '13', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'CompartmentSubstanceStored', 'ut_substance_type', 'ut_substance_desc', 'v_substances', 'substance', 'ut_substance_type_id')
returning 'select distinct
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, ''' || ut_substance_desc || ''', '''');'
from "TRUSTD_UST".ut_substance_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, '0% ethanol', 'Gasoline (non-ethanol)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Av Gas', 'Aviation gasoline');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (319, 'Biodiesel', '100% biodiesel (not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Biodiesel (B10)', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Diesel Containing >20% Biodiesel', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (319, 'Diesel Exhaust Fluid', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Gasohol', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Gasohol 10% or less', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Gasoline (containing <=10% ethanol)', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Gasoline Containing >10% Ethanol', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Gasoline/Diesel (Legacy)', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Hazardous Substance', 'Hazardous substance');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Heating Oil', 'Heating/fuel oil # unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Hydraulic Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Jet A', 'Jet fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Jet B', 'Jet fuel B');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Jet Fuel', 'Jet Fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'JP-4', 'Jet Fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'JP-8', 'Jet Fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Kerosene', 'Kerosene');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Mineral Oil (Transformer Oil)', 'Solvent');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Mixture Of Substances', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Motor Oil (New)', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Stove Oil', 'Heating/fuel oil # unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Unknown Petroleum', 'Petroleum product');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (319, 'Used Oil', 'Used oil/waste oil');

select * from substances ;

select * from "TRUSTD_UST".ut_substance_type ;

select * from ust_element_value_mappings

select distinct state_value, epa_value from  v_ust_element_mapping 
where element_name like '%Substance%' and lower(state_value) like '%mix%'
order by 1, 2;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'ExcavationLiner', 'ut_tank_attribute_type', 'ut_tank_attribute_desc', 'v_tank_attributes', 'tank_attribute', 'ut_tank_attribute_type_id')
returning 'select distinct
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (320, ''' || ut_tank_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_tank_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (320, 'Excavation Liner', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'TankWallType', 'ut_tank_attribute_type', 'ut_tank_attribute_desc', 'v_tank_attributes', 'tank_attribute', 'ut_tank_attribute_type_id')
returning 'select distinct
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_tank_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (321, ''' || ut_tank_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_tank_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (321, 'Double Walled', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (321, 'Triple Walled', 'Triple');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (321, 'Single Walled', 'Single');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'MaterialDescription', 'ut_tank_attribute_type', 'ut_tank_attribute_desc', 'v_tank_attributes', 'tank_attribute', 'ut_tank_attribute_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_tank_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, ''' || ut_tank_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_tank_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Asphalt Coated Or Bare Steel', 'Asphalt coated or bare steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Composite (steel clad with noncorrodible material)', 'Composite/Cclad (steel w/fiberglass reinforced plastic)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Concrete', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Epoxy Coated Steel (Legacy)', 'Epoxy coated steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Coated and Cathodically Protected Steel (impressed current)', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Coated and Cathodically Protected Steel (sacrificial anodes)', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Noncorrodible Tank Jacket', 'Jacketed steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (322, 'Unknown', 'Unknown');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'PipingMaterialDescription', 'ut_piping_attribute_type', 'ut_piping_attribute_desc', 'v_piping_attributes', 'piping_attribute', 'ut_piping_attribute_type_id')
returning 'select distinct
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_piping_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, ''' || ut_piping_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_piping_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'Bare Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'Galvanized Steel', 'Galvanized steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'Flexible Plastic', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'Copper', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (323, 'No Piping (Legacy)', 'No piping');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'PipingStyle', 'ut_piping_delivery_type', 'ut_piping_delivery_desc', 'v_piping_deliveries', 'piping_delivery', 'ut_piping_delivery_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_piping_delivery_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, ''' || ut_piping_delivery_desc || ''', '''');'
from "TRUSTD_UST".ut_piping_delivery_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'Safe Suction (no valve at tank)', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'U.S. Suction (valve at tank)', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'Pressure', 'Pressure');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'Gravity Feed', 'Non-operational ( e.g., fill line, vent line, gravity)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'Above Ground (Not Regulated)', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'Not Listed', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'Unknown (Legacy)', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (324, 'Suction (unspecified)', 'Suction');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'PipingWallType', 'ut_piping_attribute_type', 'ut_piping_attribute_desc', 'v_piping_attributes', 'piping_attribute', 'ut_piping_attribute_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_piping_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (325, ''' || ut_piping_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_piping_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (325, 'Double Walled', 'Double walled');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'PipingRepaired', 'ut_tank_system_comp', 'pipe_repaired', null, null, null)
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (326, ''' || pipe_repaired || ''', '''');'
from "TRUSTD_UST".ut_tank_system_comp order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (326, False::text, 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (326, True::text, 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'TankCorrosionProtectionImpressedCurrent', 'ut_tank_attribute_type', 'ut_tank_attribute_desc', 'v_tank_attributes', 'tank_attribute', 'ut_tank_attribute_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_tank_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (327, ''' || ut_tank_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_tank_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (327, 'Cathodically Protected Steel (impressed current)', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (327, 'Coated and Cathodically Protected Steel (impressed current)', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'TankCorrosionProtectionSacrificialAnode', 'ut_tank_attribute_type', 'ut_tank_attribute_desc', 'v_tank_attributes', 'tank_attribute', 'ut_tank_attribute_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_tank_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (328, ''' || ut_tank_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_tank_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (328, 'Cathodically Protected Steel (sacrificial anodes)', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (328, 'Coated and Cathodically Protected Steel (sacrificial anodes)', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'PipingCorrosionProtectionImpressedCurrent', 'ut_piping_attribute_type', 'ut_piping_attribute_desc', 'v_piping_attributes', 'piping_attribute', 'ut_piping_attribute_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_piping_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (329, ''' || ut_piping_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_piping_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (329, 'Cathodically Protected (impressed current)', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'PipingCorrosionProtectionSacrificialAnode', 'ut_piping_attribute_type', 'ut_piping_attribute_desc', 'v_piping_attributes', 'piping_attribute', 'ut_piping_attribute_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_piping_attribute_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (330, ''' || ut_piping_attribute_desc || ''', '''');'
from "TRUSTD_UST".ut_piping_attribute_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (330, 'Cathodically Protected (sacrificial anodes)', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'FlowShutoffDevice', 'ut_overfill_protection_type', 'ut_overfill_protection_desc', 'v_overfill_protections', 'overfill_protection', 'ut_overfill_protection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_overfill_protection_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (331, ''' || ut_overfill_protection_desc || ''', '''');'
from "TRUSTD_UST".ut_overfill_protection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (331, 'Automatic Shutoff', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (331, 'Flapper Valve (Legacy)', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'BallFloatValve', 'ut_overfill_protection_type', 'ut_overfill_protection_desc', 'v_overfill_protections', 'overfill_protection', 'ut_overfill_protection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_overfill_protection_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (332, ''' || ut_overfill_protection_desc || ''', '''');'
from "TRUSTD_UST".ut_overfill_protection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (332, 'Flow Restrictor', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (332, 'Ball Float (Legacy)', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'HighLevelAlarm', 'ut_overfill_protection_type', 'ut_overfill_protection_desc', 'v_overfill_protections', 'overfill_protection', 'ut_overfill_protection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_overfill_protection_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (333, ''' || ut_overfill_protection_desc || ''', '''');'
from "TRUSTD_UST".ut_overfill_protection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (333, 'High-level Alarm', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'SpillBucketInstalled', 'ut_tank_system_comp', 'spill_installed', null,null,null)
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (334, ''' || spill_installed || ''', '''');'
from "TRUSTD_UST".ut_tank_system_comp order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (334, 'Exempt due to small delivery', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (334, 'FALSE', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (334, 'TRUE', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'SpillBucketWallType', 'ut_spill_prevention_type', 'ut_spill_prevention_desc', 'ut_tank_system_comp', 'spill_preventions', 'ut_spill_prevention_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_spill_prevention_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (335, ''' || ut_spill_prevention_desc || ''', '''');'
from "TRUSTD_UST".ut_spill_prevention_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (335, 'Double Walled', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (335, 'Double Walled with Interstitial Monitoring', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (335, 'Single Walled', 'Single');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'AutomaticTankGauging', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_release_detection_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (336, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (336, 'Automatic Tank Gauging', 'Yes');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'ManualTankGauging', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_release_detection_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (337, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (337, 'Manual Tank Gauging', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'StatisticalInventoryReconciliation', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (338, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (338, 'Statistical Inventory Reconciliation', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'TankTightnessTesting', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (339, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (339, 'Tank Tightness Testing', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'GroundwaterMonitoring', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (340, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (340, 'Groundwater Monitoring', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'VaporMonitoring', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (341, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (341, 'Vapor Monitoring', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'ElectronicLineLeakDetector', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_release_detection_type_id,
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (342, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (342, 'Automatic Line Leak Detectors - Electronic', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-03-28', 'MechanicalLineLeakDetector', 'ut_release_detection_type', 'ut_release_detection_desc', 'v_tank_release_detections', 'release_detection', 'ut_release_detection_type_id')
returning 'select distinct 
''insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (343, ''' || ut_release_detection_desc || ''', '''');'
from "TRUSTD_UST".ut_release_detection_type order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (343, 'Automatic Line Leak Detectors - Mechanical', 'Yes');

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	
         
select * from ust_elements;

select * from "TRUSTD_UST".ut_facility;
select * From "TRUSTD_UST".ut_land_location;
select * from "TRUSTD_UST".ut_land_use_hist;	     



select * from "TRUSTD_UST".ut_land_use_type

select * from ust_elements;

select distinct "TankRepairDate" from "TRUSTD_UST".v_ust_base 

select * from "TRUSTD_UST".ut_tank_system where repair_date is not null;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop view "TRUSTD_UST".v_ust_base;

create or replace view "TRUSTD_UST".v_ust_base as
select distinct 
	f.land_location_id::text as "FacilityID", --use land_location_id instead of facility_id per OUST
    left(f.facility_desc,100) as "FacilityName",
	ot.epa_value as "OwnerType",
	ft.epa_value as "FacilityType1",
	left(ll.address_1,100) as "FacilityAddress1", 
	ll.address_2 as "FacilityAddress2", 
	ll.city as "FacilityCity",
	ll.zip::text as "FacilityZipCode", 
	ll.county as "FacilityCounty",
	left(ll.phone,40) as "FacilityPhoneNumber", 
	ll.state as "FacilityState",
	case when rg.region_key like 'R%' then replace(rg.region_key,'R','')::int end as "FacilityEPARegion",
	case when ll.tribe_owned in ('True','TRUE','Y') or ll.tribe_id is not null then 'Yes' 
	     when ll.tribe_owned in ('False','FALSE','N') then 'No' else null end as "FacilityTribalSite", 
	case when ll.tribe is not null and t.current_name is null then left(ll.tribe,200) 
	     when t.current_name is not null then left(t.current_name,200) else null end as "FacilityTribe",
	ll.latitude as "FacilityLatitude", 
	ll.longitude as "FacilityLongitude", 
	fcs.epa_value as "FacilityCoordinateSource",
	substr(fo.responsible_entity_name,1,100) as "FacilityOwnerCompanyName", 
	fo.address_1 as "FacilityOwnerAddress1", 
	fo.address_2 as "FacilityOwnerAddress2",
	fo.city as "FacilityOwnerCity",
	fo.county as "FacilityOwnerCounty", 
	fo.zip::text as "FacilityOwnerZipCode",
	fo.state as "FacilityOwnerState", 
	fo.phone as "FacilityOwnerPhoneNumber",
	fo.email_addr as "FacilityOwnerEmail",
	--1:MANY between facility and operator; currently using highest operator ID     
	substr(fop.facility_operator_name,1,100) as "FacilityOperatorCompanyName", 
	fop.address_1 as "FacilityOperatorAddress1",
	fop.address_2 as "FacilityOperatorAddress2",
	fop.city as "FacilityOperatorCity", 
	fop.county as "FacilityOperatorCounty", 
	fop.zip::text as "FacilityOperatorZipCode",
	fop.state as "FacilityOperatorState",
	fop.phone as "FacilityOperatorPhoneNumber",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Local Govt. Bond Rating Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityBondRatingTest",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Insurance' and fr.facility_id = f.facility_id) as "FinancialResponsibilityCommercialInsurance",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Guarantee' and fr.facility_id = f.facility_id) as "FinancialResponsibilityGuarantee",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Letter of Credit' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLetterOfCredit",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Local Govt. Financial Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLocalGovernmentFinancialTest",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Risk Retention Group' and fr.facility_id = f.facility_id) as "FinancialResponsibilityRiskRetentionGroup",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Self Insured' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySelfInsuranceFinancialTest",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'State Fund' and fr.facility_id = f.facility_id) as "FinancialResponsibilityStateFund",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Surety Bond' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySuretyBond",
	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type in ('Trust Fund','Standby Trust Fund') and fr.facility_id = f.facility_id) as "FinancialResponsibilityTrustFund",
	(select string_agg(distinct fr_type, '; ' order by fr_type) as fr_type from "TRUSTD_UST".ut_financial_responsibility fr where fr_type not in 
		('Guarantee','Insurance','Letter of Credit','Local Govt. Bond Rating Test','Local Govt. Financial Test','Risk Retention Group',
 		'Self Insured','Standby Trust Fund','State Fund','Surety Bond','Trust Fund','Govt. Entity: Federal Covered','Govt. Entity: State Covered') and fr.facility_id = f.facility_id) as "FinancialResponsibilityOtherMethod",
 	(select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type like 'Govt. Entity%' and fr.facility_id = f.facility_id) as "FinancialResponsibilityNotRequired",
    ts.tank_name as "TankID", 
    'Yes' as "FederallyRegulated", --we are excluding those that are FALSE.
    tsc.compartment_name as "CompartmentID",
    tst.epa_value as "TankStatus",
    mt.epa_value as "ManifoldedTanks",
    ts.date_closed::date as "ClosureDate",
    ts.date_installed::date as "InstallationDate",
    vc.compartmentalized as "CompartmentalizedUST",
    vc.num_compartments as "NumberOfCompartments",
    css.epa_value as "CompartmentSubstanceStored",
    ts.tank_capacity as "TankCapacityGallons",
    tsc.compartment_capacity as "CompartmentCapacityGallons", 
    el.epa_value as "ExcavationLiner",
    twt.epa_value as "TankWallType",
    md.epa_value as "MaterialDescription",
    case when ts.tank_repaired = True then 'Yes' when ts.tank_repaired = False then 'No' end as "TankRepaired", 
--    ts.repair_date::date as "TankRepairDate", always null and is a float so can't convert to date; omit
    pmd.epa_value as "PipingMaterialDescription",
    ps.epa_value as "PipingStyle",
    pwt.epa_value as "PipingWallType",
    pr.epa_value as "PipingRepaired",
    tcpic.epa_value as "TankCorrosionProtectionImpressedCurrent",
    tcpsa.epa_value as "TankCorrosionProtectionSacrificialAnode",
    pcpic.epa_value as "PipingCorrosionProtectionImpressedCurrent",
    pcpsa.epa_value as "PipingCorrosionProtectionSacrificialAnode",
    bfv.epa_value as "BallFloatValve",
    fsd.epa_value as "FlowShutoffDevice",
    hla.epa_value as "HighLevelAlarm",
    sbi.epa_value as "SpillBucketInstalled",
    sbwt.epa_value as "SpillBucketWallType",
    atg.epa_value as "AutomaticTankGauging",
    case when atg.epa_value is not null then 'Yes' end as "AutomaticTankGaugingReleaseDetection",
    case when atg.epa_value is not null then 'Unknown' end as "AutomaticTankGaugingContinuousLeakDetection",
    mtg.epa_value as "ManualTankGauging",
    sir.epa_value as "StatisticalInventoryReconciliation",
    ttt.epa_value as "TankTightnessTesting",
    gm.epa_value as "GroundwaterMonitoring",
    vm.epa_value as "VaporMonitoring",
    elld.epa_value as "ElectronicLineLeakDetector",
    mlld.epa_value as "MechanicalLineLeakDetector",
	case when r.release_id is not null then 'Yes' end as "USTReportedRelease",
    r.release_id as "AssociatedLUSTID" 
from
	"TRUSTD_UST".ut_facility f
	left join "TRUSTD_UST".v_most_recent_land_use_type lu on f.land_location_id = lu.land_location_id --ERG view to get current land use
	left join "TRUSTD_UST".ut_land_use_type lut on lut.land_use_type_id  = lu.land_use_type_id --lookup table
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'OwnerType') ot on lut.land_use_type_desc = ot.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'FacilityType1') ft on lut.land_use_type_desc = ft.state_value
	left join "TRUSTD_UST".ut_land_location ll on f.land_location_id = ll.land_location_id --1:1
	left join "TRUSTD_UST".ut_tribes t on ll.tribe_id = t.tribe_id
    left join "TRUSTD_UST".st_regions rg on t.region_id = rg.region_id
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'FacilityCoordinateSource') fcs on ll.lat_lon_source = fcs.state_value
    left join (select * from (select fh.facility_id, lre.responsible_entity_name, lre.address_1, lre.address_2, 
    							     lre.city, lre.state, lre.zip, lre.county, lre.phone, lre.email_addr,
       				            	 row_number() over (partition by fh.facility_id order by fh.end_date desc nulls first, 
       				            							fh.date_observed desc nulls last, fh.ut_facility_owner_hist_id desc) rn
			  				 from "TRUSTD_UST".ut_facility_owner_hist fh 
			  				 	join "TRUSTD_UST".ut_legally_responsible_entity lre on lre.responsible_entity_id = fh.responsible_entity_id) lre
			  				 where rn = 1) fo on f.facility_id = fo.facility_id 
    left join (select c.facility_id, d.* from "TRUSTD_UST".ut_facility_operator d join        
                (select a.facility_id, facility_operator_id from "TRUSTD_UST".ut_facility_oper_hist a join         
                    (select facility_id, max(ut_facility_oper_hist_id) as ut_facility_oper_hist_id 
                     from "TRUSTD_UST".ut_facility_oper_hist where end_date is null group by facility_id) b        
                        on a.ut_facility_oper_hist_id = b.ut_facility_oper_hist_id) c on c.facility_operator_id = d.facility_operator_id) fop
            on f.facility_id = fop.facility_id    	
    left join "TRUSTD_UST".v_ut_tank_system ts on f.facility_id = ts.facility_id
    left join "TRUSTD_UST".ut_tank_system_comp tsc on ts.tank_system_id = tsc.tank_system_id
    left join "TRUSTD_UST".v_compartments vc on tsc.tank_system_id = vc.tank_system_id
    left join "TRUSTD_UST".v_tank_status vts on ts.facility_id = vts.facility_id and ts.tank_name = vts.tank_name
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'TankStatus') tst on vts.tank_status = tst.state_value
	left join "TRUSTD_UST".v_substances vs on tsc.tank_system_comp_id = vs.tank_system_comp_id
	left join "TRUSTD_UST".ut_substance_type st on vs.ut_substance_type_id::int = st.ut_substance_type_id 
	left join (select state_value, epa_value, exclude_from_query from v_ust_element_mapping where control_id = 18 and element_name = 'CompartmentSubstanceStored') css on st.ut_substance_desc = css.state_value 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'PipingRepaired') pr on tsc.pipe_repaired::text = pr.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'SpillBucketInstalled') sbi on tsc.spill_installed = sbi.state_value
	left join "TRUSTD_UST".ut_spill_prevention_type spt on tsc.spill_preventions = spt.ut_spill_prevention_type_id
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'SpillBucketWallType') sbwt on spt.ut_spill_prevention_desc = sbwt.state_value
	left join (select distinct a.state_value, a.epa_value, c.tank_system_id
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_tank_attribute_type b on a.state_value = b.ut_tank_attribute_desc 
			   		join "TRUSTD_UST".v_tank_attributes c on b.ut_tank_attribute_type_id = c.ut_tank_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'TankWallType') twt on ts.tank_system_id = twt.tank_system_id
	left join (select distinct a.state_value, a.epa_value, c.tank_system_id
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_tank_attribute_type b on a.state_value = b.ut_tank_attribute_desc 
			   		join "TRUSTD_UST".v_tank_attributes c on b.ut_tank_attribute_type_id = c.ut_tank_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'ManifoldedTanks') mt on ts.tank_system_id = mt.tank_system_id
	left join (select distinct a.state_value, a.epa_value, c.tank_system_id
				from v_ust_element_mapping a join "TRUSTD_UST".ut_tank_attribute_type b on a.state_value = b.ut_tank_attribute_desc 
			   		join "TRUSTD_UST".v_tank_attributes c on b.ut_tank_attribute_type_id = c.ut_tank_attribute_type_id::int
				where a.control_id = 18 and a.element_name = 'MaterialDescription') md on ts.tank_system_id = md.tank_system_id
	left join (select distinct a.state_value, a.epa_value, c.tank_system_id 
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_tank_attribute_type b on a.state_value = b.ut_tank_attribute_desc 
			   		join "TRUSTD_UST".v_tank_attributes c on b.ut_tank_attribute_type_id = c.ut_tank_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'ExcavationLiner') el on ts.tank_system_id = el.tank_system_id	
	left join (select distinct a.state_value, a.epa_value, c.tank_system_id
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_tank_attribute_type b on a.state_value = b.ut_tank_attribute_desc 
			   		join "TRUSTD_UST".v_tank_attributes c on b.ut_tank_attribute_type_id = c.ut_tank_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'TankCorrosionProtectionImpressedCurrent') tcpic on ts.tank_system_id = tcpic.tank_system_id
	left join (select distinct a.state_value, a.epa_value, c.tank_system_id 
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_tank_attribute_type b on a.state_value = b.ut_tank_attribute_desc 
			   		join "TRUSTD_UST".v_tank_attributes c on b.ut_tank_attribute_type_id = c.ut_tank_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'TankCorrosionProtectionSacrificialAnode') tcpsa on ts.tank_system_id = tcpsa.tank_system_id				
	left join (select distinct a.state_value, a.epa_value, c.tank_system_comp_id 
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_piping_attribute_type b on a.state_value = b.ut_piping_attribute_desc 
			   		join "TRUSTD_UST".v_piping_attributes c on b.ut_piping_attribute_type_id = c.ut_piping_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'PipingMaterialDescription') pmd on tsc.tank_system_comp_id = pmd.tank_system_comp_id	
	left join (select distinct a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_piping_attribute_type b on a.state_value = b.ut_piping_attribute_desc 
			   		join "TRUSTD_UST".v_piping_attributes c on b.ut_piping_attribute_type_id = c.ut_piping_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'PipingWallType') pwt on tsc.tank_system_comp_id = pwt.tank_system_comp_id	
	left join (select distinct a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_piping_attribute_type b on a.state_value = b.ut_piping_attribute_desc 
			   		join "TRUSTD_UST".v_piping_attributes c on b.ut_piping_attribute_type_id = c.ut_piping_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'PipingCorrosionProtectionImpressedCurrent') pcpic on tsc.tank_system_comp_id = pcpic.tank_system_comp_id	
	left join (select distinct a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_piping_attribute_type b on a.state_value = b.ut_piping_attribute_desc 
			   		join "TRUSTD_UST".v_piping_attributes c on b.ut_piping_attribute_type_id = c.ut_piping_attribute_type_id::int
			   where a.control_id = 18 and a.element_name = 'PipingCorrosionProtectionSacrificialAnode') pcpsa on tsc.tank_system_comp_id = pcpsa.tank_system_comp_id		
	left join "TRUSTD_UST".v_piping_deliveries vpd on tsc.tank_system_comp_id = vpd.tank_system_comp_id		   
	left join "TRUSTD_UST".ut_piping_delivery_type pdt on vpd.ut_piping_delivery_type_id::int = pdt.ut_piping_delivery_type_id 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 18 and element_name = 'PipingStyle') ps on pdt.ut_piping_delivery_desc = ps.state_value
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id   
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_overfill_protection_type b on a.state_value = b.ut_overfill_protection_desc 
			   		join "TRUSTD_UST".v_overfill_protections c on b.ut_overfill_protection_type_id = c.ut_overfill_protection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'FlowShutoffDevice') fsd on tsc.tank_system_comp_id = fsd.tank_system_comp_id	
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id   
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_overfill_protection_type b on a.state_value = b.ut_overfill_protection_desc 
			   		join "TRUSTD_UST".v_overfill_protections c on b.ut_overfill_protection_type_id = c.ut_overfill_protection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'BallFloatValve') bfv on tsc.tank_system_comp_id = bfv.tank_system_comp_id	
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id   
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_overfill_protection_type b on a.state_value = b.ut_overfill_protection_desc 
			   		join "TRUSTD_UST".v_overfill_protections c on b.ut_overfill_protection_type_id = c.ut_overfill_protection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'HighLevelAlarm') hla on tsc.tank_system_comp_id = hla.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'AutomaticTankGauging') atg on tsc.tank_system_comp_id = atg.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc 
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'ManualTankGauging') mtg on tsc.tank_system_comp_id = mtg.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc 
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'StatisticalInventoryReconciliation') sir on tsc.tank_system_comp_id = sir.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc 
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'TankTightnessTesting') ttt on tsc.tank_system_comp_id = ttt.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id   
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc 
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'GroundwaterMonitoring') gm on tsc.tank_system_comp_id = gm.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc 
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'VaporMonitoring') vm on tsc.tank_system_comp_id = vm.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id  
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc 
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'ElectronicLineLeakDetector') elld on tsc.tank_system_comp_id = elld.tank_system_comp_id		
	left join (select a.state_value, a.epa_value, c.tank_system_comp_id   
			   from v_ust_element_mapping a join "TRUSTD_UST".ut_release_detection_type b on a.state_value = b.ut_release_detection_desc 
			   		join "TRUSTD_UST".v_tank_release_detections c on b.ut_release_detection_type_id = c.ut_release_detection_type_id::int 
			   where a.control_id = 18 and a.element_name = 'MechanicalLineLeakDetector') mlld on tsc.tank_system_comp_id = mlld.tank_system_comp_id		
	left join (select a.land_location_id, max(a.release_id) as release_id
				from "TRUSTD_UST".ut_release a join 
					(select release_id, max(event_date) event_date 
					from "TRUSTD_UST".ut_release_event re join "TRUSTD_UST".ut_release_event_type ret on re.release_event_type_id = ret.release_event_type_id 
					where ret.release_event_desc = 'Confirmed Release' and release_id not in 
						(select release_id from "TRUSTD_UST".ut_release_event re join "TRUSTD_UST".ut_release_event_type ret on re.release_event_type_id = ret.release_event_type_id 
						where ret.release_event_desc = 'Determination of Non-Jurisdiction')
					group by release_id) b on a.release_id = b.release_id group by a.land_location_id) r on f.land_location_id = r.land_location_id	
where ll.land_status <> 'Not Indian Country' --per OUST
and ts.federal_regulated_tank = True 
and coalesce(css.exclude_from_query,'X') <> 'Y' --exclude non-federally regulated substances
order by f.land_location_id::text;
	

			   select pg_get_viewdef('"TRUSTD_UST".v_ust_base', true)
			   
select * from ust where organization_id = 'TRUSTD'			   


select column_name from information_schema.columns 
	         where table_schema ='TRUSTD_UST' and table_name = 'v_ust_base'
             and column_name in ('FacilityName', 'FacilityAddress1', 'FacilityAddress2', 'FacilityCity',
                                 'FacilityCounty', 'FacilityZipCode', 'FacilityLatitude', 'FacilityLongitude',
                                 'SiteName', 'SiteAddress', 'SiteAddress2', 'SiteCity', 'Zipcode', 'County', 'State',
                                 'Latitude', 'Longitude') 
	         order by ordinal_position


select * from ust_control;


select * from ust_facilities

select '"' || column_name || '",' from information_schema.columns where table_schema = 'public' and table_name = 'ust_facilities' order by ordinal_position;

insert into ust_facilities ("control_id",
"organization_id",
"FacilityID",
"FacilityName",
"FacilityAddress1",
"FacilityAddress2",
"FacilityCity",
"FacilityCounty",
"FacilityZipCode",
"FacilityState",
"FacilityLatitude",
"FacilityLongitude")
select distinct 18, 'TRUSTD', "FacilityID",
"FacilityName",
"FacilityAddress1",
"FacilityAddress2",
"FacilityCity",
"FacilityCounty",
"FacilityZipCode",
"FacilityState",
"FacilityLatitude",
"FacilityLongitude"
from "TRUSTD_UST".v_ust_base

select * from ust_geocode where control_id = 15;

insert into ust_geocode (control_id, organization_id, ust_facilities_id, gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type)
select b.control_id, b.organization_id, b.ust_facilities_id, a.gc_latitude, a.gc_longitude, a.gc_coordinate_source, a.gc_address_type
from ust_geocode a join ust_facilities x on a.control_id = x.control_id and x.ust_facilities_id = a.ust_facilities_id 
	join ust_facilities b on b."FacilityID" = x."FacilityID"
where a.control_id = 15 and b.control_id = 18;

select count(*) from ust_facilities where control_id = 18;



select * from "TRUSTD_UST".v_ust_base

select * from ust where organization_id = 'TRUSTD'

select '"' || column_name || '",' from information_schema.columns where table_schema = 'TRUSTD_UST' and table_name = 'v_ust_base' order by ordinal_position;

select * from ust_elements where element_name like '%Trib%'

insert into ust (control_id, organization_id, ust_facilities_id, "FacilityID",
"FacilityName",
"OwnerType",
"FacilityType1",
"FacilityAddress1",
"FacilityAddress2",
"FacilityCity",
"FacilityZipCode",
"FacilityCounty",
"FacilityPhoneNumber",
"FacilityState",
"FacilityEPARegion",
"FacilityTribe",
"FacilityTribeName",
"FacilityLatitude",
"FacilityLongitude",
"FacilityCoordinateSource",
"FacilityOwnerCompanyName",
"FacilityOwnerAddress1",
"FacilityOwnerAddress2",
"FacilityOwnerCity",
"FacilityOwnerCounty",
"FacilityOwnerZipCode",
"FacilityOwnerState",
"FacilityOwnerPhoneNumber",
"FacilityOwnerEmail",
"FacilityOperatorCompanyName",
"FacilityOperatorAddress1",
"FacilityOperatorAddress2",
"FacilityOperatorCity",
"FacilityOperatorCounty",
"FacilityOperatorZipCode",
"FacilityOperatorState",
"FacilityOperatorPhoneNumber",
"FinancialResponsibilityBondRatingTest",
"FinancialResponsibilityCommercialInsurance",
"FinancialResponsibilityGuarantee",
"FinancialResponsibilityLetterOfCredit",
"FinancialResponsibilityLocalGovernmentFinancialTest",
"FinancialResponsibilityRiskRetentionGroup",
"FinancialResponsibilitySelfInsuranceFinancialTest",
"FinancialResponsibilityStateFund",
"FinancialResponsibilitySuretyBond",
"FinancialResponsibilityTrustFund",
"FinancialResponsibilityOtherMethod",
"FinancialResponsibilityNotRequired",
"TankID",
"FederallyRegulated",
"CompartmentID",
"TankStatus",
"ManifoldedTanks",
"ClosureDate",
"InstallationDate",
"CompartmentalizedUST",
"NumberOfCompartments",
"CompartmentSubstanceStored",
"TankCapacityGallons",
"CompartmentCapacityGallons",
"ExcavationLiner",
"TankWallType",
"MaterialDescription",
"TankRepaired",
"TankRepairDate",
"PipingMaterialDescription",
"PipingStyle",
"PipingWallType",
"PipingRepaired",
"TankCorrosionProtectionImpressedCurrent",
"TankCorrosionProtectionSacrificialAnode",
"PipingCorrosionProtectionImpressedCurrent",
"PipingCorrosionProtectionSacrificialAnode",
"BallFloatValve",
"FlowShutoffDevice",
"HighLevelAlarm",
"SpillBucketInstalled",
"SpillBucketWallType",
"AutomaticTankGauging",
"AutomaticTankGaugingReleaseDetection",
"AutomaticTankGaugingContinuousLeakDetection",
"ManualTankGauging",
"StatisticalInventoryReconciliation",
"TankTightnessTesting",
"GroundwaterMonitoring",
"VaporMonitoring",
"ElectronicLineLeakDetector",
"MechanicalLineLeakDetector",
"USTReportedRelease",
"AssociatedLUSTID")
select control_id, organization_id, ust_facilities_id, 
a."FacilityID",
a."FacilityName",
a."OwnerType",
a."FacilityType1",
a."FacilityAddress1",
a."FacilityAddress2",
a."FacilityCity",
a."FacilityZipCode",
a."FacilityCounty",
a."FacilityPhoneNumber",
a."FacilityState",
a."FacilityEPARegion",
a."FacilityTribe",
a."FacilityTribeName",
a."FacilityLatitude",
a."FacilityLongitude",
"FacilityCoordinateSource",
"FacilityOwnerCompanyName",
"FacilityOwnerAddress1",
"FacilityOwnerAddress2",
"FacilityOwnerCity",
"FacilityOwnerCounty",
"FacilityOwnerZipCode",
"FacilityOwnerState",
"FacilityOwnerPhoneNumber",
"FacilityOwnerEmail",
"FacilityOperatorCompanyName",
"FacilityOperatorAddress1",
"FacilityOperatorAddress2",
"FacilityOperatorCity",
"FacilityOperatorCounty",
"FacilityOperatorZipCode",
"FacilityOperatorState",
"FacilityOperatorPhoneNumber",
"FinancialResponsibilityBondRatingTest",
"FinancialResponsibilityCommercialInsurance",
"FinancialResponsibilityGuarantee",
"FinancialResponsibilityLetterOfCredit",
"FinancialResponsibilityLocalGovernmentFinancialTest",
"FinancialResponsibilityRiskRetentionGroup",
"FinancialResponsibilitySelfInsuranceFinancialTest",
"FinancialResponsibilityStateFund",
"FinancialResponsibilitySuretyBond",
"FinancialResponsibilityTrustFund",
"FinancialResponsibilityOtherMethod",
"FinancialResponsibilityNotRequired",
"TankID",
"FederallyRegulated",
"CompartmentID",
"TankStatus",
"ManifoldedTanks",
"ClosureDate",
"InstallationDate",
"CompartmentalizedUST",
"NumberOfCompartments",
"CompartmentSubstanceStored",
"TankCapacityGallons",
"CompartmentCapacityGallons",
"ExcavationLiner",
"TankWallType",
"MaterialDescription",
"TankRepaired",
"TankRepairDate",
"PipingMaterialDescription",
"PipingStyle",
"PipingWallType",
"PipingRepaired",
"TankCorrosionProtectionImpressedCurrent",
"TankCorrosionProtectionSacrificialAnode",
"PipingCorrosionProtectionImpressedCurrent",
"PipingCorrosionProtectionSacrificialAnode",
"BallFloatValve",
"FlowShutoffDevice",
"HighLevelAlarm",
"SpillBucketInstalled",
"SpillBucketWallType",
"AutomaticTankGauging",
"AutomaticTankGaugingReleaseDetection",
"AutomaticTankGaugingContinuousLeakDetection",
"ManualTankGauging",
"StatisticalInventoryReconciliation",
"TankTightnessTesting",
"GroundwaterMonitoring",
"VaporMonitoring",
"ElectronicLineLeakDetector",
"MechanicalLineLeakDetector",
"USTReportedRelease",
"AssociatedLUSTID"
from "TRUSTD_UST".v_ust_base a left join ust_facilities b 
	on a."FacilityID" = b."FacilityID"
where b.control_id = 18;





select count(*) from (select distinct "FacilityID","TankID","CompartmentID" from "TRUSTD_UST".v_ust_base) a;

select distinct element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk, element_db_mapping_id
from v_ust_element_mapping 
where control_id = 18
order by element_db_mapping_id;

TankWallType
MaterialDescription
PipingMaterialDescription
PipingWallType

select * from "TRUSTD_UST".ut_facility where land_location_id = 5;

select * from "TRUSTD_UST".ut_tank_system where facility_id = 5 and tank_name = 'TANK 1'


select * from ust_element_value_mappings where epa_value = 'Composite/Cclad (steel w/fiberglass reinforced plastic)'
update ust_element_value_mappings set epa_value = 'Composite/clad (steel w/fiberglass reinforced plastic)'
where epa_value = 'Composite/Cclad (steel w/fiberglass reinforced plastic)'

drop table "TRUSTD_UST".v_ust_base_temp;
select * into "TRUSTD_UST".v_ust_base_temp from "TRUSTD_UST".v_ust_base;

select count(*) from (select distinct "FacilityID","TankID","CompartmentID" from "TRUSTD_UST".v_ust_base_temp) a;


select * from (
  SELECT "FacilityID","TankID","CompartmentID",
  ROW_NUMBER() OVER(PARTITION BY "FacilityID","TankID","CompartmentID" ORDER BY "FacilityID","TankID","CompartmentID" asc) AS Row
  FROM "TRUSTD_UST".v_ust_base_temp
) dups
where 
dups.Row > 1

select * from "TRUSTD_UST".v_ust_base_temp where "FacilityID" = '59' and "TankID" = 'TANK 003' and "CompartmentID" = 'TANK 003 Compartment';

select count(distinct "TankStatus") from "TRUSTD_UST".v_ust_base_temp where "FacilityID" = '1343' and "TankID" = 'Tank 9' and "CompartmentID" = 'Tank 9 Compartment 1';


(8531, 'Tank 1', 'Tank 1 Compartment 1c', 2)

select "FacilityID", "TankID", "CompartmentID", "MaterialDescription" from "TRUSTD_UST"."v_ust_base_temp" where "FacilityID" = '59' and "TankID" = 'TANK 003' and "CompartmentID" = 'TANK 003 Compartment';


select "FacilityID", "TankID", "CompartmentID", "PipingStyle" from "TRUSTD_UST"."v_ust_base_temp" where "FacilityID" = '121' and "TankID" = 'TANK 1' and "CompartmentID" = 'TANK 1 Compartment';

select * from  "TRUSTD_UST"."v_ust_base_temp" where "FacilityID" = '1773' and "TankID" = 'Tank 16' and "CompartmentID" = 'Tank 16 Compartment 3';;

select * from "TRUSTD_UST".ut_facility where land_location_id = 1773;

select * from "TRUSTD_UST".v_ut_tank_system where facility_id = 1694 and tank_name = 'Tank 16';
6:12:5

select * from "TRUSTD_UST".v_tank_attributes a join "TRUSTD_UST".ut_tank_attribute_type b 
	on a.ut_tank_attribute_type_id::int = b.ut_tank_attribute_type_id
where tank_system_id = 3539;


select "FacilityID", "TankID", "CompartmentID", "CompartmentSubstanceStored" from "TRUSTD_UST"."v_ust_base_temp" where "FacilityID" = '1423' and "TankID" = 'Tank 5' and "CompartmentID" = 'Tank 5 Compartment 1';

select "FacilityID", "TankID", "CompartmentID", "MaterialDescription" from "TRUSTD_UST"."v_ust_base_temp" where "FacilityID" = '59' and "TankID" = 'TANK 003' and "CompartmentID" = 'TANK 003 Compartment';
Coated and cathodically protected steel
Composite/clad (steel w/fiberglass reinforced plastic)

select * from v_ust_element_mapping where control_id = 18 and element_name = 'MaterialDescription'



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------





select distinct f.land_location_id as "FacilityID", 
	f.facility_desc as "FacilityName",  
    case when luh1.land_use_type_desc in ('Utilities','Commercial Airport or Airline','Industrial','Truck/Transporter',
                                        'Railroad', 'Commercial','Petroleum Distributor','Auto Dealership','Casino',
                                        'Contractor','Hospital','Marina') then 'Commercial'
         when luh1.land_use_type_desc = 'Federal Non-Military' then 'Federal Government - Non Military'
         when luh1.land_use_type_desc = 'Local Government' then 'Local Government'
         when luh1.land_use_type_desc = 'Federal Military' then 'Military'
         when luh1.land_use_type_desc in ('Aircraft Owner','Farm','Private') then 'Private'
         when luh1.land_use_type_desc = 'State Government' then 'State Government - Non Military' else null end as "OwnerType",
    case when luh1.land_use_type_desc = 'Farm' then 'Agricultural/farm'         
         when luh1.land_use_type_desc = 'Auto Dealership' then 'Auto dealership/auto maintenance & repair'         
         when luh1.land_use_type_desc in ('Aircraft Owner','Commercial Airport or Airline') then 'Aviation/airport'         
         when luh1.land_use_type_desc = 'Petroleum Distributor' then 'Bulk plant storage/petroleum distributor'         
         when luh1.land_use_type_desc = 'Commercial' then 'Commercial'         
         when luh1.land_use_type_desc = 'Contractor' then 'Contractor'         
         when luh1.land_use_type_desc = 'Hospital' then 'Hospital'         
         when luh1.land_use_type_desc = 'Industrial' then 'Industrial'         
         when luh1.land_use_type_desc in ('Federal Military','Other','Federal Non-Military','State Government',
                                        'Local Government','Casino','Marina','Private') then 'Other'         
         when luh1.land_use_type_desc = 'Railroad' then 'Railroad'         
         when luh1.land_use_type_desc = 'Residential' then 'Residential'         
         when luh1.land_use_type_desc = 'Gas Station' then 'Retail fuel sales'         
         when luh1.land_use_type_desc = 'School' then 'School'         
         when luh1.land_use_type_desc = 'Truck/Transporter' then 'Trucking/transport/fleet operation'         
         when luh1.land_use_type_desc = 'Not Listed' then 'Unknown'         
         when luh1.land_use_type_desc = 'Utilities' then 'Utility' else null end as "FacilityType1",
    case when luh2.land_use_type_desc = 'Farm' then 'Agricultural/farm'         
         when luh2.land_use_type_desc = 'Auto Dealership' then 'Auto dealership/auto maintenance & repair'         
         when luh2.land_use_type_desc in ('Aircraft Owner','Commercial Airport or Airline') then 'Aviation/airport'         
         when luh2.land_use_type_desc = 'Petroleum Distributor' then 'Bulk plant storage/petroleum distributor'         
         when luh2.land_use_type_desc = 'Commercial' then 'Commercial'         
         when luh2.land_use_type_desc = 'Contractor' then 'Contractor'         
         when luh2.land_use_type_desc = 'Hospital' then 'Hospital'         
         when luh2.land_use_type_desc = 'Industrial' then 'Industrial'         
         when luh2.land_use_type_desc in ('Federal Military','Other','Federal Non-Military','State Government',
                                        'Local Government','Casino','Marina','Private') then 'Other'         
         when luh2.land_use_type_desc = 'Railroad' then 'Railroad'         
         when luh2.land_use_type_desc = 'Residential' then 'Residential'         
         when luh2.land_use_type_desc = 'Gas Station' then 'Retail fuel sales'         
         when luh2.land_use_type_desc = 'School' then 'School'         
         when luh2.land_use_type_desc = 'Truck/Transporter' then 'Trucking/transport/fleet operation'         
         when luh2.land_use_type_desc = 'Not Listed' then 'Unknown'         
         when luh2.land_use_type_desc = 'Utilities' then 'Utility' else null end as "FacilityType2",
         ll.address_1 as "FacilityAddress1", ll.address_2 as "FacilityAddress2", ll.city as "FacilityCity",
         ll.zip as "FacilityZipCode", ll.county as "FacilityCounty", ll.phone as "FacilityPhoneNumber", ll.state as "FacilityState",
         case when rg.region_key like 'R%' then replace(rg.region_key,'R','') end as "FacilityEPARegion",
         case when ll.tribe_owned in ('True','TRUE','Y') or ll.tribe_id is not null then 'Yes' 
              when ll.tribe_owned in ('False','FALSE','N') then 'No' else null end as "FacilityTribe", 
         case when ll.tribe is not null and t.current_name is null then ll.tribe 
              when t.current_name is not null then t.current_name else null end as "FacilityTribeName",
         ll.latitude as "FacilityLatitude", ll.longitude as "FacilityLongitude", 
         case when ll.lat_lon_source like 'GPS%' then 'GPS' 
              when ll.lat_lon_source = 'Estimation' then 'Map Interpolation'
              when ll.lat_lon_source is not null then 'Other' end as "FacilityCoordinateSource",
         substr(fo.responsible_entity_name,1,100) as "FacilityOwnerCompanyName", 
         fo.address_1 as "FacilityOwnerAddress1", 
         fo.address_2 as "FacilityOwnerAddress2",
         fo.city as "FacilityOwnerCity",
         fo.county as "FacilityOwnerCounty", 
         fo.zip as "FacilityOwnerZipCode",
         fo.state as "FacilityOwnerState", 
         fo.phone as "FacilityOwnerPhoneNumber",
         fo.email_addr as "FacilityOwnerEmail",
         --1:MANY between facility and operator; currently using highest operator ID     
         substr(fop.facility_operator_name,1,100) as "FacilityOperatorCompanyName", 
         fop.address_1 as "FacilityOperatorAddress1",
		 fop.address_2 as "FacilityOperatorAddress2",
         fop.city as "FacilityOperatorCity", 
         fop.county as "FacilityOperatorCounty", 
         fop.zip as "FacilityOperatorZipCode",
         fop.state as "FacilityOperatorState",
         fop.phone as "FacilityOperatorPhoneNumber",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Local Govt. Bond Rating Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityBondRatingTest",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Insurance' and fr.facility_id = f.facility_id) as "FinancialResponsibilityCommercialInsurance",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Guarantee' and fr.facility_id = f.facility_id) as "FinancialResponsibilityGuarantee",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Letter of Credit' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLetterOfCredit",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Local Govt. Financial Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLocalGovernmentFinancialTest",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Risk Retention Group' and fr.facility_id = f.facility_id) as "FinancialResponsibilityRiskRetentionGroup",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Self Insured' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySelfInsuranceFinancialTest",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'State Fund' and fr.facility_id = f.facility_id) as "FinancialResponsibilityStateFund",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type = 'Surety Bond' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySuretyBond",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type in ('Trust Fund','Standby Trust Fund') and fr.facility_id = f.facility_id) as "FinancialResponsibilityTrustFund",
--         (select listagg(fr_type,'; ') within group (order by fr_type) as fr_type from "TRUSTD_UST".ut_financial_responsibility fr where fr_type not in 
--            ('Guarantee','Insurance','Letter of Credit','Local Govt. Bond Rating Test','Local Govt. Financial Test','Risk Retention Group',
--             'Self Insured','Standby Trust Fund','State Fund','Surety Bond','Trust Fund','Govt. Entity: Federal Covered','Govt. Entity: State Covered') and fr.facility_id = f.facility_id) as "FinancialResponsibilityOtherMethod",
         (select distinct 'Yes' from "TRUSTD_UST".ut_financial_responsibility fr where fr_type like 'Govt. Entity%' and fr.facility_id = f.facility_id) as "FinancialResponsibilityNotRequired",
         ts.tank_name as "TankID", 
         'Yes' as "FederallyRegulated", --we are excluding those that are FALSE.
         tsc.compartment_name as "CompartmentID",
         case when ts.tank_status = 'Abandoned' then 'Abandoned'
              when ts.tank_status = 'Currently in Use' then 'Currently in use' 
              when ts.closure_status_desc = 'Tank closed in place' then 'Closed (in place)' 
              when ts.closure_status_desc like 'Tank removed%' then 'Closed (removed from ground)' 
              when ts.tank_status = 'Temporarily Out of Use' then 'Temporarily out of service' end as "TankStatus",
        case when ta.tank_attributes like '%:13:%' then 'Yes' end as "ManifoldedTanks",
        ts.date_closed as "ClosureDate", ts.date_installed as "InstallationDate",
        case when tscc.num_compartments > 1 or ts.tank_attributes like '%14%' then 'Yes' when  tscc.num_compartments = 1 then 'No' end as "CompartmentalizedUST",
        tscc.num_compartments as "NumberOfCompartments",
--        case when sub.substances = 3 then '00% biodiesel (not federally regulated)'    
--             when sub.substances = 8 then 'Diesel blend containing greater than 20% and less than 99% biodiesel'
--             when sub.substances = 2 then 'Diesel fuel (b-unknown)'
--             when sub.substances in (22,23) then 'Ethanol blend gasoline (e-unknown)'
--             when sub.substances = 21 then 'Gasoline (non-ethanol)'
--             when sub.substances in (1,7) then 'Gasoline E-10 (E1-E10)'
--             when sub.substances = 9 then 'Hazardous substance'
--             when sub.substances in (5,43) then 'Heating/fuel oil # unknown'
--             when sub.substances = 58 then 'Jet fuel A'
--             when sub.substances = 59 then 'Jet fuel B'
--             when sub.substances = 4 then 'Kerosene'
--             when sub.substances in (55,62) then 'Lube/motor oil (new)'
--             when sub.substances in (10,12,13,44,54,61) then 'Other'
--             when sub.substances = 11 then 'Unknown'
--             when sub.substances in (42,56,57,60) then 'Unknown aviation gas or jet fuel'
--             when sub.substances = 41 then 'Petroleum product'
--             when sub.substances = 6 then 'Used oil/waste oil' end as "CompartmentSubstanceStored",
        ts.tank_capacity as "TankCapacityGallons", --assume unit is gallons
        tsc.compartment_capacity as "CompartmentCapacityGallons", --assume unit is gallons
        case when ta.tank_attributes like '%:11:%' then 'Yes' end as "ExcavationLiner",
        case when ta.tank_attributes like '%:43:%' then 'Single' 
             when ta.tank_attributes like '%:12:%' then 'Double' 
             when ta.tank_attributes like '%:41:%' then 'Triple' end as "TankWallType",
        case when ta.tank_attributes like '%:8:%' then 'Fiberglass reinforced plastic' 
             when ta.tank_attributes like '%:1:%' then 'Asphalt coated or bare steel'  
             when ta.tank_attributes like '%:6:%' then 'Composite/Cclad (steel w/fiberglass reinforced plastic)' 
             when ta.tank_attributes like '%:7:%' then 'Concrete' 
             when ta.tank_attributes like '%:19:%' then 'Epoxy coated steel' 
             when ta.tank_attributes like '%:4:%' or ta.tank_attributes like '%:5:%' then 'Coated and cathodically protected steel' 
             when ta.tank_attributes like '%:18:%' then 'Cathodically protected steel (without coating)' 
             when ta.tank_attributes like '%:9:%' then 'Jacketed steel' 
             when ta.tank_attributes like '%:17:%' then 'Other' 
             when ta.tank_attributes like '%:16:%' then 'Unknown' end as "MaterialDescription",
        case when ts.tank_repaired = True then 'Yes' when ts.tank_repaired = False then 'No' end as "TankRepaired", 
        ts.repair_date as "TankRepairDate",
        case when pa.piping_attributes like '%:1:%' then 'Steel' 
             when pa.piping_attributes like '%:5:%' then 'Copper' 
             when pa.piping_attributes like '%:3:%' then 'Fiberglass reinforced plastic' 
             when pa.piping_attributes like '%:2:%' then 'Galvanized steel' 
             when pa.piping_attributes like '%:4:%' then 'Flex piping' 
             when pa.piping_attributes like '%:13:%' then 'No piping' 
             when pa.piping_attributes like '%:11:%' then 'Unknown' 
             when pa.piping_attributes like '%:12:%' then 'Other' end as "PipingMaterialDescription",
        case when ps.piping_deliveries like '%:1:%' or ps.piping_deliveries like '%:2:%' or ps.piping_deliveries like '%:23:%' then 'Suction'
             when ps.piping_deliveries like '%:3:%' then 'Pressure'
             when ps.piping_deliveries like '%:4:%' then 'Non-operational ( e.g., fill line, vent line, gravity)'
             when ps.piping_deliveries like '%:6:%' or ps.piping_deliveries like '%:22:%' then 'Unknown'
             when ps.piping_deliveries like '%:5:%' or  ps.piping_deliveries like '%:21:%' then 'Other' end as "PipingStyle",
        case when pa.piping_attributes like '%:8:%' then 'Double Walled' end as "PipingWallType",
        case when tsc.pipe_repaired = True then 'Yes' when tsc.pipe_repaired = False then 'No' end as "PipingRepaired",
        case when ta.tank_attributes like '%:2:%' or ta.tank_attributes like '%:4:%'  then 'Yes' end as "TankCorrosionProtectionImpressedCurrent",
        case when ta.tank_attributes like '%:3:%' or ta.tank_attributes like '%:5:%'  then 'Yes' end as "TankCorrosionProtectionSacrificialAnode",
        case when pa.piping_attributes like '%:6:%' then 'Yes' end as "PipingCorrosionProtectionImpressedCurrent",
        case when pa.piping_attributes like '%:7:%' then 'Yes' end as "PipingCorrosionProtectionSacrificialAnode",
        case when tsc.overfill_protections like '%1%' or tsc.overfill_protections like '%6%' then 'Yes' end as "AutomaticShutoffDevice",
        case when tsc.overfill_protections like '%3%' then 'Yes' end as "OverfillAlarm",
        case when tsc.overfill_protections like '%2%' or tsc.overfill_protections like '%5%' then 'Yes' end as "BallFloatValve",
        case when upper(tsc.spill_installed) = 'TRUE' then 'Yes' when upper(tsc.spill_installed) = 'FALSE' or tsc.spill_installed = 'Exempt due to small delivery' then 'No' end as "SpillBucketInstalled",
        case when tsc.spill_preventions in (1,21) then 'Double' when tsc.spill_preventions = 41 then 'Single' end as "SpillBucketWallType",
        case when trd.tank_release_detections like '%:7:%' then 'Yes' end as "InterstitialMonitoringUnknonwType",
        case when trd.tank_release_detections like '%:4:%' then 'Yes' end as "AutomaticTankGauging", --if this is "Yes", AutomaticTankGaugingReleaseDetection and AutomaticTankGaugingContinuousLeakDetection are supposed to be required but cannot be answered
        case when trd.tank_release_detections like '%:1:%' then 'Yes' end as "ManualTankGauging",
        case when trd.tank_release_detections like '%:9:%' then 'Yes' end as "StatisticalInventoryReconciliation",
        case when trd.tank_release_detections like '%:2:%' then 'Yes' end as "TankTightnessTesting",
        case when trd.tank_release_detections like '%:6:%' then 'Yes' end as "GroundwaterMonitoring",
        case when trd.tank_release_detections like '%:5:%' then 'Yes' end as "VaporMonitoring",
        case when trd.tank_release_detections like '%:9:%' then 'Yes' end as "GroundwaterMonitoring",
        case when trd.tank_release_detections like '%:21:%' then 'Yes' end as "ElectronicLineLeakDetector",
        case when trd.tank_release_detections like '%:22:%' then 'Yes' end as "MechanicalLineLeakDetector",
        case when r.release_id is not null then 'Yes' end as "USTReportedRelease",
        r.release_id as "AssociatedLUSTID" --!! does release_id relate to a LUST ID?
from "TRUSTD_UST".ut_facility f left join "TRUSTD_UST".ut_land_location ll on f.land_location_id = ll.land_location_id
    left join (select land_location_id, land_use_type_desc from 
				(select a.land_location_id, b.land_use_type_desc,
					row_number() over (partition by a.land_location_id order by a.date_observed) rn 
			     from "TRUSTD_UST".ut_land_use_hist a join "TRUSTD_UST".ut_land_use_type b on a.land_use_type_id = b.land_use_type_id
			     where a.end_date is null) w where rn = 1) luh1 on ll.land_location_id = luh1.land_location_id
    left join (select land_location_id, land_use_type_desc from 
				(select a.land_location_id, b.land_use_type_desc,
					row_number() over (partition by a.land_location_id order by a.date_observed) rn 
			     from "TRUSTD_UST".ut_land_use_hist a join "TRUSTD_UST".ut_land_use_type b on a.land_use_type_id = b.land_use_type_id
			     where a.end_date is null) w where rn = 2) luh2 on ll.land_location_id = luh2.land_location_id
    left join "TRUSTD_UST".ut_tribes t on ll.tribe_id = t.tribe_id
    left join "TRUSTD_UST".st_regions rg on t.region_id = rg.region_id
    left join (select * from (select fh.facility_id, lre.responsible_entity_name, lre.address_1, lre.address_2, 
    							     lre.city, lre.state, lre.zip, lre.county, lre.phone, lre.email_addr,
       				            	 row_number() over (partition by fh.facility_id order by fh.end_date desc nulls first, 
       				            							fh.date_observed desc nulls last, fh.ut_facility_owner_hist_id desc) rn
			  				 from "TRUSTD_UST".ut_facility_owner_hist fh 
			  				 	join "TRUSTD_UST".ut_legally_responsible_entity lre on lre.responsible_entity_id = fh.responsible_entity_id) lre
			  				 where rn = 1) fo on f.facility_id = fo.facility_id 
    left join (select c.facility_id, d.* from "TRUSTD_UST".ut_facility_operator d join        
                (select a.facility_id, facility_operator_id from "TRUSTD_UST".ut_facility_oper_hist a join         
                    (select facility_id, max(ut_facility_oper_hist_id) as ut_facility_oper_hist_id 
                     from "TRUSTD_UST".ut_facility_oper_hist where end_date is null group by facility_id) b        
                        on a.ut_facility_oper_hist_id = b.ut_facility_oper_hist_id) c on c.facility_operator_id = d.facility_operator_id) fop
            on f.facility_id = fop.facility_id    
    left join "TRUSTD_UST".ut_tank_system ts on f.facility_id = ts.facility_id
    left join "TRUSTD_UST".ut_tank_system_comp tsc on ts.tank_system_id = tsc.tank_system_id
    left join (select tank_system_id, count(*) num_compartments from "TRUSTD_UST".ut_tank_system_comp group by tank_system_id) tscc on tsc.tank_system_id = tscc.tank_system_id
    left join (select tank_system_id, ':' || tank_attributes || ':' as tank_attributes from "TRUSTD_UST".ut_tank_system) ta on ts.tank_system_id = ta.tank_system_id
    left join (select tank_system_id, ':' || piping_attributes || ':' as piping_attributes from "TRUSTD_UST".ut_tank_system_comp) pa on ts.tank_system_id = pa.tank_system_id
    left join (select tank_system_id, ':' || piping_deliveries || ':' as piping_deliveries from "TRUSTD_UST".ut_tank_system_comp) ps on ts.tank_system_id = ps.tank_system_id
    left join (select tank_system_id, ':' || tank_release_detections || ':' as tank_release_detections from "TRUSTD_UST".ut_tank_system_comp) trd on ts.tank_system_id = trd.tank_system_id
    left join (select tank_system_id, ':' || pipe_release_detections || ':' as pipe_release_detections from "TRUSTD_UST".ut_tank_system_comp) prd on ts.tank_system_id = prd.tank_system_id
--    left join (select tank_system_id, case when substances like '%:%' then substr(substances,0,instr(substances,':')-1) else substances end as substances from "TRUSTD_UST".ut_tank_system_comp) sub on ts.tank_system_id = sub.tank_system_id
    left join (select distinct a.land_location_id, a.release_id from "TRUSTD_UST".ut_release a 
				join (select release_id, max(event_date) from "TRUSTD_UST".ut_release_event 
				      where release_event_type_id = 2 and release_id not in 
				      	(select release_id from "TRUSTD_UST".ut_release_event where release_event_type_id = 6)
				      group by release_id) b on a.release_id = b.release_id) r on f.land_location_id = r.land_location_id 
where ll.land_status <> 'Not Indian Country' 
and ts.federal_regulated_tank = True
order by 1;

select distinct spill_installed from "TRUSTD_UST".ut_tank_system_comp 

select * from facility_type  

select * from ust_elements 

--ut_facility
--ut_land_location
--ut_land_use_hist
--ut_tribes
--st_regions
--ut_facility_owner
--ut_facility_owner_hist
--ut_facility_operator
--ut_facility_oper_hist
--ut_tank_system
--ut_tank_system_comp
--ut_release
--ut_release_event
--ut_financial_responsibility

select count(*) from (
	select distinct "FacilityID", "TankID", "CompartmentID" from v_ust where organization_id = 'TRUSTD'
) a;


select distinct "TANK_STATUS" from "TRUSTD_UST"."UT_TANK_SYSTEM"

select tank_status, count(*) from (
   SELECT DISTINCT F."LAND_LOCATION_ID" AS "FACILITYID", TS."TANK_NAME", TSC."COMPARTMENT_NAME", 
   		case when ts."TANK_STATUS" in ('Currently in Use', 'Temporarily Out of Use','Abandoned') then 'Active'
   		     when ts."TANK_STATUS" = 'Permanently Out of Use' then 'Closed' end as tank_status
   FROM  "TRUSTD_UST"."UT_FACILITY" F LEFT JOIN "TRUSTD_UST"."UT_LAND_LOCATION" LL ON F."LAND_LOCATION_ID" = LL."LAND_LOCATION_ID"
   		LEFT JOIN "TRUSTD_UST"."UT_TANK_SYSTEM" TS ON F."FACILITY_ID" = TS."FACILITY_ID"
		LEFT JOIN "TRUSTD_UST"."UT_TANK_SYSTEM_COMP" TSC ON TS."TANK_SYSTEM_ID" = TSC."TANK_SYSTEM_ID"
   WHERE LL."LAND_STATUS" <> 'Not Indian Country'
   AND TS."FEDERAL_REGULATED_TANK" = 'TRUE'
) a
group by tank_status;

drop table temp_trustd;

SELECT DISTINCT F."LAND_LOCATION_ID" AS "FACILITYID", TS."TANK_NAME", TSC."COMPARTMENT_NAME", 
	case when ts."TANK_STATUS" in ('Currently in Use', 'Temporarily Out of Use','Abandoned') then 'Active'
   		 when ts."TANK_STATUS" = 'Permanently Out of Use' then 'Closed' end as tank_status
into temp_trustd
FROM  "TRUSTD_UST"."UT_FACILITY" F LEFT JOIN "TRUSTD_UST"."UT_LAND_LOCATION" LL ON F."LAND_LOCATION_ID" = LL."LAND_LOCATION_ID"
	LEFT JOIN "TRUSTD_UST"."UT_TANK_SYSTEM" TS ON F."FACILITY_ID" = TS."FACILITY_ID"
	LEFT JOIN "TRUSTD_UST"."UT_TANK_SYSTEM_COMP" TSC ON TS."TANK_SYSTEM_ID" = TSC."TANK_SYSTEM_ID"
WHERE LL."LAND_STATUS" <> 'Not Indian Country'
AND TS."FEDERAL_REGULATED_TANK" = 'TRUE';

select * from "TRUSTD_UST"."UT_FACILITY"  where "LAND_LOCATION_ID" <> "FACILITY_ID"

       Not Indian Country
       
  select distinct "FacilityID",  "TankID", "CompartmentID"
  from v_ust a where organization_id = 'TRUSTD' and not exists 
  	(select 1 from temp_trustd b
  	where a."FacilityID"  = b."FACILITYID"::text and a."TankID" = b."TANK_NAME" and a."CompartmentID" = b."COMPARTMENT_NAME");


select count(*) from temp_trustd;
8867


select count(*) from (
	select distinct a.*, f.*, ts.*, tsc.*
	from temp_trustd a 
		left join "TRUSTD_UST"."UT_FACILITY" f on a."FACILITYID" = f."FACILITY_ID"
		left join "TRUSTD_UST"."UT_LAND_LOCATION" LL ON F."LAND_LOCATION_ID" = LL."LAND_LOCATION_ID"
		left join "TRUSTD_UST"."UT_TANK_SYSTEM" TS ON f."FACILITY_ID" = TS."FACILITY_ID" and a."TANK_NAME" = ts."TANK_NAME"
		left join "TRUSTD_UST"."UT_TANK_SYSTEM_COMP" TSC ON TS."TANK_SYSTEM_ID" = TSC."TANK_SYSTEM_ID"
	where LL."LAND_STATUS" <> 'Not Indian Country'
	AND TS."FEDERAL_REGULATED_TANK" = 'TRUE'
	order by 1, 2, 3
) x;
5111

select count(*) from "TRUSTD_UST"."UT_LAND_LOCATION"  where "LAND_STATUS" is null;
select * from "TRUSTD_UST"."UT_TANK_SYSTEM" where "FEDERAL_REGULATED_TANK" is null;



       
select distinct "FacilityID",  "TankID", "CompartmentID"
from v_ust a where organization_id = 'TRUSTD' and not exists 
	(select 1 from temp_trustd b
	where a."FacilityID"  = b."FACILITYID"::text and a."TankID" = b."TANK_NAME" 
	and a."CompartmentID" = b."COMPARTMENT_NAME");

1010	1	1 Compartment
1010	2a	2a Compartment
1010	2b	2b Compartment
1011		
select * from "TRUSTD_UST"."UT_FACILITY" where "LAND_LOCATION_ID" = '1010'


select * from "TRUSTD_UST"."UT_FACILITY" 
where "LAND_LOCATION_ID"::text in   
	(select distinct "FacilityID"
	from v_ust a where organization_id = 'TRUSTD' and not exists 
		(select 1 from temp_trustd b
		where a."FacilityID"  = b."FACILITYID"::text and a."TankID" = b."TANK_NAME" 
		and a."CompartmentID" = b."COMPARTMENT_NAME"));


select * from "TRUSTD_UST"."UT_TANK_SYSTEM" where "TANK_NAME" 


select * from "TRUSTD_UST".v_ust_base where "FacilityID" = '10000'

select * from "TRUSTD_UST"."UT_TANK_SYSTEM" where "FACILITY_ID"  = '10000'

select * from temp_trustd order by 1 desc, 2, 3;where  "FACILITYID"  = '10000'


select count(*) from "TRUSTD_UST"."UT_TANK_SYSTEM"
where "FEDERAL_REGULATED_TANK" = 'TRUE'

select count(*) from "TRUSTD_UST"."UT_TANK_SYSTEM_COMP"

delete
from ust where organization_id = 'TRUSTD' and "FacilityID" in 
	(select "FACILITY_ID"::text from "TRUSTD_UST"."UT_FACILITY" f join  "TRUSTD_UST"."UT_LAND_LOCATION" ll on f."LAND_LOCATION_ID" = ll."LAND_LOCATION_ID"
	where "LAND_STATUS" = 'Not Indian Country');

