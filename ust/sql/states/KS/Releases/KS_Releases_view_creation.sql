----------------------------------------------------------------------------------------------------------

drop table  ks_release.erg_exclude_releases ;
create table  ks_release.erg_exclude_releases 
	(release_id varchar(50) not null, 
	reported_date date, 
	start_date date,
	status varchar(50),
	collection_method varchar(50));

insert into ks_release.erg_exclude_releases values ('P9RV-FWP4-0ZB','1990-11-15 06:00:00.000','1990-11-20 12:00:00.000','CLOSED',null);
insert into ks_release.erg_exclude_releases values ('369H-KYNV-0WY','1992-02-15 06:00:00.000','1992-01-07 12:00:00.000','CLOSED',null);
insert into ks_release.erg_exclude_releases values ('Q4SA-8453-JG1','1993-02-15 06:00:00.000','1989-08-31 12:00:00.000','CLOSED',null);
insert into ks_release.erg_exclude_releases values ('TJ22-F4JX-SA6','1993-02-15 06:00:00.000','1993-03-15 12:00:00.000','CLOSED',null);
insert into ks_release.erg_exclude_releases values ('26WB-QQXW-5HB',null,null,null,'Unknown');
insert into ks_release.erg_exclude_releases values ('','','');
insert into ks_release.erg_exclude_releases values ('','','');

select * from  ks_release.erg_exclude_releases

select "Number", "Inspection Details - Confirmed Release Date", "Start Date", "Master Status", "Storage Tank Details - Cleanup Completed Date"
from ks_release.historical_releases 
where "Number" = '26WB-QQXW-5HB'

select * from ks_release.releases where "Number" = '26WB-QQXW-5HB'
 
drop view ks_release.v_releases;
CREATE OR REPLACE VIEW ks_release.v_releases
AS SELECT a."Number" AS release_id,
    a."ALT_ID" AS facility_id,
    a."Name" AS site_name,
    a."Address Street" AS site_address,
    a."Address Line 2" AS site_address2,
    a."Address City" AS site_city,
    a."Address State" AS state,
    a."Address PostalCode"::text AS zipcode,
    a."Latitude" AS latitude,
    a."Longitude" AS longitude,
    a."Collection Method" AS coordinate_source,
    a."County" AS county,
    a."Master Status" AS release_status,
    case when lower(a."Leak and Additional Information - Suspected or Report Leak Date") = 'unknown' then null 
              else a."Leak and Additional Information - Suspected or Report Leak Date"::date end AS reported_date,
        CASE
            WHEN a."Tank Excavation Area - Remaining soil condition" IS NOT NULL THEN a."Tank Excavation Area - Remaining soil condition"
            ELSE a."Tank Excavation Area - Remaining soil condition.1"
        END AS media_impacted_soil,
        CASE
            WHEN a."Groundwater contamination was confirmed on site ab " IS NOT NULL THEN upper(a."Groundwater contamination was confirmed on site ab ")
            ELSE upper(a."Groundwater contamination was confirmed on site ab")
        END AS media_impacted_groundwater,
    NULL::date AS nfa_date
   FROM ks_release.releases a
   where not exists (select 1 from ks_release.erg_exclude_releases b where a."Number" = b.release_id and a."Collection Method" = b.collection_method)
UNION ALL
 SELECT a."Number" AS release_id,
    a."ALT_ID" AS facility_id,
    a."Name" AS site_name,
    a."Address Street" AS site_address,
    a."Address Line 2" AS site_address2,
    a."Address City" AS site_city,
    a."Address State" AS state,
    a."Address PostalCode" AS zipcode,
    a."Latitude" AS latitude,
    a."Longitude" AS longitude,
    a."Collection Method" AS coordinate_source,
    a."County" AS county,
    a."Master Status" AS release_status,
    a."Inspection Details - Confirmed Release Date"::date AS reported_date,
    NULL::text AS media_impacted_soil,
    a."Inspection Details - Describe extent of groundwater contaminati" AS media_impacted_groundwater,
    a."Storage Tank Details - Cleanup Completed Date"::date AS nfa_date
   FROM ks_release.historical_releases a 
   where not exists (select 1 from ks_release.erg_exclude_releases b where a."Number" = b.release_id and a."Master Status" = b.status);


create or replace view ks_release.v_release_max_reported_date as
select release_id, max(reported_date) as reported_date 
from ks_release.v_releases
group by release_id;

drop view ks_release.v_ust_release;
create  or replace view ks_release.v_ust_release as
select distinct
    "facility_id"::character varying(50) as facility_id, 
    a."release_id"::character varying(50) as release_id, 
    "site_name"::character varying(200) as site_name, 
    "site_address"::character varying(100) as site_address, 
    "site_address2"::character varying(100) as site_address2, 
    "site_city"::character varying(100) as site_city, 
    "zipcode"::character varying(10) as zipcode, 
    "county"::character varying(100) as county, 
    a.state as state, 
    "latitude"::double precision as latitude, 
    "longitude"::double precision as longitude, 
    coordinate_source_id,
    release_status_id,
    mx.reported_date::date as reported_date,
    max(nfa_date::date) as nfa_date
from ks_release."v_releases" a join ks_release.v_release_max_reported_date mx on a.release_id = mx.release_id and a.reported_date::date = mx.reported_date
 	left join ks_release.v_coordinate_source_xwalk b on a."coordinate_source" = b.organization_value
 	left join ks_release.v_release_status_xwalk c on a."release_status" = c.organization_value	
group by facility_id, a.release_id, site_name, site_address, site_address2,
	site_city, zipcode, county, a.state, latitude, longitude, coordinate_source_id, 
	release_status_id, mx.reported_date;


select * from  ks_release.v_ust_release where release_id = 'P9RV-FWP4-0ZB'

select * from ks_release.v_releases where release_id = '369H-KYNV-0WY'

select * from ks_release.releases where "Number" = 'P9RV-FWP4-0ZB'

select * from ks_release.historical_releases where "Number" = '369H-KYNV-0WY'


select * from ks_release.v_ust_release where release_id = '16KK-QCPN-DGQ'
select * from ks_release.v_releases where release_id = '16KK-QCPN-DGQ'

select * from 
(select distinct
    "facility_id"::character varying(50) as facility_id, 
    "release_id"::character varying(50) as release_id, 
    "site_name"::character varying(200) as site_name, 
    "site_address"::character varying(100) as site_address, 
    "site_address2"::character varying(100) as site_address2, 
    "site_city"::character varying(100) as site_city, 
    "zipcode"::character varying(10) as zipcode, 
    "county"::character varying(100) as county, 
    a.state as state, 
    "latitude"::double precision as latitude, 
    "longitude"::double precision as longitude, 
    coordinate_source_id as coordinate_source_id, 
    max(case when "reported_date" = 'Unknown' then null else "reported_date"::date end) as reported_date
from ks_release."v_releases" a
    left join ks_release.v_coordinate_source_xwalk b on a."coordinate_source" = b.organization_value
    left join ks_release.v_release_status_xwalk c on a."release_status" = c.organization_value
group by  "facility_id"::character varying(50), 
    "release_id"::character varying(50), 
    "site_name"::character varying(200), 
    "site_address"::character varying(100), 
    "site_address2"::character varying(100), 
    "site_city"::character varying(100), 
    "zipcode"::character varying(10), 
    "county"::character varying(100), 
    a.state, 
    "latitude"::double precision, 
    "longitude"::double precision, 
    coordinate_source_id) x
 where release_id = '049V-626R-J67'

    
select * from ks_release.releases where "Number"::character varying(50) = '3Q5V-3G0N-1EB';

select x."Number", x."Inspection Details - Confirmed Release Date"::text, "Inspection Details - Describe extent of groundwater contaminati"
from ks_release.historical_releases x
where "Number"::character varying(50) = '3Q5V-3G0N-1EB';


select * from ks_release."v_releases" where "nfa_date" = 'Unknown'

select * from  ks_release.v_ust_release ;

select distinct media_impacted_groundwater
from ks_release.v_ust_release 
where lower(media_impacted_groundwater) like '%yes%'


select distinct media_impacted_groundwater
from ks_release.v_ust_release 
where lower(media_impacted_groundwater) like '%no%' and lower(media_impacted_groundwater) not like '%unk%'

select distinct media_impacted_groundwater
from ks_release.v_ust_release 
where lower(media_impacted_groundwater) like 'no%' --and lower(media_impacted_groundwater) not like '%unk%'


select * from release_element_allowed_values where column_name = 'media_impacted_groundwater'

select * from oust_release_value_mapping where release_control_id = 23;



select facility_id, release_id, site_name, site_address, site_address2, site_city, zipcode, county, state,
	latitude, longitude, coordinate_source_id, release_status_id, reported_date, nfa_date, 
	media_impacted_soil, media_impacted_groundwater, count(*) 
from ks_release.v_ust_release 
group by facility_id, release_id, site_name, site_address, site_address2, site_city, zipcode, county, state, 
	latitude, longitude, coordinate_source_id, release_status_id, reported_date, nfa_date, 
	media_impacted_soil, media_impacted_groundwater 
having count(*) > 1 order by 1, 2;

----------------------------------------------------------------------------------------------------------

create view ks_release.v_ust_release_cause as
select distinct
	 "release_id"::character varying(50) as release_id,
    cause_id as cause_id
from ks_release."v_release_cause" a
    left join ks_release.v_cause_xwalk b on a."cause" = b.organization_value

    
    select count(*) from ks_release."v_release_cause"
    
select     SELECT releases."Number" AS release_id,
    releases."Leak and Additional Information - Cause of leak" AS cause
   FROM ks_release.releases
  WHERE releases."Leak and Additional Information - Cause of leak" IS NOT NULL;
    
select count(*) from  ks_release.releases where "Leak and Additional Information - Cause of leak" IS NOT NULL;


create or replace view ks_release.v_ust_release_cause as
select distinct
    "release_id"::character varying(50) as release_id ,
    cause_id
from ks_release."erg_cause_datarows_deagg" a
    left join ks_release.v_cause_xwalk b on a."cause" = b.organization_value;



----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

create or replace view ks_release.v_ust_release_source as
select distinct
    "release_id"::character varying(50) as release_id ,
    source_id as source_id
from ks_release."erg_source_datarows_deagg" a
    left join ks_release.v_source_xwalk b on a."source" = b.organization_value;

select count(*) from ks_release.v_ust_release_source
where source_id is null;

select * from ks_release.v_ust_release_source 

select * from  ks_release."v_release_source" 

----------------------------------------------------------------------------------------------------------

create or replace  view ks_release.v_ust_release_substance as
select distinct
	 "release_id"::character varying(50) as release_id ,
    substance_id as substance_id, 
    case when lower("quantity_released") = 'unknown' or  lower("quantity_released") = 'minimal'
     or lower("quantity_released") = lower('Approximately 2750 gallons') then null 
    	else "quantity_released"::double precision end as quantity_released, 
    "unit"::character varying(20) as unit 
from ks_release.erg_substance_datarows_deagg a
    left join ks_release.v_substance_xwalk b on a."substance" = b.organization_value;

select * from ks_release.v_ust_release_substance where substance_id is null;

select * from ks_release.erg_substance_datarows_deagg where release_id = 'V6TD-XAC9-TCR'

delete from  ks_release.erg_substance_datarows_deagg where release_id = 'V6TD-XAC9-TCR'

select * from ks_release.erg_substance_datarows_deagg where release_id = 'ZY5M-GGJS-7FJ'

delete from ks_release.erg_substance_datarows_deagg where  release_id = '1NN4-1AQE-P4X' and substance = 'gasoline';
delete from ks_release.erg_substance_datarows_deagg where  release_id = '3ST6-6X0Z-CQ2' and substance = 'regular gasoline';
delete from ks_release.erg_substance_datarows_deagg where  release_id = '7WG3-EXNT-YYA' and substance = 'gasoline';
delete from ks_release.erg_substance_datarows_deagg where  release_id = 'D8AQ-V22C-8HX' and substance = 'gas';
delete from ks_release.erg_substance_datarows_deagg where  release_id = 'KWPR-7AMN-CTD' and unit is null;
delete from ks_release.erg_substance_datarows_deagg where  release_id = 'PE1W-8KB4-A4W' and substance = 'Gasoline';
delete from ks_release.erg_substance_datarows_deagg where  release_id = 'PQMH-2ST5-WB2' and substance = 'gas';
delete from ks_release.erg_substance_datarows_deagg where  release_id = 'ZY5M-GGJS-7FJ' and substance = 'gas ?';


delete from ks_release.erg_substance_datarows_deagg where substance = 'a'

select * from ks_release.v_ust_release_substance a 
join ks_release.v_ust_release_substance b 
	on a.release_id = b.release_id and a.substance_id = b.substance_id 
where a.quantity_released <> b.quantity_released;

select * from ks_release.erg_substance_datarows_deagg where release_id = '1NN4-1AQE-P4X'




delete from  ks_release.erg_substance_datarows_deagg where substance is null;

select * from ks_release.erg_substance_datarows_deagg where substance ='';

select * from ks_release.erg_substance_datarows_deagg where substance not in
(select organization_value from  ks_release.v_substance_xwalk)

select * from ks_release.erg_substance_datarows_deagg where release_id = '1W8B-5X1A-6RE'

delete from   ks_release.erg_substance_datarows_deagg a
where unit is  null and exists
	(select 1 from  ks_release.erg_substance_datarows_deagg b 
	where a.release_id = b.release_id and lower(a.substance) = lower(b.substance)
	and b.unit is not null)


select * from ks_release.erg_substance_datarows_deagg where substance is null;

select * from  ks_release.v_ust_release_substance 
where release_id = '1W8B-5X1A-6RE'
where substance_id is null;




select * from ks_release.v_ust_release_substance where release_id = '0B58-6ZX3-7SF'


select * from  ks_release."v_release_substance" where substance not in 
	(select organization_value from  ks_release.v_substance_xwalk);

select distinct "quantity_released" from  ks_release."v_release_substance" order by 1;

select * from ks_release.v_ust_release_substance

select * from ks_release."v_release_substance" where  "quantity_released" = 'Unknown'


select distinct epa_table_name, epa_column_name, epa_value, database_lookup_table, database_column_name 
from public.v_release_element_mapping a join public.release_elements b on a.epa_column_name = b.database_column_name 
where release_control_id = 23 and database_lookup_table is not null and epa_table_name = 'ust_release_substance' and epa_value is not null
order by 1, 2, 3

select * from public.v_release_element_mapping
where release_control_id = 23 and epa_table_name = 'ust_release_substance'
and epa_value = 'Other'

delete from release_element_value_mapping where release_element_value_mapping_id in (1189,1271);



