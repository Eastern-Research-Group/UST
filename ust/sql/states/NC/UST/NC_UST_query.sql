insert into ust_control (organization_id, date_received, date_processed, data_source, comments)
values ('NC', '2021-12-30', '2023-06-29', 'State sent zip file containing Excel spreadsheets, CSVs, and Word documents',
'Re-processing existing data to try to get counts to more closely match OUST performance measures.');
17 


----------------------------------------------------------------------------------------------------------------------------------------------
create or replace function "NC_UST".build_facility_id(multi_facility_id text, multi_owner_id bigint, base_facility_id bigint) 
returns text 
language plpgsql
as 
$$
declare 
	p1 text := lpad(multi_facility_id,2,'0');
	p2 text := multi_owner_id::text;
	p3 text := lpad(base_facility_id::text,10,'0');
begin
	return p1 || '-' || p2 || '-' || p3;
end;
$$


select  "NC_UST".build_facility_id('0',0,224);

----------------------------------------------------------------------------------------------------------------------------------------------
create view "NC_UST".v_USTF_TANK_DETAIL_DATA_TABLE as
select b.* from 
	(select "TANK_KEY", max("INFO_SOURCE_DATE") "INFO_SOURCE_DATE"
	from "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" group by "TANK_KEY") a
	join "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" b on a."TANK_KEY" = b."TANK_KEY" and a."INFO_SOURCE_DATE" = b."INFO_SOURCE_DATE";	
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'OwnerType', 'USTF_TYPE_OWNER_CD', 'TYPE_OWNER_NAME')
returning id;

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'OwnerType';

select distinct "TYPE_OWNER_NAME" from "NC_UST"."USTF_TYPE_OWNER_CD" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (267, ''' || "TYPE_OWNER_NAME" ||  ''', '''');'
from "NC_UST"."USTF_TYPE_OWNER_CD"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (267, 'Federal-Billable', 'Federal Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (267, 'Federal-Non Billable', 'Federal Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (267, 'Local Gov''t', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (267, 'Private/Corporate', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (267, 'State Gov''t', 'State Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (267, 'Unknown', '');

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityBondRatingTest', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityGuarantee', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityLetterOfCredit', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityLocalGovernmentFinancialTest', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityRiskRetentionGroup', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilitySelfInsuranceFinancialTest', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilitySuretyBond', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityTrustFund', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityOtherMethod', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FinancialResponsibilityNotRequired', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');


select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (268, ''' || "" ||  ''', '''');'
from "NC_UST".""
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (268, 'Local Gov. Bond Rating Test', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (269, 'Corporate Guarantee', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (269, 'Local Gov. Guarantee', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (270, 'Letter of Credit', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (271, 'Local Gov. Financial Test', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (272, 'Insurance & Risk Retension', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (273, 'Self-Insurance', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (274, 'Surety Bond', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (275, 'Private Trust Fund', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (276, 'Insurance Pools', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (276, 'Local Gov. Dedicated Fund', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (277, 'None', 'Yes');

select * from "NC_UST"."USTF_FINANCIAL_MECH_CD"
0	None
1	Corporate Guarantee
2	Insurance & Risk Retension
3	Surety Bond
4	Letter of Credit
5	Insurance Pools
6	Private Trust Fund
7	Local Gov. Bond Rating Test
8	Local Gov. Financial Test
9	Local Gov. Guarantee
10	Local Gov. Dedicated Fund
11	Self-Insurance

select a."FACILITY_KEY", b."DESCRIPTION"
from "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE" a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b 
	on a."FINANCIAL_RESPONSIBILITY" = b."FINANCIAL_MECH_KEY"

	
	select * from ust_element_db_mapping order by 1 desc;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_FACILITY_DATA_TABLE', state_join_column = 'FINANCIAL_RESPONSIBILITY'
where control_id = 17 and element_name like 'Financial%'


select element_db_mapping_id, element_name, state_value, epa_value
from v_ust_element_mapping where organization_id = 'NC' and element_name like 'Finan%';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FederallyRegulated', 'USTF_TANK_DETAIL_DATA_TABLE', 'REGULATED')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (278, '1', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (278, '0', 'No');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'TankStatus', 'USTF_TANK_STATUS_CD_DATA_TABLE', 'TANK_STATUS_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'TANK_STATUS_KEY' where id = 279;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (279, ''' || "TANK_STATUS_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_TANK_STATUS_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (279, 'Abandoned', 'Abandoned');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (279, 'Chg. In Service', 'Closed (general)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (279, 'Current', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query) values (279, 'Intent to Install', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query) values (279, 'Never Installed', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (279, 'Removed', 'Closed (removed from ground)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (279, 'Temporarily Closed', 'Temporarily out of service');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query) values (279, 'Transfer', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (279, 'Unknown', 'Unknown');

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%TANK%STATUS%'
and table_name not like 'VW%'
order by 1, 2;

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'TankStatus';

select * from v_ust_element_mapping where element_name = 'TankStatus';

USTF_TANK_DETAIL_DATA_TABLE	TANK_STATUS_KEY
USTF_TANK_STATUS_CD_DATA_TABLE	TANK_STATUS_KEY
USTF_TANK_STATUS_CD_DATA_TABLE	TANK_STATUS_NAME
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'MultipleTanks', 'USTF_TANK_DETAIL_DATA_TABLE', 'MANIFOLD_TANK')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (280, '1', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (280, '0', 'No');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'CompartmentalizedUST', 'USTF_TANK_DETAIL_DATA_TABLE', 'COMPARTMENT_TANK')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (281, '1', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (281, '0', 'No');

select distinct "COMPARTMENT_TANK" from  "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'TankSubstanceStored', 'USTF_PRODUCT_CD_DATA_TABLE', 'PRODUCT_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'PRODUCT_KEY' where id = 282;

select * from ust_element_db_mapping where id in (279,282);

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, ''' || "PRODUCT_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_PRODUCT_CD_DATA_TABLE"
order by 1;	


select * from "NC_UST"."USTF_PRODUCT_CD_DATA_TABLE"

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Fuel Oil', 'Heating/fuel oil # unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Gasoline, Aviation', 'Aviation gasoline');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Gasoline, Gas Mix', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Gear/Lube Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Heating Oil/Fuel', 'Heating/fuel oil # unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Hydraulic Fluid', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Kerosene, Aviation', 'Kerosene');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Kerosene, Kero Mix', 'Kerosene');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'LP/Propane Gas', 'Petroleum product');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Mineral Oil', 'Solvent');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Motor Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Natural Gas', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Oil, New/Used/Mix', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Other, Hazardous', 'Hazardous substance');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Other, Non-Petroleum', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Other, Petroleum', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Petroleum', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Transmission Fluid', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (282, 'Unknown', 'Unknown');

select * from substances order by 2;

select * from v_ust_element_mapping where lower(state_value) like '%transmis%'

select state_value, epa_value
from v_ust_element_mapping where organization_id = 'NC' and element_name = 'TankSubstanceStored'
order by 1;

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%PRODUCT%'
and table_name not like 'VW%'
order by 1, 2;


select * From 

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'TankWallType', 'USTF_TANK_CONST_CD_DATA_TABLE', 'TANK_CONSTR_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'TANK_CONSTR_KEY' where id = 283;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, ''' || "TANK_CONSTR_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_TANK_CONST_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Double Wall FRP', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Double Wall Steel', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Double Wall Steel/FRP', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Double Wall Steel/Jacketed', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Double Wall Steel/Polyurethane', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Single Wall FRP', 'Single');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Single Wall Steel', 'Single');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Single Wall Steel/FRP', 'Single');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Single Wall Steel/Polyurethane', 'Single');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (283, 'Unknown', 'Unknown');

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'TankWallType';

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%TANK%CON%'
and table_name not like 'VW%'
order by 1, 2;

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'MaterialDescription', 'USTF_TANK_CONST_CD_DATA_TABLE', 'TANK_CONSTR_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'TANK_CONSTR_KEY' where id = 284;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, ''' || "TANK_CONSTR_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_TANK_CONST_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Double Wall FRP', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Double Wall Steel', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Double Wall Steel/FRP', 'Composite/clad (steel w/fiberglass reinforced plastic)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Double Wall Steel/Jacketed', 'Jacketed steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Double Wall Steel/Polyurethane', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Single Wall FRP', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Single Wall Steel', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Single Wall Steel/FRP', 'Composite/clad (steel w/fiberglass reinforced plastic)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Single Wall Steel/Polyurethane', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (284, 'Unknown', 'Unknown');

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'MaterialDescription';

select * from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE";
select * from "NC_UST"."USTF_TANK_CONST_CD_DATA_TABLE";

select * from material_description ;

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'MaterialDescription';

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'PipingMaterialDescription', 'USTF_PIPING_CONSTR_CD_DATA_TABLE', 'PIPING_CONSTR_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'PIPING_CONSTR_KEY' where id = 285;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, ''' || "PIPING_CONSTR_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_PIPING_CONSTR_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Double Wall Flex', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Double Wall FRP', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Double Wall Metal/Plastic', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Double Wall PVC', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Double Wall Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'DW Flexible Piping', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'DW Steel/FRP', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'None', 'No piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Single Wall Copper', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Single Wall Flex', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Single Wall FRP', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Single Wall Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'SW Flexible Piping', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'SW Steel/FRP', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (285, 'Unknown', 'Unknown');

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%PIP%CON%'
and table_name not like 'VW%'
order by 1, 2;

select * from piping_material_description 


select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'PipingMaterialDescription';

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'PipingFlexConnector', 'USTF_FLEX_CONNECTOR_TANK_CD_DATA_TABLE', 'FLEX_CONNECTOR_TANK_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'FLEX_CONNECTOR_TANK_KEY' where id = 286;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (286, ''' || "FLEX_CONNECTOR_TANK_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_FLEX_CONNECTOR_TANK_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (286, 'Isolation Boot', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (286, 'Not in contact w/ ground', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (286, 'Not Present', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (286, 'Sacrificial Anodes', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (286, 'Unknown', 'Unknown');

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%FLEX%'
and table_name not like 'VW%'
order by 1, 2;

select * from "NC_UST"."USTF_FLEX_CONNECTOR_TANK_CD_DATA_TABLE";

select * from ust_elements where element_name like '%Flex%'

select distinct "PipingFlexConnector" from ust where organization_id = 'NC';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'PipingStyle', 'USTF_PIPING_SYSTEM_CD_DATA_TABLE', 'PIPING_SYSTEM_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'PIPING_SYSTEM_KEY' where id = 287;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, ''' || "PIPING_SYSTEM_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_PIPING_SYSTEM_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'European Suction', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'Gravity System', 'Non-operational (e.g., fill line, vent line, gravity)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'Manifold Bar', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'No Piping', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'Pressurized System', 'Pressure');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'Suction System', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (287, 'Unknown', 'Unknown');

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%PIPING%'
and table_name not like 'VW%'
order by 1, 2;

select * from piping_style 

select * from "NC_UST"."USTF_PIPING_SYSTEM_CD_DATA_TABLE";

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'PipingStyle';
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'PipingWallType', 'USTF_PIPING_CONSTR_CD_DATA_TABLE', 'PIPING_CONSTR_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'PIPING_SYSTEM_KEY' where id = 288;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, ''' || "PIPING_CONSTR_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_PIPING_CONSTR_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Double Wall Flex', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Double Wall FRP', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Double Wall Metal/Plastic', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Double Wall PVC', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Double Wall Steel', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'DW Flexible Piping', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'DW Steel/FRP', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'None', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Single Wall Copper', 'Single walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Single Wall Flex', 'Single walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Single Wall FRP', 'Single walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Single Wall Steel', 'Single walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'SW Flexible Piping', 'Single walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'SW Steel/FRP', 'Single walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (288, 'Unknown', 'Unknown');

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%PIP%%'
and table_name not like 'VW%'
order by 1, 2;

select * from piping_wall_type 

select distinct "" from "NC_UST"."";

select * from "NC_UST"."USTF_PIPING_CONSTR_CD_DATA_TABLE";

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'PipingStyle';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'BallFloatValve', 'USTF_OVERFILL_PROTECTION_CD_DATA_TABLE', 'OVERFILL_PROTECTION_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'OVERFILL_PROTECTION_KEY' where id = 289;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (289, ''' || "OVERFILL_PROTECTION_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_OVERFILL_PROTECTION_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (289, '25 Gal or Less Transfer', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (289, 'Auto Shutoff Device',null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (289, 'Ball Float Valve', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (289, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (289, 'Overfill Alarm', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (289, 'Unknown', null);

update ust_element_value_mappings set epa_value = 'None' where element_db_mapping_id = 289  and state_value = 'None';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'FlowShutoffDevice', 'USTF_OVERFILL_PROTECTION_CD_DATA_TABLE', 'OVERFILL_PROTECTION_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'OVERFILL_PROTECTION_KEY' where id = 290;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, ''' || "OVERFILL_PROTECTION_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_OVERFILL_PROTECTION_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, '25 Gal or Less Transfer', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, 'Auto Shutoff Device','Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, 'Ball Float Valve', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, 'None', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, 'Overfill Alarm', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, 'Unknown', null);


update ust_element_value_mappings set epa_value = 'None' where element_db_mapping_id = 290  and state_value = 'None';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'HighLevelAlarm', 'USTF_OVERFILL_PROTECTION_CD_DATA_TABLE', 'OVERFILL_PROTECTION_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'OVERFILL_PROTECTION_KEY' where id = 291;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, ''' || "OVERFILL_PROTECTION_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_OVERFILL_PROTECTION_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (291, '25 Gal or Less Transfer', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (291, 'Auto Shutoff Device',null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (291, 'Ball Float Valve', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (291, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (291, 'Overfill Alarm', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (291, 'Unknown', null);

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%OVERFIL%'
and table_name not like 'VW%'
order by 1, 2;


select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'BallFloatValve';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'OverfillProtectionPrimary', 'USTF_OVERFILL_PROTECTION_CD_DATA_TABLE', 'OVERFILL_PROTECTION_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'OVERFILL_PROTECTION_KEY' where id = 292;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (290, ''' || "OVERFILL_PROTECTION_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_OVERFILL_PROTECTION_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (292, '25 Gal or Less Transfer', 'Not required');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (292, 'Auto Shutoff Device','Flow shutoff device (flapper)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (292, 'Ball Float Valve', 'Ball float valvenull');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (292, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (292, 'Overfill Alarm', 'High level alarm');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (292, 'Unknown', 'Unknown');

select * from overfill_protection ;

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'OverfillProtectionPrimary';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'SpillBucketInstalled', 'USTF_SPILL_PROTECTION_CD_DATA_TABLE', 'SPILL_PROTECTION_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'SPILL_PROTECTION_KEY' where id = 293;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (293, ''' || "SPILL_PROTECTION_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_SPILL_PROTECTION_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (293, '25 Gallons or Less Transfer', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (293, 'Catchment Basin', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (293, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (293, 'Not Required', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (293, 'Unknown', 'Unknown');

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%SPILL%'
and table_name not like 'VW%'
order by 1, 2;

select * from ust_elements where element_name = 'SpillBucketInstalled' 

select * from "NC_UST"."USTF_SPILL_PROTECTION_CD_DATA_TABLE"
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'InterstitialMonitoringContinualElectric', 'USTF_LD_INTERSTL_PIP_SYSTEM_CD', 'LD_INTERSTL_PIP_SYSTEM__NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_INTERSTL_PIP_SYSTEM_KEY' where id = 294;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (294, ''' || "LD_INTERSTL_PIP_SYSTEM__NAME"  ||  ''', '''');'
from "NC_UST"."USTF_LD_INTERSTL_PIP_SYSTEM_CD"
order by 1;	
	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (294, 'Hydrostatic', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (294, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (294, 'Pressure', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (294, 'Sump Sensor', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (294, 'Vacuum', 'No');

select * from "NC_UST"."USTF_LD_INTERSTL_PIP_SYSTEM_CD"

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%INTERS%'
and table_name not like 'VW%'
order by 1, 2;

select * from ust_elements where element_name = 'InterstitialMonitoringContinualElectric'

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'InterstitialMonitoringContinualElectric';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'InterstitialMonitoringManual', 'USTF_LD_INTERSTL_PIP_SYSTEM_CD', 'LD_INTERSTL_PIP_SYSTEM__NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_INTERSTL_PIP_SYSTEM_KEY' where id = 295;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (295, ''' || "LD_INTERSTL_PIP_SYSTEM__NAME"  ||  ''', '''');'
from "NC_UST"."USTF_LD_INTERSTL_PIP_SYSTEM_CD"
order by 1;	
	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (295, 'Hydrostatic', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (295, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (295, 'Pressure', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (295, 'Sump Sensor', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (295, 'Vacuum', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'AutomaticTankGauging', 'USTF_LD_SYSTEM_TANK_CD_DATA_TABLE', 'LD_SYSTEM_TANK_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_TANK_KEY' where id = 296;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, ''' || "LD_SYSTEM_TANK_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"
order by 1;	
	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Automatic Tank Gauging', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Automatic Tank Gauging & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Groundwater Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Interstitial Monitoring (IM)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Inventory Control & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Inventory Control per DoD 4140.25 & GWM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Inventory Control per DoD 4140.25 & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Inventory Control per DoD 4140.25 & VM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'LD Not Req-EmerGen (< 11/1/2007)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'LD Not Req-Heating', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'LD Not Req-Waste Water System', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Manual Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Manual Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Other', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Statistical Inventory Reconciliation (SIR)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Vapor Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (296, 'Vapor Monitoring with Tracer Compound', 'No');

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%SYSTEM%'
and table_name not like 'VW%'
order by 1, 2;

select * from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"

select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'AutomaticTankGauging';
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'ManualTankGauging', 'USTF_LD_SYSTEM_TANK_CD_DATA_TABLE', 'LD_SYSTEM_TANK_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_TANK_KEY' where id = 297;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, ''' || "LD_SYSTEM_TANK_NAME"  ||  ''', ''No'');'
from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Automatic Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Automatic Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Groundwater Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Interstitial Monitoring (IM)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Inventory Control & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Inventory Control per DoD 4140.25 & GWM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Inventory Control per DoD 4140.25 & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Inventory Control per DoD 4140.25 & VM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'LD Not Req-EmerGen (< 11/1/2007)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'LD Not Req-Heating', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'LD Not Req-Waste Water System', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Manual Tank Gauging', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Manual Tank Gauging & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Other', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Statistical Inventory Reconciliation (SIR)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Vapor Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (297, 'Vapor Monitoring with Tracer Compound', 'No');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'StatisticalInventoryReconciliation', 'USTF_LD_SYSTEM_TANK_CD_DATA_TABLE', 'LD_SYSTEM_TANK_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_TANK_KEY' where id = 298;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, ''' || "LD_SYSTEM_TANK_NAME"  ||  ''', ''No'');'
from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Automatic Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Automatic Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Groundwater Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Interstitial Monitoring (IM)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Inventory Control & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Inventory Control per DoD 4140.25 & GWM', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Inventory Control per DoD 4140.25 & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Inventory Control per DoD 4140.25 & VM', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'LD Not Req-EmerGen (< 11/1/2007)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'LD Not Req-Heating', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'LD Not Req-Waste Water System', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Manual Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Manual Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Other', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Statistical Inventory Reconciliation (SIR)', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Vapor Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (298, 'Vapor Monitoring with Tracer Compound', 'No');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'TankTightnessTesting', 'USTF_LD_SYSTEM_TANK_CD_DATA_TABLE', 'LD_SYSTEM_TANK_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_TANK_KEY' where id = 299;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, ''' || "LD_SYSTEM_TANK_NAME"  ||  ''', ''No'');'
from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Automatic Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Automatic Tank Gauging & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Groundwater Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Interstitial Monitoring (IM)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Inventory Control & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Inventory Control per DoD 4140.25 & GWM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Inventory Control per DoD 4140.25 & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Inventory Control per DoD 4140.25 & VM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'LD Not Req-EmerGen (< 11/1/2007)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'LD Not Req-Heating', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'LD Not Req-Waste Water System', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Manual Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Manual Tank Gauging & TTT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Other', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Statistical Inventory Reconciliation (SIR)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Vapor Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (299, 'Vapor Monitoring with Tracer Compound', 'No');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'VaporMonitoring', 'USTF_LD_SYSTEM_TANK_CD_DATA_TABLE', 'LD_SYSTEM_TANK_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_TANK_KEY' where id = 303;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, ''' || "LD_SYSTEM_TANK_NAME"  ||  ''', ''No'');'
from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Automatic Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Automatic Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Groundwater Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Interstitial Monitoring (IM)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Inventory Control & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Inventory Control per DoD 4140.25 & GWM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Inventory Control per DoD 4140.25 & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Inventory Control per DoD 4140.25 & VM', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'LD Not Req-EmerGen (< 11/1/2007)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'LD Not Req-Heating', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'LD Not Req-Waste Water System', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Manual Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Manual Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Other', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Statistical Inventory Reconciliation (SIR)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Vapor Monitoring', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (303, 'Vapor Monitoring with Tracer Compound', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'GroundwaterMonitoring', 'USTF_LD_SYSTEM_TANK_CD_DATA_TABLE', 'LD_SYSTEM_TANK_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_TANK_KEY' where id = 304;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, ''' || "LD_SYSTEM_TANK_NAME"  ||  ''', ''No'');'
from "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Automatic Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Automatic Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Groundwater Monitoring', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Interstitial Monitoring (IM)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Inventory Control & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Inventory Control per DoD 4140.25 & GWM', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Inventory Control per DoD 4140.25 & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Inventory Control per DoD 4140.25 & VM', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'LD Not Req-EmerGen (< 11/1/2007)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'LD Not Req-Heating', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'LD Not Req-Waste Water System', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Manual Tank Gauging', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Manual Tank Gauging & TTT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Other', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Statistical Inventory Reconciliation (SIR)', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Vapor Monitoring', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (304, 'Vapor Monitoring with Tracer Compound', 'No');

----------------------------------------------------------------------------------------------------------------------------------	

insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'ElectronicLineLeak', 'USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE', 'PRESSURIZE_LEAK_DETECT_NAME')
returning id;


update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'PRESSURIZE_LEAK_DETECT_KEY' where id = 300;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (300, ''' || "PRESSURIZE_LEAK_DETECT_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE"
order by 1;	
	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (300, 'ELLD', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (300, 'MLLD', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (300, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (300, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (300, 'Unknown', 'Unknown');

select * from "NC_UST"."USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE"

select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%PRESSUR%'
and table_name not like 'VW%'
order by 1, 2;

select * from v_ust_element_mapping where organization_id = 'NC' and element_name  like 'ElectronicLineLeak%'
----------------------------------------------------------------------------------------------------------------------------------	

insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'MechanicalLineLeak', 'USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE', 'PRESSURIZE_LEAK_DETECT_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'PRESSURIZE_LEAK_DETECT_KEY' where id = 301;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (300, ''' || "PRESSURIZE_LEAK_DETECT_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE"
order by 1;	
	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (301, 'ELLD', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (301, 'MLLD', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (301, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (301, 'Not Required', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (301, 'Unknown', 'Unknown');
----------------------------------------------------------------------------------------------------------------------------------	

insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'SafeSuction', 'USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE', 'LD_SYSTEM_PIPE_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_PIPE_KEY' where id = 302;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, ''' || "LD_SYSTEM_PIPE_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE"
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'ELLD', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Exempt (European Style)', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Ground Water Monitoring', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Interstitial Monitoring (IM)', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Inventory Control per DoD 4140.25 & GWM', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Inventory Control per DoD 4140.25 & LTT', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Inventory Control per DoD 4140.25 & VM', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'LD Not Req-EmerGen (< 11/1/2007)', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'LD Not Req-Heating', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'LD Not Req-Waste Water System', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Line Tightness Testing (LTT)', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'MLLD', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'None', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Not Required', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Other', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Statistical Inventory Reconciliation (SIR)', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Vapor Monitoring', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (302, 'Vapor Monitoring with Tracer Compound', null);
----------------------------------------------------------------------------------------------------------------------------------	

insert into ust_element_db_mapping (control_id, mapping_date, element_name, state_table_name, state_column_name)
values (17, '2023-06-29', 'PrimaryReleaseDetectionType', 'USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE', 'LD_SYSTEM_PIPE_NAME')
returning id;

update ust_element_db_mapping set state_join_table = 'USTF_TANK_DETAIL_DATA_TABLE', state_join_column = 'LD_SYSTEM_PIPE_KEY' where id = 305;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, ''' || "LD_SYSTEM_PIPE_NAME"  ||  ''', '''');'
from "NC_UST"."USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE"
order by 1;	


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'ELLD', 'Line test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Exempt (European Style)', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Ground Water Monitoring', 'Groundwater monitoring');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Interstitial Monitoring (IM)', 'Interstitial monitoring');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Inventory Control per DoD 4140.25 & GWM', 'SIR');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Inventory Control per DoD 4140.25 & LTT', 'SIR');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Inventory Control per DoD 4140.25 & VM', 'SIR');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'LD Not Req-EmerGen (< 11/1/2007)', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'LD Not Req-Heating', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'LD Not Req-Waste Water System', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Line Tightness Testing (LTT)', 'Line test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'MLLD', 'Line test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'None', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Not Required', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Statistical Inventory Reconciliation (SIR)', 'SIR');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Vapor Monitoring', 'Vapor monitoring');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (305, 'Vapor Monitoring with Tracer Compound', 'Vapor monitoring');

select * from release_detection_type ;


select table_name, column_name
from information_schema.columns 
where table_schema = 'NC_UST' and column_name like '%SYSTEM%'
and table_name not like 'VW%'
order by 1, 2;

select * from "NC_UST"."USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE"


		prd.epa_value as "PrimaryReleaseDetectionType",

		

1 = yes 
0 = no 

	           
select * from v_ust_element_mapping where organization_id = 'NC' and element_name = 'SafeSuction';

----------------------------------------------------------------------------------------------------------------------------------
create index nc1 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("MULTI_FACILITY_ID");
create index nc2 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("MULTI_OWNER_ID");
create index nc3 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("BASE_FACILITY_ID");
create index nc4 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("FACILITY_NAME");
create index nc5 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("ADDRESS1");
create index nc6 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("ADDRESS2");
create index nc7 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("CITY");
create index nc8 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("ZIP");
create index nc9 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("PHONE");
create index nc10 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("STATE");
create index nc11 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("LATITUDE");
create index nc12 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("LONGITUDE");
create index nc13 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("FACILITY_KEY");
create index nc83 on "NC_UST"."USTF_AFFILIATE_DATA_TABLE"("AFFILIATE_TYPE_KEY");
create index nc84 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("CONTACT_KEY");
create index nc85 on "NC_UST"."USTF_AFFILIATE_DATA_TABLE"("CONTACT_KEY");
create index nc14 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("BUSINESS_NAME");
create index nc15 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("LAST_NAME");
create index nc16 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("FIRST_NAME");
create index nc17 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("ADDRESS1");
create index nc18 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("ADDRESS2");
create index nc19 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("CITY");
create index nc20 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("ZIP");
create index nc21 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("STATE");
create index nc22 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("PHONE");
create index nc23 on "NC_UST"."USTF_CONTACT_DATA_TABLE"("EMAIL_ADDR");
create index nc24 on "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE"("FACILITY_KEY");
create index nc25 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("FACILITY_TYPE_KEY");
create index nc26 on "NC_UST"."USTF_FACILITY_TYPE_CD"("FACILITY_TYPE_KEY");
create index nc27 on "NC_UST"."FIPS_COUNTY_CODES"("FIPS_COUNTY_CODE");
create index nc28 on "NC_UST"."USTF_FACILITY_DATA_TABLE"("COUNTY_KEY");
create index nc29 on "NC_UST"."USTF_TANK_OWNERSHIP_DATA_TABLE"("TANK_FACILITY_KEY");
create index nc30 on "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE"("TANK_FACILITY_KEY");
create index nc31 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("TANK_KEY");
create index nc32 on "NC_UST"."USTF_TANK_OWNERSHIP_DATA_TABLE"("TANK_KEY");
create index nc33 on "NC_UST"."USTF_TYPE_OWNER_CD"("TYPE_OWNER_KEY");
create index nc34 on "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE"("TYPE_OWNER_KEY");
create index nc35 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("TANK_ID");
create index nc36 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("PERM_CLOSE_DATE");
create index nc37 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("INSTALLATION_DATE");
create index nc38 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("COMPARTMENT_TANK");
create index nc39 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("CAPACITY");
create index nc40 on "NC_UST"."USTF_FINANCIAL_MECH_CD"("FINANCIAL_MECH_KEY");
create index nc41 on "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE"("FINANCIAL_RESPONSIBILITY");
create index nc42 on "NC_UST"."USTF_FINANCIAL_MECH_CD"("DESCRIPTION");
create index nc43 on "NC_UST"."USTF_TANK_STATUS_CD_DATA_TABLE"("TANK_STATUS_KEY");
create index nc44 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("TANK_STATUS_KEY");
create index nc45 on "NC_UST"."USTF_TANK_STATUS_CD_DATA_TABLE"("TANK_STATUS_NAME");
create index nc46 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("REGULATED");
create index nc47 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("MANIFOLD_TANK");
create index nc48 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("COMPARTMENT_TANK");
create index nc49 on "NC_UST"."USTF_PRODUCT_CD_DATA_TABLE"("PRODUCT_KEY");
create index nc50 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("PRODUCT_KEY");
create index nc51 on "NC_UST"."USTF_PRODUCT_CD_DATA_TABLE"("PRODUCT_NAME");
create index nc52 on "NC_UST"."USTF_TANK_CONST_CD_DATA_TABLE"("TANK_CONSTR_KEY");
create index nc53 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("TANK_CONSTR_KEY");
create index nc54 on "NC_UST"."USTF_TANK_CONST_CD_DATA_TABLE"("TANK_CONSTR_NAME");
create index nc55 on "NC_UST"."USTF_PIPING_CONSTR_CD_DATA_TABLE"("PIPING_CONSTR_KEY");
create index nc56 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("PIPING_CONSTR_KEY");
create index nc57 on "NC_UST"."USTF_PIPING_CONSTR_CD_DATA_TABLE"("PIPING_CONSTR_NAME");
create index nc58 on "NC_UST"."USTF_FLEX_CONNECTOR_TANK_CD_DATA_TABLE"("FLEX_CONNECTOR_TANK_KEY");
create index nc59 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("FLEX_CONNECTOR_TANK_KEY");
create index nc60 on "NC_UST"."USTF_FLEX_CONNECTOR_TANK_CD_DATA_TABLE"("FLEX_CONNECTOR_TANK_NAME");
create index nc61 on "NC_UST"."USTF_PIPING_SYSTEM_CD_DATA_TABLE"("PIPING_SYSTEM_KEY");
create index nc62 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("PIPING_SYSTEM_KEY");
create index nc63 on "NC_UST"."USTF_PIPING_SYSTEM_CD_DATA_TABLE"("PIPING_SYSTEM_NAME");
create index nc64 on "NC_UST"."USTF_OVERFILL_PROTECTION_CD_DATA_TABLE"("OVERFILL_PROTECTION_KEY");
create index nc65 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("OVERFILL_PROTECTION_KEY");
create index nc66 on "NC_UST"."USTF_OVERFILL_PROTECTION_CD_DATA_TABLE"("OVERFILL_PROTECTION_NAME");
create index nc67 on "NC_UST"."USTF_SPILL_PROTECTION_CD_DATA_TABLE"("SPILL_PROTECTION_KEY");
create index nc68 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("SPILL_PROTECTION_KEY");
create index nc69 on "NC_UST"."USTF_SPILL_PROTECTION_CD_DATA_TABLE"("SPILL_PROTECTION_NAME");
create index nc70 on "NC_UST"."USTF_LD_INTERSTL_PIP_SYSTEM_CD"("LD_INTERSTL_PIP_SYSTEM_KEY");
create index nc71 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("LD_INTERSTL_PIP_SYSTEM_KEY");
create index nc72 on "NC_UST"."USTF_LD_INTERSTL_PIP_SYSTEM_CD"("LD_INTERSTL_PIP_SYSTEM__NAME");
create index nc73 on "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"("LD_SYSTEM_TANK_KEY");
create index nc74 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("LD_SYSTEM_TANK_KEY");
create index nc75 on "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE"("LD_SYSTEM_TANK_NAME");
create index nc76 on "NC_UST"."USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE"("PRESSURIZE_LEAK_DETECT_KEY");
create index nc77 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("PRESSURIZED_LEAK_DETECT_KEY");
create index nc78 on "NC_UST"."USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE"("PRESSURIZE_LEAK_DETECT_NAME");
create index nc79 on "NC_UST"."USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE"("LD_SYSTEM_PIPE_KEY");
create index nc80 on "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"("LD_SYSTEM_PIPE_KEY");
create index nc81 on "NC_UST"."USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE"("LD_SYSTEM_PIPE_NAME");


select distinct "FacilID", "USTNum" as lust_id
into "NC_UST".lust
from "NC_LUST"."LUST_Data_050523";

create index nc86 on "NC_UST".lust("FacilID");
create index nc87 on "NC_UST".lust(lust_id);

drop table  "NC_UST".facility_ids;

select "MULTI_FACILITY_ID", "MULTI_OWNER_ID","BASE_FACILITY_ID"
into  "NC_UST".facility_ids
from "NC_UST"."USTF_FACILITY_DATA_TABLE";

alter table "NC_UST".facility_ids add "FacilityID" text;

update "NC_UST".facility_ids set "FacilityID" = "NC_UST".build_facility_id("MULTI_FACILITY_ID","MULTI_OWNER_ID","BASE_FACILITY_ID");
alter table "NC_UST".facility_ids add constraint facility_ids_pk  primary key   ("FacilityID");


drop table  "NC_UST".temp;
select distinct a."FACILITY_KEY", b."BUSINESS_NAME", b."FIRST_NAME", b."LAST_NAME", b."ADDRESS1", b."ADDRESS2",
		b."CITY", b."ZIP", b."STATE", b."PHONE", b."EMAIL_ADDR"
into "NC_UST".temp
from "NC_UST"."USTF_AFFILIATE_DATA_TABLE" a join "NC_UST"."USTF_CONTACT_DATA_TABLE" b on a."CONTACT_KEY" = b."CONTACT_KEY"
where "AFFILIATE_TYPE_KEY" = 1 and a."END_DATE" is  null;


----------------------------------------------------------------------------------------------------------------------------------
drop view "NC_UST".v_ust_base;

create or replace view "NC_UST".v_ust_base as
select distinct  
	fi."FacilityID" as "FacilityID", 
   	f."FACILITY_NAME" as "FacilityName",
   	ot.epa_value as "OwnerType",
   	f."ADDRESS1" as "FacilityAddress1",
   	f."ADDRESS2" as "FacilityAddress2",
   	f."CITY" as "FacilityCity",
   	fcc."FIPS_COUNTY_DESC" as "FacilityCounty",
   	f."ZIP" as "FacilityZipCode",
   	f."PHONE" as "FacilityPhoneNumber",
   	f."STATE" as "FacilityState",
   	4 as "FacilityEPARegion",
   	f."LATITUDE" as "FacilityLatitude",
   	f."LONGITUDE" as "FacilityLongitude",	
    fown."BUSINESS_NAME" as "FacilityOwnerCompanyName",
    fown."LAST_NAME" as "FacilityOwnerLastName",
    fown."FIRST_NAME" as "FacilityOwnerFirstName",
    fown."ADDRESS1" as "FacilityOwnerAddress1",
    fown."ADDRESS2" as "FacilityOwnerAddress2",
    fown."CITY" as "FacilityOwnerCity",
    fown."ZIP" as "FacilityOwnerZipCode",
    fown."STATE" as "FacilityOwnerState",
    fown."PHONE" as "FacilityOwnerPhoneNumber",
    fown."EMAIL_ADDR" as "FacilityOwnerEmail",	   
    fopr."BUSINESS_NAME" as "FacilityOperatorCompanyName",
    fopr."LAST_NAME" as "FacilityOperatorLastName",
    fopr."FIRST_NAME" as "FacilityOperatorFirstName",
    fopr."ADDRESS1" as "FacilityOperatorAddress1",
    fopr."ADDRESS2" as "FacilityOperatorAddress2",
    fopr."CITY" as "FacilityOperatorCity",
    fopr."ZIP" as "FacilityOperatorZipCode",
    fopr."STATE" as "FacilityOperatorState",
    fopr."PHONE" as "FacilityOperatorPhoneNumber",
    fopr."EMAIL_ADDR" as "FacilityOperatorEmail",	  
    frg.epa_value as "FinancialResponsibilityGuarantee", 
    frlc.epa_value as "FinancialResponsibilityLetterOfCredit", 
    frlg.epa_value as "FinancialResponsibilityLocalGovernmentFinancialTest", 
    frrr.epa_value as "FinancialResponsibilityRiskRetentionGroup", 
    frsi.epa_value as "FinancialResponsibilitySelfInsuranceFinancialTest", 
    frsb.epa_value as "FinancialResponsibilitySuretyBond", 
    frtf.epa_value as "FinancialResponsibilityTrustFund", 
    fro.epa_value as "FinancialResponsibilityOtherMethod", 
    frnr.epa_value as "FinancialResponsibilityNotRequired", 	
    t."TANK_ID" as "TankID",
    fr.epa_value as "FederallyRegulated",
    ts.epa_value as "TankStatus",	
    mt.epa_value as "MultipleTanks",
    t."PERM_CLOSE_DATE"::date as "ClosureDate",
    t."INSTALLATION_DATE"::date as "InstallationDate",
	t."COMPARTMENT_TANK" as "CompartmentalizedUST",
	tss.epa_value as "TankSubstanceStored",
	t."CAPACITY" as "TankCapacityGallons", -- assume gallons	
	twt.epa_value as "TankWallType",
	md.epa_value as "MaterialDescription",
	pmd.epa_value as "PipingMaterialDescription",
	pfc.epa_value as "PipingFlexConnector",
	ps.epa_value as "PipingStyle",
	pwt.epa_value as "PipingWallType",
	bfv.epa_value as "BallFloatValve",
	fsd.epa_value as "FlowShutoffDevice",
	hla.epa_value as "HighLevelAlarm",
	opp.epa_value as "OverfillProtectionPrimary",
	sbi.epa_value as "SpillBucketInstalled",
	imce.epa_value as "InterstitialMonitoringContinualElectric",
	imm.epa_value as "InterstitialMonitoringManual", 
	atg.epa_value as "AutomaticTankGauging",
	mtg.epa_value as "ManualTankGauging",
	sir.epa_value as "StatisticalInventoryReconciliation",
	ttt.epa_value as "TankTightnessTesting",
	ell.epa_value as "ElectronicLineLeak",
	mll.epa_value as "MechanicalLineLeak",
	ss.epa_value as "SafeSuction", 
	vm.epa_value as "VaporMonitoring",
	gm.epa_value as "GroundwaterMonitoring",
	prdt.epa_value as "PrimaryReleaseDetectionType",
	case when lust."FacilID" is not null then 'Yes' end as "USTReportedRelease",
	lust.lust_id as "AssociatedLUSTID"
from 
		 "NC_UST"."USTF_FACILITY_DATA_TABLE" f  
	join "NC_UST".facility_ids fi on f."MULTI_FACILITY_ID" = fi."MULTI_FACILITY_ID" and f."MULTI_OWNER_ID" = fi."MULTI_OWNER_ID" and f."BASE_FACILITY_ID" = fi."BASE_FACILITY_ID"		 
	join "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE" fd on f."FACILITY_KEY" = fd."FACILITY_KEY" 
	join "NC_UST"."USTF_FACILITY_TYPE_CD" ft on f."FACILITY_TYPE_KEY" = ft."FACILITY_TYPE_KEY"
	left join "NC_UST"."FIPS_COUNTY_CODES" fcc on f."COUNTY_KEY" = fcc."FIPS_COUNTY_CODE"
	join "NC_UST"."USTF_TANK_OWNERSHIP_DATA_TABLE" o on fd."TANK_FACILITY_KEY" = o."TANK_FACILITY_KEY"
	join "NC_UST".v_USTF_TANK_DETAIL_DATA_TABLE t on o."TANK_KEY" = t."TANK_KEY"
	join "NC_UST"."USTF_TYPE_OWNER_CD" ocd on fd."TYPE_OWNER_KEY" = ocd."TYPE_OWNER_KEY"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'OwnerType') ot on ocd."TYPE_OWNER_NAME" = ot.state_value
	left join (select distinct a."FACILITY_KEY", b."BUSINESS_NAME", b."FIRST_NAME", b."LAST_NAME", b."ADDRESS1", b."ADDRESS2",
						b."CITY", b."ZIP", b."STATE", b."PHONE", b."EMAIL_ADDR"
				from "NC_UST"."USTF_AFFILIATE_DATA_TABLE" a join "NC_UST"."USTF_CONTACT_DATA_TABLE" b on a."CONTACT_KEY" = b."CONTACT_KEY"
				where "AFFILIATE_TYPE_KEY" = 1 and a."END_DATE" is null) fown on f."FACILITY_KEY" = fown."FACILITY_KEY"
	left join (select distinct a."FACILITY_KEY", b."BUSINESS_NAME", b."FIRST_NAME", b."LAST_NAME", b."ADDRESS1", b."ADDRESS2",
						b."CITY", b."ZIP", b."STATE", b."PHONE", b."EMAIL_ADDR"
				from "NC_UST"."USTF_AFFILIATE_DATA_TABLE" a join "NC_UST"."USTF_CONTACT_DATA_TABLE" b on a."CONTACT_KEY" = b."CONTACT_KEY"
				where "AFFILIATE_TYPE_KEY" = 2 and a."END_DATE" is null) fopr on f."FACILITY_KEY" = fopr."FACILITY_KEY"	
	left join "NC_UST"."USTF_FINANCIAL_MECH_CD" fin on fd."FINANCIAL_RESPONSIBILITY" = fin."FINANCIAL_MECH_KEY"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityBondRatingTest') frbrt on frbrt.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityGuarantee') frg on frg.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityLetterOfCredit') frlc on frlc.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityLocalGovernmentFinancialTest') frlg on frlg.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityRiskRetentionGroup') frrr on frrr.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilitySelfInsuranceFinancialTest') frsi on frsi.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilitySuretyBond') frsb on frsb.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityTrustFund') frtf on frtf.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityOtherMethod') fro on fro.state_value = fin."DESCRIPTION"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FinancialResponsibilityNotRequired') frnr on frnr.state_value = fin."DESCRIPTION"
	join "NC_UST"."USTF_TANK_STATUS_CD_DATA_TABLE" tscd on t."TANK_STATUS_KEY" = tscd."TANK_STATUS_KEY" 
	join (select state_value, epa_value, exclude_from_query from v_ust_element_mapping where control_id = 17 and element_name = 'TankStatus') ts on tscd."TANK_STATUS_NAME" = ts.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FederallyRegulated') fr on t."REGULATED"::text = fr.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'MultipleTanks') mt on t."MANIFOLD_TANK"::text = mt.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'CompartmentalizedUST') cu on t."COMPARTMENT_TANK"::text = cu.state_value
	left join "NC_UST"."USTF_PRODUCT_CD_DATA_TABLE" pcd on t."PRODUCT_KEY" = pcd."PRODUCT_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'TankSubstanceStored') tss on pcd."PRODUCT_NAME" = tss.state_value
	left join "NC_UST"."USTF_TANK_CONST_CD_DATA_TABLE" tccd on t."TANK_CONSTR_KEY" = tccd."TANK_CONSTR_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'TankWallType') twt on tccd."TANK_CONSTR_NAME" = twt.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'MaterialDescription') md on tccd."TANK_CONSTR_NAME" = md.state_value
	left join "NC_UST"."USTF_PIPING_CONSTR_CD_DATA_TABLE" pccd on t."PIPING_CONSTR_KEY" = pccd."PIPING_CONSTR_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'PipingMaterialDescription') pmd on pccd."PIPING_CONSTR_NAME" = pmd.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'PipingWallType') pwt on pccd."PIPING_CONSTR_NAME" = pwt.state_value
	left join "NC_UST"."USTF_FLEX_CONNECTOR_TANK_CD_DATA_TABLE" fccd on t."FLEX_CONNECTOR_TANK_KEY" = fccd."FLEX_CONNECTOR_TANK_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'PipingFlexConnector') pfc on fccd."FLEX_CONNECTOR_TANK_NAME" = pfc.state_value
	left join "NC_UST"."USTF_PIPING_SYSTEM_CD_DATA_TABLE" pscd on t."PIPING_SYSTEM_KEY" = pscd."PIPING_SYSTEM_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'PipingStyle') ps on pscd."PIPING_SYSTEM_NAME" = ps.state_value
	left join "NC_UST"."USTF_OVERFILL_PROTECTION_CD_DATA_TABLE" pocd on t."OVERFILL_PROTECTION_KEY" = pocd."OVERFILL_PROTECTION_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'BallFloatValve') bfv on pocd."OVERFILL_PROTECTION_NAME" = bfv.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'FlowShutoffDevice') fsd on pocd."OVERFILL_PROTECTION_NAME" = fsd.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'HighLevelAlarm') hla on pocd."OVERFILL_PROTECTION_NAME" = hla.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'OverfillProtectionPrimary') opp on pocd."OVERFILL_PROTECTION_NAME" = opp.state_value
	left join "NC_UST"."USTF_SPILL_PROTECTION_CD_DATA_TABLE" spcd on t."SPILL_PROTECTION_KEY" = spcd."SPILL_PROTECTION_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'SpillBucketInstalled') sbi on spcd."SPILL_PROTECTION_NAME" = sbi.state_value
	left join "NC_UST"."USTF_LD_INTERSTL_PIP_SYSTEM_CD" ipcd on t."LD_INTERSTL_PIP_SYSTEM_KEY" = ipcd."LD_INTERSTL_PIP_SYSTEM_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'InterstitialMonitoringContinualElectric') imce on ipcd."LD_INTERSTL_PIP_SYSTEM__NAME" = imce.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'InterstitialMonitoringManual') imm on ipcd."LD_INTERSTL_PIP_SYSTEM__NAME" = imm.state_value
	left join "NC_UST"."USTF_LD_SYSTEM_TANK_CD_DATA_TABLE" stcd on t."LD_SYSTEM_TANK_KEY" = stcd."LD_SYSTEM_TANK_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'AutomaticTankGauging') atg on stcd."LD_SYSTEM_TANK_NAME" = atg.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'ManualTankGauging') mtg on stcd."LD_SYSTEM_TANK_NAME" = mtg.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'StatisticalInventoryReconciliation') sir on stcd."LD_SYSTEM_TANK_NAME" = sir.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'TankTightnessTesting') ttt on stcd."LD_SYSTEM_TANK_NAME" = ttt.state_value
	left join "NC_UST"."USTF_PRESSURIZE_LEAK_DETECT_CD_DATA_TABLE" plcd on t."PRESSURIZED_LEAK_DETECT_KEY" = plcd."PRESSURIZE_LEAK_DETECT_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'ElectronicLineLeak') ell on plcd."PRESSURIZE_LEAK_DETECT_NAME" = ell.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'MechanicalLineLeak') mll on plcd."PRESSURIZE_LEAK_DETECT_NAME" = mll.state_value
	left join "NC_UST"."USTF_LD_SYSTEM_PIPE_CD_DATA_TABLE" lscd on t."LD_SYSTEM_PIPE_KEY" = lscd."LD_SYSTEM_PIPE_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'SafeSuction') ss on lscd."LD_SYSTEM_PIPE_NAME" = ss.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'PrimaryReleaseDetectionType') prdt on lscd."LD_SYSTEM_PIPE_NAME" = prdt.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'VaporMonitoring') vm on stcd."LD_SYSTEM_TANK_NAME" = vm.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 17 and element_name = 'GroundwaterMonitoring') gm on stcd."LD_SYSTEM_TANK_NAME" = gm.state_value
	left join "NC_UST".lust lust on fi."FacilityID" = lust."FacilID"
where ts.exclude_from_query is null and t."REGULATED" = 1
and ft."FACILITY_TYPE_DESC" = 'UST';

select count(*) from "NC_UST".v_ust_base;

drop table  "NC_UST".ust_base;
select * into "NC_UST".ust_base from "NC_UST".v_ust_base;

create index ust_base_facid on "NC_UST".ust_base("FacilityID");
create index ust_base_tankid on "NC_UST".ust_base("TankID");
create index ust_base_factankid on "NC_UST".ust_base("FacilityID","TankID");

select * from "NC_UST".ust_base;

select * from ust_geocoded_temp
where organization_id = 'NC'
where control_id = 17;

select count(*) from "NC_UST".ust_base;

select count(*) from ust where control_id = 17;

select * from v_ust_element_mapping where control_id = 17 and element_name = 'TankStatus'

update ust_element_value_mappings set epa_value = 'Currently in use' where id = 4859

select * from "NC_UST"."USTF_TANK_STATUS_CD_DATA_TABLE"
8	Never Installed
0	Unknown
1	Removed
2	Abandoned
3	Chg. In Service
4	Transfer
5	Current
6	Temporarily Closed
7	Intent to Install

select * from ust_geocode where control_id = 17;


select "FacilityID", "TankID", count(*) from (
select distinct "FacilityID", "TankID", "TankStatus"
from "NC_UST".ust_base) a group by "FacilityID", "TankID" having count(*) > 1;

select * from "NC_UST".ust_base where "FacilityID" = '00-0-0000000002' and "TankID" = '001';

 "NC_UST"."USTF_FACILITY_DATA_TABLE" f  
	join "NC_UST".facility_ids fi on f."MULTI_FACILITY_ID" = fi."MULTI_FACILITY_ID" and f."MULTI_OWNER_ID" = fi."MULTI_OWNER_ID" and f."BASE_FACILITY_ID" = fi."BASE_FACILITY_ID"		 
	join "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE" fd on f."FACILITY_KEY" = fd."FACILITY_KEY" 
	join "NC_UST"."USTF_TANK_OWNERSHIP_DATA_TABLE" o on fd."TANK_FACILITY_KEY" = o."TANK_FACILITY_KEY"
	join "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" t on o."TANK_KEY" = t."TANK_KEY"

select t.* 
from "NC_UST"."USTF_FACILITY_DATA_TABLE" f  
	join "NC_UST".facility_ids fi on f."MULTI_FACILITY_ID" = fi."MULTI_FACILITY_ID" and f."MULTI_OWNER_ID" = fi."MULTI_OWNER_ID" and f."BASE_FACILITY_ID" = fi."BASE_FACILITY_ID"		 
	join "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE" fd on f."FACILITY_KEY" = fd."FACILITY_KEY" 
	join "NC_UST"."USTF_TANK_OWNERSHIP_DATA_TABLE" o on fd."TANK_FACILITY_KEY" = o."TANK_FACILITY_KEY"
	join "NC_UST".v_USTF_TANK_DETAIL_DATA_TABLE t on o."TANK_KEY" = t."TANK_KEY"
where "FacilityID"  = '00-0-0000000002' and "TANK_ID" = '001';
82387

create view "NC_UST".v_USTF_TANK_DETAIL_DATA_TABLE as
select b.* from 
	(select "TANK_KEY", max("INFO_SOURCE_DATE") "INFO_SOURCE_DATE"
	from "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" group by "TANK_KEY") a
	join "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" b on a."TANK_KEY" = b."TANK_KEY" and a."INFO_SOURCE_DATE" = b."INFO_SOURCE_DATE"

select * from "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" where 

select "FacilityID", "TankID", "TankStatus"
from ust u where control_id = 17 and exists (
select 1
from     "NC_UST"."USTF_FACILITY_DATA_TABLE" f  
	join "NC_UST".facility_ids fi on f."MULTI_FACILITY_ID" = fi."MULTI_FACILITY_ID" and f."MULTI_OWNER_ID" = fi."MULTI_OWNER_ID" and f."BASE_FACILITY_ID" = fi."BASE_FACILITY_ID"		 
	join "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE" fd on f."FACILITY_KEY" = fd."FACILITY_KEY" 
	join "NC_UST"."USTF_TANK_OWNERSHIP_DATA_TABLE" o on fd."TANK_FACILITY_KEY" = o."TANK_FACILITY_KEY"
	join "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" t on o."TANK_KEY" = t."TANK_KEY"
where "TANK_STATUS_KEY" = 3
and fi."FacilityID" = u."FacilityID" and t."TANK_ID" = u."TankID")
order by 1, 2;
	
00-0-0000001904	631936	Closed (general)
00-0-0000001904	631936	Currently in use
00-0-0000001904	631936	Closed (general)
00-0-0000001904	631936	Currently in use
00-0-0000001904	631936	Currently in use
00-0-0000001904	631936	Currently in use


select * from ust where  control_id = 17 
and  "FacilityID" = '00-0-0000001904' and "TankID" = '631936';


select * from information_schema.columns where lower(column_name) like '%reg%' and table_schema = 'NC_UST';

select "REGULATED", count(*) from "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE"
group by "REGULATED"

0	11377
1	221081

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
select distinct 
	   fown."FACILITY_ID" as "FacilityID",
	   f."FACILITY_NAME" as "FacilityName",
	   ot.epa_value as "OwnerType",
	   f."ADDRESS1" as "FacilityAddress1",
	   f."ADDRESS2" as "FacilityAddress2",
	   f."CITY" as "FacilityCity",
	   fcc."FIPS_COUNTY_DESC" as "FacilityCounty",
	   f."ZIP" as "FacilityZipCode",
	   f."PHONE" as "FacilityPhoneNumber",
	   f."STATE" as "FacilityState",
	   4 as "FacilityEPARegion",
	   f."LATITUDE" as "FacilityLatitude",
	   f."LONGITUDE" as "FacilityLongitude",
	   fown."OWNER_NAME" as "FacilityOwnerCompanyName",
	   fown."ADDRESS1" as "FacilityOwnerAddress1",
	   fown."ADDRESS2" as "FacilityOwnerAddress2",
	   fown."CITY" as "FacilityOwnerCity",
	   fown."COUNTY_DESC" as "FacilityOwnerCounty",
	   fown."ZIP" as "FacilityOwnerZipCode",
	   fown."STATE" as "FacilityOwnerState",
	   fown."PHONE" as "FacilityOwnerPhoneNumber",
	   fown."EMAIL_ADDR" as "FacilityOwnerEmail",	   
	   fopr."OPERATOR_NAME" as "FacilityOperatorCompanyName",
	   fopr."ADDRESS1" as "FacilityOperatorAddress1",
	   fopr."ADDRESS2" as "FacilityOperatorAddress2",
	   fopr."CITY" as "FacilityOperatorCity",
	   fopr."COUNTY_DESC" as "FacilityOperatorCounty",
	   fopr."ZIP" as "FacilityOperatorZipCode",
	   fopr."STATE" as "FacilityOperatorState",
	   fopr."PHONE" as "FacilityOperatorPhoneNumber",
	   fopr."EMAIL_ADDR" as "FacilityOperatorEmail",	  
	   frbr.epa_value as "FinancialResponsibilityBondRatingTest",
	   frg.epa_value as "FinancialResponsibilityGuarantee", 
	   frlc.epa_value as "FinancialResponsibilityLetterOfCredit", 
	   frlg.epa_value as "FinancialResponsibilityLocalGovernmentFinancialTest", 
	   frrr.epa_value as "FinancialResponsibilityRiskRetentionGroup", 
	   frsi.epa_value as "FinancialResponsibilitySelfInsuranceFinancialTest", 
	   frsb.epa_value as "FinancialResponsibilitySuretyBond", 
	   frtf.epa_value as "FinancialResponsibilityTrustFund", 
	   fro.epa_value as "FinancialResponsibilityOtherMethod", 
	   frnr.epa_value as "FinancialResponsibilityNotRequired", 
	   ft."TANK_ID" as "TankID",
	   ft."REGULATED" as "FederallyRegulated",
	   ts.epa_value as "TankStatus",	
	   ft."MANIFOLD_TANK" as "MultipleTanks",
	   ft."PERM_CLOSE_DATE" as "ClosureDate",
	   ft."INSTALLATION_DATE" as "InstallationDate",
	   	ft."COMPARTMENT_TANK" as "CompartmentalizedUST",
	   	sub.epa_value as "TankSubstanceStored",
	   	ft."CAPACITY" as "TankCapacityGallons", -- assume gallons	
		twt.epa_value as "TankWallType",
		md.epa_value as "MaterialDescription",
		pmd.epa_value as "PipingMaterialDescription",
		"FLEX_CONNECTOR_TANK" as "PipingFlexConnector",
		ps.epa_value as "PipingStyle",
		pwt.epa_value as "PipingWallType",
		bfv.epa_value as "BallFloatValve",
		fsd.epa_value as "FlowShutoffDevice",
		hla.epa_value as "HighLevelAlarm",
		opp.epa_value as "OverfillProtectionPrimary",
		sb.epa_value as "SpillBucketInstalled",
		imce.epa_value as "InterstitialMonitoringContinualElectric",
		imm.epa_value as "InterstitialMonitoringManual", 
		atg.epa_value as "AutomaticTankGauging",
		mtg.epa_value as "ManualTankGauging",
		sir.epa_value as "StatisticalInventoryReconciliation",
		ttt.epa_value as "TankTightnessTesting",
		ell.epa_value as "ElectronicLineLeak",
		mll.epa_value as "MechanicalLineLeak",
		ss.epa_value as "SafeSuction", 
		prd.epa_value as "PrimaryReleaseDetectionType",
		case when lust."FacilID" is not null then 'Yes' end as "USTReportedRelease",
		lust.lust_id as "AssociatedLUSTID"
from "NC_UST"."USTF_FACILITY_DATA_TABLE" f 
	left join "NC_UST"."VW_USTF_FACILITY_OWNER_DTLS_DATA_VIEW" fown on f."FACILITY_KEY" = fown."FACILITY_KEY"
	left join "NC_UST"."VW_USTF_FACILITY_OPERATOR_DTLS_DATA_VIEW" fopr on f."FACILITY_KEY" = fopr."FACILITY_KEY"
	left join "NC_UST"."VW_USTF_TANK_DETAIL_DATA_VIEW" ft on f."FACILITY_KEY" = ft."FACILITY_KEY"
	left join "NC_UST"."USTF_TANK_DETAIL_DATA_TABLE" t on ft."TANK_DETAIL_KEY" = t."TANK_DETAIL_KEY"
	left join (select "FacilID", max("IncidentNumber") as lust_id from "NC_LUST"."qryLUST_Data" group by "FacilID") lust 
		on fown."FACILITY_ID" = lust."FacilID"
	left join "NC_UST"."USTF_TANK_FACILITY_DATA_TABLE" tfd on f."FACILITY_KEY" = tfd."FACILITY_KEY"
	left join "NC_UST"."USTF_TYPE_OWNER_CD" toc on tfd."TYPE_OWNER_KEY" = toc."TYPE_OWNER_KEY" 
	left join "NC_UST"."FIPS_COUNTY_CODES" fcc on f."COUNTY_KEY" = fcc."FIPS_COUNTY_CODE"
	left join (select state_code, epa_value from v_ust_element_mapping where state = 'NC' and element_name = 'OwnerType') ot 
		on toc."TYPE_OWNER_KEY"::varchar = ot.state_code
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityBondRatingTest') frbr
		on tfd."FINANCIAL_RESPONSIBILITY" = frbr."FINANCIAL_MECH_KEY" 
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityGuarantee') frg
		on tfd."FINANCIAL_RESPONSIBILITY" = frg."FINANCIAL_MECH_KEY" 
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityLetterOfCredit') frlc
		on tfd."FINANCIAL_RESPONSIBILITY" = frlc."FINANCIAL_MECH_KEY" 	
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityLocalGovernmentFinancialTest') frlg
		on tfd."FINANCIAL_RESPONSIBILITY" = frlg."FINANCIAL_MECH_KEY" 	
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityRiskRetentionGroup') frrr
		on tfd."FINANCIAL_RESPONSIBILITY" = frrr."FINANCIAL_MECH_KEY" 			
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilitySelfInsuranceFinancialTest') frsi
		on tfd."FINANCIAL_RESPONSIBILITY" = frsi."FINANCIAL_MECH_KEY" 	
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilitySuretyBond') frsb
		on tfd."FINANCIAL_RESPONSIBILITY" = frsb."FINANCIAL_MECH_KEY" 			
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityTrustFund') frtf
		on tfd."FINANCIAL_RESPONSIBILITY" = frtf."FINANCIAL_MECH_KEY" 		
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityOtherMethod') fro
		on tfd."FINANCIAL_RESPONSIBILITY" = fro."FINANCIAL_MECH_KEY" 	
	left join  (select distinct epa_value, b."FINANCIAL_MECH_KEY" 
				from v_ust_element_mapping a join "NC_UST"."USTF_FINANCIAL_MECH_CD" b on a.state_value = b."DESCRIPTION" 
				where state = 'NC' and element_name = 'FinancialResponsibilityNotRequired') frnr
		on tfd."FINANCIAL_RESPONSIBILITY" = frnr."FINANCIAL_MECH_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'TankStatus' and exclude_from_query is null) ts 
	    on ft."TANK_STATUS" = ts.state_value
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'TankSubstanceStored' and exclude_from_query is null) sub 
	    on ft."PRODUCT" = sub.state_value
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'TankWallType') twt 
	    on ft."TANK_CONSTR" = twt.state_value	    
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'MaterialDescription') md 
	    on ft."TANK_CONSTR" = md.state_value		    
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'PipingMaterialDescription') pmd 
	    on ft."PIPING_CONSTR" = pmd.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'PipingStyle') ps 
	    on ft."PIPING_SYSTEM" = ps.state_value		    
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'PipingWallType') pwt
	    on ft."OVERFILL_PROTECTION" = pwt.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'BallFloatValve') bfv
	    on ft."OVERFILL_PROTECTION" = bfv.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'FlowShutoffDevice') fsd
	    on ft."OVERFILL_PROTECTION" = fsd.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'HighLevelAlarm') hla
	    on ft."OVERFILL_PROTECTION" = hla.state_value		    
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'OverfillProtectionPrimary') opp
	    on ft."OVERFILL_PROTECTION" = opp.state_value		    
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'SpillBucketInstalled') sb
	    on ft."SPILL_PROTECTION" = sb.state_value	
	left join (select state_code, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'InterstitialMonitoringContinualElectric') imce
	    on t."LD_INTERSTL_PIP_SYSTEM_KEY"::varchar = imce.state_code		    
	left join (select state_code, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'InterstitialMonitoringManual') imm
	    on t."LD_INTERSTL_PIP_SYSTEM_KEY"::varchar = imm.state_code	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'AutomaticTankGauging') atg
	    on ft."LD_SYSTEM_TANK" = atg.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'ManualTankGauging') mtg
	    on ft."LD_SYSTEM_TANK" = mtg.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'StatisticalInventoryReconciliation') sir
	    on ft."LD_SYSTEM_TANK" = sir.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'TankTightnessTesting') ttt
	    on ft."LD_SYSTEM_TANK" = ttt.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'ElectronicLineLeak') ell
	    on ft."LD_SYSTEM_PIPE" = ell.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'MechanicalLineLeak') mll
	    on ft."LD_SYSTEM_PIPE" = mll.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'SafeSuction') ss
	    on ft."LD_SYSTEM_PIPE" = ss.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping
	           where state = 'NC' and element_name = 'PrimaryReleaseDetectionType') prd
	    on ft."LD_SYSTEM_PIPE" = prd.state_value	
where "TANK_STATUS" not in ('Intent to Install','Never Installed','Transfer')
and "PRODUCT" not in ('ETHANOL','Tank never installed at location.') 
and f."FACILITY_TYPE_KEY" = 0  
order by fown."FACILITY_ID", ft."TANK_ID";



select * from information_schema.columns where table_schema = 'NC_UST' and column_name = 'PRODUCT'

select * from "NC_UST"."VW_USTF_TANK_DETAIL_DATA_VIEW" where "PRODUCT" in ('ETHANOL','Tank never installed at location.') 

select count(*) from (select distinct "FacilityID", "TankID" from "NC_UST".v_ust) a;

select * from ust_facilities where control_id = 17;