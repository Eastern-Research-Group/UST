 select * from release_control where organization_id = 'SD'
 
 Filter release data using  sor_type = UST and regulated =true and  cause_type  not in (no Release,No Release)  
 and union with  sor_type = UST and regulated =true and  cause_type  in (no Release,No Release) and site_type = ATP. 
 Search by county here https://apps.sd.gov/NR42InteractiveMap# and download each county''s data by using the "download results button"
and pull the facility data out of the https://arcgis.sd.gov/arcgis/rest/services/DENR/NR42_SpillReports_Public/MapServer/0 layer using ArcGIS Pro.  

ignore rows where sor_type <> 'UST'


select * from v_release_mapping where release_control_id = 4


select * from sd_release.spill_reports_all

select * from  sd_release.erg_unregulated_releases 

delete from sd_release.erg_unregulated_releases 

insert into sd_release.erg_unregulated_releases 
select distinct id, 'sor_type <> ''UST'''
from sd_release.spill_reports_all
where sor_type <> 'UST'
on conflict do nothing;

select regulated, count(*)
from sd_release.spill_reports_all 
group by regulated;

select sor_type, count(*)
from sd_release.spill_reports_all 
where regulated <> 'true'
group by sor_type;


insert into sd_release.erg_unregulated_releases 
select distinct id, 'regulated = ''false'''
from sd_release.spill_reports_all
where regulated = 'false'
on conflict do nothing;

select unregulated_reason, count(*)
from sd_release.erg_unregulated_releases 
group by unregulated_reason


select cause_type, count(*)
from sd_release.spill_reports_all 
group by cause_type;



 Filter release data using  sor_type = UST and regulated =true and  cause_type  not in (no Release,No Release)  
 and union with  sor_type = UST and regulated =true and  cause_type  in (no Release,No Release) and site_type = ATP. 
 Search by county here https://apps.sd.gov/NR42InteractiveMap# and download each county''s data by using the "download results button"
and pull the facility data out of the https://arcgis.sd.gov/arcgis/rest/services/DENR/NR42_SpillReports_Public/MapServer/0 layer using ArcGIS Pro.  

--ATP = 'Abandoned Tank Program'


select * from sd_release.spill_reports_all 
where site_type = 'ATP' and lower(cause_type) <> 'no release'

insert into sd_release.erg_unregulated_releases 
select distinct id, 'site_type = ''ATP'' and lower(cause_type) <> ''no release'''
from sd_release.spill_reports_all 
where site_type = 'ATP' and lower(cause_type) <> 'no release'
on conflict do nothing;

--Per Victoria:
delete from sd_release.erg_unregulated_releases
where unregulated_reason =  'site_type = ''ATP'' and lower(cause_type) <> ''no release'''

insert into sd_release.erg_unregulated_releases 
select distinct id, 'site_type = ''ATP'''
from sd_release.spill_reports_all 
where site_type = 'ATP'
on conflict do nothing;

insert into sd_release.erg_unregulated_releases 
select distinct id, 'lower(cause_type) = ''no release'''
from sd_release.spill_reports_all 
where lower(cause_type) = 'no release'
on conflict do nothing;


select distinct id, site_type, cause_type, sor_type, regulated 
--'site_type = ''ATP'' and lower(cause_type) <> ''no release'''
from sd_release.spill_reports_all 
where (site_type = 'ATP' and lower(cause_type) <> 'no release')
and sor_type = 'UST' and regulated = 'true'

select site_type, count(*)
from  sd_release.spill_reports_all 
group by site_type;

insert into sd_release.erg_unregulated_releases 
select distinct id, 'site_type = ''ATP'' and lower(cause_type) <> ''no release'''
from sd_release.spill_reports_all 
where (site_type = 'ATP' and lower(cause_type) <> 'no release')
on conflict do nothing;


select * from sd_release.erg_unregulated_releases 
where release_id  = '2001.463'



select * from v_release_mapping 
where release_control_id = 4 and epa_column_name = 'cause_id'
order by organization_value;

delete from release_element_value_mapping where release_element_value_mapping_id = 403;

aviation fuel
Aviation fuel
Aviation Fuel
Aviation Fuel - 87 or 100 octane

select * from substances 
where inactive_flag is null and release_flag is not null
order by substance_group, substance;

select * from release_element_value_mapping
where organization_value in ('aviation fuel',
'Aviation fuel',
'Aviation Fuel',
'Aviation Fuel - 87 or 100 octane')
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id')


update release_element_value_mapping 
set epa_value = 'Unknown aviation gas or jet fuel'
where  organization_value in ('aviation fuel',
'Aviation fuel',
'Aviation Fuel',
'Aviation Fuel - 87 or 100 octane')
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id')
	
	
	
update release_element_value_mapping 
set epa_value = 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel'
where  organization_value in (
'diesel',
'Diesel',
'Diesel #1',
'Diesel #2',
'Diesel #6',
'diesel fuel',
'Diesel fuel',
'Diesel Fuel',
'Diesel, Water'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');


update release_element_value_mapping 
set epa_value = 'Gasoline (unknown type)'
where  organization_value in (
'fuel',
'Fuel'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');



update release_element_value_mapping 
set epa_value = 'Ethanol blend gasoline (e-unknown)'

select * from release_element_value_mapping
where lower(organization_value) = 'gasohol'
and epa_value <> 'Ethanol blend gasoline (e-unknown)'

select * from ust_element_value_mapping
where lower(organization_value) = 'gasohol'
and epa_value = 'Ethanol blend gasoline (e-unknown)'

update release_element_value_mapping 
set epa_value = 'Ethanol blend gasoline (e-unknown)'
where lower(organization_value) = 'gasohol'
and epa_value <> 'Ethanol blend gasoline (e-unknown)'


update ust_element_value_mapping 
set epa_value = 'Ethanol blend gasoline (e-unknown)'
where lower(organization_value) = 'gasohol'
and epa_value <> 'Ethanol blend gasoline (e-unknown)'



select * from substances 
where inactive_flag is null and release_flag is not null
order by substance_group, substance;

update release_element_value_mapping 
set epa_value = 'Unleaded gasoline (unknown type)'
where  organization_value in (
'Gasoline Unleaded',
'unleaded gasoline',
'Unleaded Gasoline'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');


update release_element_value_mapping 
set epa_value = 'Oil (unspecified)'
where  organization_value in (
'Grease, Oil'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');

update release_element_value_mapping 
set epa_value = 'Heating oil/fuel oil 6'
where  organization_value in (
'Heavy fuel oil',
'Heavy Fuel Oil'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');


update release_element_value_mapping 
set epa_value = 'Jet fuel'
where  organization_value in (
'jet fuel',
'JP-4'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');


select * from substances 
where inactive_flag is null and release_flag is not null
order by substance_group, substance;

update release_element_value_mapping 
set epa_value = 'Mineral spirits'
where  organization_value in (
'Mineral Spirits'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');

delete from  release_element_value_mapping 
where  organization_value in (
'MTBE'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');


update release_element_value_mapping 
set epa_value = 'Petroleum product'
where  organization_value in (
'Petroleum, VOC''s'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');



update release_element_value_mapping 
set epa_value = 'Used oil/waste oil'
where  organization_value in (
'used oil',
'Used Oil',
'waste oil',
'Waste oil',
'Waste Oil',
'Waste/Motor Oil'
)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');




select * from sd_release.spill_reports_all where material in (
'Diesel, Fuel Oil',
'Diesel, Gas, Oil',
'Diesel, Gasoline',
'Diesel, JP-4 Fuel',
'Diesel, Oil'
)


select material, count(*)
from sd_release.spill_reports_all a 
where material like '%, %' 
and id not in 
	(select release_id from sd_release.erg_unregulated_releases)
group by material
order by material;


create table sd_release.spill_reports_all_deagg as 
select * from sd_release.spill_reports_all
where 1=0


create table sd_release.spill_reports_all_agg_materials
as 
select * from sd_release.spill_reports_all
where material in (
'Diesel, Fuel Oil',
'Diesel, Gas, Oil',
'Diesel, Gasoline',
'Diesel, JP-4 Fuel',
'Diesel, Oil',
'Fertilizer, Petroleum',
'fuel oil & perc',
'Fuel Oil & Waste Oil',
'Fuel Oil Gas Solvent',
'Fuel Oil, Gasoline',
'Gasoline & Kerosene',
'Gasoline, Fuel Oil',
'Gasoline, Kerosene',
'Gasoline, Oil',
'Gasoline, Waste Oil',
'JP-4, JP-8, and Gasoline',
'JP-4, Solvent, Oil',
'JP 4, water mixture',
'Petroleum & Agri Chem',
'Petroleum, Solvents',
'Petroleum, Waste Oil',
'solvents / petroleum',
'Solvents, Petroleum',
'Waste & Fuel Oil',
'waste oil / diesel',
'Waste Oil and TCE'
)



select * from release_element_value_mapping 
where organization_value in (select material from sd_release.spill_reports_all_agg_materials)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');

delete from release_element_value_mapping 
where organization_value in (select material from sd_release.spill_reports_all_agg_materials)
and release_element_mapping_id in 
	(select release_element_mapping_id 
	from release_element_mapping 
	where release_control_id = 4
	and epa_column_name = 'substance_id');


select * from sd_release.erg_material_deagg;


select distinct epa_table_name
 from public.release_element_mapping 
 where release_control_id = 4
 and organization_table_name = 'spill_reports_all_agg_materials' and organization_column_name = 'material';


select distinct "material" from sd_release."spill_reports_all_agg_materials" 
 where "material" is not null and "material" like '%, %'
 and "material" <> any('{}')
 order by 1;


select * from sd_release.erg_material_deagg;


delete from sd_release.erg_material_deagg
where erg_material_deagg_id in (1,27,49)


select * from sd_release.spill_reports_all_agg_materials;



select * from sd_release.erg_material_datarows_deagg;


insert into sd_release.erg_material_datarows_deagg
values ('96.254','JP-4');
insert into sd_release.erg_material_datarows_deagg
values ('96.254','JP-8');

delete from  sd_release.erg_material_datarows_deagg
where id = '96.254' and material = 'JP-4, JP-8,';

select * from sd_release.spill_reports_all_agg_materials 
where id not in (select id from sd_release.erg_material_datarows_deagg)

select count(*) from (select distinct id from sd_release.spill_reports_all_agg_materials) x;
206

select count(*) from (select distinct id from sd_release.erg_material_datarows_deagg) x;
206

select id, count(*)
from sd_release.spill_reports_all_agg_materials
group by id having count(*) > 1;

91.55	2
2012.241	2
90.397	2
2001.132	2

select * from sd_release.spill_reports_all_agg_materials
where id in 
	(select id
	from sd_release.spill_reports_all_agg_materials
	group by id having count(*) > 1)
order by id;


select * from sd_release.erg_material_datarows_deagg;

insert into sd_release.erg_material_datarows_deagg
select distinct id, material 
from sd_release.spill_reports_all 
where id not in 
	(select id from sd_release.erg_material_datarows_deagg)

	
select count(*) from (select distinct id from sd_release.spill_reports_all )	x
14907

select count(*) from (select distinct id from sd_release.erg_material_datarows_deagg )	x
14907

select * from release_element_mapping 
where release_control_id = 4 
and epa_column_name = 'substance_id'

select * from sd_release.erg_material_datarows_deagg

select * from release_element_mapping 
where release_control_id = 4 
and deagg_table_name is not null;


select * from release_element_mapping 
where  deagg_table_name is not null;

	
update release_element_mapping
set deagg_table_name = 'erg_material_datarows_deagg', deagg_column_name = 'material' 
where release_control_id = 4 
and  epa_column_name = 'substance_id'


select distinct material 
from sd_release.erg_material_datarows_deagg 
where id not in (select release_id from sd_release.erg_unregulated_releases)
and material not in 
	(select organization_value from v_release_mapping 
	where release_control_id = 4 and epa_column_name = 'substance_id')
order by 1;

update sd_release.erg_material_datarows_deagg  set material = 'Gasoline'
where material = 'and Gasoline'

Agri Chem
Fertilizer
Gas
JP-4 Fuel
MTBE
No known contamination
Solvent
Solvents


Fertilizer
Fuel Oil Gas Solvent
MTBE
No known contamination

select * from sd_release.spill_reports_all_agg_materials 
where material = 'Fuel Oil Gas Solvent'
90.641

select * from sd_release.erg_material_datarows_deagg 
where material = 'Fuel Oil Gas Solvent'

insert into sd_release.erg_material_datarows_deagg  values ('90.641','Fuel Oil');
insert into sd_release.erg_material_datarows_deagg  values ('90.641','Gas');
insert into sd_release.erg_material_datarows_deagg  values ('90.641','Solvent');

delete from sd_release.erg_material_datarows_deagg 
where material = 'Fuel Oil Gas Solvent';

select organization_value, epa_value, release_element_mapping_id 
from v_release_mapping 
where release_control_id = 4 and epa_column_name = 'substance_id'
order by 1;



insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (226, 'Gas', 'Gasoline (unknown type)');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (226, 'JP-4 Fuel', 'Jet fuel');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (226, 'Solvent', 'Hazardous substance');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (226, 'Solvents', 'Hazardous substance');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (226, 'Agri Chem', 'Other');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (226, 'Fertilizer', 'Other');



drop view  sd_release.v_ust_release_substance;

select * from  sd_release.v_ust_release_substance;


select * from sd_release.erg_unregulated_substances
where unregulated_reason  <> 'Non-regulated substance'

select count(*) from  sd_release.erg_unregulated_substances


select * 
from sd_release.erg_material_datarows_deagg 
where id not in (select release_id from sd_release.erg_unregulated_releases)
and material not in 
	(select organization_value 
	from v_release_mapping 
	where release_control_id = 4 
	and epa_column_name = 'substance_id')


select distinct material from  sd_release.erg_material_datarows_deagg 
where id not in (select release_id from sd_release.erg_unregulated_releases)
order by 1;

heating fuel
Heating Fuel
Heating Oil


select b.*, a.* from sd_release.spill_reports_all a join sd_release.vw_erg_facility_type_mapping b on a.siteid = b.facility_id 
where id in (select id from sd_release.erg_material_datarows_deagg where lower(material) like 'heating%')
and id not in (select release_id from sd_release.erg_unregulated_releases )

select * from sd_release.vw_erg_facility_type_mapping 

select * from  sd_release.spill_reports_all 


select * from v_release_mapping where organization_value = 'oil/water separator'

select * from substances order by substance_group, substance;

update release_element_value_mapping 
set epa_value = 'Oil water separator contents' 
where organization_value = 'oil/water separator'


select * from release_element_value_mapping

update release_element_value_mapping
set epa_comments = null 
where release_element_mapping_id in 
	(select release_element_mapping_id
	from release_element_mapping
	where release_control_id = 4 and epa_column_name = 'substance_id')
and epa_comments is not null;


drop table sd_release.erg_unregulated_facilities 

select distinct unregulated_reason from sd_release.erg_unregulated_releases 
Heating oil
Non-regulated substance
sor_type <> 'UST'
lower(cause_type) = 'no release'
regulated = 'false'
site_type = 'ATP'


select * from sd_release.erg_unregulated_substances 
where unregulated_reason = 'Non-regulated substance'
and release_id in 
	(select release_id 
	from sd_release.erg_unregulated_releases 
	where unregulated_reason <> 'Heating oil')
	
delete from sd_release.erg_unregulated_releases 
where unregulated_reason in ('Heating oil','Non-regulated substance')

delete from sd_release.erg_unregulated_substances
where unregulated_reason in ('Heating oil','Non-regulated substance')





select * From sd_release.v_ust_release_substance where release_id = '97.052'


select * from sd_release.erg_unregulated_substances
where unregulated_reason <> 'Non-regulated substance'



select distinct ts.release_id
		from (select release_id from sd_release.v_ust_release where facility_type_id <> 4) r
			join sd_release.v_ust_release_substance ts on ts.release_id = r.release_id
			join public.substances s on ts.substance_id = s.substance_id 
		where s.substance_group = 'Heating'
	order by 1

	
	select * 
	from sd_release.v_ust_release  r
			join sd_release.v_ust_release_substance ts on ts.release_id = r.release_id
			join public.substances s on ts.substance_id = s.substance_id 
		where s.substance_group = 'Heating' and facility_type_id <> 4
		order by r.release_id;
	
select * from sd_release.vw_erg_unreg_tanks 

select * from v_release_mapping 
where release_control_id = 4




update release_element_value_mapping 
set epa_value = 'Other or mixture'
where release_element_value_mapping_id in (1533,1534);

select * from substances where inactive_flag is null and release_flag is not null
order by substance_group, substance;


select epa_column_name, organization_column_name, organization_table_name, organization_join_table, organization_join_column
from public.release_element_mapping a join public.v_release_sort_order b 
	on a.epa_table_name = b.table_name and a.epa_column_name = b.column_name 
where release_control_id = 4
and epa_table_name = 'ust_release_substance'
and epa_column_name in ('facility_id', 'tank_id', 'release_id', 'substance_id')
order by b.column_sort_order

update release_element_mapping 
set deagg_column_name = 'id', deagg_table_name = 'erg_material_datarows_deagg'
where release_control_id = 4 
and  epa_table_name = 'ust_release_substance'
and epa_column_name = 'release_id'

select epa_column_name,
	case when deagg_column_name is not null then deagg_column_name else organization_column_name end as organization_column_name, 
	case when deagg_table_name is not null then deagg_table_name else organization_table_name end as organization_table_name, 
	organization_join_table, organization_join_column
from public.release_element_mapping a join public.v_release_sort_order b 
	on a.epa_table_name = b.table_name and a.epa_column_name = b.column_name 
where release_control_id = 4
and epa_table_name = 'ust_release_substance'
and epa_column_name in ('facility_id', 'tank_id', 'release_id', 'substance_id')
order by b.column_sort_order


drop view sd_release.vw_erg_substance_mapping cascade;


select * from v_release_mapping 
where release_control_id = 4 and epa_table_name = 'ust_release_substance'



CREATE OR REPLACE VIEW sd_release.vw_erg_substance_mapping
AS 
SELECT a.id AS release_id,
    a.material AS org_substance,
    s.substance AS epa_substance,
    s.substance_id
   FROM sd_release.spill_reports_all a
     LEFT JOIN ( SELECT v_release_mapping.organization_value,
            v_release_mapping.epa_value
           FROM v_release_mapping
          WHERE v_release_mapping.release_control_id = 4 AND v_release_mapping.epa_table_name::text = 'ust_release_substance'::text) x ON x.organization_value::text = a.material::text
     LEFT JOIN substances s ON x.epa_value::text = s.substance::text
  WHERE a.material IS NOT NULL;



select * from sd_release.vw_erg_substance_mapping

drop view if exists sd_release.vw_erg_unreg_tanks;


select distinct ts.release_id
from (select release_id from sd_release.v_ust_release where facility_type_id <> 4) r
	join sd_release.v_ust_release_substance ts on ts.release_id = r.release_id
	join public.substances s on ts.substance_id = s.substance_id 
where s.substance_group = 'Heating' 
and not exists 
	(select 1 from sd_release.v_ust_release r2
	join sd_release.v_ust_release_substance ts2 on ts2.release_id = r2.release_id
	join public.substances s2 on ts2.substance_id = s2.substance_id 
	where r.release_id = r2.release_id and s.substance_id <> s2.substance_id)
order by 1
2006.151
88.197
89.195
89.23
89.303
90.641
92.266
93.28
95.183


select distinct ts.release_id, s.substance, facility_type_id
from (select release_id, facility_type_id from sd_release.v_ust_release where facility_type_id <> 4) r
	join sd_release.v_ust_release_substance ts on ts.release_id = r.release_id
	join public.substances s on ts.substance_id = s.substance_id 
where s.substance_group = 'Heating' 

select *
from sd_release.v_ust_release_substance ts join sd_release.v_ust_release r on ts.release_id = r.release_id
	join public.substances s on ts.substance_id = s.substance_id 
where facility_type_id <> 4 and substance_group = 'Heating' 




select * from sd_release.v_ust_release_substance a join substances s on a.substance_id = s.substance_id 
where release_id = '88.197'

24	Gasoline (unknown type)	Gasoline
36	Heating/fuel oil # unknown	Heating

select * from sd_release.erg_unregulated_substances where release_id =  '88.197'
88.197	Fuel Oil	36	Heating/fuel oil # unknown	Heating oil

select * from sd_release.erg_unregulated_releases where release_id =  '88.197'



select * From sd_release.erg_unregulated_substances where release_id = '88.197'
88.197	Fuel Oil	36	Heating/fuel oil # unknown	Heating oil

select * from sd_release.erg_material_datarows_deagg where id = '88.197'
88.197	Fuel Oil


CREATE OR REPLACE VIEW sd_release.v_ust_release_substance
AS 
SELECT DISTINCT x.id::character varying(50) AS release_id,
    s.substance_id,
    x.amount::double precision AS quantity_released,
    x.units::character varying(20) AS unit
   FROM sd_release.spill_reports_all x
     JOIN sd_release.erg_material_datarows_deagg d ON x.id::text = d.id::text
     JOIN sd_release.v_substance_xwalk s ON d.material::text = s.organization_value::text
  WHERE s.substance_id IS NOT NULL 
  AND NOT (x.id::character varying(50)::text IN ( SELECT erg_unregulated_releases.release_id FROM sd_release.erg_unregulated_releases)) 
  AND NOT EXISTS ( SELECT 1
           FROM sd_release.erg_unregulated_substances unregsub
           WHERE d.id::character varying(50)::text = unregsub.release_id::text 
			AND d.material::text = unregsub.organization_substance::text)
and x.id = '88.197';

88.197	Gasoline


select * from sd_release.v_ust_release_substance ;


select organization_value, cause, v.*
from v_release_mapping a join causes c on a.epa_value = c.cause
	left join sd_release.v_ust_release_cause v on c.cause_id = v.cause_id 
where release_control_id = 4 and  epa_column_name = 'cause_id'
and v.release_id is null;

select organization_value, epa_value
from v_release_mapping
where release_control_id = 4 and  epa_column_name = 'cause_id'
order by organization_value

select * from sd_release.v_ust_release_cause where release_id in (select release_id from sd_release.erg_unregulated_releases )


select length('Unreg rows ust_release_substances')



select "release_id", "organization_substance", "epa_substance", "unregulated_reason"
from sd_release.erg_unregulated_substances order by 1;

select * from sd_release.erg_unregulated_substances

select * from sd_release.vw_erg_substance_mapping 
where org_substance = '';


select material from sd_release.spill_reports_all where id = '2001177'



delete from sd_release.erg_unregulated_releases 
where unregulated_reason in ('Heating oil','Non-regulated substance');

delete from sd_release.erg_unregulated_substances
where unregulated_reason in ('Heating oil','Non-regulated substance');


select * from v_release_mapping where epa_value = 'Oil water separator contents'

select * from sd_release.erg_material_datarows_deagg where material = 'oil/water separator'

select * from sd_release.erg_unregulated_substances where release_id = '2000.149'

select * from sd_release.erg_unregulated_releases where release_id = '2000.149'


select epa_table_name, epa_column_name, database_lookup_table, database_lookup_column   
from public.v_release_available_mapping
where release_control_id = 4
and epa_table_name <> 'ust_compartment_substance'
order by table_sort_order, column_sort_order
