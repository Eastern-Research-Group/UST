insert into release_control(organization_id, date_received, date_processed, data_source, comments)
select organization_id, date_received, date_processed,
	'Downloaded "All LUST Cases" Excel file from https://apps.dep.wv.gov/tanks/public/Pages/USTReports.aspx' as data_source, 
	'Excluded rows where Suspected Release = "Yes"'
from release_control where release_control_id = 7;

create table wv_release.erg_release_status as 
select distinct "Leak_ID" as release_id, 
	case when "Closed Date" is not null then 'No further action' 
		 when "Cleanup Initiated" is not null then 'Active: corrective action' 
		 when "Confirmed Release" is not null then 'Active: general' 
		 else 'Other' end as release_status 
from  wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic";

insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','facility_id','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Facility_ID', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','site_name','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Current Facility Name', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','site_address','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Address', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','site_city','WVDEP.USTLUSTReports_FOIA-LUSTPublic','City', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','zipcode','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Zip', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','county','WVDEP.USTLUSTReports_FOIA-LUSTPublic','County', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','release_status_id','erg_release_status','release_status','ERG created table erg_release_status to calculate release status from three date columns: "Closed Date", "Cleanup Initiated", and "Closed Date", with the following logic: case when "Closed Date" is not null then ''No further action'' when "Cleanup Initiated" is not null then ''Active: corrective action'' when "Confirmed Release" is not null then ''Active: general'' else ''Other''');
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','nfa_date','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Closed Date', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','reported_date','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Confirmed Release', null);
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','media_impacted_soil','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Priority', 'If Priority = ''3-Soil contamination'', then ''Yes'' ');
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','media_impacted_groundwater','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Priority', 'If Priority = ''2-Groundwater contamination'', then ''Yes'' ');
insert into release_element_mapping (release_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (10, '2024-08-27','ust_release','release_id','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Leak_ID', null);

select * from release_element_mapping where release_control_id = 10;

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) 
values (292, '3-Soil contamination', 'Yes');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) 
values (293, '2-Groundwater contamination', 'Yes');

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) 
values (287, 'Other', 'Other');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) 
values (287, 'Active: corrective action', 'Active: corrective action');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) 
values (287, 'No further action', 'No further action');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) 
values (287, 'Active: general', 'Active: general');

--run org_mapping_xwalks.py, which created view wv_release.v_release_status_xwalk


select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name,
	programmer_comments
from v_release_table_population_sql
where release_control_id = 10 and epa_table_name = 'ust_release'
order by column_sort_order;

select distinct "Priority" from wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic"

create view wv_release.v_ust_release_rm as
select 
	"Facility_ID"::character varying(50) as facility_id,
	a."Leak_ID"::character varying(50) as release_id,
	"Current Facility Name"::character varying(200) as site_name,
	"Address"::character varying(100) as site_address,
	"City"::character varying(100) as site_city,
	"Zip"::character varying(10) as zipcode,
	"County"::character varying(100) as county,
	'WV' as state, 
	3 as epa_region,
	release_status_id as release_status_id,
	"Confirmed Release"::date as reported_date,
	"Closed Date"::date as nfa_date,
	case when "Priority" = '3-Soil contamination' then 'Yes' end as media_impacted_soil,
	case when "Priority" = '2-Groundwater contamination' then 'Yes' end as media_impacted_groundwater
from wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" a
	left join wv_release.erg_release_status b on a."Leak_ID" = b.release_id
	left join wv_release.v_release_status_xwalk rs on b.release_status = rs.organization_value
where "Suspected Release" <> 'Yes';


select count(*) from wv_release.v_ust_release_rm;
3930

select count(*) from wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" 
where "Suspected Release" <> 'Yes';

