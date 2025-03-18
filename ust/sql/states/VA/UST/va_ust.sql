select * from public.ust_control where ust_control_id = 8;



select * from ust_element_mapping where ust_control_id = 8 order by epa_table_name;


select * from public.facility_types ft 

--Step 6: Map the source data values to EPA values 

/* 
 * Table public.ust_element_value_mapping documents the mapping of the source data element
 * values to EPA's lookup values. 
 * This table needs to be populated for all data elements mapped above where the EPA column 
 * has a lookup table. 
 * The following query will tell you which columns you need to perform this exercise for. 
 * (If no rows are returned, make sure you actually ran the SQL statements above after 
 * manipulating them!)

select epa_column_name from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from public.v_ust_needed_mapping 
	where ust_control_id = 8 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run the script 
 * generate_value_mapping_sql.py. Set the following variables before running the script:
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.
 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/XX/UST/XX_UST_value_mapping.sql). Open the generated file in your database console 
 * and step through it.  
 * 
 */



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_status_id

--select distinct "tank_status" from va_ust."tanks" where "tank_status" is not null order by 1;
/* Organization values are:

CLOSED IN PLACE
CLS IN GRD
CURR IN USE
DISMANTLED
PERM OUT OF USE
REM FROM GRD
TEMP OUT OF USE
 */


select * from public.ust_element_value_mapping where ust_element_mapping_id 
in (select ust_element_mapping_id from public.ust_element_mapping where ust_control_id = 8);



select * from public.ust_element_mapping where ust_control_id = 8 order by epa_table_name,epa_column_name; 

select * from public.ust_element_value_mapping where ust_element_mapping_id = 7 order by 3;
/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2837, 'CLOSED IN PLACE', 'Closed (in place)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2837, 'CLS IN GRD', 'Closed (in place)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2837, 'CURR IN USE', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2837, 'DISMANTLED', 'Closed (removed from ground)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2837, 'PERM OUT OF USE', 'Closed (general)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2837, 'REM FROM GRD', 'Closed (removed from ground)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2837, 'TEMP OUT OF USE', 'Temporarily out of service', null);

--select tank_status from public.tank_statuses;
/* Valid EPA values are:

Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_material_description_id

--select distinct "tank_material_description" from va_ust."erg_va_tank_materials" where "tank_material_description" is not null order by 1;
/* Organization values are:

tank_material_asphalt/baresteel
tank_material_ccp_/_sti-p3
tank_material_composite
tank_material_fiberglass
tank_material_impressed_current
tank_material_other
tank_material_polyethylene_tank_jacket
tank_material_unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_asphalt/baresteel', 'Asphalt coated or bare steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_ccp_/_sti-p3', 'Coated and cathodically protected steel', 'Please verify.');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_composite', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_fiberglass', 'Fiberglass reinforced plastic', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_impressed_current', 'Coated and cathodically protected steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_polyethylene_tank_jacket', 'Jacketed steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2845, 'tank_material_unknown', 'Unknown', null);

--select tank_material_description from public.tank_material_descriptions;
/* Valid EPA values are:

Fiberglass reinforced plastic
Asphalt coated or bare steel
Composite/clad (steel w/fiberglass reinforced plastic)
Epoxy coated steel
Coated and cathodically protected steel
Cathodically protected steel (without coating)
Jacketed steel
Steel (NEC)
Concrete
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_material_description_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_material_descriptions to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_secondary_containment_id

--select distinct "secondary_containment" from va_ust."erg_va_tank_secondary_containment" where "secondary_containment" is not null order by 1;
/* Organization values are:

tank_material_double_walled
tank_material_excavation_liner
tank_material_secondary_containment
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2846, 'tank_material_double_walled', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2846, 'tank_material_excavation_liner', 'Excavation liner', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2846, 'tank_material_secondary_containment', 'Unknown', 'Please verify');

--select tank_secondary_containment from public.tank_secondary_containments;
/* Valid EPA values are:

Single wall
Double wall
Triple wall
Jacketed
Excavation liner
Vault
Tank-within-a-tank retrofit (UL standard 1856)
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_secondary_containment_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_secondary_containments to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--compartment_status_id

/*
VA does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
 */

--select distinct "tank_status" from va_ust."usttankpipereleasedetection" where "tank_status" is not null order by 1;
/* Organization values are:

CLOSED IN PLACE
CLS IN GRD
CURR IN USE
DISMANTLED
PERM OUT OF USE
REM FROM GRD
TEMP OUT OF USE
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2853, 'CLOSED IN PLACE', 'Closed (in place)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2853, 'CLS IN GRD', 'Closed (in place)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2853, 'CURR IN USE', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2853, 'DISMANTLED', 'Closed (removed from ground)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2853, 'PERM OUT OF USE', 'Closed (general)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2853, 'REM FROM GRD', 'Closed (removed from ground)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2853, 'TEMP OUT OF USE', 'Temporarily out of service', null);

--select compartment_status from public.compartment_statuses;
/* Valid EPA values are:

Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'compartment_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.compartment_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--spill_bucket_wall_type_id

--select distinct "tank_spill_bucket_wall" from va_ust."erg_tank_spill_bucket_wall" where "tank_spill_bucket_wall" is not null order by 1;
/* Organization values are:

tank_rd_im_double_walled
tank_rd_im_secondary_containment
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2872, 'tank_rd_im_double_walled', 'Double', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2872, 'tank_rd_im_secondary_containment', 'Double', 'Please verify');

--select spill_bucket_wall_type from public.spill_bucket_wall_types;
/* Valid EPA values are:

Single
Double
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'spill_bucket_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.spill_bucket_wall_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_style_id

--select distinct "piping_type" from va_ust."ustpipematerials" where "piping_type" is not null order by 1;
/* Organization values are:


GRAVITY
NO UST PIPING
NO VALVE SUCTION
PRESSURE
UNKNOWN
VALVE SUCTION
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2893, 'GRAVITY', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2893, 'NO UST PIPING', 'No piping', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2893, 'NO VALVE SUCTION', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2893, 'PRESSURE', 'Pressure', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2893, 'UNKNOWN', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2893, 'VALVE SUCTION', 'Suction', null);

--select piping_style from public.piping_styles;
/* Valid EPA values are:

Suction
Pressure
Hydrant
Non-operational (e.g., fill line, vent line, gravity)
Other
Unknown
No piping

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'piping_style_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.piping_styles to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_wall_type_id

--select distinct "pipe_rd_im_double_walled_tank" from va_ust."usttankpipereleasedetection" where "pipe_rd_im_double_walled_tank" is not null order by 1;
/* Organization values are:


N
Y
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */

insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2915, 'Y', 'Double walled', null);

--select piping_wall_type from public.piping_wall_types;
/* Valid EPA values are:

Single walled
Double walled
Other

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'piping_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.piping_wall_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* If the source data contains tank material information for cathodically protected steel and doesn't
 * contain explicit cathodic protection elements, we can infer the cathodic protection, which will default to
 * sacraficial anodes because they are more prevelant than impressed current (per OUST).
 * Run the SQL below to insert rows into public.ust_element mapping if these conditions apply to this data.
 */

insert into public.ust_element_mapping
	(ust_control_id, epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
	query_logic, inferred_value_comment)
select ust_control_id, 'ust_tank', 'tank_corrosion_protection_sacrificial_anode', organization_table_name, organization_column_name, 
	organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
	'when tank_material_description_id in (5,6) then ''Yes'' else null', 'Inferred from tank material'
from public.ust_element_mapping a
where ust_control_id = 8 and epa_column_name = 'tank_material_description_id'
and exists 
	(select 1 from public.ust_element_value_mapping b 
	where a.ust_element_mapping_id = b.ust_element_mapping_id 
	and epa_value like '%athod%')
and not exists 
	(select 1 from public.ust_element_mapping b 
	where a.ust_control_id = b.ust_control_id
	and b.epa_column_name like 'tank_corrosion_protection%')
and not exists
	(select 1 from public.ust_element_mapping b 
	where a.ust_control_id = b.ust_control_id
	and b.epa_column_name = 'tank_corrosion_protection_sacrificial_anode');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 7: Send the substance mapping (if it exists) for review by an ERG chemical expert 

/*
 * Run script export_substance_mapping.py to export the substance mapping and email it to John Wilhelmi,
 * who will send it along to a chemical expert at ERG to review it for possible hazardous substances.  
 * The script will automatically send the email through Outlook if you are on an ERG computer and
 * have the python module pypiwin32 installed in your environment. 
 * (Note: If the script is unable to send the email automatically (check your Sent folder), please
 * manually attach the file (located at /ust/python/exports/mapping/XX/UST/) and send an email 
 * to John.Wilhelmi@erg.com, CCing Victoria and Renae. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
send_email = True				# Boolean; defaults to True. If True, will use Outlook to automatically email the generated file for ERG review. 

# These variables can usually be left unset. This script will generate an Excel file in the appropriate state folder in the repo under /ust/python/exports/mapping.
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None

*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 8: Create the value mapping crosswalk views

/* 
 * Run script org_mapping_xwalks.py to create crosswalk views for all lookup tables.
 * Set these variables in the script:
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('XX_ust') and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;

*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 9: Create unique identifiers if they don't exist

/* 
 * Run script create_missing_id_columns.py to identify if any required columns (e.g. Tank ID, Compartment ID, etc.)
 * are missing and to create an ERG table containing generated IDs if necessary. 
 * Set these variables in the script:

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the ust_control_id
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

 * By default, this script will generate any required ID columns, update the public.ust_element_mapping table,
 * and export a SQL file (located by default in the repo at /ust/sql/XX/UST/XX_UST_id_column_generation.sql).
 * You do NOT need to run the SQL in the generated file, however, if the script encounters errors or if you
 * are unable to write the views in the next step because the script did not correctly create the ID
 * generation tables, you can review this SQL file and make changes as needed to fix the data. If you do
 * need to make changes to generated ID tables, be sure to accurately update public.ust_element_mapping table,
 * including making robust comments in the programmer_comments columns.

*/
--check to see if the script generated any tables 
select epa_table_name, epa_column_name, organization_table_name 
from public.v_ust_element_mapping a join public.ust_template_data_tables b 
	on a.epa_table_name = b.table_name 
where ust_control_id = 8 and organization_table_name like 'erg%'
order by sort_order;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 10: Write the views that convert the source data to the EPA format

/** THIS SECTION UNDER CONSTRUCTION!!! 
 * 
 * Please write the views manually (refer to the views in other state schemas for the basic structure)
 * for now.  
 * 
 * 
 * **/

/* UNDER CONSTRUCTION!!!!
 * Run script create_view_sql.py to create the BASIC STRUCTURE of the views that will be used to
 * populate the templates. 
 * WARNING! The queries generated by the script are a STARTING PLACE for the developers but will 
 * in most cases need to be manually manipulated to correctly select the data. 
 * 
*/

--Remind yourself if there are any state-level business rules you need to take into consideration
--when writing the views (such as excluding AST, for example).
select comments from public.ust_control where ust_control_id = 8;
--filter registered_petroleum_tank_facilities by ("FAC_ACTIVE_UST" > 0 or "FAC_INACTIVE_UST"> 0) and "FAC_FED_REG_YN"=Y


-- va_ust.v_ust_facility source


----------------------------------------------------------------------------------------------------------

drop view va_ust.v_ust_facility;

create or replace view va_ust.v_ust_facility as
select distinct
    a."FAC_ID"::character varying(50) as facility_id, 
    a."FAC_NAME"::character varying(100) as facility_name, 
        CASE
            WHEN c.facility_type_id = 22 THEN 7
            ELSE va_ust.get_owner_type(a."FAC_ID")::integer
        END AS owner_type_id,
    facility_type_id as facility_type1, 
    "FAC_ADDR1"::character varying(100) as facility_address1, 
    "FAC_ADDR2"::character varying(100) as facility_address2, 
    "FAC_CITY"::character varying(100) as facility_city, 
    "NAME"::character varying(100) as facility_county, 
    "FAC_ZIP5"::character varying(10) as facility_zip_code, 
    "Lat"::double precision as facility_latitude, 
    "Lon"::double precision as facility_longitude, 
     va_ust.get_owner_name(a."FAC_ID")::character varying(100) AS facility_owner_company_name,
     'VA'::text AS facility_state,
    3 AS facility_epa_region
from va_ust."registered_petroleum_tank_facilities" a
    LEFT JOIN va_ust.owner_data od ON a."FAC_ID"::text = od."Fac_Id"::text
    left join va_ust.v_facility_type_xwalk c on a."FAC_TYPE" = c.organization_value
  WHERE (a."FAC_ACTIVE_UST"::integer > 0 OR a."FAC_INACTIVE_UST"::integer > 0) AND a."FAC_FED_REG_YN"::text = 'Y'::text;
;

select count(*) from v_ust_facility; --20321

drop view va_ust.v_ust_tank ;

create or replace view va_ust.v_ust_tank as
select distinct a.tank_facility_id::character varying(50) AS facility_id,
    a."index"::integer as tank_id, 
    a."tank_number"::character varying(50) as tank_name, 
    tank_status_id as tank_status_id, 
    "federally_regulated_tank"::character varying(7) as federally_regulated,
    case when lower(other_contents) like '%em%gen%' then 'Yes' else null end as emergency_generator,  
    a."date_closed"::date as tank_closure_date, 
    a."install_date"::date as tank_installation_date, 
     tank_material_description_id as tank_material_description_id,   
     case when tank_material_description_id in (5,6) then 'Yes' else null end as tank_corrosion_protection_sacrificial_anode,   
     case when "tank_material_impressed_current" = 'Y' then 'Yes' when "tank_material_impressed_current" = 'N' then 'No' else null end  as tank_corrosion_protection_impressed_current, 
 	 case when "tank_material_lined_interior" = 'Y' then 'Yes' when "tank_material_lined_interior" = 'N' then 'No' else null end  as tank_corrosion_protection_interior_lining, 
    tank_secondary_containment_id as tank_secondary_containment_id 
from va_ust."tanks" a
	left join va_ust.erg_va_tank_materials z on a.index=z.index
	left join va_ust.erg_va_tank_secondary_containment y on a.index=y.index 
	    left join va_ust.usttankmaterials x on a.index=x.index
    left join va_ust.v_tank_material_description_xwalk c on z."tank_material_description" = c.organization_value
    left join va_ust.v_tank_secondary_containment_xwalk d on y."secondary_containment" = d.organization_value
    left join va_ust.v_tank_status_xwalk e on a."tank_status" = e.organization_value
  WHERE a.tank_type::text = 'UST'::text AND a.federally_regulated_tank::text = 'Yes'::text
;

select count(*) from va_ust.v_ust_tank; --70447
  
drop view  va_ust.v_ust_tank_substance;

create or replace view va_ust.v_ust_tank_substance as
select distinct  a.tank_facility_id::character varying(50) AS facility_id,
    a."index"::integer as tank_id,
    substance_id as substance_id 
from va_ust."tanks" a
left join va_ust.v_substance_xwalk b on a."contents" = b.organization_value
  WHERE a.tank_type::text = 'UST'::text AND a.federally_regulated_tank::text = 'Yes'::text and "contents" is not null;

select count(*) from va_ust.v_ust_tank_substance; 70447


drop view va_ust.v_ust_compartment;

create or replace view va_ust.v_ust_compartment as
select distinct
	b.tank_facility_id facility_id,
	b.index::integer tank_id,
    a."index"::integer as compartment_id, 
    compartment_status_id as compartment_status_id, 
    "capacity"::integer as compartment_capacity_gallons, 
	case when overfill_type in ('ALARM-BALL FLOAT','BALL FLOAT', 'AUTOMATIC SHUTOFF-BALL FLOAT') then 'Yes' end  as overfill_prevention_ball_float_valve,
	case when overfill_type in ('AUTOMATIC SHUTOFF', 'AUTOMATIC SHUTOFF-BALL FLOAT') then 'Yes'  end as overfill_prevention_flow_shutoff_device,
	case when overfill_type in ('ALARM-BALL FLOAT','ALARM', 'ALARM-AUTOMATIC SHUTOFF') then 'Yes' end as overfill_prevention_high_level_alarm,
	case when overfill_type in ('OTHER') then 'Yes' end as  overfill_prevention_other,
	case when overfill_type in ('NONE') then 'Yes'  end as  overfill_prevention_not_required,	
	case when "spill_device_installed" = 'Y' then 'Yes' when "spill_device_installed" = 'N' then 'No' end  as spill_bucket_installed,
	case when "overfill_other_specify" = 'Y' then 'Yes'  when "overfill_other_specify" = 'N' then 'No' end as spill_prevention_other,
	case when overfill_other_specify in ('Not Required','Not required') then 'Yes' else 'No' end as  spill_prevention_not_required,
    spill_bucket_wall_type_id as spill_bucket_wall_type_id,   
	case when "tank_rd_im_secondary_containment" = 'Y' then 'Yes' when "tank_rd_im_secondary_containment" = 'N' then 'No' end  as tank_interstitial_monitoring,
	case when "tank_rd_atg" = 'Y' then 'Yes' when "tank_rd_atg" = 'N' then 'No' end  as tank_automatic_tank_gauging_release_detection,
	case when "tank_rd_manual_gauging" = 'Y' then 'Yes' when "tank_rd_manual_gauging" = 'N' then 'No' end  as tank_manual_tank_gauging,
	case when "tank_rd_sir" = 'Y' then 'Yes' when "tank_rd_sir" = 'N' then 'No' end  as tank_statistical_inventory_reconciliation,
	case when "tank_rd_tightness_testing" = 'Y' then 'Yes' when "tank_rd_tightness_testing" = 'N' then 'No' end  as tank_tightness_testing,
	case when "tank_rd_inventory_control" = 'Y' then 'Yes' when "tank_rd_inventory_control" = 'N' then 'No' end  as tank_inventory_control,
	case when "tank_rd_groundwater_monitoring" = 'Y' then 'Yes' when "tank_rd_groundwater_monitoring" = 'N' then 'No' end  as tank_groundwater_monitoring,	
	case when "tank_rd_vapor_monitoring" = 'Y' then 'Yes' when "tank_rd_vapor_monitoring" = 'N' then 'No' end  as tank_vapor_monitoring,
	case when "tank_rd_other" = 'Y' then 'Yes' when "tank_rd_other" = 'N' then 'No' end  as tank_other_release_detection	
from va_ust."usttankpipereleasedetection" a
join va_ust.tanks b on a.tank_facility_id=b.tank_facility_id and a.tank_number=b.tank_number and a.tank_owner_id=b.tank_owner_id
left join va_ust.erg_tank_spill_bucket_wall  z on a.index=z.index and a.tank_number=z.tank_number and a.tank_facility_id=z.tank_facility_id
    left join va_ust.v_compartment_status_xwalk c on a."tank_status" = c.organization_value
    left join va_ust.v_spill_bucket_wall_type_xwalk d on z."tank_spill_bucket_wall" = d.organization_value
  WHERE a.tank_type::text = 'UST'::text AND b.federally_regulated_tank::text = 'Yes'::text;
  
  
 	
 select * from va_ust.v_ust_compartment; 70477
 
 
 74590
 
 drop view va_ust.v_ust_piping;

create or replace view va_ust.v_ust_piping as
select distinct
	z.tank_facility_id facility_id,
    z.index::integer tank_id,
    y.index::integer compartment_id,    
    a."index"::character varying(50) as piping_id, 
    piping_style_id as piping_style_id, 
   CASE
            WHEN a.pipe_material_fiberglass::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_fiberglass::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
    END AS piping_material_frp,
        CASE
            WHEN a.pipe_material_galvanized_steel::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_galvanized_steel::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
    case when lower(pipe_material_other_specify) like '%stainless%steel%' then 'Yes' else null end  as piping_material_stainless_steel,    
	   CASE
	        WHEN a.pipe_material_cathodically_protected::text = 'Y'::text THEN 'Yes'::text
	        WHEN a.pipe_material_cathodically_protected::text = 'N'::text THEN 'No'::text
	        ELSE NULL::text
	    END AS piping_material_steel,        
	    CASE
	        WHEN a.pipe_material_copper::text = 'Y'::text THEN 'Yes'::text
	        WHEN a.pipe_material_copper::text = 'N'::text THEN 'No'::text
	        ELSE NULL::text
	    END AS piping_material_copper,
  		CASE
            WHEN a.pipe_material_polyflexible::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_polyflexible::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_flex,
    case when lower(pipe_material_other_specify) = 'no piping' then 'Yes' else null end as piping_material_no_piping, 
		CASE
            WHEN a.pipe_material_other::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_other::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN a.pipe_material_unknown::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_unknown::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_unknown,
    	case when lower(pipe_material_other_specify) like '%flex%connector%' then 'Yes' else null end as piping_flex_connector,  
		CASE
            WHEN a.pipe_material_cathodically_protected::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_cathodically_protected::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
		CASE
            WHEN a.pipe_material_impressed_current::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_impressed_current::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
		CASE
            WHEN a.pipe_material_other::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_other::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_other,
		CASE
            WHEN a.pipe_material_unknown::text = 'Y'::text THEN 'Yes'::text
            WHEN a.pipe_material_unknown::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_unknown,
		CASE
            WHEN y.pipe_rd_alld::text = 'Y'::text THEN 'Yes'::text
            WHEN y.pipe_rd_alld::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
		CASE
            WHEN y.pipe_rd_tightness_testing::text = 'Y'::text THEN 'Yes'::text
            WHEN y.pipe_rd_tightness_testing::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
		CASE
            WHEN y.pipe_rd_groundwater_monitoring::text = 'Y'::text THEN 'Yes'::text
            WHEN y.pipe_rd_groundwater_monitoring::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
		CASE
            WHEN y.pipe_rd_vapor_monitoring::text = 'Y'::text THEN 'Yes'::text
            WHEN y.pipe_rd_vapor_monitoring::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
		CASE
            WHEN y.pipe_rd_im_secondary_containment::text = 'Y'::text THEN 'Yes'::text
            WHEN y.pipe_rd_im_secondary_containment::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
		CASE
            WHEN y.pipe_rd_sir::text = 'Y'::text THEN 'Yes'::text
            WHEN y.pipe_rd_sir::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
		CASE
            WHEN y.pipe_rd_other::text = 'Y'::text THEN 'Yes'::text
            WHEN y.pipe_rd_other::text = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_release_detection_other,        
        piping_wall_type_id
from va_ust."ustpipematerials" a
join va_ust.tanks z on a.tank_facility_id=z.tank_facility_id and a.tank_number=z.tank_number and a.tank_owner_id=z.tank_owner_id
 LEFT JOIN va_ust.usttankpipereleasedetection y ON a.tank_facility_id::text = y.tank_facility_id::text AND a.tank_number::text = y.tank_number::text AND a.tank_owner_id::text = y.tank_owner_id::text
    left join va_ust.v_piping_style_xwalk b on a."piping_type" = b.organization_value
    left join va_ust.v_piping_wall_type_xwalk c on y."pipe_rd_im_double_walled_tank" = c.organization_value
  WHERE a.tank_type::text = 'UST'::text AND z.federally_regulated_tank::text = 'Yes'::text;
  

select count(*) from va_ust.v_ust_piping; --70442



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 11: QA the views 

/* 
 * Run script qa_check.py to check that the views you have written to populate the main data tables
 * adhere to all business and logic rules.  
 * Set these variables in the script:

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the ust_control_id

 * This script will check the views you just created in the state schema for the following:
 * 1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
 *    exist. 
 * 2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
 *    every tank should have at least one compartment). 
 * 3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
 *    to its parent tables. 
 * 4) Missing required columns. 
 * 5) Required columns that exist but contain null values. 
 * 6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
 *    typos or other errors. 
 * 7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
 *    Then check for bad joins.  
 * 8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
 *    if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
 *    an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
 * 9) Failed check constraints. 
 * 10) Columns that exist in the view that were not mapped in ust_element_mapping. 
 * 11) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping 
 *     and ensure the epa_value exists in the associated lookup table. 
 *
 * The script will also provide the counts of rows in v_ust_facility, v_ust_tank, v_ust_compartment, and v_ust_piping (if these views exist) -
 * ensure these counts make sense! 
 *   
 * The script will export a QAQC spreadsheet to the repo at 
 * /ust/python/exports/QAQC/XX/UST/XX_UST_QAQC_yyyymmddsssss.xlsx 
 * (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
 * then re-run the qa script, and proceed when all errors have been resolved. 
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 12: Insert data into the EPA schema 

/*
 * Run script populate_epa_data_tables.py to insert data into the main data tables in the public schema 
 * (ust_facility, ust_tank, ust_tank_substance, ust_compartment, ust_compartment_substance, ust_piping,
 * ust_facility_dispenser, ust_tank_dispenser, and/or ust_compartment_dispenser) using the views you 
 * wrote in Step 9 above. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the ust_control_id
delete_existing = False 		 # can set to True if there is existing UST data you need to delete before inserting new

 * Do a quick sanity check of number of rows inserted:
*/
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 8
order by sort_order;

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 13: Export populated EPA template

/*
 * Run script export_template.py to generate a populated EPA template that will be sent first to OUST
 * for review, then to the state for review.
 * 
 * Set these variables in the script: 

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/epa_templates/XX/UST/XX_UST_template_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 14: Export control table summary

/*
 * Run script control_table_summary.py to generate a high-level overview of the data for OUST's review. 
 * 
 * Set these variables in the script: 

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/control_table_summaries/XX/UST/XX_UST_control_table_summary_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 15: Upload exported files to EPA Teams

/* 
 * Upload the following three files to the appropriate state folder on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/02%20-%20Draft%20Mapped%20Templates?csf=1&web=1&e=fp1koB
 * (Documents > General > 02 - Draft Mapped Templates)
 * 
 * 1) Populated EPA template: /ust/python/exports/epa_templates/XX/UST/XX_UST_template_yyyymmddsssss.xlsx
 * 2) QAQC file: /ust/python/exports/QAQC/XX/UST/XX_UST_QAQC_yyyymmddsssss.xlsx
 * 3) Control table summary file: /ust/python/exports/control_table_summaries/XX/UST/XX_UST_control_table_summary_yyyymmddsssss.xlsx
 *
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 16: Request peer review and make any suggested changes

/* 
 * All templates must be peer reviewed before sending to OUST. Currently Renae and Jim are available for peer reviews.
 * Send a Teams message to both Renae and Jim asking who is available to do a review. Set the status to 
 * "ERG Peer Review" in the Jira ticket and assign it to whichever developer agreed to perform the review. 
 * 
 * If the reviewing developer suggested any changes to your mapping or logic, follow these steps:
 * 
 * 1) Make suggested changes in the database. 
 * 2) If necessary, update the views you created in Step 9. 
 * 3) If you made any changes to the views you created in Step 9, re-run Step 10 to QA the views. 
 * 4) Rerun Step 11 to re-insert the data into the EPA schema. Remember to set the delete_existing variable 
 *    in the script to True (it defaults to False) to delete the data before re-inserting it. 
 * 5) Rerun Step 12 to export a new populated template. 
 * 6) If you made any changes to ust_control, rerun Step 13 to export a new control table summary file. 
 * 7) Rerun Step 14 to re-upload all new exports to the EPA Teams site. 
 * 8) Add a comment to the Jira ticket noting you've made the changes and are ready for another review.
 *    Assign the ticket back to the original reviewer and make sure the status is ERG Peer Review if not already.
 *    Be sure to @ the reviewer in the ticket comment so they are aware they need to take action. 
 * 9) Repeat these steps until the reviewer approves the template for sending to OUST. 
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 17: Export source data (if necessary)

/* 
 * OUST has requested that ERG make all source data available to them to assist in their review. If the 
 * state sent ERG Excel or CSV files, or a populated EPA template, Victoria will upload the source data to 
 * the EPA Teams site and you can skip this step. If, however, you had to download files from a state website, 
 * or if you retrieved the state data from an API, or if the state sent a database we extracted data from, or 
 * if for any other reason the source data was not uploaded to the EPA Teams site in the 
 * Documents > General > 01 - UST Source Data > XX > State-Provided Source Data folder, you must export the 
 * tables from the ERG database to CSV files and upload them to the EPA Teams site at
 * Documents > General > 01 - UST Source Data > XX > ERG Source Data folder. 
 * 
 * To export the source data from the database, run script export_source_data.py
 * 
 * Set these variables in the script: 
 * 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
all_tables = True               # Boolean, defaults to True. If True will export all source data tables; if False will only export those referenced in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)
empty_export_dir = True         # Boolean, defaults to True. If True, will delete all files in the export directory before proceeding. If False, will not delete any files, but will overwrite any that have the same name as the generated file name. 

 * 
 * This script will output a CSV file for each table in the state schema (the default export location is 
 * in the repo at /ust/python/exports/source_data/XX/UST). 
 * After exporting the files, upload them to the appropriate state folder on the EPA Teams site at
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/01%20-%20UST%20Source%20Data?csf=1&web=1&e=7GtcsH
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--old script
/*
 * 
 * 
create table erg_tank_spill_bucket_wall as
select distinct index, tank_number, tank_facility_id, 
case when tank_rd_im_double_walled = 'Y' then 'tank_rd_im_double_walled'
when tank_rd_im_secondary_containment = 'Y' then 'tank_rd_im_secondary_containment'
else null
end tank_spill_bucket_wall
from usttankpipereleasedetection;


select distinct tank_rd_other_specify from usttankpipereleasedetection order by 1;

select * from public.spill_bucket_wall_types sbwt 

select * from tanks;


select * from tanks;
--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 8 and mapping_complete = 'N'
order by 1, 2;

select * from ust_element_mapping where ust_control_id = 8 order by epa_table_name,epa_column_name;

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 8 and epa_column_name = 'substance_id';



select * from ust_element_mapping where ust_control_id = 8 order by epa_table_name;

select * from ust_element_value_mapping where ust_element_mapping_id=31;

update ust_element_value_mapping
set programmer_comments = 'The logic to differentiate between military and non-military is handled in the view that populates the template and is not represented fully in the mapping here. If the facility type is marked military then this is military.'
where ust_element_mapping_id=7 and organization_value = 'FEDERAL';
Federal government, non-military

select fac_name from registered_petroleum_tank_facilities	

select * from ust_element_mapping where ust_control_id = 8 order by epa_table_name;


select * from public.tank_material_descriptions tmd 

select distinct tank_material_secondary_containment from usttankmaterials u  order by 1;

select distinct tank_material_other_specify from usttankmaterials where lower(tank_material_other_specify) like '%steel%' 

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 772 || ', ''' || "contents" || ''', '''', null);'
from va_ust."tanks" order by 1;

select * from public.substances where lower(substance) like lower('%petroleum product%')


create table erg_va_tank_materials as
select distinct
index,
tank_facility_id,
tank_owner_id,
tank_number,
install_date,
tank_status,
case when "tank_material_fiberglass" = 'Y' then 'Fiberglass reinforced plastic'
when "tank_material_asphalt/baresteel" = 'Y' then 'Asphalt coated or bare steel'
when "tank_material_composite" = 'Y' then 'Composite/clad (steel w/fiberglass reinforced plastic)'
when "tank_material_ccp_/_sti-p3" = 'Y' then 'Coated and cathodically protected steel'
when "tank_material_impressed_current" = 'Y' then 'Cathodically protected steel (without coating)'
when "tank_material_polyethylene_tank_jacket" = 'Y' then 'Jacketed steel'
when "tank_material_other" = 'Y' then 'Other'
when "tank_material_unknown" = 'Y' then 'Unknown'
when lower("tank_material_other_specify") like '%epoxy%coated%steel%' then 'Epoxy coated steel'
when lower("tank_material_other_specify") like '%concrete%' then 'Concrete'
else null end tank_material_description
from usttankmaterials
;



create table erg_va_tank_secondary_containment as
select distinct
index,
tank_facility_id,
tank_owner_id,
tank_number,
install_date,
tank_status,
case when "tank_material_double_walled" = 'Y' then 'tank_material_double_walled'
when "tank_material_excavation_liner" = 'Y' then 'tank_material_excavation_liner'
when "tank_material_secondary_containment" = 'Y' then 'tank_material_secondary_containment'
else null end secondary_containment
from usttankmaterials
;

create table erg_va_tank_materials as
select distinct
index,
tank_facility_id,
tank_owner_id,
tank_number,
install_date,
tank_status,
case when "tank_material_fiberglass" = 'Y' then 'tank_material_fiberglass'
when "tank_material_asphalt/baresteel" = 'Y' then 'tank_material_asphalt/baresteel'
when "tank_material_composite" = 'Y' then 'tank_material_composite'
when "tank_material_ccp_/_sti-p3" = 'Y' then 'tank_material_ccp_/_sti-p3'
when "tank_material_impressed_current" = 'Y' then 'tank_material_impressed_current'
when "tank_material_polyethylene_tank_jacket" = 'Y' then 'tank_material_polyethylene_tank_jacket'
when "tank_material_other" = 'Y' then 'tank_material_other'
when "tank_material_unknown" = 'Y' then 'tank_material_unknown'
when lower("tank_material_other_specify") like '%epoxy%coated%steel%' then 'epoxy coated steel: ='||tank_material_other_specify
when lower("tank_material_other_specify") like '%concrete%' then 'concrete: ='||tank_material_other_specify
else null end tank_material_description
from usttankmaterials





update  ust_element_value_mapping set epa_value = 'Diesel fuel (b-unknown)' where ust_element_mapping_id = 772 and organization_value = 'EMER GENERATOR';

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
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'HYDRAULIC OIL', 'Hydraulic oil', null);
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


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (772, 'HYDRAULIC OIL', 'Hydraulic oil', null);

update ust_element_value_mapping
set epa_value = 'Hydraulic oil'
where  organization_value='HYDRAULIC OIL'
and ust_element_mapping_id = 772;

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
case when facility_type_id = 22 then 7 
else va_ust.get_owner_type("FAC_ID")::int  end  owner_type_id,
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

select * from public.tank_statuses ts 


select * from v_ust_tank where tank_status_id = 3;


select * from  va_ust."tanks" where tank_status = 'DISMANTLED' and tank_type  = 'UST';

tank_facility_id in (4006666, 4018496)

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
ust_compartment	70477
ust_piping	70417
*/
70442


		select distinct ust_compartment_id, piping_id, piping_style_id, piping_material_frp, piping_material_gal_steel, piping_material_stainless_steel, piping_material_steel, piping_material_copper, piping_material_flex, piping_material_no_piping, piping_material_other, piping_material_unknown, piping_flex_connector, piping_corrosion_protection_sacrificial_anode, piping_corrosion_protection_impressed_current, piping_corrosion_protection_other, piping_corrosion_protection_unknown, piping_line_leak_detector, piping_line_test_annual, piping_groundwater_monitoring, piping_vapor_monitoring, piping_interstitial_monitoring, piping_statistical_inventory_reconciliation, piping_release_detection_other, piping_wall_type_id from va_ust.v_ust_piping a 
										join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = 8) b
											on a.facility_id = b.facility_id
										join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id
										join ust_compartment d on c.ust_tank_id = d.ust_tank_id and a.compartment_id = d.compartment_id




select count(*) from va_ust.v_ust_piping; 70417


select * from va_ust.v_ust_tank where facility_id = '1018286' and tank_id = 5624; 

select * from va_ust.v_ust_piping where facility_id = '1018286' and tank_id = 5624; 

select * from va_ust.v_ust_piping  where compartment_Id is null;
select * from public.ust_piping ; 70417


select * from public.v_ust_piping where "FacilityID" = '1018286' and "TankID" = '5624';
 
   (70442) and public.ust_piping (70417)!!!
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
*/


