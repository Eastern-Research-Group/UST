
--asked Victoria to map the statues for each tank, including up to 5 that don't have many deatils with it

select * from public.ust_control where ust_control_id = 22;


select * from mp_ust_202501271000_va;


se

ALTER TABLE mp_ust_202501271000_va rename to mp_ust;

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


select * from mp_ust

--delete the rows that are hidden in the spreadsheet that get imported
delete from mp_ust where deq_id is null or deq_id in ('S-0017');


create table erg_mp_ust_tanks as
select deq_id,
tank1_size tank_size,
tank1_contents tank_contents,
tank1_type tank_type,
tank1_install_date tank_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection,
tank1_status status ,
1 tank_id,
case when tank1_type like '%Double%' then 'Double Wall' 
 when tank1_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust where tank1_status is not null 

union

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
tank2_status status ,
2 tank_id,
case when tank2_type like '%Double%' then 'Double Wall' 
 when tank2_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust where tank2_status is not null 

union 

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
tank3_status status ,
3 tank_id,
case when tank3_type like '%Double%' then 'Double Wall' 
 when tank3_type like '%Single%' then 'Single Wall'
else null end secondary_containment
from mp_ust where tank3_status is not null 

union 

select deq_id,
null tank1_size,
null tank1_contents,
null tank1_type,
null tank1_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
tank4_status status ,
4 tank_id,
null secondary_containment
from mp_ust mp 
where tank4_status is not null

union 


select deq_id,
null tank1_size,
null tank1_contents,
null tank1_type,
null tank1_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
tank5_status status ,
5 tank_id,
null secondary_containment
from mp_ust mp 
where tank5_status is not null

union 


select deq_id,
null tank1_size,
null tank1_contents,
null tank1_type,
null tank1_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
tank6_status status ,
6 tank_id,
null secondary_containment
from mp_ust mp 
where tank6_status is not null

union 

select deq_id,
null tank1_size,
null tank1_contents,
null tank1_type,
null tank1_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
tank7_status status ,
7 tank_id,
null secondary_containment
from mp_ust mp 
where tank7_status is not null

union 

select deq_id,
null tank1_size,
null tank1_contents,
null tank1_type,
null tank1_install_date,
active_tank_count,
total_tanks_at_site,
"COMPARTMENT_TK",
tanks_status_notes,
leak_detection_tank_equipment,
leak_detection_piping,
spill_overflow_corrosion_protection ,
tank8_status status ,
8 tank_id,
null secondary_containment
from mp_ust mp 
where tank8_status is not null

;


select * from erg_mp_ust_tanks;
118


select  deq_id,tank_id from erg_mp_ust_tanks 
group by deq_id,tank_id
having count(*) > 1;
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



create table mp_ust.erg_compartment (facility_id character varying(50), tank_id int, compartment_id int generated always as identity);
insert into mp_ust.erg_compartment (facility_id, tank_id)
select  distinct deq_id,tank_id from erg_mp_ust_tanks;


create or replace view mp_ust.v_ust_compartment as 
select distinct 
c.facility_id as facility_id,
c.tank_id,
c.compartment_id,
x."tblCompartment_Compartment"::character varying(50) as compartment_name,
compartment_status_id as compartment_status_id,
x."Gallons"::integer as compartment_capacity_gallons
from md_ust.md_tanks_combined x  
join md_ust.erg_compartment c on x."FacilityID"::varchar = c.facility_id and x."TankID"::int = c.tank_id
left join md_ust.v_compartment_status_xwalk ts on x."TankStatusDesc" = ts.organization_value;

create table mp_ust.erg_piping (facility_id character varying(50), tank_id int, compartment_id int, piping_id int generated always as identity);
insert into mp_ust.erg_piping (facility_id, tank_id,compartment_id)
select facility_id,tank_id,compartment_id from mp_ust.erg_compartment;


select * from erg_piping




select * from md_ust.erg_piping ;
select * from v_ust_piping

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (22,'ust_compartment','compartment_id','erg_compartment','compartment_id','This required field is not present in the source data. Table erg_compartment was created by ERG so the data can conform to the EPA template structure.',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (22,'ust_piping','compartment_id','erg_piping','compartment_id','This required field is not present in the source data. Table erg_piping was created by ERG so the data can conform to the EPA template structure.',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (22,'ust_piping','piping_id','erg_piping','piping_id','This required field is not present in the source data. Table erg_piping was created by ERG so the data can conform to the EPA template structure.',null);

 

select * from ust_element_mapping where organization_table_name = 'erg_piping'; 


compartment_status_id
overfill_prevention_other
facility_id
tank_id
compartment_capacity_gallons
overfill_prevention_ball_float_valve
overfill_prevention_high_level_alarm
/*you can run this SQL so you can copy and paste table and column names into the SQL statements generated by the query above
select table_name, column_name from information_schema.columns 
where table_schema = 'mp_ust' order by table_name, ordinal_position;
*/


select * from ust_element_mapping where ust_control_id =22 order by epa_table_name;

leak_detection_tank_equipment           
leak_detection_piping 
spill_overflow_corrosion_protection

select * from ust_element_mapping where ust_element_mapping_id =1237;

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

select * from ust_element_mapping where ust_control_id = 22;
select * from public.piping_styles ps 


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','facility_id','mp_ust_tanks','deq_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','tank_id','mp_ust_tanks','tank_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','compartment_capacity_gallons','mp_ust_tanks','tank1_size',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','overfill_prevention_ball_float_valve','mp_ust_tanks','spill_overflow_corrosion_protection','where spill_overflow_corrosion_protection like %Ball Float%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','overfill_prevention_high_level_alarm','mp_ust_tanks','spill_overflow_corrosion_protection','where spill_overflow_corrosion_protection like %Alarm%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','overfill_prevention_other','mp_ust_tanks','spill_overflow_corrosion_protection','Please verify - where spill_overflow_corrosion_protection like %Flapper device%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_compartment','compartment_status_id','mp_ust_tanks','status','I hard-coded this and needs review in the SQL of the view.  The tank status notes might have some data we can derive this value too.' );

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_piping','facility_id','mp_ust_tanks','deq_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (22,'ust_piping','piping_style_id','mp_ust_tanks','leak_detection_piping','First part of the field.');


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (22,'ust_tank','tank_id','erg_mp_ust_tanks','tank_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (22,'ust_tank_substance','tank_id','erg_mp_ust_tanks','tank_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (22,'ust_piping','tank_id','erg_mp_ust_tanks','tank_id',null,null);


select * from ust_element_mapping where ust_control_id = 22 order by epa_table_name;


select * from ust_element_value_mapping where ust_element_mapping_id = 1246;


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
ust_facility	facility_type1
ust_compartment	compartment_status_id
ust_tank	tank_status_id
ust_tank	tank_material_description_id
ust_tank	tank_secondary_containment_id
ust_tank_substance	substance_id
ust_piping	piping_style_id

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

select distinct "FACILITY TYPE" from mp_ust."mp_ust" order by 1;

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
from mp_ust."erg_mp_ust_tanks" order by 1;
select distinct status from erg_mp_ust_tanks;


select * from public.ust_element_value_mapping where ust_element_mapping_id = 1237;

insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1257, 'Closed (in place)', 'Closed (in place)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1257, 'Closed (removed from ground)', 'Closed (removed from ground)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1257, 'Emergency generator use', 'Currently in use', 'Please verify - ERG plans to talk with EPA further about emergency generator in UST.');


select *
from public.v_ust_element_mapping
where  lower(organization_value) like lower('%generator%')
order by 1, 2;

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


select * from ust_element_value_mapping where lower(organization_value) like '%suction%';




insert into public.ust_element_mapping
	(ust_control_id, epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
	query_logic, inferred_value_comment)
select ust_control_id, 'ust_tank', 'tank_corrosion_protection_sacrificial_anode', organization_table_name, organization_column_name, 
	organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
	'when tank_material_description_id in (5,6) then ''Yes'' else null', 'Inferred from tank material'
from public.ust_element_mapping a
where ust_control_id = 22 and epa_column_name = 'tank_material_description_id'
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


--pulled latest script from master 2/20/25 -- commented out my earlier stuff at the bottom

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 5: Check for lookup data that needs to be deaggregated 

/* 
 * Some states store data with multiple values in a single row, for example, 
 * a tank with multiple substances in one row. Before proceeding, we need 
 * to deaggregate this data by creating an ERG table that contains a single
 * value per row.
 * 
 * Run script generate_deagg_code.py to look for state data that may be
 * in this format, and then perform the deaggregation if necessary. 
 * Set the following variables before running the script:
 
ust_or_release = 'ust' 			# valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True 			# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/XX/UST/XX_UST_deagg.sql). Open the generated file in your database console and step through it.  
 * If no file is produced, proceed to the next step. 
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	where ust_control_id = ZZ and mapping_complete = 'N'
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
where table_schema = lower('MP_ust') and table_type = 'VIEW'
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
where ust_control_id = 22 and organization_table_name like 'erg%'
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
select comments from public.ust_control where ust_control_id = 22;

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
where ust_control_id = 22
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 18: Request OUST review

/* 
 * Sit back and relax, your work here is done for the time being! Or rather, sit back and start another ticket! 
 * Victoria will copy the final files to the appropriate folder on the EPA Teams site and alert
 * OUST that the data is ready for their review. 
 * 
 * OUST will report the findings of their reviews during our bi-weekly Tuesday meetings at 11 a.m. Eastern. 
 * They typically send an agenda out in the hour before the meeting. It's good to attend all of these meetings,
 * but please try especially to attend when they will be discussing a state you have processed - it's much
 * easier to understand their request (and learn a ton about USTs in general) if you are able to hear them 
 * talk about it instead of just reading their comments in the template.   
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 19: Respond to OUST comments 

/* 
 * When OUST completes their review, they will email us. An updated version of the populated template will be 
 * posted in the appropriate state folder at Documents > General > 04 - Template Feedback from OUST on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/04%20-%20Template%20Feedback%20from%20OUST?csf=1&web=1&e=tVFLfE
 * 
 * Any changes you make per OUST's comments need to be peer reviewed before sending the template back to OUST, 
 * so repeat Step 15: Request peer review and make any suggested changes. 
 * 
 * Once you've resolved all of OUST's comments and the reviewing developer approves it, the process repeats itself
 * until OUST declares their review final, at which time Victoria will send the populated template to the state
 * for their review. 
 * 
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 20: State review 

/* 
 * We haven't gotten this far yet, but this process will be very similar to the OUST review process. 
 * Repeat Step 15 for any changes requested by the state. 
 * 
 */

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 21: GIS processing (coming soon)

/* 
 * For any facilities the state did not submit coordinates for, or for coordinates less than 3 decimal 
 * places of accuracy, ERG will be geo-locating the data. This will be a separate process not covered by this 
 * processing template. Further instructions will be provided later. 
*/

/*
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

alter table mp_ust ALTER COLUMN  "Current LUST" char(1)
ALTER TABLE mp_ust ALTER COLUMN "Current LUST" TYPE varchar (1);

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

select  case when (x."Current LUST" like 'Y%')  then 'Yes' end  as ust_reported_release from mp_ust.mp_ust  x
select * from 
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

select * from v_ust_tank;

create or replace view mp_ust.v_ust_tank as 
select distinct
tank_id::integer tank_id,
tank_status_id as tank_status_id,
case when lower(tanks_status_notes) like '%emerg%' then 'Yes' end  emergency_generator, 
case when "total_tanks_at_site" > 2 then 'Yes' end as multiple_tanks,
TO_DATE("tank_install_date",'YYYY (Mon)') as tank_installation_date,
case when "COMPARTMENT_TK" = 'Y' then 'Yes' end  as compartmentalized_ust,
tank_material_description_id as tank_material_description_id, 
tank_secondary_containment_id as tank_secondary_containment_id, 
"tanks_status_notes"::character varying(4000) as tank_comment,
		"deq_id"::character varying(50) as facility_id
from mp_ust.erg_mp_ust_tanks x 
left join mp_ust.v_tank_status_xwalk ts on x.status = ts.organization_value 
left join mp_ust.v_tank_material_description_xwalk tm on x.tank_type  = tm.organization_value 
left join mp_ust.v_tank_secondary_containment_xwalk sc on x.secondary_containment = sc.organization_value ;


select * from v_ust_tank;

select count(*) from v_ust_tank; 
118
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
from mp_ust.erg_mp_ust_tanks x 
left join mp_ust.v_substance_xwalk sx on x."tank_contents" = sx.organization_value
where "tank_contents"  is not null


 

select count(*) from mp_ust.v_ust_tank_substance;
--76

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

create or replace view mp_ust.v_ust_compartment as 
select  
x.deq_id as facility_id,
x.tank_id::int4 tank_id,
c.compartment_id compartment_id,
"tank_size"::integer as compartment_capacity_gallons,
case when "spill_overflow_corrosion_protection" like '%Ball Float%' then 'Yes' end as overfill_prevention_ball_float_valve,
case when "spill_overflow_corrosion_protection" like '%Alarm%' then 'Yes' end as overfill_prevention_high_level_alarm,
case when "spill_overflow_corrosion_protection" like '%Flapper device%' then 'Yes' end as overfill_prevention_other,
compartment_status_id as compartment_status_id
from mp_ust.erg_mp_ust_tanks x
join mp_ust.erg_compartment c on x.deq_id = c.facility_id and x.tank_id = c.tank_id	
left join mp_ust.v_compartment_status_xwalk ts on x.status = ts.organization_value;

select * from mp_ust.erg_mp_ust_tanks  where deq_id = 'S-0003' and tank_id =	1

select count(*) from v_ust_compartment;
116

select * from v_ust_compartment;
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
c.piping_id::varchar(50) piping_id,
x.deq_id as facility_id,
x.tank_id,
c.compartment_id::int4 compartment_id,
px.piping_style_id as piping_style_id
from mp_ust.erg_mp_ust_tanks x
join mp_ust.erg_piping c on x.deq_id = c.facility_id and x.tank_id = c.tank_id	
join mp_ust.v_piping_style_xwalk px on x.leak_detection_piping = px.organization_value

;

select * from mp_ust.v_ust_piping;
select count(*) from mp_ust.v_ust_piping;93


select * from erg_piping


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

*/
