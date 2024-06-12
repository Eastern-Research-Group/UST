select * from information_schema.tables
where table_schema = 'pa_ust';

alter table "Storage_Tanks_-_Active" rename to active_tanks;

select * from information_schema.columns
where table_schema = 'pa_ust' and table_name = 'active_tanks'
order by ordinal_position ;

alter table active_tanks rename column "ï»¿X" to "X";

select 'alter table active_tanks rename column "' || 
	column_name || '" to ' || lower(column_name) || ';'
from information_schema.columns
where table_schema = 'pa_ust' and table_name = 'active_tanks'
order by ordinal_position ;

alter table active_tanks rename column "X" to x;
alter table active_tanks rename column "Y" to y;
alter table active_tanks rename column "OBJECTID" to objectid;
alter table active_tanks rename column "FACILITY_ID" to facility_id;
alter table active_tanks rename column "FACILITY_NAME" to facility_name;
alter table active_tanks rename column "FACILITY_ADDRESS1" to facility_address1;
alter table active_tanks rename column "FACILITY_ADDRESS2" to facility_address2;
alter table active_tanks rename column "FACILITY_CITY" to facility_city;
alter table active_tanks rename column "FACILITY_STATE" to facility_state;
alter table active_tanks rename column "FACILITY_ZIP" to facility_zip;
alter table active_tanks rename column "FACILITY_COUNTY" to facility_county;
alter table active_tanks rename column "FACILITY_MUNICIPALITY" to facility_municipality;
alter table active_tanks rename column "REG_EXPIRATION_DATE" to reg_expiration_date;
alter table active_tanks rename column "TANK_OWNER_ID" to tank_owner_id;
alter table active_tanks rename column "TANK_OWNER_NAME" to tank_owner_name;
alter table active_tanks rename column "TANK_OWNER_ADDRESS1" to tank_owner_address1;
alter table active_tanks rename column "TANK_OWNER_ADDRESS2" to tank_owner_address2;
alter table active_tanks rename column "TANK_OWNER_CITY" to tank_owner_city;
alter table active_tanks rename column "TANK_OWNER_STATE" to tank_owner_state;
alter table active_tanks rename column "TANK_OWNER_ZIP" to tank_owner_zip;
alter table active_tanks rename column "PRIMARY_FACILITY_ID" to primary_facility_id;
alter table active_tanks rename column "SITE_ID" to site_id;
alter table active_tanks rename column "TANK_INFORMATION" to tank_information;

select * from active_tanks;

FACILITY ID
PRIMARY FACILITY NAME
SEQ NUMBER
TANK CODE
TANK SYSTEM COMPONENT
TANK COMPONENT
DATE begin
	
create table active_tank_components (
FACILITY_ID text,
PRIMARY_FACILITY_NAME text,
SEQ_NUMBER text,
TANK_CODE text,
TANK_SYSTEM_COMPONENT text,
TANK_COMPONENT text,
DATE_BEGIN date
);

select column_name from information_schema.columns 
where table_schema = 'pa_ust' and table_name = 'active_tank_components'
order by ordinal_position ;


select facility_id from pa_ust.active_tanks 
where facility_id not in 
	(select facility_id from pa_ust.active_tank_components)
and facility_id not in 
	(select facility_id from pa_ust.facilities_without_tank_info)
order by 1;

create table pa_ust.facilities_without_tank_info (
	facility_id text not null primary key
);

select * from pa_ust.active_tank_components;

delete from pa_ust.active_tank_components;

select count(*) from pa_ust.active_tank_components;


select count(*) from pa_ust.active_tanks ;
11288

select count(*) from 
	(select distinct facility_id from pa_ust.active_tank_components) x
union all
select count(*) from pa_ust.facilities_without_tank_info;


select 11288 - count(*) from 
	(select distinct facility_id from pa_ust.active_tank_components union all
	select facility_id from pa_ust.facilities_without_tank_info) x;

select * from release_control;

alter table ust_release_elements rename to release_elements;


select element_id, element_name, database_column_name, database_lookup_table 
from release_elements where allowed_values = 'Y'
order by 1;

update release_elements set database_lookup_table  = 'states' where element_name = 'State';
update release_elements set database_lookup_table  = 'facility_types' where element_name = 'FacilityType';
update release_elements set database_lookup_table  = 'coordinate_sources' where element_name = 'CoordinateSource';
update release_elements set database_lookup_table  = 'ust_release_statuses' where element_name = 'USTReleaseStatus';
update release_elements set database_lookup_table  = 'substances' where element_name = 'SubstanceReleased';
update release_elements set database_lookup_table  = 'sources' where element_name = 'SourceOfRelease';
update release_elements set database_lookup_table  = 'causes' where element_name = 'CauseOfRelease';
update release_elements set database_lookup_table  = 'how_release_detected' where element_name = 'HowReleaseDetected';
update release_elements set database_lookup_table  = 'corrective_action_strategies' where element_name = 'CorrectiveActionStrategy';

select * from ust_elements_tables;


CREATE TABLE public.release_elements_tables (
	element_table_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	element_id int4 NOT NULL,
	table_name varchar(100) NOT NULL,
	sort_order int4 NULL,
	CONSTRAINT release_elements_tables_pkey PRIMARY KEY (element_table_id)
);

alter table release_elements add constraint release_elements_pkey primary key (element_id);

ALTER TABLE public.release_elements_tables 
ADD CONSTRAINT release_elements_tables_element_id_fkey 
FOREIGN KEY (element_id) REFERENCES public.release_elements(element_id);


select database_column_name, element_type, element_size 
from release_elements order by element_id;

select * from ust_elements_tables;

insert into release_elements_tables (element_id, 'ust_release', )

