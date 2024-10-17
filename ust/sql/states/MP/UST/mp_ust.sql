select * from public.ust_control where ust_control_id = 22;

ALTER TABLE "UST_UNIVERSE_tracking_file_FY2023" rename to mp_ust;
ALTER TABLE mp_ust  RENAME COLUMN "DEQ File Number" TO deq_id;
alter table mp_ust rename column "Type of Financial Responsibility 1) Self-Assurance.  2) Group C" to financial_resp;
alter table mp_ust rename column "FMR_LUST?" to former_lust;
alter table mp_ust rename column "AKA/Former/Associated Facility Names" to previous_name;
alter table mp_ust rename column "Current Tank Status or NOTES/Comments " to tanks_status_notes;
alter table mp_ust rename column "# of tanks Assoc @ Site" to total_tanks_at_site;
alter table mp_ust rename column "# of ACTIVE TANKS in ground" to active_tank_count;
alter table mp_ust rename column "TANK 1 size & contents" to tank1_size;
alter table mp_ust rename column "Unnamed: 15"  to tank1_contents;
alter table mp_ust rename column "Type" to tank1_type;
alter table mp_ust rename column "Date of Install" to tank1_install_date;
alter table mp_ust rename column "TANK 2 size & contents" to tank2_size;
alter table mp_ust rename column "Unnamed: 19"  to tank2_contents;
alter table mp_ust rename column "Type.1" to tank2_type;
alter table mp_ust rename column "Date of Install.1" to tank2_install_date;
alter table mp_ust rename column "TANK 3 size & contents" to tank3_size;
alter table mp_ust rename column "Unnamed: 23"  to tank3_contents;
alter table mp_ust rename column "Type.2" to tank3_type;
alter table mp_ust rename column "Date of Install.2" to tank3_install_date;
alter table mp_ust rename column "UST Leak Detection - Tank/Equipment " to leak_detection_tank_equipment;
alter table mp_ust rename column "UST Leak Detection - Piping " to leak_detection_piping;
alter table mp_ust rename column "UST Spill Overfill, & Corrosion Protection" to spill_overflow_corrosion_protection;
 
update mp_ust set deq_id = trim(deq_id);

--delete the rows that are hidden in the spreadsheet that get imported
delete from mp_ust where deq_id is null or deq_id in ('S-0017');



--create view to try to break out the tanks into individual records
create or replace view mp_ust_tanks as 


select  a.*, row_number() over (order by a.deq_id) tank_id from 

(
--create records for active with tank1 populated  
select deq_id,
tank1_size,
tank1_contents,
tank1_type,
tank1_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection,
'Currently in use' status ,
0 seq_val,
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment

from mp_ust where active_tank_count > 0 and tank1_size is not null
union all

--create records for active with tank2 populated 
select deq_id, 
tank2_size,
tank2_contents,
tank2_type,
tank2_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection,
'Currently in use' status  ,
null seq_val,
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment

from mp_ust where active_tank_count > 1 and tank2_size is not null
union all

--create records for active with tank3 populated
select deq_id,
tank3_size,
tank3_contents,
tank3_type,
tank3_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection,
'Currently in use' status ,
null seq_val,
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust mp 
where active_tank_count > 2 
and tank3_size is not null
union all

--create records for not active with tank1 populated  and no active tanks at site
select deq_id,
tank1_size,
tank1_contents,
tank1_type,
tank1_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
'Closed (general)',
0,
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust mp 
where "CLOSED in place or removed" > 0 and tank1_contents is not null and active_tank_count=0
union all

--create records for not active with tank2 populated  and no active tanks at site
select deq_id,
tank2_size,
tank2_contents,
tank2_type,
tank2_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
'Closed (general)',
0,
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust mp 
where "CLOSED in place or removed" > 0 and tank2_contents is not null and active_tank_count=0
union all

--create records for not active with tank3 populated  and no active tanks at site
select deq_id,
tank3_size,
tank3_contents,
tank3_type,
tank3_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
'Closed (general)',
0,
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust mp 
where "CLOSED in place or removed" > 0 and tank3_contents is not null and active_tank_count=0
union all

--create records for when a site has closed and active facilities - create the closed records only here; active were already created
select deq_id,
null tank3_size,
null tank3_contents,
null tank3_type,
null tank3_install_date,
active_tank_count,
total_tanks_at_site,
null "COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
'Closed (general)',
 generate_series(1, mp."CLOSED in place or removed"),
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust.mp_ust mp 
where  ("CLOSED in place or removed" > 0  and active_tank_count>0)

union all

--create records where active and closed both = 0 but the total > 0; inactive facilities
select deq_id,
null tank3_size,
null tank3_contents,
null tank3_type,
null tank3_install_date,
active_tank_count,
total_tanks_at_site,
null "COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
'Temporarily out of service',
 generate_series(1, mp.total_tanks_at_site),
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust mp 
where (active_tank_count=0 and "CLOSED in place or removed" = 0 and total_tanks_at_site > 0)

union all


--create 2 records for S-0015 because 2 of the records don't get captured in the logic above
select deq_id,
null tank3_size,
null tank3_contents,
null tank3_type,
null tank3_install_date,
active_tank_count,
total_tanks_at_site,
null "COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
'Closed (general)',
 generate_series(1, 2),
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust mp 
where (active_tank_count=0 and total_tanks_at_site > 0)
and deq_id = 'S-0015'
) a
;

select row_number() over (order by deq_id)  from mp_ust_tanks;

--these numbers should match
select sum(total_tanks_at_site) from mp_ust; --116
select count(*) from mp_ust_tanks; --116

select * from mp_ust_tanks where lower(tanks_status_notes) like '%inact%';



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Generate SQL statements to do the inserts into ust_element_mapping. 
Run the query below, paste the results into your console, then do a global replace of 9 for the ust_control_id 
Next, go through each generated SQL statement and do the following:
If there is no matching column in the state's data, delete the SQL statement 
If there is a matching column in the state's data, update the tanks and ORG_COL_NAME variables to match the state's data 
If you have questions or comments, replace the "null" with your comment. 
After you have updated all the SQL statements, run them to update the database. 
*/
select * from public.v_ust_element_summary_sql;



/*you can run this SQL so you can copy and paste table and column names into the SQL statements generated by the query above
select table_name, column_name from information_schema.columns 
where table_schema = 'mp_ust' order by table_name, ordinal_position;
*/

update ust_element_mapping 
set organization_column_name='FACILITY TYPE'
where ust_control_id = 22
and organization_column_name='FACILITY_TYPE';

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_id','mp_ust','deq_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_name','mp_ust','FACILITY NAME',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_type1','mp_ust','FACILITY TYPE',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_address1','mp_ust','VILLAGE','Please verify, there is no real mailing street address in the data provided and was not sure where else to put this village field.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_city','mp_ust','ISLAND','Please verify, island = Saipan/Rota and the island name is associated with a cities for USPS it appears.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_county','mp_ust','ISLAND','Please verify, island = Saipan/Rota and I made this assumption based on other EPA work I have done with MP with counties.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_latitude','mp_ust','Latitude gearth',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_longitude','mp_ust','Longitude gearth',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_owner_company_name','mp_ust','OWNER',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_operator_company_name','mp_ust','OPERATOR',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','financial_responsibility_self_insurance_financial_test','mp_ust','financial_resp','Please veriy.  where financial_resp = Self-Assurance');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','ust_reported_release','mp_ust','former_lust','where former_lust  = YES or ("Current LUST" is not null and "Current LUST" <> N)  - I am guessing on this one because all of their data has N or Null populated currently in the current lust field.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_facility','facility_comment','mp_ust','previous_name','Please verify this is an appropriate mapping.  This field contains AKA/Former/Associated Facility Names.');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','facility_id','mp_ust_tanks','deq_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','tank_status_id','mp_ust_tanks','status','I hard-coded this and needs review in the SQL of the view.  The tank status notes might have some data we can derive this value too.' );
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','emergency_generator','mp_ust_tanks','tanks_status_notes','where lower(tanks_status_notes) like %emerg%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','multiple_tanks','mp_ust_tanks','total_tanks_at_site','');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','tank_installation_date','mp_ust_tanks','tank1_install_date','');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','compartmentalized_ust','mp_ust_tanks','COMPARTMENT_TK','where COMPARTMENT_TK = Y');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','tank_material_description_id','mp_ust_tanks','tank1_type','Pull in only the first part of this field.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','tank_secondary_containment_id','mp_ust_tanks','secondary_containment','');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank','tank_comment','mp_ust_tanks','tank_status_notes','This field can apply to all tanks at this site and no way to distinguish which tank.');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank_substance','facility_id','mp_ust_tanks','deq_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_tank_substance','substance_id','mp_ust_tanks','tank1_contents',null);


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','facility_id','mp_ust_tanks','deq_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','tank_id','mp_ust_tanks','tank_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','compartment_capacity_gallons','mp_ust_tanks','tank1_size',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','overfill_prevention_ball_float_valve','mp_ust_tanks','spill_overflow_corrosion_protection','where spill_overflow_corrosion_protection like %Ball Float%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','overfill_prevention_high_level_alarm','mp_ust_tanks','spill_overflow_corrosion_protection','where spill_overflow_corrosion_protection like %Alarm%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','overfill_prevention_other','mp_ust_tanks','spill_overflow_corrosion_protection','Please verify - where spill_overflow_corrosion_protection like %Flapper device%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','compartment_status_id','mp_ust_tanks','status','I hard-coded this and needs review in the SQL of the view.  The tank status notes might have some data we can derive this value too.' );

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_piping','facility_id','mp_ust_tanks','deq_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_piping','piping_style_id','mp_ust_tanks','leak_detection_piping','First part of the field.');

select * from ust_element_mapping where ust_control_id = 22;

update ust_element_mapping
set organization_column_name = 'secondary_containment'
 where ust_control_id = 22 and epa_column_name = 'tank_secondary_containment_id';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name
from v_ust_available_mapping 
where ust_control_id = 22
order by table_sort_order, column_sort_order;
/*


*/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from mp_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 22 and epa_column_name = 'facility_type1';

select distinct "FACILITY TYPE" from mp_ust."mp_ust" order by 1;

select * from public.facility_types ft ;


select * from mp_ust where "FACILITY TYPE"  = 'Government';

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1225, 'Commercial (Financial Institution)', 'Commercial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1225, 'Commercial (Hotel/Resort) ', 'Commercial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1225, 'Commercial (Telecommunications) ', 'Telecommunication facility', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1225, 'Government', 'State/local government', 'Please verify. There are 3 records with this value and look like state govt buildings.');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1225, 'Hotel/Resort', 'Commercial', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1225, 'Private Firm', 'Other', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1225, 'Service Station', 'Retail fuel sales (non-marina)', 'Please verify');


--substance id

select distinct 'select distinct "' || organization_column_name || '" from mp_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 22 and epa_column_name = 'substance_id';

select distinct "tank1_contents" from mp_ust."mp_ust_tanks" order by 1;


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 22 and epa_column_name = 'substance_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1246 || ', ''' || "tank1_contents" || ''', '''', null);'
from mp_ust."mp_ust_tanks" order by 1;


select * from substances where lower(substance) like '%gas%';


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1246, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1246, 'Gasoline', 'Gasoline (unknown type)', null);



--piping_style_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 22 and epa_column_name = 'piping_style_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1248 || ', ''' || "leak_detection_piping" || ''', '''', null);'
from mp_ust."mp_ust_tanks" order by 1;

select * from piping_styles;




insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1248, 'Pressured Piping/Electronic LLD', 'Pressure', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1248, 'Pressured Piping/Mechanical LLD', 'Pressure', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1248, 'Suction Piping', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1248, 'Suction Piping  ', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1248, 'Suction Piping / __________', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1248, 'Suction Piping / Automatic Shut off Device', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1248, 'Suction Piping / Continuous Alarm Sys & Auto Shut off device', 'Suction', null);


--tank_status_id


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 22 and epa_column_name = 'tank_status_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1237 || ', ''' || "status" || ''', '''', null);'
from mp_ust."mp_ust_tanks" order by 1;

select * from public.tank_statuses ;
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1237, 'Closed (general)', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1237, 'Currently in use', 'Currently in use', null);

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1237, 'Temporarily out of service', 'Temporarily out of service', null);

--compartment_status_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 22 and epa_column_name = 'compartment_status_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1257 || ', ''' || "status" || ''', '''', null);'
from mp_ust."mp_ust_tanks" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1257, 'Closed (general)', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1257, 'Currently in use', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1257, 'Temporarily out of service', 'Temporarily out of service', null);



--tank_secondary_containment_id


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 22 and epa_column_name = 'tank_secondary_containment_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1243 || ', ''' || "secondary_containment" || ''', '''', null);'
from mp_ust."mp_ust_tanks" order by 1;

select * from public.tank_secondary_containments ;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1243, 'Double Wall', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1243, 'Single Wall', 'Single wall', null);

delete from ust_element_value_mapping where ust_element_mapping_id = 1243;

select * from tank_secondary_containments;
--tank_material_description_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 22 and epa_column_name = 'tank_material_description_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1242 || ', ''' || "tank1_type" || ''', '''', null);'
from mp_ust."mp_ust_tanks" order by 1;




select * from public.tank_material_descriptions 


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1242, 'Fiberglass - Double Wall', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1242, 'Fiberglass - Single Wall', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1242, 'RFP', 'Fiberglass reinforced plastic', 'Please confirm -  RFP typo for FRP?');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1242, 'Steel', 'Steel (NEC)', null);



------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 22 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_ust_bad_mapping 
where ust_control_id = 22 order by 1, 2;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'mp_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_facility_type_xwalk
v_piping_style_xwalk
v_substance_xwalk
v_tank_material_description_xwalk
v_tank_secondary_containment_xwalk
v_tank_status_xwalk
*/

--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 22
order by table_sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 22;

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
where ust_control_id = 22 and epa_table_name = 'ust_facility'
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

create or replace view mp_ust.v_ust_facility as 
select distinct 
		"deq_id"::character varying(50) as facility_id,
"FACILITY NAME"::character varying(100) as facility_name,
facility_type_id as facility_type1,
"VILLAGE"::character varying(100) as facility_address1,
"ISLAND"::character varying(100) as facility_city,
"ISLAND"::character varying(100) as facility_county,
"Latitude gearth"::double precision as facility_latitude,
"Longitude gearth"::double precision as facility_longitude,
"OWNER"::character varying(100) as facility_owner_company_name,
"OPERATOR"::character varying(100) as facility_operator_company_name,
case when "financial_resp" like '%Self-Assurance%' then 'Yes' end as financial_responsibility_self_insurance_financial_test, 
case when (former_lust = 'YES' or "Current LUST" like 'Y%')  then 'Yes' end  as ust_reported_release, 
'AKA/Former/Associated Facility Names: ' || "previous_name"::character varying(4000) as facility_comment ,
9 as facility_epa_region,
'MP' as facility_state
from mp_ust.mp_ust x 
left join mp_ust.v_facility_type_xwalk cs on x."FACILITY TYPE" = cs.organization_value ;


--review: 
select * from mp_ust.v_ust_facility;
select count(*) from mp_ust.v_ust_facility;
--36
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 22 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/


create or replace view mp_ust.v_ust_tank as 
select distinct
tank_id::integer tank_id,
tank_status_id as tank_status_id,
case when lower(tanks_status_notes) like '%emerg%' then 'Yes' end  emergency_generator, 
case when "total_tanks_at_site" > 2 then 'Yes' end as multiple_tanks,
TO_DATE("tank1_install_date",'YYYY (Mon)') as tank_installation_date,
case when "COMPARTMENT_TK" = 'Y' then 'Yes' end  as compartmentalized_ust,
tank_material_description_id as tank_material_description_id, 
tank_secondary_containment_id as tank_secondary_containment_id, 
"tanks_status_notes"::character varying(4000) as tank_comment,
		"deq_id"::character varying(50) as facility_id
from mp_ust.mp_ust_tanks x 
left join mp_ust.v_tank_status_xwalk ts on x.status = ts.organization_value 
left join mp_ust.v_tank_material_description_xwalk tm on x.tank1_type  = tm.organization_value 
left join mp_ust.v_tank_secondary_containment_xwalk sc on x.secondary_containment = sc.organization_value ;


select * from v_ust_tank;

select count(*) from v_ust_tank; 116
--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 22 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;

create or replace view mp_ust.v_ust_tank_substance as 
select distinct 
	"deq_id"::character varying(50) as facility_id,
	tank_id as tank_id,
	sx.substance_id as substance_id
from mp_ust.mp_ust_tanks x 
left join mp_ust.v_substance_xwalk sx on x."tank1_contents" = sx.organization_value
where "tank1_contents"  is not null


 

select count(*) from mp_ust.v_ust_tank_substance;
--116

select *  from mp_ust.v_ust_tank_substance;


--ust_compartment

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 22 and epa_table_name = 'ust_compartment'
order by column_sort_order;

--just using tank_id for compartment ID becuase it's all a 1 to 1 mapping


create or replace view mp_ust.v_ust_compartment as 
select distinct 
c.deq_id as facility_id,
c.tank_id::int4 tank_id,
c.tank_id::int4 compartment_id,
"tank1_size"::integer as compartment_capacity_gallons,
case when "spill_overflow_corrosion_protection" like '%Ball Float%' then 'Yes' end as overfill_prevention_ball_float_valve,
case when "spill_overflow_corrosion_protection" like '%Alarm%' then 'Yes' end as overfill_prevention_high_level_alarm,
case when "spill_overflow_corrosion_protection" like '%Flapper device%' then 'Yes' end as overfill_prevention_other,
compartment_status_id as compartment_status_id
from mp_ust.mp_ust_tanks c
left join mp_ust.v_compartment_status_xwalk ts on c.status = ts.organization_value

select * from v_ust_compartment;

select count(*) from v_ust_compartment;
116
--------------------------------------------------------------------------------------------------------------------------
--ust_piping





select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 22 and epa_table_name = 'ust_piping'
order by column_sort_order;


--using tank_id for piping_id because of a 1 to 1 mapping
create or replace view mp_ust.v_ust_piping as
select   distinct
x.tank_id::varchar(50) piping_id,
x.deq_id as facility_id,
x.tank_id,
x.tank_id::int4 compartment_id,
px.piping_style_id as piping_style_id
from mp_ust.mp_ust_tanks x 
left join mp_ust.v_piping_style_xwalk px on x.leak_detection_piping = px.organization_value
;

select * from mp_ust.v_ust_piping;
select count(*) from mp_ust.v_ust_piping;116



--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 22
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

The script will also provide the counts of rows in mp_ust.v_ust_facility, mp_ust.v_ust_tank, mp_ust.v_ust_compartment, and
   mp_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
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
where ust_control_id = 22 
order by sort_order;
/*
ust_facility	3270
ust_tank	10654
ust_tank_substance	10395
ust_compartment	10672
ust_piping	10680
*/


--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 9
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
control_id = 9
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------

