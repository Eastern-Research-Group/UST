select * from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"

----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('AL', '2023-04-11', 'LUSTStatus', 'AL_LUST', 'STATUS')
returning id;

select * from lust_element_db_mapping where state = 'AL' order by 1 desc;

select distinct "" from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023" order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (69, ''' || "STATUS" ||  ''', '''');'
from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"
order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (69, 'Active', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (69, 'Closed', 'No further action');

select * from lust_status ;


----------------------------------------------------------------------------------------------------------------------------------
select column_name from information_schema.columns where table_schema = 'AL_LUST' order by ordinal_position ;


select num_commas, count(*)
from 
	(select "SITE ADDRESS", (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',') as num_commas
	from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023") a
group by num_commas;

select "SITE ADDRESS"
from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"
where (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',') = 3;

select "SITE ADDRESS"
from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"
where (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',') = 2;

select "INCIDENT NUMBER", "SITE ADDRESS" 
from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"
where (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',')  > 2;

select "SITE ADDRESS" || ' 
', 'update lust 
set "SiteAddress" = '''', "SiteCity" = '''', "State" = '''', "Zipcode" = ''''
where state = ''AL'' and "LUSTID" = ''' || "INCIDENT NUMBER" || ''';
'
from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"
where (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',')  > 2;

update lust 
set "SiteAddress" = '1622 7TH SO.', "SiteCity" = 'CLANTON', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST90-09-36';
	update lust 
set "SiteAddress" = 'HWY 9', "SiteCity" = 'LINEVILLE', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST02-10-07';
	update lust 
set "SiteAddress" = 'RT1 BOX 336', "SiteCity" = 'ROCKFORD', "State" = 'AL', "Zipcode" = '35136'
where "State" = 'AL' and "LUSTID" = 'UST09-08-05';
	update lust 
set "SiteAddress" = 'SITE 12.  US HWY 280', "SiteCity" = 'KELLYTON', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST94-12-24';
	update lust 
set "SiteAddress" = '630 M. L. KING JR. EXPRESSWAY', "SiteCity" = 'ANDALUSIA', "State" = 'AL', "Zipcode" = '36420'
where "State" = 'AL' and "LUSTID" = 'UST12-08-08';
	update lust 
set "SiteAddress" = '525 ALA HWY 69 S', "SiteCity" = 'DODGE CITY', "State" = AL'', "Zipcode" = '35077'
where "State" = 'AL' and "LUSTID" = 'UST11-11-01';
	update lust 
set "SiteAddress" = '393 MAIN STREET EAST', "SiteCity" = 'RAINSVILLE', "State" = 'AL', "Zipcode" = '35986'
where "State" = 'AL' and "LUSTID" = 'UST91-10-37';
	update lust 
set "SiteAddress" = '500 HOSPITAL DR', "SiteAddress2" = 'PO BOX 120', "SiteCity" = 'WETUMPKA', "State" = 'AL', "Zipcode" = '36092'
where "State" = 'AL' and "LUSTID" = 'UST00-12-22';
	update lust 
set "SiteAddress" = 'OLD DEPOT', "SiteAddress2" = 'HOFFMAN AVE', "SiteCity" = 'BRIDGEPORT', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST94-09-14';
	update lust 
set "SiteAddress" = 'BLK 188', "SiteAddress2" = 'LOTS 2A,3A(PARCELS13-18)& 5', "SiteCity" = 'BIRMINGHAM', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST91-12-14';
	update lust 
set "SiteAddress" = '2 41ST ST S & 1ST AVE S', "SiteAddress2" = 'BLDG 2', "SiteCity" = 'BIRMINGHAM', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST93-01-35';
	update lust 
set "SiteAddress" = '1220 40TH ST', "SiteCity" = 'BIRMINGHAM', "State" = 'AL', "Zipcode" = null
where "State" = 'AL' and "LUSTID" = 'UST94-03-14';
	update lust 
set "SiteAddress" = '360D Quality Cir NW', "SiteAddress2" = 'Suite 450', "SiteCity" = 'Huntsville', "State" = 'AL', "Zipcode" = '35806'
where "State" = 'AL' and "LUSTID" = 'UST12-08-07';
	update lust 
set "SiteAddress" = 'ALA HWY 80 EAST', "SiteCity" = 'TUSKEGEE', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST94-06-22';
	update lust 
set "SiteAddress" = 'ROUTE 2', "SiteAddress2" = 'HIGHWAY 78 WEST', "SiteCity" = 'WINFIELD', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST93-09-12';
	update lust 
set "SiteAddress" = '1451 MARTIN LUTHER KING, JR. AVENUE', "SiteCity" = 'MOBILE', "State" = 'AL', "Zipcode" = '36603'
where "State" = 'AL' and "LUSTID" = 'UST19-03-05';
	update lust 
set "SiteAddress" = 'RIVER ROAD', "SiteAddress2" = 'MAXWELL AFB', "SiteCity" = 'MONTGOMERY', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST94-09-19';
	update lust 
set "SiteAddress" = 'HWY 31',  "SiteAddress2" = 'WASHINGTON FERRY ROAD', "SiteCity" = 'MONTGOMERY', "State" = 'AL', "Zipcode" = ''
where "State" = 'AL' and "LUSTID" = 'UST97-12-07';
	update lust 
set "SiteAddress" = 'RT 6 PO BOX 103 (ST HWY 223, US 29)', "SiteCity" = 'TROY', "State" = 'AL', "Zipcode" = '36081'
where "State" = 'AL' and "LUSTID" = 'UST92-03-07';
	update lust 
set "SiteAddress" = 'HWY 10, HWY 28, & HWY 41', "SiteCity" = 'CAMDEN', "State" = 'AL', "Zipcode" = '36726'
where "State" = 'AL' and "LUSTID" = 'UST03-07-12';
	update lust 
set "SiteAddress" = '2540 HWY 278 (HWY 278, 5 & 13)', "SiteCity" = 'LYNN', "State" = 'AL', "Zipcode" = '35575-2532 '
where "State" = 'AL' and "LUSTID" = 'UST07-07-06';
	update lust 
set "SiteAddress" = '2540 HWY 278 (HWY 278, 5 & 13)', "SiteCity" = 'LYNN', "State" = 'AL', "Zipcode" = '35575-2532 '
where "State" = 'AL' and "LUSTID" = 'UST98-01-16';





create or replace function reverse_string(text) returns text 
 LANGUAGE plpgsql
AS $function$
declare
    reversed_string text;
    incoming alias for $1;
begin
	reversed_string = '''';
	for i in reverse char_length(incoming)..1 loop
		reversed_string = reversed_string || substring(incoming from i for 1);
	end loop;
return reversed_string;
end
$function$
;

select length('930 SELMA HWY (HWY 82 & 14), PRATTVILLE, AL 36707') - position(' ' in reverse_string('930 SELMA HWY (HWY 82 & 14), PRATTVILLE, AL 36707')) + 1;

create or replace function get_last_index(search_string text, search_char text) returns integer
language plpgsql
as $function$
declare
	i integer;
begin 
	select length(search_string) - position(search_char in reverse_string(search_string)) + 1 into i;
	return i;
end
$function$
;

create or replace function get_first_index(search_string text, search_char text) returns integer
language plpgsql
as $function$
declare
	i integer;
begin 
	select position(search_char in search_string) into i;
	return i;
end
$function$
;

create or replace function "AL_LUST".get_zip_code(search_string text) returns text
language plpgsql
as $function$
declare
	i integer;
	zip text;
begin 
	if search_string like '%AL' then
		return null;
	end if;
	select get_last_index(search_string, ' ') + 2 into i;
	select substring(search_string from i) into zip;
	return zip;
end
$function$
;


create or replace function "AL_LUST".get_state(search_string text) returns text
language plpgsql
as $function$
declare
	i integer;
	i2 integer;
	len integer;
	state text;
	string text;
begin 
	if search_string like '%AL' then
		string = search_string || ' ';
	else
		string = search_string;
	end if;
	select get_last_index(string, ',') + 2 into i;
	select get_last_index(string, ' ') + 2 into i2;
	select i2 - i into len;
	select trim(substring(string from i for len)) into state;
	return state;
end
$function$
;

create or replace function "AL_LUST".get_address(search_string text) returns text
language plpgsql
as $function$
declare
	i integer;
	address text;
begin 
	select get_first_index(search_string, ',') - 1 into i;
	select trim(substring(search_string for i)) into address;
	return address;
end
$function$
;

select get_last_index('930 SELMA HWY (HWY 82 & 14), PRATTVILLE, AL 36707-1234',' ');
43
select get_last_index('930 SELMA HWY (HWY 82 & 14), PRATTVILLE, AL 36707-1234',',');
39

select get_first_index('143 GROUBY AIRPORT ROAD, PRATTVILLE, AL',',');
16


select length('930 SELMA HWY (HWY 82 & 14), PRATTVILLE, AL 36707-1234');
54

select "AL_LUST".get_zip_code('930 SELMA HWY (HWY 82 & 14), PRATTVILLE, AL 36707-1234');
select "AL_LUST".get_state('930 SELMA HWY (HWY 82 & 14), PRATTVILLE, AL 36707-1234');
select "AL_LUST".get_address('143 GROUBY AIRPORT ROAD, PRATTVILLE, AL');



select * from "AL_LUST".v_lust_base
where "FacilityID" like 'Memorial Parkway Filling Statio%'

select * from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"
where "FACILITY ID" like 'Memorial Parkway Filling Statio%';

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

select column_name from information_schema.columns where table_schema = 'AL_LUST' order by ordinal_position ;

create or replace view "AL_LUST".v_lust_base as
select 
	case when length("FACILITY ID") > 30 then null else "FACILITY ID" end as "FacilityID",
	"INCIDENT NUMBER" as "LUSTID",
	"INCIDENT SITE NAME" as "SiteName",
	"SITE ADDRESS",
	case when (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',') = 2 --there are a few site addresses that have too many commas; not parsing those
		then "AL_LUST".get_address("SITE ADDRESS") end as "SiteAddress",
	case when (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',') = 2 --there are a few site addresses that have too many commas; not parsing those
		then "AL_LUST".get_state("SITE ADDRESS") end as "State",
	4::int as "EPARegion",
	case when (CHAR_LENGTH("SITE ADDRESS") - CHAR_LENGTH(REPLACE("SITE ADDRESS", ',', ''))) / CHAR_LENGTH(',') = 2 --there are a few site addresses that have too many commas; not parsing those
		then "AL_LUST".get_zip_code("SITE ADDRESS") end as "Zipcode",
	"COUNTY" as "County",
	"LATITUDE" as "Latitude",
	"LONGITUDE" as "Longitude",
	ls.epa_value as "LUSTStatus"
from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023" a
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'AL' and element_name = 'LUSTStatus') ls on a."STATUS" = ls.state_value
;
select * from  "AL_LUST".v_lust_base 

alter table ust alter "FacilityID" drop not null ;

select distinct element_name, state_table_name, state_column_name 
from v_lust_element_mapping where state = 'AL';





select * from "AL_LUST".v_lust order by "FacilityID", "LUSTID";

select * from lust_status 


select state_value, epa_value from v_lust_element_mapping where state = 'AL';

select * from "AL_LUST"."ListofIssuedReleaseIncidentsMarch2023"  where  length("FACILITY ID") > 30 


select '"' || column_name || '",'
from information_schema."columns" 
where table_name = 'lust' and table_schema = 'public'
order by ordinal_position ;

select
	"FacilityID",
	"TankIDAssociatedwithRelease",
	"LUSTID",
	"FederallyReportableRelease",
	"SiteName",
	"SiteAddress",
	"SiteAddress2",
	"SiteCity",
	"Zipcode",
	"County",
	"State",
	"EPARegion",
	"FacilityType",
	"TribalSite",
	"Tribe",
	"Latitude",
	"Longitude",
	"CoordinateSource",
	"LUSTStatus",
	"ReportedDate",
	"NFADate",
	"MediaImpactedSoil",
	"MediaImpactedGroundwater",
	"MediaImpactedSurfaceWater",
	"SubstanceReleased1",
	"QuantityReleased1",
	"Unit1",
	"SubstanceReleased2",
	"QuantityReleased2",
	"Unit2",
	"SubstanceReleased3",
	"QuantityReleased3",
	"Unit3",
	"SubstanceReleased4",
	"QuantityReleased4",
	"Unit4",
	"SubstanceReleased5",
	"QuantityReleased5",
	"Unit5",
	"SourceOfRelease1",
	"CauseOfRelease1",
	"SourceOfRelease2",
	"CauseOfRelease2",
	"SourceOfRelease3",
	"CauseOfRelease3",
	"HowReleaseDetected",
	"CorrectiveActionStrategy1",
	"CorrectiveActionStrategy1StartDate",
	"CorrectiveActionStrategy2",
	"CorrectiveActionStrategy2StartDate",
	"CorrectiveActionStrategy3",
	"CorrectiveActionStrategy3StartDate",
	"ClosedWithContamination",
	"NoFurtherActionLetterURL",
	"MilitaryDoDSite"
from lust where state = 'AL' order by "FacilityID", "LUSTID"; 
