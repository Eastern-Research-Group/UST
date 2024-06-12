insert into lust_control(organization_id, date_received, date_processed, data_source, comments)
values ('OR','2021-09-21','2023-07-25','SQL Server database backup file sent from state','exported required tables using Python script; redoing for OUST performance measures due to wrong LUST Status counts')
returning control_id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create view "OR_LUST".v_substance_released as 
select * from 
	(select x.*, row_number() over (partition by "LustId" order by "SubstanceReleased") rn from 
		(select a."LustId", a."AmountReleased", b."SubstanceReleased"
		from "OR_LUST"."Assessment" a left join
			(select "LustId", 'Diesel fuel (b-unknown)' as "SubstanceReleased" from "OR_LUST"."Assessment" where "DSContamInd" = True union all
			 select "LustId", 'Ethanol blend gasoline (e-unknown)' as "SubstanceReleased" from "OR_LUST"."Assessment" where "UGContamInd" = True union all
			 select "LustId", 'Gasoline (unknown type)' as "SubstanceReleased" from "OR_LUST"."Assessment" where "MGContamInd" = True union all
			 select "LustId", 'Heating/fuel oil # unknown' as "SubstanceReleased" from "OR_LUST"."Assessment" where "HOContamInd" = True union all
			 select "LustId", 'Lube/motor oil (new)' as "SubstanceReleased" from "OR_LUST"."Assessment" where "LBContamInd" = True union all
			 select "LustId", 'Other' as "SubstanceReleased" from "OR_LUST"."Assessment" where "OPContamInd" = True or "CHContamInd" = True or "MTBEContamInd" = True union all
			 select "LustId", 'Racing fuel/leaded gasoline' as "SubstanceReleased" from "OR_LUST"."Assessment" where "LGContamInd" = True union all
			 select "LustId", 'Solvent' as "SubstanceReleased" from "OR_LUST"."Assessment" where "SVContamInd" = True union all
			 select "LustId", 'Unknown' as "SubstanceReleased" from "OR_LUST"."Assessment" where "UNContamInd" = True union all
			 select "LustId", 'Used oil/waste oil' as "SubstanceReleased" from "OR_LUST"."Assessment" where "WOContamInd" = True) b on a."LustId" = b."LustId") x) y
where rn <= 5;

create view "OR_LUST".v_remediation_strategy as 
select a.*, row_number() over (partition by "LustId" order by "RemediationStrategyStartDate") rn from 
	(select "LustId", min("RemediationStrategyStartDate") as "RemediationStrategyStartDate", "RemediationStrategy" from 
		(select "LustId", wr."WorkReportedDate" as "RemediationStrategyStartDate", 
			case when wrt."WorkTypeCode" = 'GWTRT' then 'In-Situ Groundwater Remediation'
				 when wrt."WorkTypeCode" = 'SOILEX' then 'Excavation and Hauling'
				 else 'Other' end "RemediationStrategy"
		from "OR_LUST"."WorkReported" wr inner join "OR_LUST"."WorkReportedType" wrt on wr."WorkReportedTypeId" = wrt."WorkTypeId"
		where wrt."WorkTypeCode" in ('AS/VE','GWTRT','HOTG','SLMAT','SOILEX','SOILTR')) b
		group by "LustId", "RemediationStrategy") a;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (13, '2023-07-25', 'SourceOfRelease1', 'AssessmentSourceType', 'ReleaseSourceDescription', 'Assessment', 'ReleaseSourceId', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || "' || state_column_name || '" || '''''', '''''''');''
from "OR_LUST"."' || state_table_name || '" order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, ''' || "ReleaseSourceDescription" || ''', '''');'
from "OR_LUST"."AssessmentSourceType" order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Delivery Problem', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Dispenser', 'Dispenser');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Not Reported', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Other', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Piping', 'Piping');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Tank', 'Tank');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Turbine Pump', 'Submersible turbine pump');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (13, '2023-07-25', 'CauseOfRelease1', 'AssessmentReleaseType', 'ReleaseCauseDescription', 'Assessment', 'ReleaseCauseCode', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || "' || state_column_name || '" || '''''', '''''''');''
from "OR_LUST"."' || state_table_name || '" order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, ''' || "ReleaseCauseDescription" || ''', '''');'
from "OR_LUST"."AssessmentReleaseType" order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'CORROSION', 'Tank corrosion');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'INSTALLATION PROBLEM', 'Human error');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'NOT REPORTED', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'OTHER', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'OVERFILL', 'Overfill (general)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'PHYSICAL/MECH DAMAGE', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'SPILL', 'Dispenser spill');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'UNKNOWN', 'Unknown');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values (13, '2023-07-25', 'HowReleaseDetected', 'AssessmentDiscoveryType', 'DiscoveryDescription', 'Assessment', 'DiscoveryCode', null)
returning 'select distinct 
''insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''''' || "' || state_column_name || '" || '''''', '''''''');''
from "OR_LUST"."' || state_table_name || '" order by 1;' as vsql;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, ''' || "DiscoveryDescription" || ''', '''');'
from "OR_LUST"."AssessmentDiscoveryType" order by 1;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'COMPLAINT', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'DECOMMISSIONING', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'LEAK DETECTION', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'OTHER', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'ROUTINE MONITORING', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'SITE ASSESSMENT', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'TIGHTNESS TEST', 'Other');


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * from "OR_LUST"."AssessmentDiscoveryType";


select "LustId", count(*) from (select distinct "LustId", "DiscoveryCode" from  "OR_LUST"."Assessment") a group by "LustId"  having count(*) > 1;

select 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

drop view "OR_LUST".v_lust_base;
create or replace view "OR_LUST".v_lust_base as 
select distinct 
	i."FacilityId"::text as "FacilityID", 
	i."LustId"::text as "LUSTID",
	case when i."RegulatedTankInd" = True then 'Yes' when i."RegulatedTankInd" = False then 'No' end as "FederallyReportableRelease", 
	i."SiteName",
	i."SiteAddress", 
	i."SiteCity", 
	i."SiteZip" as "Zipcode", 
	'OR' as "State", 
	10 as "EPARegion",
	case when m."ClosedDate" is null then 'Active: general' else 'No further action' end as "LUSTStatus",	
	i."ReceivedDate"::date as "ReportedDate",
	m."ClosedDate"::date as "NFADate",
	case when a."SLMediaInd" = True then 'Yes' when a."SLMediaInd" = False then 'No' end as "MediaImpactedSoil",
	case when a."GWMediaInd" = True then 'Yes' when a."GWMediaInd" = False then 'No' end as "MediaImpactedGroundwater",
	case when a."SWMediaInd" = True then 'Yes' when a."SWMediaInd" = False then 'No' end as "MediaImpactedSurfaceWater",
	(select "SubstanceReleased" from "OR_LUST".v_substance_released sr where rn = 1 and sr."LustId" = i."LustId") as "SubstanceReleased1",
	(select "AmountReleased" from "OR_LUST".v_substance_released sr where rn = 1 and sr."LustId" = i."LustId") as "QuantityReleased1",	
	'gallons' as "Unit1",
	(select "SubstanceReleased" from "OR_LUST".v_substance_released sr where rn = 2 and sr."LustId" = i."LustId") as "SubstanceReleased2",
	(select "AmountReleased" from "OR_LUST".v_substance_released sr where rn = 2 and sr."LustId" = i."LustId") as "QuantityReleased2",	
	'gallons' as "Unit2",
	(select "SubstanceReleased" from "OR_LUST".v_substance_released sr where rn = 3 and sr."LustId" = i."LustId") as "SubstanceReleased3",
	(select "AmountReleased" from "OR_LUST".v_substance_released sr where rn = 3 and sr."LustId" = i."LustId") as "QuantityReleased3",	
	'gallons' as "Unit3",
	(select "SubstanceReleased" from "OR_LUST".v_substance_released sr where rn = 4 and sr."LustId" = i."LustId") as "SubstanceReleased4",
	(select "AmountReleased" from "OR_LUST".v_substance_released sr where rn = 4 and sr."LustId" = i."LustId") as "QuantityReleased4",	
	'gallons' as "Unit4",
	(select "SubstanceReleased" from "OR_LUST".v_substance_released sr where rn = 5 and sr."LustId" = i."LustId") as "SubstanceReleased5",
	(select "AmountReleased" from "OR_LUST".v_substance_released sr where rn = 5 and sr."LustId" = i."LustId") as "QuantityReleased5",	
	'gallons' as "Unit5",
	sr.epa_value as "SourceOfRelease1",
	cr.epa_value as	"CauseOfRelease1",
	hrd.epa_value as "HowReleaseDetected",
	(select "RemediationStrategy" from "OR_LUST".v_remediation_strategy rs where rn = 1 and rs."LustId" = i."LustId") as "RemediationStrategy1",
	(select "RemediationStrategyStartDate"::date from "OR_LUST".v_remediation_strategy rs where rn = 1 and rs."LustId" = i."LustId") as "RemediationStrategyStartDate1",
	(select "RemediationStrategy" from "OR_LUST".v_remediation_strategy rs where rn = 2 and rs."LustId" = i."LustId") as "RemediationStrategy2",
	(select "RemediationStrategyStartDate"::date from "OR_LUST".v_remediation_strategy rs where rn = 2 and rs."LustId" = i."LustId") as "RemediationStrategyStartDate2",
	(select "RemediationStrategy" from "OR_LUST".v_remediation_strategy rs where rn = 3 and rs."LustId" = i."LustId") as "RemediationStrategy3",
	(select "RemediationStrategyStartDate"::date from "OR_LUST".v_remediation_strategy rs where rn = 3 and rs."LustId" = i."LustId") as "RemediationStrategyStartDate3",
	case when i."SiteTypeCode" in ('RBCA','GW','POCKET') then 'Yes' end as "ClosedWithContamination"
from "OR_LUST"."Incident" i left join "OR_LUST"."Management" m on i."LustId" = m."LustId"
	left join "OR_LUST"."Assessment" a on i."LustId" = a."LustId"
	left join (select state_value epa_value, "ReleaseSourceId" from v_lust_element_mapping a join "OR_LUST"."AssessmentSourceType" b on a.state_value = b."ReleaseSourceDescription"
	           where control_id = 13 and element_name = 'SourceOfRelease1') sr on sr."ReleaseSourceId" = a."ReleaseSourceId"
	left join (select state_value epa_value, "ReleaseCauseCode" from v_lust_element_mapping a join "OR_LUST"."AssessmentReleaseType" b on a.state_value = b."ReleaseCauseDescription"
	           where control_id = 13 and element_name = 'CauseOfRelease1') cr on cr."ReleaseCauseCode" = a."ReleaseCauseCode"
	left join (select state_value epa_value, "DiscoveryCode" from v_lust_element_mapping a join "OR_LUST"."AssessmentDiscoveryType" b on a.state_value = b."DiscoveryDescription"
	           where control_id = 13 and element_name = 'HowReleaseDetected') hrd on hrd."DiscoveryCode" = a."DiscoveryCode"	           
where i."FacilityId" is not null
--and coalesce(i."GeoLocId",0) <> 0 
;


select * into "OR_LUST".lust_base 
from "OR_LUST".v_lust_base;

create unique index lustid on "OR_LUST".lust_base("LUSTID");

select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0;


create index "Incident_lustid" on "OR_LUST"."Incident"("LustId");
create index "Management_lustid" on "OR_LUST"."Management"("LustId");
create index "Assessment_lustid" on "OR_LUST"."Assessment"("LustId");

select count(*) from (
select distinct 
	i."FacilityId"::text as "FacilityID", 
	i."LustId"::text as "LUSTID",
	(select "SubstanceReleased" from "OR_LUST".v_substance_released sr where rn = 1 and sr."LustId" = i."LustId") as "SubstanceReleased1",
	(select "RemediationStrategy" from "OR_LUST".v_remediation_strategy rs where rn = 1 and rs."LustId" = i."LustId") as "RemediationStrategy1",
	(select "RemediationStrategyStartDate"::date from "OR_LUST".v_remediation_strategy rs where rn = 1 and rs."LustId" = i."LustId") as "RemediationStrategyStartDate1"	
from "OR_LUST"."Incident" i left join "OR_LUST"."Management" m on i."LustId" = m."LustId"
	left join "OR_LUST"."Assessment" a on i."LustId" = a."LustId"
	left join (select state_value epa_value, "ReleaseSourceId" from v_lust_element_mapping a join "OR_LUST"."AssessmentSourceType" b on a.state_value = b."ReleaseSourceDescription"
	           where control_id = 13 and element_name = 'SourceOfRelease1') sr on sr."ReleaseSourceId" = a."ReleaseSourceId"
	left join (select state_value epa_value, "ReleaseCauseCode" from v_lust_element_mapping a join "OR_LUST"."AssessmentReleaseType" b on a.state_value = b."ReleaseCauseDescription"
	           where control_id = 13 and element_name = 'CauseOfRelease1') cr on cr."ReleaseCauseCode" = a."ReleaseCauseCode"
	left join (select state_value epa_value, "DiscoveryCode" from v_lust_element_mapping a join "OR_LUST"."AssessmentDiscoveryType" b on a.state_value = b."DiscoveryDescription"
	           where control_id = 13 and element_name = 'HowReleaseDetected') hrd on hrd."DiscoveryCode" = a."DiscoveryCode"	           
where i."FacilityId" is not null
) a;


select count(*) from  "OR_LUST".v_remediation_strategy 

select distinct element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk, element_db_mapping_id
from v_lust_element_mapping 
where control_id = 13
order by element_db_mapping_id;


insert into lust_locations("control_id",
"organization_id",
"LUSTID",
"SiteName",
"SiteAddress",
"SiteCity",
"Zipcode",
"State")
select distinct 13, 'OR', "LUSTID",
"SiteName",
"SiteAddress",
"SiteCity",
"Zipcode",
"State" from "OR_LUST".v_lust_base;

select * from lust_locations where control_id = 13;















select count(*) from "OR_LUST".Incident i
where i.RegulatedTankInd = 1
and isnull(i.GeoLocId,0) <> 0;
53451
8125
49998
8077


select count(*) from "OR_LUST".Incident i where FacilityId is not null;
46099
7352

select * from "OR_LUST".Incident i

select * from "OR_LUST".FileStatusType;
1	CRT		Certification
3	ADMCLO	Administrative Closure
4	NFA		No Further Action

select FileStatusCode, ActiveReleaseInd, count(*)
from  "OR_LUST".Incident i
group by FileStatusCode, ActiveReleaseInd 
order by 1, 2;



select i.LogNumber, i.LustID, i.FacilityId, i.SiteName, i.SiteAddress, i.SiteCity, i.SiteZip,
	i.ActiveReleaseInd, i.FileStatusCode, i.SiteTypeCode, i.GeolocId, m.*
from "OR_LUST".Incident i
	left join "OR_LUST".Management m on i.LustId = m.LustId
where i.RegulatedTankInd = 1
and i.LogNumber in ('10-02-0003','26-22-0099','26-22-0780','24-19-0902','20-10-1168')
order by SiteName;

select * from  "OR_LUST".Incident i where LogNbrYear>= 21 and LogNbrYear < 30;


select * from "OR_LUST".IncidentWithoutGeoLocIDs20110519 where LogNumber = '26-22-0099';

select * from "OR_LUST".LustGeoLocIDCorrections  where LogNumber = '26-22-0099';

select count(*) from temp_active;
842


select count(*) from temp_active where LogNumber like '%-22-%';
42

select i.LogNumber, i.LustID, i.FacilityId, i.SiteName, i.SiteAddress, i.SiteCity, i.SiteZip,
	i.ActiveReleaseInd, i.FileStatusCode, i.SiteTypeCode, i.GeolocId, m.*
from temp_active t 
	join "OR_LUST".Incident i on t.LogNumber = i.LogNumber
	join "OR_LUST".Management m on i.LustId = m.LustId
where i.RegulatedTankInd = 1
order by i.SiteName;



select * from LUST.INFORMATION_SCHEMA.COLUMNS where lower(column_name) like '%date%'
and column_name not like 'LastChange%' and column_name not like 'Update%'
order by table_name, column_name;

select * from LUST.INFORMATION_SCHEMA.COLUMNS where column_name = 'LogNumber';

select * from "OR_LUST".WorkReported;

select * from "OR_LUST".WorkReportedType;

select * from "OR_LUST".AssessmentConfirmationType;
1	SI	STAFF SITE INSPECTION
2	LD	LAB SAMPLE - DEQ
3	LR	LAB SAMPLE - RP
4	LO	LAB SAMPLE - OTHER
5	RR	RP REPORT
6	OT	OTHER
7	CN	CONTRACTOR RPT

select * from "OR_LUST".AssessmentReleaseType;
3	OF	OVERFILL
4	SS	SPILL
6	OT	OTHER
7	UN	UNKNOWN
8	NR	NOT REPORTED
9	CR	CORROSION
10	IP	INSTALLATION PROBLEM
12	PM	PHYSICAL/MECH DAMAGE


select * from "OR_LUST".AssessmentSourceType;
1	Tank
2	Piping
3	Dispenser
4	Turbine Pump
5	Delivery Problem
6	Other
7	Not Reported

select * from "OR_LUST".Assessment;

select i.FacilityId as FacilityID, 
	i.LustId as LUSTID,
	case when i.RegulatedTankInd = 1 then 'Yes' when i.RegulatedTankInd = 0 then 'No' end as FederallyReportableRelease, 
	i.SiteName,
	i.SiteAddress, 
	i.SiteCity, 
	i.SiteZip as Zipcode, 
	'OR' as State, 
	'10' as EPARegion,
	case when i.ActiveReleaseInd = 1 then 'Active' end as LUSTStatus,
	i.ReceivedDate as ReportedDate,
	m.ClosedDate as NFADate,
	case when a.SLMediaInd = 1 then 'Yes' when a.SLMediaInd = 0 then 'No' end as MediaImpactedSoil,
	case when a.GWMediaInd = 1 then 'Yes' when a.GWMediaInd = 0 then 'No' end as MediaImpactedGroundwater,
	case when a.SWMediaInd = 1 then 'Yes' when a.SWMediaInd = 0 then 'No' end as MediaImpactedSurfaceWater,
	sr.SubstanceReleased1,
	sr.QuantityReleased as QuantityReleased1,
	'gallons' as Unit1,
	sr.SubstanceReleased2,
	sr.SubstanceReleased3,
	sr.SubstanceReleased4,
	sr.SubstanceReleased5,
	case when ast.ReleaseSourceDescription = 'Turbine Pumps' or ast.ReleaseSourceDescription = 'Delivery Problem' then 'Other'
	     when ast.ReleaseSourceDescription = 'Not Reported' then 'Unknown' 
		 else ast.ReleaseSourceDescription end as SourceOfRelease1,
	case when art.ReleaseCauseDescription = 'SPILL' then 'Spill Bucket Failure' 
		 when art.ReleaseCauseDescription = 'OTHER' then 'Other'
		 when art.ReleaseCauseDescription in ('UNKNOWN','NOT REPORTED') then 'Unknown'
		 when art.ReleaseCauseDescription is not null then 'Other' end as CauseOfRelease1,
	case when adt.DiscoveryDescription = 'TIGHTNESS TEST' then 'Tank tightness testing'
	     when adt.DiscoveryDescription = 'OTHER' then 'Other'
		 when adt.DiscoveryDescription = 'SITE ASSESSMENT' then 'Inspection'
		 when adt.DiscoveryDescription is not null then 'Other' end as HowReleaseDetected,
	rem1.RemediationStrategy1,
	rem1.RemediationStrategyStartDate1,
	rem2.RemediationStrategy2,
	rem2.RemediationStrategyStartDate2,
	rem3.RemediationStrategy3,
	rem3.RemediationStrategyStartDate3,
	case when i.SiteTypeCode in ('RBCA','GW','POCKET') then 'Yes' end as ClosedWithContamination
from "OR_LUST".Incident i left outer join "OR_LUST".Management m on i.LustId = m.LustId
	left outer join "OR_LUST".Assessment a on i.LustId = a.LustId
	left outer join "OR_LUST".AssessmentSourceType ast on a.ReleaseSourceId = ast.ReleaseSourceId
	left outer join "OR_LUST".AssessmentReleaseType art on a.ReleaseCauseId = art.ReleaseCauseId
	left outer join "OR_LUST".AssessmentDiscoveryType adt on a.DiscoveryId = adt.DiscoveryId
	left outer join 
		(select LustId, RemediationStrategy as RemediationStrategy1, RemediationStrategyStartDate as RemediationStrategyStartDate1 from 
			(select a.*, row_number() over (partition by LustId order by RemediationStrategyStartDate) rn from 
				(select LustId, min(RemediationStrategyStartDate) as RemediationStrategyStartDate, RemediationStrategy from 
					(select LustId, wr.WorkReportedDate as RemediationStrategyStartDate, 
						case when wrt.WorkTypeCode = 'GWTRT' then 'In-Situ Groundwater Remediation'
							 when wrt.WorkTypeCode = 'SOILEX' then 'Excavation and Hauling'
							 else 'Other' end RemediationStrategy
					from "OR_LUST".WorkReported wr inner join "OR_LUST".WorkReportedType wrt on wr.WorkReportedTypeId = wrt.WorkTypeId
					where wrt.WorkTypeCode in ('AS/VE','GWTRT','HOTG','SLMAT','SOILEX','SOILTR')) b
					group by LustId, RemediationStrategy) a) b
			where rn = 1) rem1 on i.LustId = rem1.LustId
	left outer join 
		(select LustId, RemediationStrategy as RemediationStrategy2, RemediationStrategyStartDate as RemediationStrategyStartDate2 from 
			(select a.*, row_number() over (partition by LustId order by RemediationStrategyStartDate) rn from 
				(select LustId, min(RemediationStrategyStartDate) as RemediationStrategyStartDate, RemediationStrategy from 
					(select LustId, wr.WorkReportedDate as RemediationStrategyStartDate, 
						case when wrt.WorkTypeCode = 'GWTRT' then 'In-Situ Groundwater Remediation'
							 when wrt.WorkTypeCode = 'SOILEX' then 'Excavation and Hauling'
							 else 'Other' end RemediationStrategy
					from "OR_LUST".WorkReported wr inner join "OR_LUST".WorkReportedType wrt on wr.WorkReportedTypeId = wrt.WorkTypeId
					where wrt.WorkTypeCode in ('AS/VE','GWTRT','HOTG','SLMAT','SOILEX','SOILTR')) b
					group by LustId, RemediationStrategy) a) b
			where rn = 2) rem2 on i.LustId = rem2.LustId
	left outer join 
	(select LustId, RemediationStrategy as RemediationStrategy3, RemediationStrategyStartDate as RemediationStrategyStartDate3 from 
			(select a.*, row_number() over (partition by LustId order by RemediationStrategyStartDate) rn from 
				(select LustId, min(RemediationStrategyStartDate) as RemediationStrategyStartDate, RemediationStrategy from 
					(select LustId, wr.WorkReportedDate as RemediationStrategyStartDate, 
						case when wrt.WorkTypeCode = 'GWTRT' then 'In-situ groundwater Rremediation'
							 when wrt.WorkTypeCode = 'SOILEX' then 'Excavation and hauling'
							 else 'Other' end RemediationStrategy
					from "OR_LUST".WorkReported wr inner join "OR_LUST".WorkReportedType wrt on wr.WorkReportedTypeId = wrt.WorkTypeId
					where wrt.WorkTypeCode in ('AS/VE','GWTRT','HOTG','SLMAT','SOILEX','SOILTR')) b
					group by LustId, RemediationStrategy) a) b
			where rn = 3) rem3 on i.LustId = rem3.LustId
	left outer join
	(select LustId, AmountReleased as QuantityReleased, 
	        [1] as SubstanceReleased1, [2] as SubstanceReleased2, [3] as SubstanceReleased3, [4] as SubstanceReleased4, [5] as SubstanceReleased5 
	from
		(select * from 
			(select x.*, row_number() over (partition by LustId order by SubstanceReleased) rn from 
				(select a.LustId, a.AmountReleased, b.SubstanceReleased
				from "OR_LUST".Assessment a left join
					(select LustId, 'Diesel fuel (b-unknown)' as SubstanceReleased from "OR_LUST".Assessment where DSContamInd = 1 union all
					 select LustId, 'Ethanol blend gasoline (e-unknown)' as SubstanceReleased from "OR_LUST".Assessment where UGContamInd = 1 union all
					 select LustId, 'Gasoline (unknown type)' as SubstanceReleased from "OR_LUST".Assessment where MGContamInd = 1 union all
					 select LustId, 'Heating/fuel oil # unknown' as SubstanceReleased from "OR_LUST".Assessment where HOContamInd = 1 union all
					 select LustId, 'Lube/motor oil (new)' as SubstanceReleased from "OR_LUST".Assessment where LBContamInd = 1 union all
					 select LustId, 'Other' as SubstanceReleased from "OR_LUST".Assessment where OPContamInd = 1 or CHContamInd = 1 or MTBEContamInd = 1 union all
					 select LustId, 'Racing fuel/leaded gasoline' as SubstanceReleased from "OR_LUST".Assessment where LGContamInd = 1 union all
					 select LustId, 'Solvent' as SubstanceReleased from "OR_LUST".Assessment where SVContamInd = 1 union all
					 select LustId, 'Unknown' as SubstanceReleased from "OR_LUST".Assessment where UNContamInd = 1 union all
					 select LustId, 'Used oil/waste oil' as SubstanceReleased from "OR_LUST".Assessment where WOContamInd = 1) b on a.LustId = b.LustId) x) y
		where rn <= 5) z
	pivot 
		(max(SubstanceReleased) for rn in ([1], [2], [3], [4], [5])) as pvt) sr on i.LustId = sr.LustId
where isnull(i.GeoLocId,0) <> 0 and i.FacilityId is not null
order by FacilityId, LustId;

