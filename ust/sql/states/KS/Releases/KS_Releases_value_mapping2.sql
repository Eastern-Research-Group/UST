------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_release_substance.substance_id

--select distinct "substance" from ks_release."erg_substance_datarows_deagg" where "substance" is not null order by 1;
/* Organization values are:

#2 diesel
#2 diesel fuel
#2 diesel oil
#2 fuel oil
#2 Fuel Oil
#5 fuel oil
#5 Fuel Oil & #2 Fuel Oil
#6 fuel
#6 fuel oil
?
0
acetone
alcohol & solvent
ant. free
antifreeze
asphalt oil
av-gas
av-gas 100 low-lead
av fuels
av gas
AV Gas & Jet Fuel
av. gas
ave-gas
ave - gas
avgas
avgas (100 octane)
aviation & jet fuel
aviation fuel
aviation fuel ?
aviation fuel/gasoli
aviation gas
Aviation Gas
aviation gas/gasolin
aviation gasoline
bad fuel
benzene
black printing ink
btex
btex/pce/tce
Bunker C
bunker c fuel oil
bunker oil
butonone
clear diesel
Clear Diesel
condensate
condensate & waste o
deisel fuel
dgasoline/diesel
diesel
Diesel
diesel-fuel oil
Diesel-Low Sulfur
diesel 
diesel #2
diesel & gas
Diesel & gas
diesel & gasoline
Diesel & Kerosene
diesel & used oil
diesel & waste oil
diesel & water
diesel (#2)
diesel (red dye)
diesel / gasoline
diesel and gas
Diesel and Gasoline
diesel fue
Diesel Fuel
diesel fuel #2
diesel fuel & gas
diesel fuel & gasoli
Diesel Fuel & Gasoline
diesel fuel (#2)
diesel fuel oil
diesel fuel/gasoline
diesel fuel/motor oi
diesel no 2
diesel or kerosene
diesel,
diesel,gasoline
diesel,kerosene,gaso
diesel,waste oil
diesel/ gas
diesel/#2 fuel oil
diesel/fuel oil
Diesel/Gas?
diesel/gasoline
Diesel/gasoline
Diesel/Kerosene
diesel/waste oil
diesel?
dissolved gas
drip oil
Dyed Diesel
Dyed diesel fuel
E15 - 15% Ethanol
ehtyl?
ethyl/gasoline
fuel
fuel-diesel
fuel oil
Fuel Oil
fuel oil #2
fuel oil #6
fuel oil (diesel)
fuel oil ?
fuel oil/ gas
Fuel oil/diesel
fuel oil?
fuel,kerosen,solvent
ga
gas
Gas
Gas-Diesel
gas-waste oil
gas  & diesel
gas & diesel
Gas & Diesel
gas & diesel fuel
Gas & Oil
gas & possibly diese
gas & used motor oil
gas & waste oil
gas (old)
gas ?
gas and diesel
Gas and Diesel
gas and used oil
Gas and/or diesel
gas or diesel
gas or solv napthe
gas&possibly diesel
gas,
gas,diesel
gas,diesel,waste oil
gas/diesel
Gas/Diesel
gas/diesel/kerosene
gas/diesel/used oil
gas/diesel/waste oil
gas/used oil
gas; diesel
gas?
gas0line
gasline
gasohol
Gasohol
gasohol/kerosene
gasoine
gasolinbe
gasoline
Gasoline
gasoline-diesel
Gasoline-Diesel
gasoline-diesel fuel
gasoline-diesel oil
gasoline-kerosene
gasoline-prem ul
gasoline-unleaded
gasoline - diesel fu
gasoline & #2 diesel
gasoline & ?
gasoline & diesel
Gasoline & Diesel
gasoline & fuel oil
gasoline & hydraulic
gasoline & kerosene
gasoline & kerosine
gasoline & oil
Gasoline & Oil
Gasoline & Used Oil
gasoline & waste oil
gasoline &/or diesel
gasoline (kerosene?)
gasoline (premium)
Gasoline (Premium)
gasoline (unleaded)
gasoline / diesel
gasoline /diesel
gasoline 50
gasoline and diesel
Gasoline and diesel
Gasoline and Diesel
gasoline diesel
gasoline from lines
gasoline or diesel
gasoline suspected
gasoline w/ diesel
gasoline,diesel
gasoline,heating oil
gasoline,kerosene
gasoline,waste oil
gasoline/ waste oil
gasoline/?
gasoline/diesel
Gasoline/diesel
Gasoline/Diesel
gasoline/diesel ??
gasoline/diesel fuel
gasoline/diesel/oil?
gasoline/fuel oil
gasoline/heating oil
gasoline/kerosene
Gasoline/Kerosene
gasoline/kerosine
gasoline/poss diesel
gasoline/used oil
Gasoline/used oil
Gasoline/Used Oil
gasoline/waste oil
gasoline?
gasoline\diesel
gasoline0
Gasolone
gassy smelling water
gsasoline
heating fuel
Heating fuel oil
heating oil
Heating oil
Heating Oil
Heavy Oil (Unknown)
hexane
high sulphur diesel
Jet A-aviation fuel
jet a fuel
jet fue
jet fuel
Jet Fuel
jet/aviation fuel
jp-4
jp-4 jet fuel
kerosene
Kerosene
kerosene or diesel
kerosene/gasoline
kerosene?
kerosine
kerosine & gasoline
leaded gasoline
low lead ave gas
lube and waste oil
lube oil
lube oil & fuel
mabye kerosene
methylmethacrylite m
Mid-Grade Gas
mid-grade gasoline
mid-grade unleaded
mineral spirits
mixed petroleum
mogas
mogas/diesel/gas
motor oil
Motor Oil
Motor oil & diesel
n/a
nat gas condensate
natural gas condensa
navgas
new oil
nl gasoline
no lead gasoline
none
oil
Oil
oil&condensate&water
Other
overfill/spilled
petro hydrocarbons
petro product
petro products
petrol hydrocarbons
petroleum
Petroleum
Petroleum (gasoline)
Petroleum hydrocarbons
petroleum naptha
petroleum products
Petroluem
possibly diesel
prem unleaded
Premium
Premium Diesel
Premium Fuel
Premium Gas
premium unleaded
Premium Unleaded
Premium Unleaded Gas
refined petrol.
refined petroleum
reg. gasoline
regular gas
regular gasoline
See attached
solvent
solvent,gasoline
solvents
stoddard solvent
super unleaded
ukwn
Ultra low sulfur
Undetermined oil
unknown
Unknown
unknown/possibly gas
unkown
unlead gasoline
unleaded
Unleaded (Premium)
unleaded gas
unleaded gas/leaded
unleaded mid-grade
unleaded&gasoline
used engine oil
used motor oil
Used motor oil
used oil
Used oil
Used Oil
used oil and diesel
used oil gasoline
used oil,trans fluid
Used Oil/Gasoline
various avia fuel
various avia. fuels
w.o. ?
waste compressor oil
waste motor oil
waste oil
Waste Oil
waste oil & antifree
waste oil & fuel oil
waste oil & gas
waste oil & gasoline
waste oil & solvent
waste oil/condensate
waste oil/gasoline
waste oil/solvent
waste oil\solvent\fu
waster oil
water
water into tank
weathered petroleum
wo
xylene
 */


select distinct "substance" from ks_release."erg_substance_datarows_deagg" 
where "substance" is not null 
and substance like '%/%'
order by 1;

select distinct "substance" from ks_release."erg_substance_deagg" 
--where "substance" is not null 
--and substance like '%-%'
order by 1;




delete from ks_release."erg_substance_deagg" 
where substance = '?' or substance = '0' or substance = ''

['n/a','aviation fuel/gasoli','aviation gas/gasolin','btex/pce/tce','ethyl/gasoline','jet/aviation fuel','unknown/possibly gas','overfill/spilled','waste oil\\solvent\\fu','/or diesel']

insert into ks_release."erg_substance_deagg" (substance) values ('n/a');
insert into ks_release."erg_substance_deagg" (substance) values ('aviation fuel/gasoli');
insert into ks_release."erg_substance_deagg" (substance) values ('aviation gas/gasolin');
insert into ks_release."erg_substance_deagg" (substance) values ('btex/pce/tce');
insert into ks_release."erg_substance_deagg" (substance) values ('ethyl/gasoline');
insert into ks_release."erg_substance_deagg" (substance) values ('jet/aviation fuel');
insert into ks_release."erg_substance_deagg" (substance) values ('unknown/possibly gas');
insert into ks_release."erg_substance_deagg" (substance) values ('overfill/spilled');
insert into ks_release."erg_substance_deagg" (substance) values ('waste oil\solvent\fu');
insert into ks_release."erg_substance_deagg" (substance) values ('/or diesel');

select * from ks_release."erg_substance_deagg"
where substance <> any(
array['n/a','aviation fuel/gasoli','aviation gas/gasolin','btex/pce/tce','ethyl/gasoline','jet/aviation fuel','unknown/possibly gas','overfill/spilled','waste oil\\solvent\\fu','/or diesel'])


select organization_column_name
from public.release_element_mapping  
where release_control_id = 23 and epa_table_name = 'ust_release_substance'
and organization_column_name <> 'substance' and organization_table_name = 'v_release_substance'

select '"' || column_name || '"'
from information_schema.columns 
where table_schema = 'ks_release' 
and table_name = 'erg_substance_datarows_deagg'
and column_name <> 'substance' 
order by ordinal_position;


select count(*) from ks_release.erg_substance_datarows_deagg



delete 
select * from ks_release.erg_substance_datarows_deagg 
where substance like '%/ %' 
and substance <> any(array['n/a','aviation fuel/gasoli','aviation gas/gasolin','btex/pce/tce','ethyl/gasoline','gasoline w/ diesel','jet/aviation fuel','unknown/possibly gas','overfill/spilled','waste oil\\solvent\\fu','/or diesel'])


select substance, count(*) 
from ks_release.erg_substance_deagg 
group by substance having count(*) > 1;


select release_id, substance, count(*) 
from ks_release.erg_substance_datarows_deagg 
group by release_id, substance having count(*) > 1;


insert into ks_release.erg_substance_datarows_deagg (release_id, substance)
select 'CAES-SRD0-3PZ', 'gas' where not exists (select 'CAES-SRD0-3PZ', 'gas' from ks_release.erg_substance_datarows_deagg)

select * from ks_release.erg_substance_deagg 
where substance like '%/ %'

select * from ks_release.v_release_substance where substance like '%w/%'

insert into ks_release.erg_substance_deagg (substance) values ('gasoline w/ diesel')

insert into ks_release.erg_substance_datarows_deagg (release_id, substance) values ('WWP4-X1B3-CEM', 'gasoline w/ diesel')

select * from  ks_release.erg_substance_datarows_deagg
where substance like '%/ %'

WWP4-X1B3-CEM	gasoline w/ diesel

select distinct substance from ks_release.v_release_substance order by 1;

select * from ks_release.erg_substance_deagg 


select distinct substance
from ks_release.v_release_substance 
where substance like any(array['%, %', '%,%', '% / %', '%/ %', '% /%', '%/%','% & %', '%& %', '% &%', '%&%'])
order by 1;

select distinct substance
from ks_release.v_release_substance 
where substance like any(array['%, %', '%,%', '% / %'])
order by 1;

['']

[', ', ',', ' / ', '/ ', ' /', '/',' & ', '& ', ' &', '&']
['%, %', '%,%', '% / %', '%/ %', '% /%', '%/%','% & %', '%& %', '% &%', '%&%']

SELECT *
FROM your_table
WHERE your_column NOT LIKE ALL(ARRAY['%pattern1%', '%pattern2%', '%pattern3%'])


select distinct "quantity_released","release_id","unit", "substance" 
 from ks_release."v_release_substance" 
 where "substance" is not null and "substance" like '%, %'
 and "substance" <> any(ARRAY['n/a','aviation fuel/gasoli','aviation gas/gasolin','btex/pce/tce','ethyl/gasoline','gasoline &/or diesel','gasoline w/ diesel','jet/aviation fuel','unknown/possibly gas','overfill/spilled','waste oil\solvent\fu'])
 order by 1, 2;


select * from ks_release.erg_substance_datarows_deagg
where substance not in (select substance from ks_release.erg_substance_deagg)

select count(*) from ks_release.erg_substance_datarows_deagg

select * from ks_release.v_release_substance where release_id = '00NS-61B7-TZW'

select * from ks_release.erg_substance_datarows_deagg 
where release_id = '1QDE-A53K-PA3'

insert into ks_release.erg_substance_datarows_deagg ("quantity_released","release_id","unit", "substance") 
				          select  'Minimal',  '1QDE-A53K-PA3',  'gallons',  'Ultra low sulfur, Diesel' where not exists
(select 1 from ks_release.erg_substance_datarows_deagg
where  "quantity_released" = 'Minimal' and  "release_id" = '1QDE-A53K-PA3' and  "unit" = 'gallons' and  "substance" = 'Ultra low sulfur')


insert into ks_release.erg_substance_datarows_deagg ("quantity_released","release_id","unit", "substance") 
 select 'Minimal', '1QDE-A53K-PA3', 'gallons', 'Ultra low sulfur'
where not exists
	(select 1 from ks_release.erg_substance_datarows_deagg
	where quantity_released = 'Minimal' and release_id = '1QDE-A53K-PA3' and unit = 'gallons' and substance = 'Ultra low sulfur');

insert into ks_release.erg_substance_datarows_deagg ("quantity_released","release_id","unit", "substance") 
 select 'Minimal', '1QDE-A53K-PA3', 'gallons', 'Ultra low sulfur'
where not exists (select 'Minimal', '1QDE-A53K-PA3', 'gallons', 'Ultra low sulfur' from ks_release.erg_substance_datarows_deagg);


select count(*) from ks_release."v_release_substance" 
where "substance" is not null;
"substance" like '%, %'

select * from ks_release.erg_substance_deagg 

update ks_release.erg_substance_deagg set substance = trim(substance)

insert into ks_release.erg_substance_deagg ("substance") 

select distinct "substance" from ks_release.v_release_substance
where "substance" not like all(ARRAY['%, %','%,%','% / %','%/ %','% /%','%/%','% & %','%& %','% &%','%&%'])

 on conflict("substance") do nothing;




select * from ks_release.erg_substance_datarows_deagg 
where substance like '%, %'

select * from ks_release.erg_substance_datarows_deagg 
where release_id = '2DAV-5684-V7Q'

Gas
Gas

alter table ks_release.erg_substance_datarows_deagg rename to erg_substance_datarows_deagg_old

select distinct quantity_released, release_id, unit, substance 
into ks_release.erg_substance_datarows_deagg
from ks_release.erg_substance_datarows_deagg_old;

delete from ks_release.erg_substance_datarows_deagg where substance like '%; %'

select * from ks_release.v_release_substance where substance like 'Other, n%'

update ks_release.erg_substance_datarows_deagg set substance = 'Other' where substance = 'Other, n'

insert into ks_release.erg_substance_datarows_deagg  values (null, '2DAV-5684-V7Q', null, 'diesel');
insert into ks_release.erg_substance_datarows_deagg  values (null, '2DAV-5684-V7Q', null, 'used oil');

update ks_release.erg_substance_datarows_deagg set quantity_released = null where quantity_released = 'None'

select * from ks_release.erg_substance_datarows_deagg 
where substance like '%; %' order by 4;

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('Z8JG-J4AA-HX5','diesel');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('Z8JG-J4AA-HX5','gas');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('18J7-TZV0-3T0','diesel');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('18J7-TZV0-3T0','gas');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('TZH7-Q4RF-VCG','Diesel');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('TZH7-Q4RF-VCG','Gasoline');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('F2D8-TZBB-J7Q','diesel');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('F2D8-TZBB-J7Q','gas');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('488B-19SK-MQQ','diesel');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('488B-19SK-MQQ','gas');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('EWA9-S4CC-017','diesel');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('EWA9-S4CC-017','gas');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('A4RP-5C1C-9MF','gas');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('A4RP-5C1C-9MF','used oil');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('CAJ9-0GGZ-9MK','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('CAJ9-0GGZ-9MK','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('2668-V265-01P','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('2668-V265-01P','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('3J74-8YST-VW8','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('3J74-8YST-VW8','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('7MR9-7G3Z-ZC4','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('7MR9-7G3Z-ZC4','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('89PA-YSKJ-DYQ','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('89PA-YSKJ-DYQ','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('NQAP-07Z2-F76','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('NQAP-07Z2-F76','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('EA2T-TC6S-AMH','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('EA2T-TC6S-AMH','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('NCN0-BZ64-BAY','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('NCN0-BZ64-BAY','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('A6K8-H0V4-KN3','gasoline');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('A6K8-H0V4-KN3','diesel');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('ZA8T-HDXK-Z8E','lube');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('ZA8T-HDXK-Z8E','waste oil');

insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('FCHS-QX2H-28C','used oil');
insert into  ks_release.erg_substance_datarows_deagg (release_id, substance) values ('FCHS-QX2H-28C','diesel');

delete from ks_release.erg_substance_datarows_deagg where substance like '% and %'


select * from substances;

gasoline & kerosene
gasoline & kerosine
gasoline & oil
Gasoline & Oil
Gasoline & Used Oil
gasoline & waste oil
gasoline &/or diesel
kerosine & gasoline
lube oil & fuel
Motor oil & diesel
oil&condensate&water
unleaded&gasoline
waste oil & antifree
waste oil & fuel oil
waste oil & gas
waste oil & gasoline
waste oil & solvent

select * from ks_release.erg_substance_deagg 
where substance  like '%&%'

delete from ks_release.erg_substance_deagg 
where substance  like '%,%'

select count(*) from  ks_release.erg_substance_deagg 
351

select * from ks_release.erg_substance_deagg  order by 1 desc;

trans fluid
kerosen
gaso


select organization_value, epa_value, programmer_comments
from v_release_element_mapping 
where release_control_id = 23 and epa_column_name = 'substance_id'
order by 1;

select distinct substance
from ks_release.erg_substance_datarows_deagg
where substance not in (select organization_value from v_release_element_mapping 
where release_control_id = 23 and epa_column_name = 'substance_id') 
order by 1;

#2 diesel fuel
#2 Fuel Oil
#5 fuel oil
#5 Fuel Oil
#6 fuel
a
ant. free
antifree
aviation

selct




/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#2 diesel fuel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#2 Fuel Oil', 'Heating oil/fuel oil 2', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#5 fuel oil', 'Heating oil/fuel oil 5', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#5 Fuel Oil', 'Heating oil/fuel oil 5', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#6 fuel', 'Heating oil/fuel oil 6', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'a', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'ant. free', 'Antifreeze', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'antifree', 'Antifreeze', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'aviation', 'Aviation gasoline', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Aviation Gas', 'Aviation gasoline', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'clear diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Clear Diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'deisel fuel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel #2', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel ??', 'Diesel fuel (b-unknown)', null);

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fue', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fuel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel Fuel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fuel #2', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel or kerosene', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel,', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel?', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Dyed Diesel', 'Off-road diesel/dyed diesel', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Fuel oil', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Fuel Oil', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel oil (diesel)', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel oil ?', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel oil?', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas-Diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas-waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas ?', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas and', 'Gasoline (unknown type)', null);

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas or diesel', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas or solv napthe', 'Gasoline (unknown type)', null);

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas?', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas?', 'Gasoline (unknown type)', null);

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasohol', 'Ethanol blend gasoline (e-unknown)', null);

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoine', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline-Diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-diesel fuel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-diesel oil', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline - diesel fu', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline (kerosene?)', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline (premium)', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline (Premium)', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline 50', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline from lines', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline or diesel', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline suspected', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline?', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline\\diesel', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline0', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'heating fuel', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Heating oil', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Heating Oil', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Heavy Oil (Unknown)', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Jet Fuel', 'Jet fuel A', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'jp-4 jet fuel', 'Jet fuel B', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosen', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosene or diesel', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosene?', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'lube and waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'mabye kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Motor oil', 'Lube/motor oil (new)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Motor Oil', 'Lube/motor oil (new)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'none', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Oil', 'Lube/motor oil (new)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'oil?', 'Lube/motor oil (new)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'or diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Petroleum', 'Petroleum product', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'petroleum naptha', 'Solvent', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Petroluem', 'Petroleum product', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'poss diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'possibly diese', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'possibly diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Premium', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Premium Unleaded', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'reg. gasoline', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'regular gas', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'regular gasoline', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'See attached', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Ultra low sulfur', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded gas', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded mid-grade', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Used motor oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Used Oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'used oil and diesel', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'used oil gasoline', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'w.o. ?', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste compressor oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Waste Oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil\solvent\fu', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'xylene', 'Petroleum product', null);


alter table oust_ust_value_mapping alter column excel_tab_name  drop not null;

select * from oust_ust_value_mapping

select * from oust_release_value_mapping

--select substance from public.substances order by substance_group, substance;
/* Valid EPA values are:

Aviation biofuel
Aviation gasoline
Biojet (diesel)
Jet fuel A
Jet fuel B
Sustainable aviation fuel/aviation fuel blend
Unknown aviation gas or jet fuel
100% biodiesel (B100, not federally regulated)
80% renewable diesel, 20% biodiesel
95% renewable diesel, 5% biodiesel
99.9 percent renewable diesel, 0.01% biodiesel
ASTM D975 diesel (known 100% renewable diesel)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blend containing greater than 20% and less than 99% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (ASTM D975), can contain 0-5% biodiesel
Diesel fuel (b-unknown)
Diesel fuel (known to contain 0% biodiesel)
Off-road diesel/dyed diesel
Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less
Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel
E-85/Flex Fuel (E51-E83)
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Gasoline/ethanol blend containing more than 83% and less than 98% ethanol
Gasoline/ethanol blends E16-E50
Leaded gasoline
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Hydraulic oil
Lube/motor oil (new)
Used oil/waste oil
Antifreeze
Denatured ethanol (98%)
Diesel exhaust fluid (DEF, not federally regulated)
Hazardous substance
Kerosene
Marine fuel
MTBE
Non-federally regulated substance (general)
Other or mixture
Petroleum product
Solvent
Unknown

 * NOTE: Hazardous substances can be found in view public.v_hazardous_substances.
 * If the state included a CAS No., you can also try mapping it to public.v_casno.

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.substances to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_release_source.source_id

--select distinct "source" from ks_release."erg_source_deagg" where "source" is not null order by 1;
/* Organization values are:

Delivery
Dispenser
Other
Piping
Spill
Spill/Overfill
Sump pump area
Tank
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (573, 'Spill', 'Other', null);


--select source from public.sources;
/* Valid EPA values are:

Dispenser
Piping
Submersible turbine pump
Tank
Other
Unknown
Delivery problem

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'source_id'
and lower(organization_value) like lower('%spill%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.sources to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
