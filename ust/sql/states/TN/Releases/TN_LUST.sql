-- Under ‘Currentstatus’ column:
-- Remove all ‘0a Suspected Release – Closed’, ‘3 Release Investigation’, and ‘0 Suspected Release - RD records’ types. These are not confirmed releases.


select distinct "Currentstatus" from "ust_all-tn-environmental-sites" order by 1;

delete from "ust_all-tn-environmental-sites" where "Currentstatus" in 
	('0a Suspected Release - Closed', '0 Suspected Release - RD records', '3 Release Investigation');

select * from "ust_all-tn-environmental-sites";

----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-07', 'LUSTStatus', 'ust_all-tn-environmental-sites', 'Currentstatus')
returning id;

update lust_element_db_mapping set state_table_name = 'tn_lust' where id = 68;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, ''' || "Currentstatus" ||  ''', '''');'
from "TN_LUST"."ust_all-tn-environmental-sites"
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '0 Suspected Release - RD records', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '0a Suspected Release - Closed', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '1 Tank Closure', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '13 Abandoned Facility Project', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '1a Completed Tank Closure', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '1b Closure Application Expired', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '1c Line Closure', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '1d Completed Line Closure', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '2 Site Check', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '3 Release Investigation', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '6 Corrective Action', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '7 Closure Monitoring', 'Active: post remediation monitoring');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '8 Case Closed', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (68, '9 Other', 'Other');
----------------------------------------------------------------------------------------------------------------------------------




insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-07', 'SubstanceReleased1', 'SubstanceReleased_deagg', 'Productreleased')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-07', 'SubstanceReleased2', 'SubstanceReleased_deagg', 'Productreleased')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-07', 'SubstanceReleased3', 'SubstanceReleased_deagg', 'Productreleased')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-07', 'SubstanceReleased4', 'SubstanceReleased_deagg', 'Productreleased')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-07', 'SubstanceReleased5', 'SubstanceReleased_deagg', 'Productreleased')
returning id;


select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, ''' || "Productreleased" ||  ''', '''');'
from "TN_LUST"."SubstanceReleased_deagg"
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, 'Gasoline', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, 'Jet Fuel', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, 'Used Oil', 'Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (73, 'Waste Oil', 'Used oil/waste oil');

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Gasoline', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Jet Fuel', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Used Oil', 'Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Waste Oil', 'Used oil/waste oil');

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Gasoline', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Jet Fuel', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Used Oil', 'Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Waste Oil', 'Used oil/waste oil');

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Gasoline', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Jet Fuel', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Used Oil', 'Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Waste Oil', 'Used oil/waste oil');

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Diesel', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Gasoline', 'Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Jet Fuel', 'Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Kerosene', 'Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Used Oil', 'Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Waste Oil', 'Used oil/waste oil');



----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-07', 'CauseOfRelease1', 'tn_lust', 'Cause')
returning id;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, ''' || "Cause" ||  ''', '''');'
from "TN_LUST".tn_lust
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '1 Spill', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '2 Overfill', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '3 Human Error', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '4 Corrosion', 'Corrosion');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '5 Pipe Failure', 'Piping failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '6 Mechanical Failure', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '7 Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, '8 Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Corrosion', 'Corrosion');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Human Error', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Install Problem', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Mechanical Failure', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Overfill', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Pipe Failure', 'Piping failure');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Spill', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Unknown', 'Unknown');

select * from lust_element_value_mappings where element_db_mapping_id = 78;

update lust_element_value_mappings set epa_value = 'Other' where id = 597;

select distinct "Cause" from "TN_LUST".tn_lust order by 1;


select * from lust_element_value_mappings where lower(state_value) like '%spill%';


----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('TN', '2023-04-26', 'HowReleaseDetected', 'tn_lust', 'Howdiscovered')
returning id;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, ''' || "Howdiscovered" ||  ''', '''');'
from "TN_LUST".tn_lust
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '1 At Closure', 'Inspection');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '2 Release Detection', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '3 On-site Impact', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '3 On-Site Impact', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '4 Off-site Impact', 'Third party (well water, vapor intrusion, etc.)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '4 Off-Site Impact', 'Third party (well water, vapor intrusion, etc.)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '5 Site Check', 'Inspection');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '6 Tightness Test', 'Tank tightness testing');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '6 Tightness Testing', 'Tank tightness testing');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '7 Environmental Audit', 'Inspection');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '8 Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, '9 Unknown', 'Unknown');

select * from how_release_detected ;

	case when "Howdiscovered" = '5 Site Check' then 'Inspection'
	     when "Howdiscovered" = '9 Unknown' then 'Unknown'
	     when "Howdiscovered" like '%Tightness%' then 'Tank Tightness Testing'
		 else 'Other' end as "HowReleaseDetected"
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

create sequence "TN_LUST".lustid_seq;

select column_name 
from information_schema.columns 
where table_schema = 'TN_LUST' and table_name = 'ust_all-tn-environmental-sites'
order by ordinal_position ;

create table "TN_LUST".tn_lust 	as
select 
	replace('TN_' || substr("Facilityname" || '_' || 	"Sitenumber",1,40) || '_' || nextval('"TN_LUST".lustid_seq'),'__','_') as "LUSTID",
	"Facilityid",
	"Sitenumber",
	"Facilityname",
	"Facilityaddress1",
	"Facilityaddress2",
	"Facilitycity",
	"Facilityzip",
	"Facilitycounty",
	"Casedescription",
	"Cause",
	"Discoverydate",
	"Currentstatus",
	"Productreleased",
	"Company",
	"Caccompany",
	"Howdiscovered" 
from  "TN_LUST"."ust_all-tn-environmental-sites";

select count(*) From (select distinct "Facilityname" || "Sitenumber" from "TN_LUST"."ust_all-tn-environmental-sites") a;

15526

select * from "TN_LUST".tn_lust


select count(*) from "TN_LUST"."ust_all-tn-environmental-sites" where "Sitenumber" is null;

create or replace view "TN_LUST".v_lust_base as 
select "Facilityid" as "FacilityID",
	l."LUSTID" as "LUSTID", 
	"Facilityname" as "SiteName",
	"Facilityaddress1" as "SiteAddress",
	"Facilityaddress2" as "SiteAddress2",
	"Facilitycity" as "SiteCity",
	case when  length("Facilityzip") > 10 then substring("Facilityzip",1,5) else "Facilityzip" end as "Zipcode",
	"Facilitycounty" as "County",
	'TN' as "State",
	4 as "EPARegion",
	ls.epa_value as "LUSTStatus",
	"Discoverydate" as "ReportedDate",
	sr1.epa_value as "SubstanceReleased1",
	sr2.epa_value as "SubstanceReleased2",
	sr3.epa_value as "SubstanceReleased3",
	sr4.epa_value as "SubstanceReleased4",
	sr5.epa_value as "SubstanceReleased5",
	cr.epa_value as "CauseOfRelease1",
	hrd.epa_value as "HowReleaseDetected"
from "TN_LUST".tn_lust l 
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'LUSTStatus') ls on l."Currentstatus" = ls.state_value
	left join (select * from "TN_LUST"."SubstanceReleased_deagg" where rownumber = 1) sdeagg1 on l."LUSTID" = sdeagg1."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'SubstanceReleased1') sr1 on sdeagg1."Productreleased" = sr1.state_value
	left join (select * from "TN_LUST"."SubstanceReleased_deagg" where rownumber = 2) sdeagg2 on l."LUSTID" = sdeagg2."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'SubstanceReleased2') sr2 on sdeagg2."Productreleased" = sr2.state_value
	left join (select * from "TN_LUST"."SubstanceReleased_deagg" where rownumber = 3) sdeagg3 on l."LUSTID" = sdeagg3."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'SubstanceReleased3') sr3 on sdeagg3."Productreleased" = sr3.state_value
	left join (select * from "TN_LUST"."SubstanceReleased_deagg" where rownumber = 4) sdeagg4 on l."LUSTID" = sdeagg4."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'SubstanceReleased4') sr4 on sdeagg4."Productreleased" = sr4.state_value
	left join (select * from "TN_LUST"."SubstanceReleased_deagg" where rownumber = 5) sdeagg5 on l."LUSTID" = sdeagg5."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'SubstanceReleased5') sr5 on sdeagg5."Productreleased" = sr5.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'CauseOfRelease1') cr on l."Cause" = cr.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'HowReleaseDetected') hrd on l."Howdiscovered" = hrd.state_value
order by "Facilityid", l."LUSTID";


select count(*) from "TN_LUST".v_lust_base;

select * from v_lust_element_mapping where organization_id = 'TN' and element_name = 'LUSTStatus';

select distinct "Currentstatus" from "TN_LUST".tn_lust order by 1;
0 Suspected Release - RD records
0a Suspected Release - Closed
1 Tank Closure
13 Abandoned Facility Project
1a Completed Tank Closure
1b Closure Application Expired
1c Line Closure
1d Completed Line Closure
2 Site Check
3 Release Investigation
6 Corrective Action
7 Closure Monitoring
8 Case Closed
9 Other

select count(*) from "TN_LUST".tn_lust where "Currentstatus" is null; 
206

select count(*) from "TN_LUST".tn_lust where "Currentstatus" = '0 Suspected Release - RD records'; 
6


select id, state_value, epa_value
from v_lust_element_mapping
where organization_id = 'TN' and element_name = 'LUSTStatus'
order by 1;

update lust_element_value_mappings set epa_value = 'Active: general' where id = 493;
update lust_element_value_mappings set epa_value = 'No further action' where id = 494;
update lust_element_value_mappings set epa_value = 'No further action' where id = 495;
update lust_element_value_mappings set epa_value = 'No further action' where id = 496;
update lust_element_value_mappings set epa_value = 'No further action' where id = 497;
update lust_element_value_mappings set epa_value = 'No further action' where id = 498;
update lust_element_value_mappings set epa_value = 'No further action' where id = 499;
update lust_element_value_mappings set epa_value = 'No further action' where id = 500;
update lust_element_value_mappings set epa_value = 'Active: site investigation' where id = 501;
update lust_element_value_mappings set epa_value = 'Active: site investigation' where id = 502;
update lust_element_value_mappings set epa_value = 'Active: remediation' where id = 503;
update lust_element_value_mappings set epa_value = 'No further action' where id = 504;
update lust_element_value_mappings set epa_value = 'No further action' where id = 505;
update lust_element_value_mappings set epa_value = 'Active: general' where id = 506;


update lust set "LUSTStatus" = 'Active: general' where organization_id = 'TN' and "LUSTStatus" = 'Other';



select * from "TN_LUST".tn_lust
where "LUSTID" is null;

update "TN_LUST".tn_lust 
set "LUSTID" = 'TN_' || "Facilityid" || '_' || "Sitenumber" || '_' || nextval('"TN_LUST".lustid_seq')
where "LUSTID" is null;

select * from "TN_LUST".tn_lust where length("Facilityzip") > 10;

select distinct "Currentstatus" from "TN_LUST".tn_lust  order by 1;

Under ‘Currentstatus’ column:
Remove all 
0a Suspected Release – Closed
3 Release Investigation
0 Suspected Release - RD records
types. These are not confirmed releases.



select distinct element_name,  state_table_name, state_column_name 
from v_lust_element_mapping where state = 'TN'
order by 1, 2;





----------------------------------------------------------------------------------------------------------------------------------------------------

select * from "TN_LUST".tn_lust_geocoded;
select * from lust_geocode where organization_id = 'TN';
select * from lust_geocode_old where state = 'TN';

insert into lust_geocode(control_id, organization_id, lust_location_id, gc_latitude, gc_longitude, gc_coordinate_source)
select 5, 'TN', , "Latitude", "Longitude", 'State'
from "TN_LUST".tn_lust_geocoded
where gc_coordinate_source = 'State'




select column_name 
from information_schema.columns
where table_schema = 'TN_LUST' and table_name = 'tn_lust_geocoded'
order by ordinal_position;


select * from lust_locations;


create table "TN_LUST".tn_lust_geocoded (
"LUSTID"  varchar(100),
"SiteName" varchar(400),
"SiteAddress" varchar(100),
"SiteAddress2" varchar(400),
"SiteCity" varchar(400),
"Zipcode" varchar(400),
"County" varchar(400),
"State" varchar(2),
"Latitude" float8,
"Longitude" float8,
"gc_coordinate_source" varchar(100),
"gc_address_type" varchar(400));

select count(*) from "TN_LUST".tn_lust_geocoded

select * from lust_locations where organization_id = 'TN'

delete from lust_geocode  where organization_id = 'TN';

insert into lust_geocode (control_id, organization_id, lust_location_id, gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type)
select distinct a.control_id, a.organization_id, a.lust_location_id, b."Latitude", b."Longitude", b."gc_coordinate_source", b."gc_address_type"
from lust_locations a join "TN_LUST".tn_lust_geocoded b on a."LUSTID" = b."LUSTID"
		and coalesce(a."SiteName",'X') = coalesce(b."SiteName",'X')
			and coalesce(a."SiteAddress",'X') = coalesce(b."SiteAddress",'X')
--			and coalesce(a."SiteAddress2",'X') = coalesce(b."SiteAddress2",'X')
			and coalesce(a."SiteCity",'X') = coalesce(b."SiteCity",'X')
--			and coalesce(a."Zipcode",'X') = coalesce(b."Zipcode",'X')
			and coalesce(a."County",'X') = coalesce(b."County",'X')
			and coalesce(a."State",'X') = coalesce(b."State",'X')
where a.organization_id = 'TN';

select count(*) from 
	(select distinct a.control_id, a.organization_id, a.lust_location_id, b."Latitude", b."Longitude", b."gc_coordinate_source", b."gc_address_type"
	from lust_locations a join "TN_LUST".tn_lust_geocoded b on a."LUSTID" = b."LUSTID"
			and coalesce(a."SiteName",'X') = coalesce(b."SiteName",'X')
				and coalesce(a."SiteAddress",'X') = coalesce(b."SiteAddress",'X')
--				and coalesce(a."SiteAddress2",'X') = coalesce(b."SiteAddress2",'X')
				and coalesce(a."SiteCity",'X') = coalesce(b."SiteCity",'X')
--				and coalesce(a."Zipcode",'X') = coalesce(b."Zipcode",'X')
				and coalesce(a."County",'X') = coalesce(b."County",'X')
				and coalesce(a."State",'X') = coalesce(b."State",'X')
			) a;

		select * from lust_locations where organization_id = 'TN' and "Zipcode" is null;
		
	select * from "TN_LUST".tn_lust_geocoded where "Zipcode" is null;

select * from  "TN_LUST".tn_lust_geocoded where "LUSTID" = 'TN_Norfolk Southern Railroad Company_1_5157'
select * from lust_locations where "LUSTID" = 'TN_Norfolk Southern Railroad Company_1_5157'


	
select * from lust_geocode where organization_id = 'TN';

select * from v_lust where organization_id = 'TN';

select count(*) from v_lust where organization_id = 'TN' and "Latitude" is null;

select * from v_lust where organization_id = 'TN' and "Latitude" is null;


select state_value, count(*) from (
select "LUSTID",
	ls.state_value, 
	ls.epa_value as "LUSTStatus"
from "TN_LUST".tn_lust l 
	left join (select state_value, epa_value from v_lust_element_mapping where organization_id = 'TN' and element_name =  'LUSTStatus') ls on l."Currentstatus" = ls.state_value
) a group by state_value order by 1;
