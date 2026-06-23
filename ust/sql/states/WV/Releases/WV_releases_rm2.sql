select * from release_control
where organization_id = 'WV' 

select * from release_element_mapping 
where release_control_id = 10

insert into release_element_mapping 
	(release_control_id, mapping_date, 
	epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name,
	organization_join_table, organization_join_column)
values (10, now(), 'ust_release','latitude','ustlustlocations','Latitude','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Facility_ID');

insert into release_element_mapping 
	(release_control_id, mapping_date, 
	epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name,
	organization_join_table, organization_join_column)
values (10, now(), 'ust_release','longitude','ustlustlocations','Longitude','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Facility_ID');


select '"' || column_name || '"'
from information_schema.columns 
where table_schema = 'public' and table_name = 'v_ust_release'
order by ordinal_position;

"SiteName"
"SiteAddress"
"SiteAddress2"
"SiteCity"
"Zipcode"
"County"
"Latitude"
"Longitude"
"CoordinateSource"

select '"' || column_name || '"'
from information_schema.columns 
where table_schema = 'wv_release' and table_name = 'ustlustlocations'
order by ordinal_position;
"Facility Name"
"Street Address"
"Latitude"
"Longitude"

select e."FacilityID", e."SiteName", s."Facility Name"
from public.v_ust_release e
	join wv_release.ustlustlocations s on e."FacilityID" = s."Facility Id"::text
where release_control_id = 10
and lower(e."SiteName") <> lower(s."Facility Name");
4108383
4505364
5405955



create table wv_release.erg_updated_locations as 
select distinct e."FacilityID", e."SiteName", s."Facility Name", 
--	e."Latitude", 
	s."Latitude", 
--	e."Longitude", 
	s."Longitude"
from public.v_ust_release e
	join wv_release.ustlustlocations s on e."FacilityID" = s."Facility Id"::text
where release_control_id = 10 
and (s."Latitude" is not null or s."Longitude" is not null)
and ((e."Latitude" is null or e."Latitude" <> s."Latitude")
or (e."Longitude" is null or e."Longitude" <> s."Longitude"));





select e."FacilityID", e."SiteName", s."Facility Name", e."SiteAddress", s."Street Address", split_part(s."Street Address", E'\n', 1)
from public.v_ust_release e
	join wv_release.ustlustlocations s on e."FacilityID" = s."Facility Id"::text
where release_control_id = 10
and lower(e."SiteAddress") <> lower(split_part(s."Street Address", E'\n', 1));






drop table wv_release.erg_updated_locations;

select * from wv_release.ustlustlocations ;

drop view  wv_release.v_ust_release
CREATE OR REPLACE VIEW wv_release.v_ust_release
AS SELECT a."Facility_ID"::character varying(50) AS facility_id,
    a."Leak_ID"::character varying(50) AS release_id,
    a."Current Facility Name"::character varying(200) AS site_name,
    a."Address"::character varying(100) AS site_address,
    a."City"::character varying(100) AS site_city,
    a."Zip"::character varying(10) AS zipcode,
    a."County"::character varying(100) AS county,
    u."Latitude"::float as latitude,
    u."Longitude"::float as longitude,
    'WV'::text AS state,
    3 AS epa_region,
    rs.release_status_id,
    a."Confirmed Release"::date AS reported_date,
    a."Closed Date"::date AS nfa_date,
        CASE
            WHEN a."Priority" = '3-Soil contamination'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_soil,
        CASE
            WHEN a."Priority" = '2-Groundwater contamination'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS media_impacted_groundwater
   FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" a
     LEFT JOIN wv_release.erg_release_status b ON a."Leak_ID" = b.release_id
     LEFT JOIN wv_release.v_release_status_xwalk rs ON b.release_status = rs.epa_value::text
     left join wv_release.ustlustlocations u on a."Facility_ID"::text = u."Facility Id"::text
  WHERE a."Suspected Release" <> 'Yes'::text;