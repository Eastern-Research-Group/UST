insert into lust_control(state, date_received, date_processed, data_source)
values ('NC', '2023-05-05', '2023-05-08','State updated Excel spreadsheet')
returning control_id;

insert into lust_control(organization_id, date_received, date_processed, data_source, comments)
values ('NC', '2023-05-05', '2023-07-06','State updated Excel spreadsheet',
	'Re-processing existing data to try to get counts to more closely match OUST performance measures.')
returning control_id;
11

select * from v_lust_element_mapping where organization_id = 'NC'



----------------------------------------------------------------------------------------------------------------------------------

select count(*) from "NC_LUST"."LUST_Data_050523"
30994

select * from "NC_LUST"."LUST_Data_050523"

select "IncidentNumber" , count(*)
from  "NC_LUST"."LUST_Data_050523"
group by "IncidentNumber" having count(*) > 1;


select "USTNum" , count(*)
from  "NC_LUST"."LUST_Data_050523"
group by "USTNum" having count(*) > 1
order by 2 desc;

select "USTNum", "LURFiled", "EPA Status"
from "NC_LUST"."LUST_Data_050523"
where "USTNum" in ('WS-4415','WS-3471','RA-5953','AS-4313','MO-8628','RA-4960','WA-669','WS-6805')
order by 1, 3;

select * from "NC_LUST"."LUST_Data_050523" where "USTNum" = 'MO-8628';

select count(*) from "NC_LUST"."LUST_Data_050523" where  "USTNum"  is  null;

select b."USTNum", a.* 
from "NC_LUST"."LUST_Data_050523" a join "NC_LUST"."LUST_Data_050523" b on a."IncidentNumber" = b."IncidentNumber"
where a."USTNum" <> b."USTNum"


select * from "NC_LUST"."LUST_Data_050523" where "IncidentNumber" = 28369;

select distinct "EPA Status" from "NC_LUST"."LUST_Data_050523" order by 1;
Active: general
Active: remediation
Active: site investigation
No further action
Other

select distinct "EPA Status" 
into "NC_LUST".status_order
from "NC_LUST"."LUST_Data_050523" order by 1;

alter table "NC_LUST".status_order add sort_order int;

update "NC_LUST".status_order set sort_order = 1 where "EPA Status" = 'No further action';
update "NC_LUST".status_order set sort_order = 2 where "EPA Status" = 'Active: remediation';
update "NC_LUST".status_order set sort_order = 3 where "EPA Status" = 'Active: general';
update "NC_LUST".status_order set sort_order = 4 where "EPA Status" = 'Active: site investigation';
update "NC_LUST".status_order set sort_order = 5 where "EPA Status" = 'Other';


select '"' || column_name || '",'
from information_schema.columns where table_name = 'LUST_Data_050523'
order by ordinal_position ;

select * from "NC_LUST"."LUST_Data_050523"

create or replace view "NC_LUST".v_state_data as
select distinct 
		"IncidentNumber",
		x."USTNum",
		"IncidentName",
		"FacilID",
		"Address",
		"CityTown",
		"State",
		"County",
		"ZipCode",
		"LatDec",
		"LongDec",
		"HCS_Res",
		"HCS_Ref",
		"Reliability",
		"DateReported",
		"CloseOut",
		"Sources",
		"Causes",
		"InterCons",
		"Comm",
		"reg",
		"LUSTStatus",
		"MTBE",
		"ReleaseCode",
		"RBCA_GW",
		"PETOPT",
		"HowReleaseDetected",
		"CauseOfRelease",
		"RemediationStrategy",
		"OwnershipType",
		"RSource",
		"Substance",
		"Plume",
		"RCause",
		"LURFiled",
		y."EPA Status"
from 
	(select "USTNum", max(b.sort_order) as sort_order
	from "NC_LUST"."LUST_Data_050523" a join "NC_LUST".status_order b on a."EPA Status" = b."EPA Status"
	group by "USTNum") x 
	join "NC_LUST"."LUST_Data_050523" y on x."USTNum" = y."USTNum" 
	join "NC_LUST".status_order z on x.sort_order = z.sort_order;

select count(*) from "NC_LUST".v_state_data;
16622

select * from "NC_LUST"."LUST_Data_050523" order by "USTNum";

----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-03-28', 'MediaImpactedSoil', 'tblRelDisc1', 'RDMethod')
returning id;

select distinct "RDMethod" from "NC_LUST"."tblRelDisc1" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (57, ''' || "RDMethod" ||  ''', ''Yes'');'
from "NC_LUST"."tblRelDisc1" where "RDCode" = 11
order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (57, 'Soil Contamination', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-07-06', 'MediaImpactedSoil', 'tblRelDisc1', 'RDMethod')
returning id;

select * from "NC_LUST"."tblRelDisc1" order by 1;

select * from 



----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-03-28', 'MediaImpactedGroundwater', 'tblRelDisc1', 'RDMethod')
returning id;

select distinct "RDMethod" from "NC_LUST"."tblRelDisc1" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (58, ''' || "RDMethod" ||  ''', ''Yes'');'
from "NC_LUST"."tblRelDisc1" where "RDCode" = 7
order by 1;
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (58, 'Groundwater Contamination', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-03-28', 'MediaImpactedSurfaceWater', 'tblRelDisc1', 'RDMethod')
returning id;

select distinct "RDMethod" from "NC_LUST"."tblRelDisc1" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (59, ''' || "RDMethod" ||  ''', ''Yes'');'
from "NC_LUST"."tblRelDisc1" where "RDCode" = 8
order by 1;
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (59, 'Surface Water Contamination', 'Yes');

select * from "NC_LUST"."tblRelDisc1";

----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-03-28', 'SubstanceReleased1', 'qryLUST_Data', 'Substance')
returning id;

update lust_element_db_mapping set state_table_name = 'LUST_Data_050523' where id = 60;

select distinct "Substance" from "NC_LUST"."qryLUST_Data" order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, ''' || "Substance" ||  ''', '''');'
from "NC_LUST"."LUST_Data_050523" 
where "Substance" not in
	(select state_value 
	from lust_element_value_mappings a join lust_element_db_mapping b on a.element_db_mapping_id = b.id
	where b.state = 'NC')
order by 1;


select * from "NC_LUST"."LUST_Data_050523"

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'DIESEL/VEGETABLE BLEND', 'Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'E01 - E10', 'Gasoline E-10 (E1-E10)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'E11 - E20', 'Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'GASOLINE/DIESEL/KEROSENE', 'Petroleum products');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'HEATING OIL', 'Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'OTHER ORGANICS', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'OTHER PETROLEUM PROD.', 'Petroleum products');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'WASTE Oil', 'Used oil/waste oil');


insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (60, 'ETHANOL 100%', 'Petroleum product');

delete from lust_element_value_mappings where element_db_mapping_id = 60 and state_value = 'ETHANOL 100%';

select * from substances order by 2;

select * from ust_element_value_mappings where lower(state_value) like '%ethanol%' order by state_value;
----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-03-28', 'SourceOfRelease1', 'tblSourceType1', 'TypeName')
returning id;

select * from lust_element_db_mapping order by 1 desc;

select * from "NC_LUST"."tblSourceType1" order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (62, ''' || "TypeName" ||  ''', '''', ''' || "TypeCode" || ''');'
from "NC_LUST"."tblSourceType1" 
order by 1;
	
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (62, 'Dispenser', 'Dispenser', 'A');	
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (62, 'Line', 'Piping', 'B');	
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (62, 'Spill/Overflow', 'Other', 'D');	
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (62, 'Tank', 'Tank', 'C');	
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (62, 'Unknown/Multiple', 'Unknown', 'E');	

----------------------------------------------------------------------------------------------------------------------------------

select distinct "RptCode", "RptType" from "NC_LUST"."LUST_Data_050523" order by 1;
6.171	SCSC
6.174	DR
6.174	dr
6.18	VR
6.19	LET
7.0	OTH
7.0	oth
	NFA
	pnaA
	RS
	
	
select * from "NC_LUST"."LUST_Status_mapping_from_state"  order by 1;

select "RptCode", "RptType" from "NC_LUST"."LUST_Data_050523" 
where "RptCode" is not null and "RptCode" not in (select "RptCode" from "NC_LUST"."LUST_Status_mapping_from_state")
order by 1, 2;


select * from lust_control ;

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, control_id)
values ('NC', '2023-03-28', 'LUSTStatus', 'LUST_Status_mapping_from_state', 'Rpt', 7)
returning id;

select * from lust_element_db_mapping order by 1 desc;

select * from "NC_LUST"."tblSourceType1" order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, ''' || "RptCode" ||  ''', '''|| "EPA Status" || ''');'
from "NC_LUST"."LUST_Status_mapping_from_state" 
order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.01', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.011', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.015', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.02', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.021', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.022', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.03', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.031', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.032', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.033', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.04', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.041', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.05', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.06', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.064', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.065', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.066', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.067', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.07', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.071', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.08', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.081', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.082', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.09', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.091', 'Active: site investigation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.1', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.101', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.105', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.106', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.12', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.121', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.13', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.14', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.15', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.16', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.17', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.171', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.173', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.174', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '6.19', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, '7', 'Other');



select * From information_schema.columns where table_name = 'LUST_Status_mapping_from_state'

----------------------------------------------------------------------------------------------------------------------------------
/*
a.	tblPIRF1.RCause, values are 

1 = Spill (Accidental), 
2 = UST Overfill, 
3 = Corrosion, 
4 = Physical or Mechanical Damage, 
5 = UST Installation Problem, 
6 = Other, 
7 = Unknown, 
8 = Spill (Intentional), 
9 = Equipment Failure,   stored in tblPIRF.RCause.  CauseOfRelease is alias to make match EPA Guuidelines

A)	 Use value 1 – 9 (there is one 8)  Ignore the alphas.  They may be either historical values or data entry issues.


New question (1/5/23) … we do not have a “8” in the data we received. Has the NC data been updated since we the initial 
set was provided last summer? If so, then that could explain the difference and we’d like to request the updated data set.
*/

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-03-28', 'CauseOfRelease1', 'tblPIRF1', 'RCause')
returning id;

select distinct "RCause" from "NC_LUST"."tblPIRF1" order by 1;

select distinct "RCause" from  "NC_LUST"."tblPIRF1"  order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, ''' || "RCause" ||  ''', '''', '''');'
from "NC_LUST"."qryLUST_Data" where "RCause" not in ('A','B','C','D','E')
order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, '1', 'Dispenser spill', 'Spill (Accidental)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, '2', 'Delivery overfill', 'UST Overfill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, '3', 'Corrosion', 'Corrosion');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, '4', 'Other', 'Physical or Mechanical Damage');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, '5', 'Human error', 'UST Installation Problem');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, '6', 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments) values (61, '7', 'Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments, programmer_comments) values (61, '8', 'Dispenser spill', 'Spill (Intentional)', 'State defined but not in data received');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_comments, programmer_comments) values (61, '9', 'Other', 'Equipment Failure', 'State defined but not in data received');

select * from lust_element_db_mapping order by 1 desc;

select * from lust_element_value_mappings order by 1 desc;

----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NC', '2023-03-28', 'HowReleaseDetected', 'tblRelDisc1', 'RDMethod')
returning id;

select distinct "HowReleaseDetected" from "NC_LUST"."qryLUST_Data" order by 1;

select * from "NC_LUST"."tblRelDisc1" ;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, ''' || "RDMethod" ||  ''', '''', ''' || "RDCode" ||  ''');'
from "NC_LUST"."tblRelDisc1"
order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, 'Groundwater Contamination', 'GW monitoring well', '7');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, 'Observation of Release at Occurrence', 'Inspection', '10');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, 'Other (Specify in "Description" field above)', 'Other', '9');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, 'Soil Contamination', 'Third party (well water, vapor intrusion, etc.)', '11');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, 'Surface Water Contamination', 'Third party (well water, vapor intrusion, etc.)', '8');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, 'Visual/Odor', 'Third party (well water, vapor intrusion, etc.)', '4');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, state_code) values (63, 'Water Supply Well Contamination', 'Third party (well water, vapor intrusion, etc.)', '6');

	
----------------------------------------------------------------------------------------------------------------------------------

update lust_element_db_mapping set state_join_table = 'qryLUST_Data', state_join_column = 'HowReleaseDetected' where id in (57,58,50,63);
update lust_element_db_mapping set state_join_column_fk = 'RDCode' where id in (57,58,50,63);

update lust_element_db_mapping set state_join_table = 'qryLUST_Data', state_join_column = 'Sources' where id = 62;
update lust_element_db_mapping set state_join_column_fk = 'TypeCode' where id = 62;
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

select * from information_schema.columns 
where table_schema = 'NC_LUST' and table_name not like 'v_%'
and upper(column_name) like '%RPT%'

select count(*) from  "NC_LUST"."LUST_Data_050523";
30994
select count(*) from  "NC_LUST"."qryLUST_Data";
26896
select count(*) from "NC_LUST"."tblUST_DB1" ;
43725

select * from  "NC_LUST"."LUST_Data_050523";

drop view"NC_LUST".v_lust_base;
create or replace view "NC_LUST".v_lust_base as 
select 
	a."FacilID" as "FacilityID",
	a."USTNum" as "LUSTID",
	a."IncidentName" as "SiteName",
	a."Address" as "SiteAddress",
	a."CityTown" as "SiteCity",
	a."ZipCode" as "Zipcode",
	a."State" as "State",
	4 as "EPARegion",
	a."LatDec" as "Latitude",
	a."LongDec" as "Longitude",
	ls.epa_value as "LUSTStatus", 
	a."DateReported" as "ReportedDate",
	a."CloseOut" as "NFADate", 
	mis.epa_value as "MediaImpactedSoil",
	mig.epa_value as "MediaImpactedGroundwater",
	misw.epa_value as "MediaImpactedSurfaceWater",
	sr.epa_value as "SubstanceReleased1",
	scr.epa_value as "SourceOfRelease1",
	cr.epa_value as "CauseOfRelease1",
	hrd.epa_value as "HowReleaseDetected",
	case when a."IncidentNumber" is not null and a."CloseOut" is not null and a."LURFiled" is not null then 'Yes' end as "ClosedWithContamination"
from 		  "NC_LUST"."LUST_Data_050523" a 
	left join "NC_LUST"."tblPIRF1" c on a."USTNum" = c."USTNum"
	left join "NC_LUST"."tblRelDisc1" rd1 on a."HowReleaseDetected" = rd1."RDCode"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'MediaImpactedSoil') mis on rd1."RDMethod"::varchar = mis.state_value
	left join "NC_LUST"."tblRelDisc1" rd2 on a."HowReleaseDetected" = rd2."RDCode"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'MediaImpactedGroundwater') mig on rd2."RDMethod"::varchar = mig.state_value
	left join "NC_LUST"."tblRelDisc1" rd3 on a."HowReleaseDetected" = rd3."RDCode"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'MediaImpactedSurfaceWater') misw on rd3."RDMethod"::varchar = misw.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'SubstanceReleased1') sr on b."Substance" = sr.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'CauseOfRelease1') cr on c."RCause" = cr.state_value
	left join "NC_LUST"."tblSourceType1" src on b."Sources" = src."TypeCode"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'SourceOfRelease1') scr on src."TypeName" = scr.state_value
	left join "NC_LUST"."tblRelDisc1" rd4 on b."HowReleaseDetected" = rd4."RDCode"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'HowReleaseDetected') hrd on rd4."RDMethod"::varchar = hrd.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'LUSTStatus') ls on a."RptCode"::text = ls.state_value
where a."Substance" <> 'ETHANOL 100%' and a."Comm" = 'C' and a."reg" = 'R'
order by a."FacilID", a."USTNum";

select * from v_lust_element_mapping where organization_id = 'NC' and element_name = 'LUSTStatus'

select * from lust where state = 'NC';

select * from  "NC_LUST"."tblRelDisc1" 

select count(*) 
from lust where control_id = 7 and 
	("Latitude" is null  or "Longitude" is null
    or length(split_part("Latitude"::text, '.', 2)::text) < 3
    or length(split_part("Longitude"::text, '.', 2)::text) < 3);


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

select * from "NC_LUST".v_lust where "MediaImpactedGroundwater" is not null;

select distinct 
	a."FacilID" as "FacilityID",
	b."Sources",
	src.*,
	scr.epa_value as "SourceOfRelease1"
from  "NC_LUST"."tblUST_DB1" a left join "NC_LUST"."qryLUST_Data" b on a."IncidentNumber" = b."IncidentNumber"
	left join "NC_LUST"."tblSourceType1" src on b."Sources" = src."TypeCode"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NC' and element_name = 'SourceOfRelease1') scr on src."TypeName" = scr.state_value
where b."Sources" is not null

select * from v_lust_element_mapping where state = 'NC' and element_name = 'SourceOfRelease1'


select * from "NC_LUST"."tblRelDisc1"

select count(*) from "NC_LUST"."qryLUST_Data" 
where --"HowReleaseDetected" = 11 and 
"Substance" <> 'ETHANOL 100%' 

select * from lust_element_db_mapping where state = 'NC' order by 1;

select * from "NC_LUST"."tblSourceType1"

select distinct "Sources" from "NC_LUST"."qryLUST_Data"

select distinct element_db_mapping_id, element_name, state_table_name, state_column_name, state_code, state_join_table, state_join_column 
from v_lust_element_mapping where state = 'NC' order by 1;
