----------------------------------------------------------------------------------------------------------------------------------

--corrective action mapping approved by Alex 4/12/2023
	
Capping					 													= Capping
Dual Phase Extraction 														= Dual/multi-phase extraction
Ex Situ Biological Treatment 												= Excavation and hauling or treatment
Ex Situ Physical/Chemical Treatment (other than P&T, SVE, or Excavation)  	= Excavation and hauling or treatment
Ex Situ Thermal Treatment													= Excavation and hauling or treatment
Excavation						 											= Excavation and hauling or treatment
Free Product Removal 														= Excavation and hauling or treatment
In Situ Biological Treatment      											= Natural source zone depletion
In Situ Physical/Chemical Treatment (other than SVE)						= In-situ groundwater remediation
In Situ Thermal Treatment													= Other
Monitored Natural Attenuation     											= Monitored natural attenuation
Other (Use Description Field)												= Other
Permeable Reactive Barrier													= Sub sealing/sub slab barrier
Pump & Treat (P&T) Groundwater 												= Pump and treat
Soil Vapor Extraction (SVE) 												= Soil vapor extraction (SVE)
	

select * from corrective_action_strategy order by 1;

update corrective_action_strategy set remediation_strategy = 'Dual/multi-phase extraction ' where remediation_strategy  = 'Duel/Multi-phase extraction '

update corrective_action_strategy set remediation_strategy = trim(remediation_strategy)

alter table corrective_action_strategy rename remediation_strategy to corrective_action_strategy;

select * from lust_element_value_mappings;

select * from lust_element_db_mapping;

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column)
values ('CA', '2023-04-12', 'CorrectiveActionStrategy1', 'v_corrective_actions', 'ACTION', 'regulatory_activities', 'ACTION')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column)
values ('CA', '2023-04-12', 'CorrectiveActionStrategy2', 'v_corrective_actions', 'ACTION', 'regulatory_activities', 'ACTION')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column)
values ('CA', '2023-04-12', 'CorrectiveActionStrategy3', 'v_corrective_actions', 'ACTION', 'regulatory_activities', 'ACTION')
returning id;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, ''' || "ACTION" ||  ''', '''', ''Y'');'
from "CA_LUST".v_corrective_actions
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Capping', 'Capping', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Dual Phase Extraction', 'Dual/multi-phase extraction', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Ex Situ Biological Treatment', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Ex Situ Physical/Chemical Treatment (other than P&T, SVE, or Excavation)', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Ex Situ Thermal Treatment', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Excavation', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Free Product Removal', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'In Situ Biological Treatment', 'Natural source zone depletion', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'In Situ Physical/Chemical Treatment (other than SVE)', 'In-situ groundwater remediation', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'In Situ Thermal Treatment', 'Other', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Monitored Natural Attenuation', 'Monitored natural attenuation', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Other (Use Description Field)', 'Other', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Permeable Reactive Barrier', 'Sub sealing/sub slab barrier', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Pump & Treat (P&T) Groundwater', 'Pump and treat', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (70, 'Soil Vapor Extraction (SVE)', 'Soil vapor extraction (SVE)', 'Y');

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Capping', 'Capping', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Dual Phase Extraction', 'Dual/multi-phase extraction', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Ex Situ Biological Treatment', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Ex Situ Physical/Chemical Treatment (other than P&T, SVE, or Excavation)', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Ex Situ Thermal Treatment', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Excavation', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Free Product Removal', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'In Situ Biological Treatment', 'Natural source zone depletion', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'In Situ Physical/Chemical Treatment (other than SVE)', 'In-situ groundwater remediation', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'In Situ Thermal Treatment', 'Other', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Monitored Natural Attenuation', 'Monitored natural attenuation', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Other (Use Description Field)', 'Other', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Permeable Reactive Barrier', 'Sub sealing/sub slab barrier', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Pump & Treat (P&T) Groundwater', 'Pump and treat', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (71, 'Soil Vapor Extraction (SVE)', 'Soil vapor extraction (SVE)', 'Y');

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Capping', 'Capping', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Dual Phase Extraction', 'Dual/multi-phase extraction', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Ex Situ Biological Treatment', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Ex Situ Physical/Chemical Treatment (other than P&T, SVE, or Excavation)', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Ex Situ Thermal Treatment', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Excavation', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Free Product Removal', 'Excavation and hauling or treatment', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'In Situ Biological Treatment', 'Natural source zone depletion', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'In Situ Physical/Chemical Treatment (other than SVE)', 'In-situ groundwater remediation', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'In Situ Thermal Treatment', 'Other', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Monitored Natural Attenuation', 'Monitored natural attenuation', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Other (Use Description Field)', 'Other', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Permeable Reactive Barrier', 'Sub sealing/sub slab barrier', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Pump & Treat (P&T) Groundwater', 'Pump and treat', 'Y');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (72, 'Soil Vapor Extraction (SVE)', 'Soil vapor extraction (SVE)', 'Y');



select distinct "ACTION_TYPE" from "CA_LUST".regulatory_activities

select distinct "ACTION" from "CA_LUST".regulatory_activities where "ACTION_TYPE" = 'REMEDIATION' order by 1;

select * from "CA_LUST".regulatory_activities where "ACTION_TYPE" = 'REMEDIATION'


select s."GLOBAL_ID", count(*) 
from "CA_LUST".sites s 
	left join 
		(select distinct "GLOBAL_ID", "ACTION" 
		from "CA_LUST".regulatory_activities
		where "ACTION_TYPE" = 'REMEDIATION') r on s."GLOBAL_ID" = r."GLOBAL_ID"
group by s."GLOBAL_ID"
order by 2 desc;

select * 
from "CA_LUST".regulatory_activities
where "GLOBAL_ID" = 'T0608100030' and "ACTION_TYPE" = 'REMEDIATION'
order by "DATE" desc;


select "GLOBAL_ID", "ACTION",  max("DATE") as "DATE"
from "CA_LUST".regulatory_activities
where "ACTION_TYPE" = 'REMEDIATION' and "ACTION" is not null
group by "GLOBAL_ID", "ACTION";

drop view "CA_LUST".v_corrective_actions;
create or replace view "CA_LUST".v_corrective_actions as
select r, "GLOBAL_ID", "ACTION", "DATE"
from 
	(select row_number() over (partition by "GLOBAL_ID" order by "DATE" desc) as r, c.*
		 from (select "GLOBAL_ID", "ACTION",  max("DATE") as "DATE"
				from "CA_LUST".regulatory_activities
				where "ACTION_TYPE" = 'REMEDIATION' and "ACTION" is not null
				group by "GLOBAL_ID", "ACTION") c) x
where x.r <= 3
order by "GLOBAL_ID", "DATE" desc;	


----------------------------------------------------------------------------------------------------------------------------------

select * from "CA_LUST".substances_deagg order by "GLOBAL_ID", epa_value;

create view "CA_LUST".v_substances as 
select r, "GLOBAL_ID", epa_value
from (select row_number() over (partition by "GLOBAL_ID" order by epa_value) as r, s.*
      from  (select distinct "GLOBAL_ID", epa_value from "CA_LUST".substances_deagg) s) x 
where x.r <= 5
order by  "GLOBAL_ID", epa_value;

create view "CA_LUST".v_sources as 
select r, "GLOBAL_ID", epa_value
from (select row_number() over (partition by "GLOBAL_ID" order by epa_value) as r, s.*
      from  (select distinct "GLOBAL_ID", epa_value from "CA_LUST".sources_deagg) s) x 
where x.r <= 3
order by  "GLOBAL_ID", epa_value;


create view "CA_LUST".v_causes as 
select r, "GLOBAL_ID", epa_value
from (select row_number() over (partition by "GLOBAL_ID" order by epa_value) as r, s.*
      from  (select distinct "GLOBAL_ID", epa_value from "CA_LUST".causes_deagg) s) x 
where x.r <= 3
order by  "GLOBAL_ID", epa_value;



select distinct "GLOBAL_ID", "POTENTIAL_CONTAMINANTS_OF_CONCERN" , epa_value from  "CA_LUST".substances_deagg order by "GLOBAL_ID", epa_value;

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



select * from "CA_LUST".seq_lustid;

select "STATE" || '_' || "BUSINESS_NAME" || '_' || nextval('"CA_LUST".seq_lustid')
from "CA_LUST".sites s 
where "RB_CASE_NUMBER" is null 


drop view "CA_LUST".v_lust_base;

drop view "CA_LUST".v_lust;


select distinct t.table_schema, t.table_name, 
	pg_get_viewdef('"' || upper(t.table_schema) || '".' || t.table_name, true)
from information_schema.columns c 
	join information_schema.tables t 
		on c.table_schema = t.table_schema and c.table_name = t.table_name 
where t.table_type = 'VIEW' and c.column_name like 'SourceO%'
and pg_get_viewdef(t.table_schema || '.' || t.table_name, true) ilike '%Table_xxx%';
order by 1, 2, 3;

drop view "AL_LUST"."v_lust_geocode";
drop view "SD_LUST"."v_lust_geocode";


alter table lust alter column "SourceOfRelease1" type varchar(25);
alter table lust alter column "SourceOfRelease2" type varchar(25);
alter table lust alter column "SourceOfRelease3" type varchar(25);

select * from information_schema.tables

drop view "CA_LUST".v_lust_base;
drop view "CA_LUST".v_lust;
drop sequence  "CA_LUST".seq_lustid;
create sequence "CA_LUST".seq_lustid;


create or replace view "CA_LUST".v_lust_base as 
select distinct 
	s."GLOBAL_ID" as "FacilityID",
	case when s."RB_CASE_NUMBER"  is not null then s."RB_CASE_NUMBER" 
	     else replace("STATE" || '_' || substring("BUSINESS_NAME",1,40) || '_' || nextval('"CA_LUST".seq_lustid'),'__','_')
	     end as "LUSTID",
	s."BUSINESS_NAME" as "SiteName",
	s."STREET_NUMBER" || ' ' || s."STREET_NAME" as "SiteAddress",
	s."CITY" as "SiteCity",
	s."ZIP" as "Zipcode",
	s."COUNTY" as "County",
	s."STATE" as "State",
	s."EPA_REGION" as "EPARegion",
	s."LATITUDE" as "Latitude",
	s."LONGITUDE" as "Longitude",
   	coord.epa_value as "CoordinateSource",
	status.epa_value as "LUSTStatus",
	"LEAK_REPORTED_DATE" as "ReportedDate",
	"NO_FURTHER_ACTION_DATE" as "NFADate",
	mis.epa_value as "MediaImpactedSoil",
	mig.epa_value as "MediaImpactedGroundwater",
	misw.epa_value as "MediaImpactedSurfaceWater",
	s1.epa_value as "SubstanceReleased1", --column is "potential contaminants of concern", not "substance released"; no order assigned to this comma-separated field; non-related contaminants included as well
	s."QUANTITY_RELEASED_GALLONS" as "QuantityReleased1", --unable to determine quantity when multiple "potential contaminants of concern"
	case when s."QUANTITY_RELEASED_GALLONS" is not null then 'Gallons' end as "Unit1",
	s2.epa_value as "SubstanceReleased2",
	s3.epa_value as "SubstanceReleased3",
	s4.epa_value as "SubstanceReleased4",
	s5.epa_value as "SubstanceReleased5",
	sr1.epa_value as "SourceOfRelease1",
	c1.epa_value as "CauseOfRelease1",
	sr2.epa_value as "SourceOfRelease2",
	c2.epa_value as "CauseOfRelease2",
	sr3.epa_value as "SourceOfRelease3",
	c3.epa_value as "CauseOfRelease3",
	cas1.epa_value as "CorrectiveActionStrategy1",
	vca1."DATE" as "CorrectiveActionStrategy1StartDate",
	cas2.epa_value as "CorrectiveActionStrategy2",
	vca2."DATE" as "CorrectiveActionStrategy2StartDate",
	cas3.epa_value as "CorrectiveActionStrategy3",
	vca3."DATE" as "CorrectiveActionStrategy3StartDate"
from "CA_LUST".sites s 
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'LUSTStatus') status on s."STATUS" = status.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'CoordinateSource') coord on s."COORDINATE_SOURCE" = coord.state_value
	left join (select * from "CA_LUST".v_substances where r = 1) s1 on s."GLOBAL_ID" = s1."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_substances where r = 2) s2 on s."GLOBAL_ID" = s2."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_substances where r = 3) s3 on s."GLOBAL_ID" = s3."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_substances where r = 4) s4 on s."GLOBAL_ID" = s4."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_substances where r = 5) s5 on s."GLOBAL_ID" = s5."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_sources where r = 1) sr1 on s."GLOBAL_ID" = sr1."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_sources where r = 2) sr2 on s."GLOBAL_ID" = sr2."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_sources where r = 3) sr3 on s."GLOBAL_ID" = sr3."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_causes where r = 1) c1 on s."GLOBAL_ID" = c1."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_causes where r = 2) c2 on s."GLOBAL_ID" = c2."GLOBAL_ID" 
	left join (select * from "CA_LUST".v_causes where r = 3) c3 on s."GLOBAL_ID" = c3."GLOBAL_ID" 
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'MediaImpactedSoil') mis on s."POTENTIAL_MEDIA_OF_CONCERN" = mis.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'MediaImpactedGroundwater') mig on s."POTENTIAL_MEDIA_OF_CONCERN" = mig.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'MediaImpactedSurfaceWater') misw on s."POTENTIAL_MEDIA_OF_CONCERN" = misw.state_value
	left join (select * from "CA_LUST".v_corrective_actions where r = 1) vca1 on s."GLOBAL_ID" = vca1."GLOBAL_ID" 
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'CorrectiveActionStrategy1') cas1 on vca1."ACTION" = cas1.state_value
	left join (select * from "CA_LUST".v_corrective_actions where r = 2) vca2 on s."GLOBAL_ID" = vca2."GLOBAL_ID" 
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'CorrectiveActionStrategy2') cas2 on vca2."ACTION" = cas2.state_value
	left join (select * from "CA_LUST".v_corrective_actions where r = 3) vca3 on s."GLOBAL_ID" = vca3."GLOBAL_ID" 
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'CorrectiveActionStrategy3') cas3 on vca3."ACTION" = cas3.state_value
where "CASE_TYPE" in ('LUST Cleanup Site','Military UST Site')
order by 1, 2;

select * from "CA_LUST".v_lust where length("LUSTID") > 50;

select * from "CA_LUST".v_lust_base where "SiteName" like 'CALAVERAS COUNTY-WHITE PINES ROAD MAINTENA%'

alter table lust alter column "SourceOfRelease1" type varchar(25);

select length('CA_CALAVERAS COUNTY-WHITE PINES ROAD MAINTENA_15230')

select * from "CA_LUST".v_lust_base where "LUSTID" like 'CA_%' order by "FacilityID"

select count(*)
from  "CA_LUST".sites s 
where "CASE_TYPE" in ('LUST Cleanup Site','Military UST Site') 
  and "RB_CASE_NUMBER" is null 
order by 1, 2;

select * from "CA_LUST".v_lust_base where "LUSTID" is null order by "SiteName";

select "FacilityID", "SiteName", "SiteAddress", "ColumnUsed", "State" || '_' || "SiteID" || '_' as col_prefix
from 
	(select "State", 
		case when "SiteName" is not null then 'SiteName' else 'FacilityID' end as "ColumnUsed",
		"FacilityID", "SiteName", "SiteAddress",
		case when "SiteName" is null then "FacilityID" else "SiteName" end as "SiteID"
	from "CA_LUST".v_lust_base where "LUSTID" is null) x
order by  1, 2, 3;

select row_number() over (), "SiteName",  "LUSTID" 
from "CA_LUST".v_lust_base 
where "SiteName" = '7-11'
order by "SiteName"
where "LUSTID" is null 



So…no need to reach out. Double check the raw data they sent us and make sure you didn’t miss a unique LUST ID.
If there isn’t one create your own using “State Initial””_””Site Name””_”sequential number:

NE_CON AGRA INC_1
NE_CON AGRA INC_2
NE_COUNTRY GENERAL STORES_3



select * from "CA_LUST".sites;

select * from "CA_LUST".substances ;

select * from "CA_LUST".causes_deagg  ;
	
select distinct element_db_mapping_id, element_name, state_table_name, state_column_name 
from  v_lust_element_mapping where state = 'CA'
order by 1;

select * from  v_lust_element_mapping where state = 'CA'
order by 1;

select * from lust_element_db_mapping where state = 'CA';

update lust_element_db_mapping set state_table_name = 'substances_deagg', state_column_name = 'epa_value', 
	state_join_table = 'sites', state_join_column = 'POTENTIAL_CONTAMINANTS_OF_CONCERN', state_join_column_fk = 'POTENTIAL_CONTAMINANTS_OF_CONCERN'
where id in (1,2,3,4,5);

update lust_element_db_mapping set state_table_name = 'causes_deagg', state_column_name = 'epa_value', 
	state_join_table = 'sites', state_join_column = 'DISCHARGE_CAUSE', state_join_column_fk = 'DISCHARGE_CAUSE'
where id in (6,7,8);


update lust_element_db_mapping set state_table_name = 'sources_deagg', state_column_name = 'epa_value', 
	state_join_table = 'sites', state_join_column = 'DISCHARGE_SOURCE', state_join_column_fk = 'DISCHARGE_SOURCE'
where id in (9,10,11);



