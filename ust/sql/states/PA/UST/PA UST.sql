select count(*) from active_tanks 
11288

select count(*) from (select distinct other_id from tanks) b;
12038

select cnt_tanks, cnt_complete, cnt_tanks - cnt_complete from 
	(select count(*) cnt_tanks from active_tanks) a, 
	(select sum(cnt) cnt_complete from 
		(
		select count(*) cnt from (select distinct facility_id from active_tank_components) x
		union all
		select count(*) cnt from (select distinct facility_id from facilities_without_tank_info) x
	) y ) z;
	

select cnt_tanks, cnt_complete, cnt_tanks - cnt_complete difference from 
	(select count(*) cnt_tanks from (select distinct other_id from tanks) b ) a, 
	(select sum(cnt) cnt_complete from 
		(
		select count(*) cnt from (select distinct facility_id from active_tank_components) x
		union all
		select count(*) cnt from (select distinct facility_id from facilities_without_tank_info) x
	) y ) z;
	



select * from facilities_without_tank_info where facility_id = '02-34277';

insert into pa_ust.facilities_without_tank_info values ('02-34277') on conflict do nothing;


select * from active_tank_components;

select * from active_tanks;


select * from "TANKS";

select count(*) from (select distinct "OTHER_ID" from "TANKS") a;
12,038


select count(*) from 
(select distinct "OTHER_ID" from "TANKS" where "OTHER_ID" not in (select facility_id from active_tanks)) a;

866

select count(*) from 
(select distinct facility_id from active_tanks where facility_id not in (select "OTHER_ID" from "TANKS")) a;
116


select * from facilities_without_tank_info;


alter table "TANKS" rename to tanks;


select 'alter table tanks rename column "' || column_name || '" to ' || lower(column_name) || ';'
from information_schema.columns where table_schema = 'pa_ust' and table_name = 'tanks'
order by ordinal_position;

alter table tanks rename column "ï»¿SITE_ID" to site_id;
alter table tanks rename column "OTHER_ID" to other_id;
alter table tanks rename column "PF_NAME" to pf_name;
alter table tanks rename column "PF_ADDRESS1" to pf_address1;
alter table tanks rename column "PF_ADDRESS2" to pf_address2;
alter table tanks rename column "PF_CITY" to pf_city;
alter table tanks rename column "PF_STATE" to pf_state;
alter table tanks rename column "PF_ZIP" to pf_zip;
alter table tanks rename column "COUNTY" to county;
alter table tanks rename column "MUNICIPALITY" to municipality;
alter table tanks rename column "CLIENT_ID" to client_id;
alter table tanks rename column "DATE_EXPIRES" to date_expires;
alter table tanks rename column "CLIENT_NAME" to client_name;
alter table tanks rename column "CLIENT_ADDRESS1" to client_address1;
alter table tanks rename column "CLIENT_ADDRESS2" to client_address2;
alter table tanks rename column "CLIENT_CITY" to client_city;
alter table tanks rename column "CLIENT_STATE" to client_state;
alter table tanks rename column "CLIENT_ZIP" to client_zip;
alter table tanks rename column "SEQ_NUMBER" to seq_number;
alter table tanks rename column "TANK_CODE" to tank_code;
alter table tanks rename column "DATE_INSTALLED" to date_installed;
alter table tanks rename column "CAPACITY" to capacity;
alter table tanks rename column "SUBSTANCE_CODE" to substance_code;
alter table tanks rename column "STATUS" to status;
alter table tanks rename column "PERMIT_TYPE" to permit_type;
alter table tanks rename column "PERMIT_STATUS" to permit_status;
alter table tanks rename column "DATE_LAST_INSPECTION" to date_last_inspection;
alter table tanks rename column "NEXT_INSPECTION_DUE" to next_inspection_due;
alter table tanks rename column "NEXT_INSPECTION_DUE_DATE" to next_inspection_due_date;

select * from tanks;

23-02719	007 CARWASH	450 S 69TH ST		UPPER DARBY	PA	19082-4901	Delaware	Upper Darby Twp
23-02719	007 CARWASH	450 S 69TH ST		UPPER DARBY	PA	19082-4901	Delaware	Upper Darby Twp
23-02719	007 CARWASH	450 S 69TH ST		UPPER DARBY	PA	19082-4901	Delaware	Upper Darby Twp

select * from active_tanks where facility_id = '23-02719'


select count(*) from 
(select distinct other_id from tanks where other_id not in (select facility_id from active_tanks)) a;
866

select count(*) from 
(select distinct facility_id from active_tanks where facility_id not in (select other_id from tanks)) a;
116


