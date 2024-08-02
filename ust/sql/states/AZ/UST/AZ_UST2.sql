


select * from ust_element_mapping
where ust_control_id = 14
and epa_column_name like 'owner%'

update ust_element_mapping set organization_comments = 
	'Per the state, federal government and military, and state government and military, are combined. To distinguish them, look at Owner Name. Create a crosswalk based on Owner Name and send to state for review.'
where ust_element_mapping_id = 568;

select * from ust_element_value_mapping 
where ust_element_mapping_id = 568;

select * from v_ust_element_mapping where  ust_element_mapping_id = 568;


drop table az_ust.erg_ower_type_military_mapping cascade;

select distinct "OwnerType", "FacilityOwnerCompanyName",
	case when "FacilityOwnerCompanyName" like '%NATIONAL%GUARD%' then 'Y'
	     when "FacilityOwnerCompanyName" like '%AIR FORCE%' then 'Y'
	     when "FacilityOwnerCompanyName" like '%ARMY%' then 'Y'
	     when "FacilityOwnerCompanyName" like '%NAVY%' then 'Y'
	     when "FacilityOwnerCompanyName" like '%NAVAL%' then 'Y'
		 when "FacilityOwnerCompanyName" like '%USAF%' then 'Y'
		 when "FacilityOwnerCompanyName" like '%USMC%' then 'Y'
	     when "FacilityOwnerCompanyName" like '%USAG FORT HUACHUCA%' then 'Y'
	     when "FacilityOwnerCompanyName" like '%USANG AIR NATL AZ 162 TAC FTR GP%' then 'Y'
	     when "FacilityOwnerCompanyName" like '%ARIZONA DEPARTMENT OF EMERGENCY AND MILITARY AFFAIRS%' then 'Y'
	 else 'N' end "MilitaryFlag"
into az_ust.erg_ower_type_military_mapping 
from az_ust.ust_facility 
where "OwnerType" is not null and "OwnerType" in ('Federal Government','State Government')
order by 1, 2;
create view az_ust.v_owner_type_mapping as
select distinct "FacilityID", a."FacilityOwnerCompanyName", 
	case when b."MilitaryFlag" = 'Y' then 'Military' 
	     when b."MilitaryFlag" = 'N' then b."OwnerType" || ' - Non Military'
	 else a."OwnerType" end "OwnerType"
from az_ust.ust_facility a left join az_ust.erg_ower_type_military_mapping b 
	on a."FacilityOwnerCompanyName" = b."FacilityOwnerCompanyName" and a."OwnerType" = b."OwnerType"
where a."OwnerType" is not null;


select * from az_ust.erg_ower_type_military_mapping 
where "MilitaryFlag" = 'Y'
order by 1, 2;

select * from owner_types ;

select "FacilityOwnerCompanyName", count(*)
from az_ust.v_owner_type_mapping where "OwnerType" = 'Military'
group by "FacilityOwnerCompanyName";

select * from ust_element_mapping where ust_element_mapping_id = 568;

update ust_element_mapping 
set organization_table_name = 'v_owner_type_mapping', 
	organization_column_name = 'OwnerType',
	programmer_comments = 'select distinct "OwnerType", "FacilityOwnerCompanyName",
	case when "FacilityOwnerCompanyName" like ''%NATIONAL%GUARD%'' then ''Y''
	     when "FacilityOwnerCompanyName" like ''%AIR FORCE%'' then ''Y''
	     when "FacilityOwnerCompanyName" like ''%ARMY%'' then ''Y''
	     when "FacilityOwnerCompanyName" like ''%NAVY%'' then ''Y''
	     when "FacilityOwnerCompanyName" like ''%NAVAL%'' then ''Y''
		 when "FacilityOwnerCompanyName" like ''%USAF%'' then ''Y''
		 when "FacilityOwnerCompanyName" like ''%USMC%'' then ''Y''
	     when "FacilityOwnerCompanyName" like ''%USAG FORT HUACHUCA%'' then ''Y''
	     when "FacilityOwnerCompanyName" like ''%USANG AIR NATL AZ 162 TAC FTR GP%'' then ''Y''
	     when "FacilityOwnerCompanyName" like ''%ARIZONA DEPARTMENT OF EMERGENCY AND MILITARY AFFAIRS%'' then ''Y''
	 else ''N'' end "MilitaryFlag"
into az_ust.erg_ower_type_military_mapping 
from az_ust.ust_facility 
where "OwnerType" is not null and "OwnerType" in (''Federal Government'',''State Government'')
order by 1, 2;
create view az_ust.v_owner_type_mapping as
select distinct "FacilityID", a."FacilityOwnerCompanyName", 
	case when b."MilitaryFlag" = ''Y'' then ''Military'' 
	     when b."MilitaryFlag" = ''N'' then b."OwnerType" || '' - Non Military''
	 else a."OwnerType" end "OwnerType"
from az_ust.ust_facility a left join az_ust.erg_ower_type_military_mapping b 
	on a."FacilityOwnerCompanyName" = b."FacilityOwnerCompanyName" and a."OwnerType" = b."OwnerType"
where a."OwnerType" is not null;'
where ust_element_mapping_id = 568;


select distinct "OwnerType" from az_ust.v_owner_type_mapping order by 1;


select * from ust_element_value_mapping where ust_element_mapping_id = 568 order by organization_value ;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value)
values (568, 'Military', 'Military');

update ust_element_value_mapping
set epa_approved = 'Y', programmer_comments = null 
where ust_element_mapping_id = 568;

update ust_element_value_mapping
set organization_comments = 'Look at the Owner Name to determine if Military or not'
where ust_element_value_mapping_id in (336,339);

update ust_element_value_mapping
set programmer_comments = 'Created ERG mapping table to extract Military Owner Types from Owner Name; Military types are rolled into Federal Government and State Government in state data'
where ust_element_value_mapping_id = 586;



-----------------------------------------------------------------------------------------------------------------------------

update ust_element_value_mapping 

select ust_element_mapping_id, organization_value, epa_value, programmer_comments, epa_comments, organization_comments
from v_ust_element_mapping where ust_control_id = 14 and epa_column_name = 'substance_id'
order by 1;

delete from ust_element_value_mapping where ust_element_mapping_id = 526;





