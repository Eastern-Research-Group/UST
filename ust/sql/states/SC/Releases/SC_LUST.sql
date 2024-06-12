create function "SC_LUST".convert_site_num_int(site_num bigint)
returns text as $$
declare v_site_num text;
begin
	v_site_num = cast(site_num as text);
	case length(v_site_num) 
		when 1 then v_site_num = 'UST-0000' || v_site_num; 
		when 2 then v_site_num = 'UST-000' || v_site_num; 
		when 3 then v_site_num = 'UST-00' || v_site_num; 
		when 4 then v_site_num = 'UST-0' || v_site_num;
	else v_site_num = 'UST-' || v_site_num;	
	end case;
	return v_site_num;
end;
$$  language plpgsql

select * from lust_element_db_mapping;

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SC','2023-03-03', 'SubstanceReleased1', '', '');

select * from "SC_LUST".ustleak_20211013;

select distinct cas_no,  chemical_desc  from "SC_UST"."Overfill_Prevention"  order by 1;
select distinct cas_no,  chemical_desc  from "SC_UST"."Spill_Prevention_"  order by 1;

create table "SC_LUST".chemicals_ERG  (chemical_desc varchar(100), cas_no varchar(15)); 

insert into "SC_LUST".chemicals_ERG 
select distinct chemical_desc, cas_no 
from 
	(select chemical_desc, cas_no from "SC_UST"."Overfill_Prevention" union all 
	 select chemical_desc, cas_no from "SC_UST"."Spill_Prevention_") a;

delete from "SC_LUST".chemicals_ERG  where chemical_desc is null and cas_no is null;	
	
select * from "SC_LUST".chemicals_ERG order by 1;

update "SC_LUST".chemicals_ERG set chemical_desc = 'Butyl acrylate' where cas_no = '141-32-2';
update "SC_LUST".chemicals_ERG set chemical_desc = 'Vinyl acetate' where cas_no = '108-05-4';
update "SC_LUST".chemicals_ERG set chemical_desc = 'Styrene' where cas_no = '100-42-5';
update "SC_LUST".chemicals_ERG set chemical_desc = 'Methyl methacrylate' where cas_no = '80-62-6';
update "SC_LUST".chemicals_ERG set chemical_desc = 'Ethyl acrylate ' where cas_no = '140-88-5';
	
select * from "SC_LUST".chemicals_ERG order by 1;
----------------------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------------------

select * from 

drop sequence  "SC_LUST".lustid_seq;
create sequence "SC_LUST".lustid_seq;


select distinct release_num from "SC_LUST".ustleak_20211013

---------------------------------------------------------------------------------------------------------------
drop view "SC_LUST".v_lust_base;
drop view "SC_LUST".v_lust;

create or replace view "SC_LUST".v_lust_base as
select count(*) from (
select 	a.site_num as "FacilityID", 
		case when a.release_num is not null then replace('SC_' || substring(a.facil_name,1,35) || '_' || a.release_num || '_' || nextval('"SC_LUST".lustid_seq')::text,'__','_')
	     else replace('SC_' || substring(a.facil_name,1,40) || '_' || nextval('"SC_LUST".lustid_seq')::text,'__','_')
	     end as "LUSTID", 
		a.facil_name as "SiteName", 
		a.facil_address as "SiteAddress",
		a.facil_city as "SiteCity",
		a.facil_zip as "ZipCode",
		'SC' as "State", 
		4 as "EPARegion",		
		b.lat_decimal as "Latitude", 
		b.long_decimal as "Longitude",
		case when a.cleanup_complete_date is null and a.cleanup_compl_mcl_date is null then 'Active: general' 
	    	 when (a.cleanup_complete_date is not null and a.cleanup_compl_mcl_date is null) 
			    or (a.cleanup_complete_date is null and a.cleanup_compl_mcl_date is not null) then 'No further action'
			 else 'Other' end as "LUSTStatus",
		to_date(a.confirmed_date,'DD-MON-YY') as "ReportedDate",
		case when a.suspect_nfaed_date is not null then to_date(a.suspect_nfaed_date,'DD-MON-YY')
		     when a.cleanup_complete_date is not null then to_date(a.cleanup_complete_date,'DD-MON-YY')
			 when a.cleanup_compl_mcl_date is not null then to_date(a.cleanup_compl_mcl_date,'DD-MON-YY') end as "NFADate",
		case when soil_contam_present = 'Y' or soil_contam_present_on = 'Y' then 'Yes' 
			 when soil_contam_present = 'N' or soil_contam_present_on = 'N' then 'No' end as "MediaImpactedSoil",
		case when gw_contam_present = 'Y' or gw_contam_present_on = 'Y' then 'Yes' 
			 when gw_contam_present = 'N' or gw_contam_present_on = 'N' then 'No' end as "MediaImpactedGroundwater",
		case when sw_contam_present = 'Y' or sw_contam_present_on = 'Y' then 'Yes' 
			 when sw_contam_present = 'N' or sw_contam_present_on = 'N' then 'No' end as "MediaImpactedSurfaceWater",
		'Petroleum product' as "SubstanceReleased1",
		case when b.cleanup_complete_date is null and b.cleanup_compl_mcl_date is null and b.cnfa = 'Y' then 'Yes' end as "ClosedWithContamination"
from "SC_LUST".ustleak_20211013 a 
	left join "SC_LUST".lwmopc_20211013 b on a.site_num = "SC_LUST".convert_site_num_int(b.site_num) and a.release_num = b.release_num) a;
	
select count(*) from "SC_LUST".ustleak_20211013



select count(*) from "SC_LUST".lwmopc_20211013


select * From "SC_LUST".lwmopc_20211013;

select * from "SC_LUST".ustleak_20211013



select * from "SC_LUST".v_lust_base where "LUSTID" is null;


select distinct confirmed_date from  "SC_LUST".ustleak_20211013 order by 1;

select cleanup_compl_mcl_date, to_date(cleanup_compl_mcl_date,'DD-MON-YY') from  "SC_LUST".ustleak_20211013 order by 1;

select * from "SC_LUST".ustleak_20211013 
	
select * from v_lust order by "FacilityID", "LUSTID";





create view "SC_LUST".v_lust as select distinct a.site_num::character varying as "FacilityID",
a.release_num::character varying as "LUSTID",
a.facil_name::character varying as "SiteName",
a.facil_address::character varying as "SiteAddress",
a.facil_city::character varying as "SiteCity",
'SC'::text as "State",
4::integer as "EPARegion",
b.lat_decimal::double precision as "Latitude",
b.long_decimal::double precision as "Longitude",
CASE
            WHEN a.cleanup_complete_date IS NULL AND a.cleanup_compl_mcl_date IS NULL THEN 'Active'::text
            WHEN a.cleanup_complete_date IS NOT NULL AND a.cleanup_compl_mcl_date IS NULL OR a.cleanup_complete_date IS NULL AND a.cleanup_compl_mcl_date IS NOT NULL THEN 'No Further Action'::text
            ELSE 'Other'::text
        END as "LUSTStatus",
'DD-MON-YY'::text) as "ReportedDate",
'DD-MON-YY'::text)
            ELSE NULL::date
        END as "NFADate",
CASE
            WHEN b.soil_contam_present = 'Y'::text OR b.soil_contam_present_on = 'Y'::text THEN 'Yes'::text
            WHEN b.soil_contam_present = 'U'::text OR b.soil_contam_present_on = 'U'::text THEN 'Unknown'::text
            WHEN b.soil_contam_present = 'N'::text OR b.soil_contam_present_on = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END as "MediaImpactedSoil",
CASE
            WHEN b.gw_contam_present = 'Y'::text OR b.gw_contam_present_on = 'Y'::text THEN 'Yes'::text
            WHEN b.gw_contam_present = 'U'::text OR b.gw_contam_present_on = 'U'::text THEN 'Unknown'::text
            WHEN b.gw_contam_present = 'N'::text OR b.gw_contam_present_on = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END as "MediaImpactedGroundwater",
CASE
            WHEN b.sw_contam_present = 'Y'::text OR b.sw_contam_present_on = 'Y'::text THEN 'Yes'::text
            WHEN b.sw_contam_present = 'U'::text OR b.sw_contam_present_on = 'U'::text THEN 'Unknown'::text
            WHEN b.sw_contam_present = 'N'::text OR b.sw_contam_present_on = 'N'::text THEN 'No'::text
            ELSE NULL::text
        END as "MediaImpactedSurfaceWater",
'Petroleum product'::text as "SubstanceReleased1",
CASE
            WHEN b.cleanup_complete_date IS NULL AND b.cleanup_compl_mcl_date IS NULL AND b.cnfa = 'Y'::text THEN 'Yes'::text
            ELSE NULL::text
        END as "ClosedWithContamination"
FROM "SC_LUST".ustleak_20211013 a
     LEFT JOIN "SC_LUST".lwmopc_20211013 b ON a.site_num = "SC_LUST".convert_site_num_int(b.site_num) AND a.release_num = b.release_num::double precision
     
     
     