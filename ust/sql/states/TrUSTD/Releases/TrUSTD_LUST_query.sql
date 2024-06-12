
insert into lust_control(organization_id, date_received, date_processed, data_source, comments)
values ('TRUSTD','2023-07-21','2023-07-24','TrUSTD Oracle database on EPA server','exported required tables using Python script; redoing for OUST performance measures due to too many rows');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--create views containing most recent release event 
create view "TRUSTD_LUST".v_ut_release_event_base as 
select a.*, c.release_event_desc, c.sequence
from "TRUSTD_UST".ut_release_event a 
	join 
	(select release_id, coalesce(max(event_date),'X') event_date
	from "TRUSTD_UST".ut_release_event group by release_id) b 
		on a.release_id = b.release_id and coalesce(a.event_date,'X') = coalesce(b.event_date,'X')
	join "TRUSTD_UST".ut_release_event_type c on a.release_event_type_id = c.release_event_type_id;

create view "TRUSTD_LUST".v_ut_release_event as
select a.*
from "TRUSTD_LUST".v_ut_release_event_base a
	join
	(select release_id, coalesce(max(sequence),999) sequence 
	from "TRUSTD_LUST".v_ut_release_event_base group by release_id) b
		on a.release_id = b.release_id and a.sequence = b.sequence;


create view "TRUSTD_LUST".v_ut_release_event_orig_base as 
select a.*, c.release_event_desc, c.sequence
from "TRUSTD_UST".ut_release_event a 
	join 
	(select release_id, coalesce(min(event_date),'X') event_date
	from "TRUSTD_UST".ut_release_event group by release_id) b 
		on a.release_id = b.release_id and coalesce(a.event_date,'X') = coalesce(b.event_date,'X')
	join "TRUSTD_UST".ut_release_event_type c on a.release_event_type_id = c.release_event_type_id;

create view "TRUSTD_LUST".v_ut_release_event_orig as
select a.*
from "TRUSTD_LUST".v_ut_release_event_base a
	join
	(select release_id, coalesce(min(sequence),999) sequence 
	from "TRUSTD_LUST".v_ut_release_event_base group by release_id) b
		on a.release_id = b.release_id and a.sequence = b.sequence;	
	
drop view "TRUSTD_LUST".v_impacted_media cascade;
create or replace view "TRUSTD_LUST".v_impacted_media as 
select release_id, ut_impacted_media_type_id
from "TRUSTD_UST".ut_release, unnest(string_to_array(impacted_media_new, ':')) ut_impacted_media_type_id;
	
drop view "TRUSTD_LUST".v_product_type_released cascade;
create or replace view "TRUSTD_LUST".v_product_type_released as 
select a.*, row_number() over (partition by release_id) as rn 
from 
	(select release_id, ut_substance_type_id
	from "TRUSTD_UST".ut_release, unnest(string_to_array(product_type_released, ':')) ut_substance_type_id) a;

--select count(*) from "TRUSTD_UST".ut_release where product_type_released is not null;
--
--select * from "TRUSTD_LUST".v_product_type_released
--where ut_substance_type_id::int not in (select ut_substance_type_id from "TRUSTD_UST".ut_substance_type)
--
--select release_id, count(*) from "TRUSTD_LUST".v_product_type_released
--group by release_id having count(*) > 3;

drop view "TRUSTD_LUST".v_suspected_causes cascade;
create or replace view "TRUSTD_LUST".v_suspected_causes as 
select a.*, row_number() over (partition by release_id) as rn 
from 
	(select release_id, ut_suspected_cause_type_id
	from "TRUSTD_UST".ut_release, unnest(string_to_array(suspected_causes, ':')) ut_suspected_cause_type_id) a;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'CoordinateSource', 'ut_land_location', 'lat_lon_source', null, null, null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, ''' || lat_lon_source || ''', '''');'
from "TRUSTD_UST".ut_land_location order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'Estimated', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'Geocode', 'Geocoded address');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'GPS_EPA', 'GPS');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'GPS_State', 'GPS');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'GPS_Tribe', 'GPS');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'Legacy Verified', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'OnlineMapGoogle', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'OnlineMapMS', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'Site Assessment Report by MCE Environmental dated 2/12/2003', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'Trimble, collected 5/3/2010', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'Trimble, collected 5/4/2010', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'Trimble, collected 5/5/2010', 'Other');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'LUSTStatus', 'ut_release_event_type', 'release_event_desc', 'v_ut_release_event', 'release_event_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, ''' || release_event_desc || ''', '''');'
from "TRUSTD_UST".ut_release_event_type order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Cleanup Completed (NFA - Confirmed Release)', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Cleanup Initiated', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Confirmed Release', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Continued GW Monitoring', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Determination of Non-Jurisdiction', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Emergency Response Taken with Federal Funds', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Emergency Response Taken with State Funds', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'NFA - Suspected Release', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Pending', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Release Mitigated', 'Active: post remediation monitoring');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Site Investigation Completed', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Site Investigation Initiated', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Suspected Release', 'Active: general');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'MediaImpactedSoil', 'ut_impacted_media_type', 'ut_impacted_media_desc', 'v_impacted_media', 'ut_impacted_media_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (89, ''' || ut_impacted_media_desc || ''', '''');'
from "TRUSTD_UST".ut_impacted_media_type order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (89, 'Soil', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'MediaImpactedGroundwater', 'ut_impacted_media_type', 'ut_impacted_media_desc', 'v_impacted_media', 'ut_impacted_media_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, ''' || ut_impacted_media_desc || ''', '''');'
from "TRUSTD_UST".ut_impacted_media_type order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'Groundwater', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'MediaImpactedSurfaceWater', 'ut_impacted_media_type', 'ut_impacted_media_desc', 'v_impacted_media', 'ut_impacted_media_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, ''' || ut_impacted_media_desc || ''', '''');'
from "TRUSTD_UST".ut_impacted_media_type order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'Surface (no impact to soil)', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'Surface Water', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'ClosedWithContamination', 'ut_release', 'closed_resid_contam', null, null, null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, ''' || closed_resid_contam || ''', '''');'
from "TRUSTD_UST".ut_release order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'N', 'No');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Y', 'Yes');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'SubstanceReleased1', 'ut_substance_type', 'ut_substance_desc', 'v_product_type_released', 'ut_substance_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, ''' || ut_substance_desc || ''', '''');'
from "TRUSTD_UST".ut_substance_type order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, '0% ethanol', 'Gasoline (non-ethanol)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Av Gas', 'Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (94, 'Biodiesel', '100% biodiesel (not federally regulated)', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Biodiesel (B10)', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Diesel Containing >20% Biodiesel', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (94, 'Diesel Exhaust Fluid', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Gasohol', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Gasohol 10% or less', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Gasoline (containing <=10% ethanol)', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Gasoline Containing >10% Ethanol', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Gasoline/Diesel (Legacy)', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Hazardous Substance', 'Hazardous substance');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Heating Oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Hydraulic Oil', 'Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Jet A', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Jet B', 'Jet fuel B');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Jet Fuel', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'JP-4', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'JP-8', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Mineral Oil (Transformer Oil)', 'Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Mixture Of Substances', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Motor Oil (New)', 'Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Stove Oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Unknown Petroleum', 'Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Used Oil', 'Used oil/waste oil');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'SubstanceReleased2', 'ut_substance_type', 'ut_substance_desc', 'v_product_type_released', 'ut_substance_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, '0% ethanol', 'Gasoline (non-ethanol)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Av Gas', 'Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (95, 'Biodiesel', '100% biodiesel (not federally regulated)', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Biodiesel (B10)', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Diesel Containing >20% Biodiesel', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (95, 'Diesel Exhaust Fluid', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Gasohol', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Gasohol 10% or less', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Gasoline (containing <=10% ethanol)', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Gasoline Containing >10% Ethanol', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Gasoline/Diesel (Legacy)', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Hazardous Substance', 'Hazardous substance');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Heating Oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Hydraulic Oil', 'Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Jet A', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Jet B', 'Jet fuel B');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Jet Fuel', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'JP-4', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'JP-8', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Mineral Oil (Transformer Oil)', 'Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Mixture Of Substances', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Motor Oil (New)', 'Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Stove Oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Unknown Petroleum', 'Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Used Oil', 'Used oil/waste oil');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'SubstanceReleased3', 'ut_substance_type', 'ut_substance_desc', 'v_product_type_released', 'ut_substance_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, '0% ethanol', 'Gasoline (non-ethanol)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Av Gas', 'Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (96, 'Biodiesel', '100% biodiesel (not federally regulated)', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Biodiesel (B10)', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Diesel Containing >20% Biodiesel', 'Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, exclude_from_query) values (96, 'Diesel Exhaust Fluid', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Gasohol', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Gasohol 10% or less', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Gasoline (containing <=10% ethanol)', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Gasoline Containing >10% Ethanol', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Gasoline/Diesel (Legacy)', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Hazardous Substance', 'Hazardous substance');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Heating Oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Hydraulic Oil', 'Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Jet A', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Jet B', 'Jet fuel B');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Jet Fuel', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'JP-4', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'JP-8', 'Jet Fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Mineral Oil (Transformer Oil)', 'Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Mixture Of Substances', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Motor Oil (New)', 'Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Stove Oil', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Unknown Petroleum', 'Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Used Oil', 'Used oil/waste oil');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'CauseOfRelease1', 'ut_suspected_cause_type', 'ut_suspected_cause_desc', 'v_suspected_causes', 'ut_suspected_cause_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

select distinct ut_suspected_cause_type_id, 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, ''' || ut_suspected_cause_desc || ''', '''');'
from "TRUSTD_UST".ut_suspected_cause_type order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, 'Leaking Pipe', 'Piping failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, 'Leaking Tank', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, 'Overfill', 'Delivery overfill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, 'Spill', 'Dispenser spill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, 'Unknown', 'Unknown');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'CauseOfRelease2', 'ut_suspected_cause_type', 'ut_suspected_cause_desc', 'v_suspected_causes', 'ut_suspected_cause_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Leaking Pipe', 'Piping failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Leaking Tank', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Overfill', 'Delivery overfill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Spill', 'Dispenser spill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Unknown', 'Unknown');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (18, '2023-07-25', 'CauseOfRelease3', 'ut_suspected_cause_type', 'ut_suspected_cause_desc', 'v_suspected_causes', 'ut_suspected_cause_type_id', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || ' || state_column_name || ' || '''''', '''''''');''
from "TRUSTD_UST".' || state_table_name || ' order by 1;' as vsql;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (99, 'Leaking Pipe', 'Piping failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (99, 'Leaking Tank', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (99, 'Overfill', 'Delivery overfill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (99, 'Spill', 'Dispenser spill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (99, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (99, 'Unknown', 'Unknown');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select distinct suspected_causes from "TRUSTD_UST".ut_release;

    decode(substr(suspected_causes,1,1),'1','Piping failure','2','Other','3','Delivery Overfill','4','Dispenser Spill','5','Other','6','Unknown') as "CauseOfRelease1",
   
    select * from cause 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

drop view  "TRUSTD_LUST".v_lust_base;

create or replace view "TRUSTD_LUST".v_lust_base as 
select distinct 
    r.land_location_id::text as "FacilityID", --use land_location_id not facility_id per OUST
    ts.tank_name as "TankIDAssociatedwithRelease",
    r.release_id::text as "LUSTID",
    ll.location_name as "SiteName",
    left(ll.address_1,100) as "SiteAddress",
    ll.address_2 as "SiteAddress2",
    ll.city as "SiteCity",
    ll.zip::text as "Zipcode",
    ll.county as "County",
    ll.state as "State",
    case when rg.region_key like 'R%' then replace(rg.region_key,'R','')::int end as "EPARegion",
	case when ll.tribe_owned in ('True','TRUE','Y') or ll.tribe_id is not null then 'Yes' 
	     when ll.tribe_owned in ('False','FALSE','N') then 'No' else null end as "FacilityTribalSite", 
	case when ll.tribe is not null and t.current_name is null then left(ll.tribe,200) 
	     when t.current_name is not null then left(t.current_name,200) else null end as "FacilityTribe",
    ll.latitude as "Latitude",
    ll.longitude as "Longitude",
    cs.epa_value as "CoordinateSource",
    ls.epa_value as "LUSTStatus",
	reo.event_date::date as "ReportedDate",
	case when ls.epa_value = 'No further action' then re.event_date::date end as "NFADate",
	mis.epa_value as "MediaImpactedSoil", 
    mig.epa_value as "MediaImpactedGroundwater",
    misw.epa_value as "MediaImpactedSurfaceWater",
    sr1.epa_value as "SubstanceReleased1", 
    sr1.epa_value as "SubstanceReleased2", 
    sr1.epa_value as "SubstanceReleased3",
    cr1.epa_value as "CauseOfRelease1",
    cr2.epa_value as "CauseOfRelease2", 
    cr3.epa_value as "CauseOfRelease3",
    cwc.epa_value as "ClosedWithContamination"
from "TRUSTD_UST".ut_release r 
	left join "TRUSTD_UST".ut_tank_system ts on r.tank_system_id = ts.tank_system_id
	left join "TRUSTD_UST".ut_land_location ll on r.land_location_id = ll.land_location_id
    left join "TRUSTD_UST".st_regions rg on ll.region_id = rg.region_id
    left join "TRUSTD_UST".ut_tribes t on ll.tribe_id = t.tribe_id
    left join "TRUSTD_LUST".v_ut_release_event re on r.release_id = re.release_id
    left join "TRUSTD_LUST".v_ut_release_event_orig reo on r.release_id = reo.release_id
    left join (select state_value, epa_value from v_lust_element_mapping where control_id = 12 and element_name = 'CoordinateSource') cs on ll.lat_lon_source = cs.state_value
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_release_event_type b on a.state_value = b.release_event_desc
    		   join "TRUSTD_LUST".v_ut_release_event c on b.release_event_type_id = c.release_event_type_id where control_id = 12 and element_name = 'LUSTStatus') ls on r.release_id = ls.release_id
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_impacted_media_type b on a.state_value = b.ut_impacted_media_desc
    		   join "TRUSTD_LUST".v_impacted_media c on b.ut_impacted_media_type_id = c.ut_impacted_media_type_id::int where control_id = 12 and element_name = 'MediaImpactedSoil') mis on r.release_id = mis.release_id 
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_impacted_media_type b on a.state_value = b.ut_impacted_media_desc
    		   join "TRUSTD_LUST".v_impacted_media c on b.ut_impacted_media_type_id = c.ut_impacted_media_type_id::int where control_id = 12 and element_name = 'MediaImpactedGroundwater') mig on r.release_id = mig.release_id 
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_impacted_media_type b on a.state_value = b.ut_impacted_media_desc
    		   join "TRUSTD_LUST".v_impacted_media c on b.ut_impacted_media_type_id = c.ut_impacted_media_type_id::int where control_id = 12 and element_name = 'MediaImpactedSurfaceWater') misw on r.release_id = misw.release_id 
    left join (select state_value, epa_value from v_lust_element_mapping where control_id = 12 and element_name = 'ClosedWithContamination') cwc on r.closed_resid_contam = cwc.state_value    		   
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_substance_type b on a.state_value = b.ut_substance_desc
    		   join "TRUSTD_LUST".v_product_type_released c on b.ut_substance_type_id = c.ut_substance_type_id::int where control_id = 12 and element_name = 'SubstanceReleased1' and rn = 1) sr1 on r.release_id = sr1.release_id 
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_substance_type b on a.state_value = b.ut_substance_desc
    		   join "TRUSTD_LUST".v_product_type_released c on b.ut_substance_type_id = c.ut_substance_type_id::int where control_id = 12 and element_name = 'SubstanceReleased2' and rn = 2) sr2 on r.release_id = sr2.release_id 
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_substance_type b on a.state_value = b.ut_substance_desc
    		   join "TRUSTD_LUST".v_product_type_released c on b.ut_substance_type_id = c.ut_substance_type_id::int where control_id = 12 and element_name = 'SubstanceReleased3' and rn = 3) sr3 on r.release_id = sr3.release_id 
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_suspected_cause_type b on a.state_value = b.ut_suspected_cause_desc
    		   join "TRUSTD_LUST".v_suspected_causes c on b.ut_suspected_cause_type_id = c.ut_suspected_cause_type_id::int where control_id = 12 and element_name = 'CauseOfRelease1' and rn = 1) cr1 on r.release_id = cr1.release_id 
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_suspected_cause_type b on a.state_value = b.ut_suspected_cause_desc
    		   join "TRUSTD_LUST".v_suspected_causes c on b.ut_suspected_cause_type_id = c.ut_suspected_cause_type_id::int where control_id = 12 and element_name = 'CauseOfRelease2' and rn = 2) cr2 on r.release_id = cr2.release_id 
    left join (select state_value, epa_value, release_id from v_lust_element_mapping a join "TRUSTD_UST".ut_suspected_cause_type b on a.state_value = b.ut_suspected_cause_desc
    		   join "TRUSTD_LUST".v_suspected_causes c on b.ut_suspected_cause_type_id = c.ut_suspected_cause_type_id::int where control_id = 12 and element_name = 'CauseOfRelease3' and rn = 3) cr3 on r.release_id = cr3.release_id 
where exists (select 1 from "TRUSTD_UST".ut_release_event re where r.release_id = re.release_id and re.release_event_type_id = 2) --must include a confirmed release event
and not exists (select 1 from "TRUSTD_UST".ut_release_event re where r.release_id = re.release_id and re.release_event_type_id = 6) --must NOT include a Determination of Non-Jurisdiction
;     

select count(*) from "TRUSTD_LUST".v_lust_base;



select distinct element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk, element_db_mapping_id
from v_lust_element_mapping 
where control_id = 12
order by element_db_mapping_id;




select '"' || column_name || '",' from information_schema.columns where table_schema = 'public' and table_name = 'lust_locations' order by ordinal_position;

insert into lust_locations("control_id",
"organization_id",
"LUSTID",
"SiteName",
"SiteAddress",
"SiteAddress2",
"SiteCity",
"Zipcode",
"County",
"State",
"Latitude",
"Longitude")
select distinct 12, 'TRUSTD', "LUSTID",
"SiteName",
"SiteAddress",
"SiteAddress2",
"SiteCity",
"Zipcode",
"County",
"State",
"Latitude",
"Longitude" from "TRUSTD_LUST".v_lust_base
