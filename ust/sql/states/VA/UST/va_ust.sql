------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data

/*refer to working_compartment, working_facility,working_tank, and working_piping SQL files for the initial load and mapping. This was done before the newer script below was written.*/

/*
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist),
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema.
To run, set these variables:

organization_id = 'VA'
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
ust_path = 'C:\Users\JChilton\repo\UST\ust\sql\states\VA\UST'
overwrite_table = False

OR:
manually in the database, create schema va_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * from public.ust_control where ust_control_id = 8;



--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping
where ust_control_id = 8 and mapping_complete = 'N'
order by 1, 2;


select insert_sql
from v_ust_needed_mapping_insert_sql
where ust_control_id = 8 and epa_column_name = 'substance_id';

select distinct
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 772 || ', ''' || "contents" || ''', '''', null);'
from va_ust."tanks" order by 1;

select * from public.substances where lower(substance) like lower('%MIXTURE%')


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'ASPHALT', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'DIESEL', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'DIESEL BIODIESEL', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'DIESEL LOW SULFUR', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'DIESEL OFF-ROAD', 'Off-road diesel/dyed diesel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'DIESEL ON-ROAD',  'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'DIESEL ULTRA LOW SULFUR', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'EMER GENERATOR', 'Other or mixture', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'FUEL OIL', 'Heating/fuel oil # unknown', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'FUEL OIL 2', 'Heating oil/fuel oil 2', '');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'FUEL OIL 6', 'Heating oil/fuel oil 6', '');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE AVIATION GAS', 'Aviation gasoline', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE E85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE GASOHOL', 'Ethanol blend gasoline (e-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE MID', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'Gasoline Non Ethanol', 'Gasoline (non-ethanol)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE PREMIUM', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE RACING', 'Racing fuel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'GASOLINE REGULAR', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'HAZARDOUS', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'HEATING OIL', 'Heating/fuel oil # unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'HYDRAULIC OIL', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'JET FUEL', 'Unknown aviation gas or jet fuel', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'KEROSENE', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'KEROSENE CLEAR', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'KEROSENE DYED', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'LUBE OIL', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'MIXTURE', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'MOTOR OIL', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'OTHER', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'UNKNOWN', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'USED OIL', 'Used oil/waste oil', null);



select state_value,epa_value
from archive.v_ust_element_mapping
where lower(element_name) like lower('%substance%')
and lower(state_value) like lower('%HYDRAULIC%');



--check if any of the mapping is bad:
select database_lookup_table, epa_value
from v_ust_bad_mapping
where ust_control_id = 8 order by 1, 2;
tank_statuses	Closed (general)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables
see new views:*/
select table_name
from information_schema.tables
where table_schema = 'va_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population
where ust_control_id = 8
order by table_sort_order;


/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 8;

/*Step 4: work through the tables in order, using the information you collected
to write views that can be used to populate the data tables
NOTE! The view queried below (v_ust_table_population_sql) contains columns that help
      construct the select sql for the insertion views, but will require manual
      oversight and manipulation by you!
      In particular, check out the organization_join_table and organization_join_column
      are used!!*/
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name
from v_ust_table_population_sql
where ust_control_id = 8 and epa_table_name = 'ust_facility'
order by column_sort_order;

/*Step 5: use the information from the queries above to create the view:
!!! NOTE look at the programmer_comments column to adjust the view if necessary
!!! NOTE also sometimes you need to explicitly cast data types so they match the EPA data tables
!!! NOTE also you may get errors related to data conversion when trying to compile the view
    you are creating here. This is good because it alerts you the data you are trying to
    insert is not compatible with the EPA format. Fix these errors before proceeding!
!!! NOTE: Remember to do "select distinct" if necessary
!!! NOTE: Some states do not include State or EPA Region in their database, but it is generally
    safe for you to insert these yourself, so add them! (facility_state is a required field! */

create or replace view va_ust.v_ust_facility as
select distinct
"FAC_ID"::character varying(50) as facility_id,
"FAC_NAME"::character varying(100) as facility_name,
va_ust.get_owner_type("FAC_ID")::int as  owner_type_id,
"FAC_ADDR1"::character varying(100) as facility_address1,
"FAC_ADDR2"::character varying(100) as facility_address2,
"FAC_CITY"::character varying(100) as facility_city,
"NAME"::character varying(100) as facility_county,
"FAC_ZIP5"::character varying(10) as facility_zip_code,
"Lat"::double precision as facility_latitude,
"Lon"::double precision as facility_longitude,
va_ust.get_owner_name("FAC_ID")::character varying(100) as facility_owner_company_name,
'VA' as facility_state,
3 as facility_epa_region,
facility_type_id facility_type1
from va_ust."registered_petroleum_tank_facilities" x
left join va_ust.owner_data od on x."FAC_ID" = od."Fac_Id"
left join va_ust.v_facility_type_xwalk ft on x."FAC_TYPE"  = ft.organization_value
where ("FAC_ACTIVE_UST"::int > 0 or "FAC_INACTIVE_UST"::int > 0)
and "FAC_FED_REG_YN"='Y';

select * from va_ust.v_facility_type_xwalk;
select distinct "FAC_TYPE" from  "registered_petroleum_tank_facilities" order by 1;

update registered_petroleum_tank_facilities
set  "FAC_TYPE"=null where  "FAC_TYPE" = ''

--review:
select * from va_ust.v_ust_facility;
select count(*) from va_ust.v_ust_facility;
--3274
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name
from v_ust_table_population_sql
where ust_control_id = 8 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/



create index idx_tanks1 on tanks(tank_facility_id);
analyze tanks;

drop view   va_ust.v_ust_tank  cascade

create or replace view va_ust.v_ust_tank as
select distinct
x."tank_facility_id"::character varying(50) as facility_id,
"index"::integer as tank_id,
"tank_number"::character varying(50) as tank_name,
tank_status_id as tank_status_id,
"federally_regulated_tank"::character varying(7) as federally_regulated,
case when lower("other_contents") like '%em%gen%' then 'Yes' end as emergency_generator,
va_ust.get_multi_tanks(tank_facility_id) multiple_tanks,
"date_closed"::date as tank_closure_date,
"install_date"::date as tank_installation_date
from va_ust."tanks" x
left join v_tank_status_xwalk ts on  x.tank_status = ts.organization_value
where tank_type = 'UST'
and   federally_regulated_tank = 'Yes';


select * from va_ust."tanks";


select count(*) from va_ust.v_ust_tank;
--70447

--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name
from v_ust_table_population_sql
where ust_control_id = 8 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;
/*
"tanks"
"Substance"
substance_id as substance_id,
integer
substances
substance
erg_substance_deagg
Substance
*/

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/
create or replace view va_ust.v_ust_tank_substance as
select distinct
	"tank_facility_id"::character varying(50) as facility_id,
	c.tank_id as tank_id,
	sx.substance_id as substance_id
from va_ust."tanks" x
join va_ust.v_ust_tank c on x."index"::int = c.tank_id::int
left join va_ust.v_substance_xwalk sx on x."contents" = sx.organization_value
where x."contents" is not null
and tank_type = 'UST'
and   federally_regulated_tank = 'Yes';



select count(*) from va_ust.v_ust_tank_substance;
--70413

--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name
from v_ust_table_population_sql
where ust_control_id = 8 and epa_table_name = 'ust_compartment'
order by column_sort_order;


drop table va_ust.erg_compartment;

delete from va_ust.erg_compartment;
create table va_ust.erg_compartment (facility_id character varying(50), tank_id int, compartment_id int generated always as identity);
insert into va_ust.erg_compartment (facility_id, tank_id)
select distinct facility_id,tank_id from va_ust.v_ust_tank;



drop view va_ust.v_ust_compartment ;


create or replace view va_ust.v_ust_compartment as
select distinct
c.facility_id,
z.compartment_id as compartment_id,
c.tank_id as tank_id,
"capacity"::integer as compartment_capacity_gallons,
case when overfill_type in ('ALARM-BALL FLOAT','BALL FLOAT', 'AUTOMATIC SHUTOFF-BALL FLOAT') then 'Yes' end  as overfill_prevention_ball_float_valve,
case when overfill_type in (' AUTOMATIC SHUTOFF', 'AUTOMATIC SHUTOFF-BALL FLOAT') then 'Yes'  end as overfill_prevention_flow_shutoff_device,
case when overfill_type in ('ALARM-BALL FLOAT','ALARM', 'ALARM-AUTOMATIC SHUTOFF') then 'Yes' end as overfill_prevention_high_level_alarm,
case when overfill_type in ('OTHER') then 'Yes' end as  overfill_prevention_other,
case when overfill_type in ('NONE') then 'Yes'  end as  overfill_prevention_not_required,
case when "spill_device_installed" = 'Y' then 'Yes' when "spill_device_installed" = 'N' then 'No' end  as spill_bucket_installed,
case when "overfill_other_specify" = 'Y' then 'Yes'  when "overfill_other_specify" = 'N' then 'No' end as spill_prevention_other,
case when overfill_other_specify in ('Not Required','Not required') then 'Yes' else 'No' end as  spill_prevention_not_required,
case when "tank_rd_atg"  = 'Y' then 'Yes' when "tank_rd_atg" = 'N' then 'No' end as tank_automatic_tank_gauging_release_detection,
case when "tank_rd_manual_gauging"  = 'Y' then 'Yes' when "tank_rd_manual_gauging"  = 'N' then 'No' end as automatic_tank_gauging_continuous_leak_detection,
case when "tank_rd_sir" = 'Y' then 'Yes' when "tank_rd_sir" = 'N' then 'No' end as tank_statistical_inventory_reconciliation,
case when "tank_rd_tightness_testing" = 'Y' then 'Yes' when "tank_rd_tightness_testing" = 'N'  then 'No' end as tank_tightness_testing,
case when "tank_rd_inventory_control" = 'Y' then 'Yes' when "tank_rd_inventory_control" = 'N'  then 'No' end as tank_inventory_control,
case when "tank_rd_groundwater_monitoring" = 'Y' then 'Yes' when "tank_rd_groundwater_monitoring" = 'N' then 'No' end as tank_groundwater_monitoring,
case when "tank_rd_vapor_monitoring" = 'Y' then 'Yes' when "tank_rd_vapor_monitoring" = 'N' then 'No' end as tank_vapor_monitoring,
c.tank_status_id as compartment_status_id
from va_ust.tanks b
join va_ust."usttankpipereleasedetection" a  on   a.tank_facility_id=b.tank_facility_id  and a.tank_number = b.tank_number and a.tank_owner_id = b.tank_owner_id
join va_ust.v_ust_tank c on b."index"::int = c.tank_id::int
join va_ust.erg_compartment z on z.facility_id=c.facility_id and  z.tank_id=c.tank_id
where  b.federally_regulated_tank = 'Yes' and b.tank_type = 'UST';

select count(*) from va_ust.tanks a,  va_ust."usttankpipereleasedetection" b
where a.tank_facility_id = b.tank_facility_id  and a.tank_number = b.tank_number and a.tank_owner_id = b.tank_owner_id and federally_regulated_tank = 'Yes';;




select count(*) from va_ust.v_ust_tank;  70447
select count(*) from va_ust.v_ust_compartment; 70460


--------------------------------------------------------------------------------------------------------------------------
--ust_piping

delete from va_ust.erg_piping;

create table va_ust.erg_piping (facility_id character varying(50), tank_id int, compartment_id int, piping_id int generated always as identity);
insert into va_ust.erg_piping (facility_id, tank_id,compartment_id)
select distinct facility_id,tank_id,compartment_id from va_ust.v_ust_compartment;


select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments,
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name
from v_ust_table_population_sql
where ust_control_id = 8 and epa_table_name = 'ust_piping'
order by column_sort_order;



create index utpr_idx on va_ust."usttankpipereleasedetection" ("index");
analyze va_ust."usttankpipereleasedetection";


create index ep_idx on va_ust."erg_piping" ("tank_id","facility_id");
analyze va_ust.erg_piping;

drop view va_ust.v_ust_piping;

create or replace view va_ust.v_ust_piping as
select   distinct
e.facility_id,
e.tank_id,
e.piping_id::varchar(50) piping_id,
psx.piping_style_id,
e.compartment_id,
case when "pipe_material_fiberglass" = 'Y' then 'Yes' when "pipe_material_fiberglass" = 'N' then 'No'  end  as piping_material_frp,
case when "pipe_material_galvanized_steel" = 'Y' then 'Yes' when "pipe_material_galvanized_steel" = 'N' then 'No'  end  as piping_material_gal_steel,
case when "pipe_material_copper" = 'Y' then 'Yes' when "pipe_material_copper" = 'N' then 'No'  end  as piping_material_copper,
case when "pipe_material_polyflexible" = 'Y' then 'Yes' when "pipe_material_polyflexible" = 'N' then 'No'  end  as piping_material_flex,
case when "pipe_material_other" = 'Y' then 'Yes' when "pipe_material_other" = 'N' then 'No'  end  as piping_material_other,
case when "pipe_material_unknown" = 'Y' then 'Yes' when "pipe_material_unknown" = 'N' then 'No'  end  as piping_material_unknown,
case when "pipe_rd_sir" = 'Y' then 'Yes' when "pipe_rd_sir" = 'N' then 'No'  end  as piping_statistical_inventory_reconciliation,
case when "pipe_rd_alld" = 'Y' then 'Yes' when "pipe_rd_alld" = 'N' then 'No'  end  as piping_line_leak_detector,
case when "pipe_rd_atg" = 'Y' then 'Yes' when "pipe_rd_atg" = 'N' then 'No'  end  as piping_automated_intersticial_monitoring,
case when "pipe_rd_groundwater_monitoring" = 'Y' then 'Yes' when "pipe_rd_groundwater_monitoring" = 'N' then 'No'  end  as piping_groundwater_monitoring,
case when "pipe_rd_vapor_monitoring" = 'Y' then 'Yes' when "pipe_rd_vapor_monitoring" = 'N' then 'No'  end  as piping_vapor_monitoring,
case when "pipe_rd_im_secondary_containment" = 'Y' then 'Yes' when "pipe_rd_im_secondary_containment" = 'N' then 'No'  end  as pipe_secondary_containment_other,
case when psx.piping_style_id = 7 then 'Yes' else 'No'  end  as piping_material_no_piping
from va_ust.tanks b
left join va_ust."usttankpipereleasedetection" a  on   a.tank_facility_id=b.tank_facility_id  and a.tank_number = b.tank_number and a.tank_owner_id = b.tank_owner_id
left join va_ust."ustpipematerials" c  on   c.tank_facility_id=b.tank_facility_id  and c.tank_number = b.tank_number and c.tank_owner_id = b.tank_owner_id
join va_ust.erg_piping e on b.tank_facility_id=e.facility_id and b."index"::int =e.tank_id
left join v_piping_style_xwalk psx on psx.organization_value = c.piping_type
where  b.federally_regulated_tank = 'Yes' and b.tank_type = 'UST';

select * from v_piping_style_xwalk;

join sd_ust.erg_piping c on x."FacilityNumber" = c.facility_id  and x."TankNumber" = c.tank_id
left join sd_ust.v_piping_style_xwalk px on x."TankProduct" = px.organization_value
left join sd_ust.v_piping_wall_type_xwalk pwx on x."TankProduct" = pwx.organization_value

select count(*) from va_ust.v_ust_tank;70447
select count(*) from va_ust.v_ust_compartment; 70460
select count(*) from va_ust.v_ust_piping; 70499


select * from v_ust_piping;




--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name,
	organization_table_name, organization_column_name,
	organization_join_table, organization_join_column,
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 8
order by 1, 2;

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'ust'
control_id = 11
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

This script will check the views you just created in the state schema for the following:
1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
   exist.
2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
   every tank should have at least one compartment).
3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
   to its parent tables.
4) Missing required columns.
5) Required columns that exist but contain null values.
6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
   typos or other errors.
7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
   Then check for bad joins.
8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns)
   if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate
   an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format.
9) Failed check constraints.
10) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping
   and ensure the epa_value exists in the associated lookup table.

The script will also provide the counts of rows in va_ust.v_ust_facility, va_ust.v_ust_tank, va_ust.v_ust_compartment, and
   va_ust.v_ust_piping (if these views exist) - ensure these counts make sense!

The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above,
then re-run the qa script, and proceed when all errors have been resolved. */



--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema

/*run script populate_epa_data_tables.py
set variables:
ust_or_release = 'ust'
control_id = 11
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows
from v_ust_table_row_count
where ust_control_id = 8
order by sort_order;
/*
ust_facility	20321
ust_tank	70447
ust_tank_substance	70413
ust_compartment	70460
ust_piping	70591
*/


--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 8
ust_or_release = 'ust'
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 			# Set to False to export full template including mapping and reference tabs
template_only = False 		# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/


--------------------------------------------------------------------------------------------------------------------------
--export control table  summary

/*run script control_table_summary.py
set variables:
control_id = 8
ust_or_release = 'ust'
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------

