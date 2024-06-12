select distinct "SubstanceReleased1" from "NE_LUST".ne_lust order by 1;

select * from "NE_LUST".lust where "SiteName" is null;

select count(*) from "NE_LUST".lust 

select * from "NE_LUST".lust 

drop sequence "NE_LUST".seq_lustid;
create sequence "NE_LUST".seq_lustid start with 1;
 

select "FacilityID", "SiteName", "SiteAddress",
	case when "SiteName" is not null then 'SC_' || substring("SiteName",1,40) || '_' || nextval('"NE_LUST".seq_lustid')
	     when "FacilityID" is not null then 'SC_' || substring("FacilityID",1,40) || '_' || nextval('"NE_LUST".seq_lustid')
	     when "SiteAddress" is not null then 'SC_' || substring("SiteAddress",1,40) || '_' || nextval('"NE_LUST".seq_lustid')
	     else 'SC_' || nextval('"NE_LUST".seq_lustid') end as "LUSTID"
from "NE_LUST".lust 

select * from "NE_LUST".ne_lust 

----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-04-26', 'SubstanceReleased1', 'SubstanceReleased1_deagg', 'SubstanceReleased1')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-04-26', 'SubstanceReleased2', 'SubstanceReleased1_deagg', 'SubstanceReleased1')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-04-26', 'SubstanceReleased3', 'SubstanceReleased1_deagg', 'SubstanceReleased1')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-04-26', 'SubstanceReleased4', 'SubstanceReleased1_deagg', 'SubstanceReleased1')
returning id;
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-04-26', 'SubstanceReleased5', 'SubstanceReleased1_deagg', 'SubstanceReleased1')
returning id;

select distinct "SubstanceReleased1" from "NE_LUST"."SubstanceReleased1_deagg" order by 1;


select * from lust_element_db_mapping order by 1 desc;

select * from substances 
where lower(substance) like '%10%';

select * from substances

select * from ust_element_value_mappings where lower(state_value) like '%ethan%'

--select distinct 
--'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, ''' || "SubstanceReleased1" ||  ''', '''');'
--from "NE_LUST"."SubstanceReleased1_deagg"
--order by 1;  

insert into  lust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
select 81, state_value, epa_value
from lust_element_value_mappings 
where element_db_mapping_id = 80;

insert into  lust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
select 82, state_value, epa_value
from lust_element_value_mappings 
where element_db_mapping_id = 80;

insert into  lust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
select 82, state_value, epa_value
from lust_element_value_mappings 
where element_db_mapping_id = 80;

insert into  lust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
select 83, state_value, epa_value
from lust_element_value_mappings 
where element_db_mapping_id = 80;

insert into  lust_element_value_mappings (element_db_mapping_id, state_value, epa_value)
select 84, state_value, epa_value
from lust_element_value_mappings 
where element_db_mapping_id = 80;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#1 DIESEL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#1 OR #2 HEATING FUEL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#2 DIESEL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#2 DIESEL FUEL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#2 DIESEL OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#2 FUEL OIL','Heating oil/fuel oil 2');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#2 FUEL OILS','Heating oil/fuel oil 2');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#2 OIL & TRANSFORMER OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#6','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '#6 FUEL OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '& KEROSENE','Kerosense');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '& WASTE OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '1,2-DICHLOROETHANE','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '190 PROOF ALCOHOL','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, '80-100 OCTANE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ACEOTONE','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ACETONE','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AG DIESEL & UNLEADED','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ALCOHOL','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AND UNK','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AND WASTE OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ANIT-FREEZE,NEW AND USED OIL','Antifreeze');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ANTIFREEZE','Antifreeze');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ARSENIC','Hazardous substance');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ASPHALT OIL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AUTOMATIC TRANSMISSION FLUD','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AV-100 GASOLINE','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AV FUEL','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AV GAS','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AV GAS AND JET FUEL','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AV. GAS','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVGAS','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVIATION','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVIATION FUEL','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVIATION GAS','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVIATION GAS & JET A FUEL','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVIATION GASOLINE','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVIATION GASOLINE & JET FUEL A','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'AVIATION GASOLINE 100LL','Aviation gasoline');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BARIUM','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BARSO','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BARSOL 100 SOLVENT','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BENZENE','Petroleum products');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BENZENE AND XYLENE','Petroleum products');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BIO-DIESEL FUEL','Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BIODIESEL','Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BLACK OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BTX','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'BUSAN 1127 & MINERAL SPIRITS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'CASOLINE AND/OR FUEL OILS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'CINDOL 3402','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'CLEANING SOLVENT','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'COMPR OIL & CONDENSER WATER','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'CUTTING OIL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'CUTTING OIL - VIRGIN PRODUCT','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DEICING FLUID','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DENATURED W/DIESL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEEL AND GASOLINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL #2','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL #2 (HAS BEEN #6 IN PAST','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & #2 FUEL OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & GAS','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & GASOHOL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & GASOLINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & GASOLINE KEROSENE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & KEROSENE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & LUBE OIL GASOLINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & LUBE OILS','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & POSSIBLY GASOLINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & USED OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL & WASTE OIL?','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL (FUEL OIL)','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL (GASOLINE?)','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL (HEATING)','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND (KEROSENE OR GAS)','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND FUEL OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND GAS','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND GAS -WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND GASOHOL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND GASOLINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND HEATING OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND KEROSENE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND MINERAL SPIRITS','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND/OR GAS','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL AND/OR WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL FOR BACKUP GENERATOR','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL FOR STANDBY GENERATOR','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL FUEL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL FUEL #2','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL FUEL & KEROSENE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL FUEL FO-10','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL FUEL/HEATING OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL GAS KEROSENE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL GAS WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL GASOLINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL GASOLINE WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL OIL AND WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL OR WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL WASTE OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL(HEATING OIL)','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL)','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL,GAS,WASTE&MOTOROIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL,KEROSENE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL/FUEL OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL/GASOLINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL/HEATING OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL/KEROSINE','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DIESEL?','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DISTILLED GRAIN','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DRAIN OIL (?)','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DRY CLNG FLUID','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'DYED DIESEL','Off-road diesel/dyed diesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'E-85 GASOLINE','E-85/Flex Fuel (E51-E83)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'E10','Gasoline E-10 (E1-E10)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ENGINE AND TRANSMISSION OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ETC','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ETHANOL','Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ETHANOL & DIESEL','Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ETHYL ALCOHOL','Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ETHYLENE GLYCOL','Ethanol blend gasoline (e-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FIBERGLASS RESIN','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FOR GENERATOR','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FREE FLOATING PROD (GAS/DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL AND HEATING OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OIL #5','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OIL (SUSPECTED)','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OIL AND WASTE OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OIL FOR HEATING','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OIL OR KEROSENE','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OIL WASTE OIL DIESEL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL OILS','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUEL TANKS','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'FUMES','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'G,D,WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS - LEADED & UNLEADED','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS -5 TANKS DIESEL - 1 TANK','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & DESIEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & DIESEL & OTHER DIST FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & GAS/OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & POSSIBLE AVIATION FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & UNKNOWN','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS & WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND CASED OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND OR DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND OTHER','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND USED OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND WASTE  OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS AND/OR DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL & HEATING OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL & WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL AND KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL USED OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS DIESEL WASTE OIL SPIRITS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS OR DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS OR WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS(2)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS,DIESEL,KERO,WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS,DIESEL,KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS,DIESEL,OTHER','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS,DIESEL,WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS,DIESEL,WASTE OIL,KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS,HEATING,WASTE OIL,DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS,WO,DIESEL,PAINT,BRK FLUID','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS/DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS/DIESEL/WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS/FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GAS? AND/OR DIESEL?','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASAHOL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASELINE OR DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOHAUL AND DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOHOL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOHOL & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOHOL DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOILINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOINE & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLIN','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLIN & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLIN & WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE-DIESEL-WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE - UNLEADED','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE -LEADED','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE  & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & AIRPLANE FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & CADMIUM','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & DIESE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & DIESEL FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & DIESEL RANGE PETROL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & DIESEL/KEROSONE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & ETHENOL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & FUEL OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & HEATING OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & HTG OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & MOTOR OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & MTBE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & POSSIBLY DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & RACING FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & SOLVENT','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & UNKNOWN','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & UNKNOWN PETROLEUM','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & USED OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE & WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE &/OR DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE &/OR FUEL OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE (?)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE (AVIATION GASOLINE)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE (BETX IN GW)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE (PRESUMED BY ODOR)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE / OTHER FUELS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE ?','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE + UNKNOWN','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND DIESEL-5 TANKS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND DIESEL FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND FUEL OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND HEATING OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND OTHER FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND UNKNOWN','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND USED OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE AND/OR DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE DIESEL & WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE DIESEL FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE DIESEL KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE DIESEL KEROSENE FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE DIESEL WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE FUEL OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE IN MUN. WELL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE KEROSENE USED OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE KEROSENE WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE OIL DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE OR DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE OR JET FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE SPILL 1988','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE VAPORS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE WASTE OIL DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE& DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE& WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE(& DIESEL?)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE,DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE,DIESEL,KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE,KEROSENE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE,WASTE OIL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE,WASTE OIL,DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE/DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE/DIESEL/OTHER','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE?','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINE? WASTE OIL?','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINEAND DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLINEAND FUEL OILS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASOLNE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASONLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GASSOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GEAR LUBE AND 30W OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'GIESEL AND GAS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING FUEL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING FUEL OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING O','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING OIL #2','Heating oil/fuel oil 2');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING OIL & GASOLINE','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING OIL & WASTE OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING OIL AND H2SIF6','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING OIL/ DIESEL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEATING OIL/WASTE OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEAVY FUEL OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HEXANE','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HO','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HO AND SOLVENT','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HTG OI','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HTG OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HYDRAULIC FLUID','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HYDRAULIC LIFT OIL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HYDRAULIC OIL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'HYDROCARBON','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'INK','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ISOPROPANOL & ACETONE','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ISOPROPANOL ALCOHOL','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JET FUEL','Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JET FUEL - A','Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JET FUEL - JP4 GRADE A','Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JET FUEL A','Jet fuel A');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JET FUEL JP4','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP-4','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP-4 JET FUEL','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP-5','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP 8','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP4 FUEL','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP4 JET FUEL','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP4 JET FUEL-O/W SEPARTOR','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'JP4 JET FUEL FARM','Unknown aviation gas or jet fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'K','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KERO','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSE','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSENE','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSENE & DENATURED ALCOHOL','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSENE & DIESEL','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSENE & GASOLINE','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSENE & WASTE OIL','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSENE,OIL','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSENE/WASTE OIL','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'KEROSINE','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'LEAD','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'LT NAPTHA SOLVENT','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'LUBE OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'LUBRICATION OIL & WASTE OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'METHYL CHLORIDE','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MINERAL OIL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MINERAL SPIR','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MINERAL SPIRITS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MINERAL SPIRITS,BUSAN 1127','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MOGAS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MOLASSES','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MOTOR & WASTE OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MOTOR OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MOTOR OIL & GASOLINE','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MOTOR OIL OR FUEL OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'MTBE','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NAPHTHA','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NAPHTHA & TOLUENE','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NEW MOTOR OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NEW OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NEW OIL AND WASTE OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NO LEAD','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NOT CERTAIN POS GAS & OTHERS','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'NOT REPORTED','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'OIL AND TRANSMISSION FLUID','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'OIL WATER SEP OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'OTHER','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'OTHER PETROLEUM','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PAINT','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM & PESTICIDES','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM (GAS/DIESEL)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM (HEPTANE)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM (SUSPECT DIESEL)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM (UNKNOWN)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM (WASTE OIL)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM CONT','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM CONT SIOL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM CONTAMINATION','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM FUEL NOS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM FUELS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM GAS DIESEL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM GASOLINE AND/OR DIES','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM HYDROCARBON','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM OF SOME KIND','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM POLLUTANT','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM PRODUCTS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM SOLVENT','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLEUM SOLVENTS','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PETROLUEM','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'POSS KEROSENE','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'POSSIBLE KEROSENE','Kerosene');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'POSSIBLY WASTE OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PREMIUM GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PREMIUM UNLEADED','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PROBABLE DIESEL/FUEL OIL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PROBABLY GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PROBABLY GASOLINE & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'PROBABLY HEATING OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'QUENCH OIL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'RACING FUEL','Racing fuel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'REGULAR','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'REGULAR GAS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'REGULAR GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'REGULAR LEADED','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'ROAD DIESEL','Off-road diesel/dyed diesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'RUBY RED DIESEL FUEL','Off-road diesel/dyed diesel');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SHOCK OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SOLVENT','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SOLVENT(?)','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SOLVENTS','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SOYBEAN OIL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'STODDARD 140','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'STODDARD SOLVENT','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SUPER UNLEADED GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SUSPECT FUEL OIL','Heating/fuel oil # unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'SUSPECTED GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TETRACHLOROETHENE','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'THINNER','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TOLUENE','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TRACTOR FUEL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TRANS FLU','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TRANS FLUID','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TRANSFORMER OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TRANSFORMER OIL/POSSIBLY PCB','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TRANSMISSION FLUID','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'TYPE UNKNOWN','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNCERTAIN','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNK','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNK & WASTE OIL','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNK PETROLEUM','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNK TYPE','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNK(PROBABLY GASOLINE)','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOW','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN-PETROLEUM SUSPECTED','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN-PROBABLY GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN - DIESEL','Diesel fuel (b-unknown)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN - PROBABLY PETROLEUM','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN - VOC','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN (ASSUME GASOLINE)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN (GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN (GASOLINE/DIESEL)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN (PETROLEUM)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN FUEL','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN HYDROCARBON ODOR','Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN PETROLEUM','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN PETROLEUM (?)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN PETROLEUM (SUSPECTED)','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN PETROLEUM AND WATER','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNKNOWN SOLVENT','Solvent');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNL. GAS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNL. GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED & DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED & REGULAR','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED & REGULAR GAS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED AND DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED AND REGULAR GAS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED FUEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED GAS','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED GAS AND DIESEL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED GASOLINE','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED GASOLINE (10%)','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'UNLEADED W/ ALCOHOL','Gasoline (unknown type)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'USED & NEW OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'USED OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'USED OIL & ??','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'VIRGIN MOTOR OIL','Lube/motor oil (new)');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'W/O','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WA','Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WAST','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WAST OIL GASOLINE DIESEL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE & MOTOR OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE AND OTHER OILS','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE MOTOR OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OI','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL & DIESEL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL & GAS','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL & GASOLINE','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL & HEATING OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL & HYDRAULIC OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL & NEW OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL & OTHER PETROL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL +/- GASOLINE','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL AND ASPHALT','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL AND DIESEL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL AND GAS','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL AND GASOLINE','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL AND UNKNOWN','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL DIESEL GAS','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL GAS DIESEL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL GASOLINE','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL GASOLINE DIESEL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL& GAS','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL(?) & SOLVENTS(?)','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL,GAS,DIESEL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OIL/FUEL OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE OILS & OTHER FLUIDS','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE SOLV','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE,DIESEL,FUEL OILS GASOLIN','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WASTE/MOTOR OIL','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WATER AND UNKNOWN PETROLEUM','Used oil/waste oil');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WHITE GAS','Petroleum product');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'WO','Used oil/waste oil');


----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NE', '2023-04-26', 'LUSTStatus', 'ne_lust', 'LUSTStatus')
returning id;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (85, ''' || "LUSTStatus" ||  ''', '''');'
from "NE_LUST".ne_lust
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (85, '1', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (85, 'ACTIVE', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (85, 'BACKLOGGED-STATE LEAD', 'Active: stalled');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (85, 'CLOSED-RP LEAD', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (85, 'CLOSED-STATE LEAD', 'No further action');

select * from lust_status ;

select distinct "LUSTStatus" from  "NE_LUST".ne_lust order by 1;

1
ACTIVE
BACKLOGGED-STATE LEAD
CLOSED-RP LEAD
CLOSED-STATE LEAD

--------------------------------------------------------------------------------------------------------


select distinct "MediaImpactedSoil" from  "NE_LUST".ne_lust order by 1;

select "NoFurtherActionLetterURL" from  "NE_LUST".ne_lust order by 1;

--------------------------------------------------------------------------------------------------------
select * from "NE_LUST".ne_lust;

select '"' || column_name || '",' from information_schema.columns where table_name = 'ne_lust' order by ordinal_position ;

drop view  "NE_LUST".v_lust_base;

create or replace view "NE_LUST".v_lust_base as 
select distinct 
	l."LUSTID" as "LUSTID",
	l."FacilityID" as "FacilityID",
	l."FederallyReportableRelease" as "FederallyReportableRelease",
	l."SiteName" as "SiteName",
	l."SiteAddress" as "SiteAddress",
	l."SiteCity" as "SiteCity",
	l."County" as "County",
	l."State" as "State",
	l."EPARegion" as "EPARegion",
	l."Latitude" as "Latitude",
	l."Longitude" as "Longitude",
	l."LUSTStatus" as "LUSTStatus",
	case when l."ReportedDate"::text = '00:00:00' then null else l."ReportedDate"::date end as "ReportedDate",
	case when l."NFADate"::text = '00:00:00' then null else l."NFADate"::date end as "NFADate",
	l."MediaImpactedSoil" as "MediaImpactedSoil",
	sr1.epa_value as "SubstanceReleased1",
	sr2.epa_value as "SubstanceReleased2",
	sr3.epa_value as "SubstanceReleased3",
	sr4.epa_value as "SubstanceReleased4",
	l."ClosedWithContamination" as "ClosedWithContamination"
from "NE_LUST".ne_lust l
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NE' and element_name =  'LUSTStatus') ls on l."LUSTStatus" = ls.state_value
	left join (select * from "NE_LUST"."SubstanceReleased1_deagg" where rownumber = 1) sdeagg1 on l."LUSTID" = sdeagg1."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NE' and element_name =  'SubstanceReleased1') sr1 on sdeagg1."SubstanceReleased1" = sr1.state_value
	left join (select * from "NE_LUST"."SubstanceReleased1_deagg" where rownumber = 2) sdeagg2 on l."LUSTID" = sdeagg2."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NE' and element_name =  'SubstanceReleased2') sr2 on sdeagg2."SubstanceReleased1" = sr2.state_value
	left join (select * from "NE_LUST"."SubstanceReleased1_deagg" where rownumber = 3) sdeagg3 on l."LUSTID" = sdeagg3."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NE' and element_name =  'SubstanceReleased3') sr3 on sdeagg3."SubstanceReleased1" = sr3.state_value
	left join (select * from "NE_LUST"."SubstanceReleased1_deagg" where rownumber = 4) sdeagg4 on l."LUSTID" = sdeagg4."LUSTID"
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'NE' and element_name =  'SubstanceReleased4') sr4 on sdeagg4."SubstanceReleased1" = sr4.state_value
order by "FacilityID", l."LUSTID";


select * from lust where state = 'NE';

select count(*) from "NE_LUST".v_lust_base ;

select * from "NE_LUST".v_lust_base where "SubstanceReleased4" is not null;

select "Latitude" from lust where state = 'NE' and length("Latitude"::text) < 8;

select count(*) from  lust where state = 'TN' and "Latitude" is null;


select "Latitude", length("Latitude"::text)  from lust where state = 'CA' order by 2 desc;


select pg_get_viewdef('"NE_LUST".v_lust_base', true)


drop view "NE_LUST".v_lust;

select * from pg_locks where not granted;

SELECT * FROM pg_stat_activity;


select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0;


SELECT pg_cancel_backend(a.pid), pg_terminate_backend(a.pid)
FROM( select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0) a

select pg_cancel_backend(3388), pg_terminate_backend(3388);
