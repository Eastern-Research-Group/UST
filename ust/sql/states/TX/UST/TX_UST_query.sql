select * from "TX_UST".facilities where facility_status = 'ACTIVE';



select * from "TX_UST".compartments ;



select * from "TX_UST".tanks ;










insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FacilityType1', 'facilities', 'facility_type')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, '', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'AIRCRAFT REFUELING', 'Aviation/airport (non-rental car)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'ASPHALT AND CONCRETE PRODUCTIO', 'Contractor');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'BULK FUEL AND LUBES DISTRIBUTI', 'Bulk plant storage/petroleum distributor');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'EMERGENCY GENERATOR', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'FARM OR RESIDENTIAL', 'Agricultural/farm');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'FLEET REFUELING', 'Trucking/transport/fleet operation');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'INDIAN LAND', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'INDUST/MFG/CHEM PLANT', 'Industrial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'OTHER', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'RETAIL', 'Retail fuel sales (non-marina)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'UNKNOWN', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'WATERCRAFT FUELING', 'Marina');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'WATERCRAFT REFUELING', 'Marina');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (115, 'WHOLESALE', 'Wholesale');

update ust_element_db_mapping set mapping_date = '2023-04-05' where id = 115;
update ust_element_value_mappings set epa_approved = 'Y' where element_db_mapping_id = 115 ;

-----------------------------------------------------------------------------------------------------------------
select distinct mechanism_type from "TX_UST".financial_assurance order by 1 ;

FINANCIAL TEST					FinancialResponsibilitySelfInsuranceFinancialTest
GUARANTEE						FinancialResponsibilityGuarantee
INSURANCE OR RISK RETENTION		FinancialResponsibilityRiskRetentionGroup
LETTER OF CREDIT				FinancialResponsibilityLetterOfCredit
LOCAL GOV FIN TEST				FinancialResponsibilityLocalGovernmentFinancialTest
LOCAL GOV GUARANTEE				FinancialResponsibilityGuarantee
OTHER							FinancialResponsibilityOtherMethod
SURETY BOND						FinancialResponsibilitySuretyBond
TRUST FUND						FinancialResponsibilityTrustFund

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilitySelfInsuranceFinancialTest', 'financial_assurance', 'mechanism_type');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilityGuarantee', 'financial_assurance', 'mechanism_type');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilityRiskRetentionGroup', 'financial_assurance', 'mechanism_type');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilityLetterOfCredit', 'financial_assurance', 'mechanism_type');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilityLocalGovernmentFinancialTest', 'financial_assurance', 'mechanism_type');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilityOtherMethod', 'financial_assurance', 'mechanism_type');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilitySuretyBond', 'financial_assurance', 'mechanism_type');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-06', 'FinancialResponsibilityTrustFund', 'financial_assurance', 'mechanism_type');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (116, 'FINANCIAL TEST', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (117, 'GUARANTEE', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (117, 'LOCAL GOV GUARANTEE', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (118, 'INSURANCE OR RISK RETENTION	', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (119, 'LETTER OF CREDIT', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (120, 'LOCAL GOV FIN TEST', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (121, 'OTHER', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (122, 'SURETY BOND', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (123, 'TRUST FUND', 'Yes');

update ust_element_value_mappings set epa_approved = 'Y' where element_db_mapping_id between 116 and 123;
update ust_element_db_mapping set mapping_date = '2023-04-05' where id between 116 and 123;

-----------------------------------------------------------------------------------------------------------------

select distinct tank_regulatory_status from "TX_UST".tanks order by 1;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-07', 'FederallyRegulated', 'tanks', 'tank_regulatory_status')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'EMERG POWER GENERATOR', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'FULLY REGULATED', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'EXEMPT', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'EXEMPT NON-USE SINCE 1974', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'EXEMPT REM  WITHIN 60 DAYS', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'EXEMPT REM WITHIN 60 DAYS', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'OIL WATER SEPARATOR', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (124, 'WASTEWATER TREATMENT', 'No');

-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-07', 'EmergencyGenerator', 'tanks', 'tank_regulatory_status')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (126, 'EMERG POWER GENERATOR', 'Yes');

-----------------------------------------------------------------------------------------------------------------

select distinct tank_status from "TX_UST".tanks order by 1;
IN USE
PERM FILLED IN PLACE
REMOVED FROM GROUND
TEMP OUT OF SERVICE

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-07', 'TankStatus', 'tanks', 'tank_status')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (125, 'IN USE','Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (125, 'PERM FILLED IN PLACE','Closed (in place)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (125, 'REMOVED FROM GROUND','Closed (removed from ground)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (125, 'TEMP OUT OF SERVICE','Temporarily out of service');

-----------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-07', 'Compliance', 'facilities', 'enforcement_action')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (225, 'N', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (225, 'Y', 'No');

case when f.enforcement_action = 'N' then 'Yes' when end as "Compliance",  --IS THIS OK?


-----------------------------------------------------------------------------------------------------------------
drop view "TX_UST".v_excavation_liner;
create or replace view "TX_UST".v_excavation_liner as
select distinct t.facility_id, t.tank_id,
	case when t.tank_synthetic_trench_liner = 'Y' or t.tank_rigid_trench_liner = 'Y' then 'Yes' end as "ExcavationLiner"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'ExcavationLiner', 'v_excavation_liner', 'ExcavationLiner')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (226, ''' || "ExcavationLiner" ||  ''', '''');'
from "TX_UST".v_excavation_liner
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (226, 'Yes', 'Yes');
-----------------------------------------------------------------------------------------------------------------
drop view  "TX_UST".v_tank_wall_type;
create view "TX_UST".v_tank_wall_type as
select distinct t.facility_id,  t.tank_id,
		case when t.tank_single_wall = 'Y' then 'Single' when t.tank_double_wall = 'Y' then 'Double' end as "TankWallType"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'TankWallType', 'v_tank_wall_type', 'TankWallType')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (227, ''' || "TankWallType" ||  ''', '''');'
from "TX_UST".v_tank_wall_type
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (227, 'Double', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (227, 'Single', 'Single');
-----------------------------------------------------------------------------------------------------------------
drop view  "TX_UST".v_material_description;
create view "TX_UST".v_material_description as
select distinct t.facility_id,  t.tank_id,
			case when t.tank_material_steel = 'Y' then 'Steel' 
	     when t.tank_material_frp = 'Y' then 'Fiberglass reinforced plastic'
	     when t.tank_material_concrete = 'Y' then 'Concrete'
	     when t.tank_material_jacketed = 'Y' then 'Jacketed steel'
	     when t.tank_material_coated = 'Y' then 'Epoxy coated steel' end as "MaterialDescription"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'MaterialDescription', 'v_material_description', 'MaterialDescription')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (228, ''' || "MaterialDescription" ||  ''', ''' || "MaterialDescription" || ''');'
from "TX_UST".v_material_description
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (228, 'Concrete', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (228, 'Epoxy coated steel', 'Epoxy coated steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (228, 'Fiberglass reinforced plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (228, 'Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (228, 'Jacketed steel', 'Jacketed steel');
-----------------------------------------------------------------------------------------------------------------
drop view  "TX_UST".v_piping_material_description;
create view "TX_UST".v_piping_material_description as
select distinct t.facility_id,  t.tank_id,
	case when t.piping_material_steel = 'Y' then 'Steel' 
		 when t.piping_material_frp = 'Y' then 'Fiberglass reinforced plastic' 
		 when t.piping_material_concrete = 'Y' then 'Other' 
		 when t.piping_material_jacketed = 'Y' then 'Other' 
		 when t.piping_material_flex_pipe = 'Y' then 'Flex piping' end as "PipingMaterialDescription"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'PipingMaterialDescription', 'v_piping_material_description', 'PipingMaterialDescription')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (229, ''' || "PipingMaterialDescription" ||  ''', ''' || "PipingMaterialDescription" || ''');'
from "TX_UST".v_piping_material_description
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (229, 'Fiberglass reinforced plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (229, 'Flex piping', 'Flex piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (229, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (229, 'Steel', 'Steel');

-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'PipingFlexConnector', 'tanks', 'piping_connector_flex')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (230, ''' || "piping_connector_flex" ||  ''', '''');'
from "TX_UST".tanks
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (230, 'Y', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (230, 'N', 'No');
-----------------------------------------------------------------------------------------------------------------
drop view "TX_UST".v_piping_wall_type;
create view "TX_UST".v_piping_wall_type as
select distinct t.facility_id,  t.tank_id,
	case when t.piping_single_wall = 'Y' then 'Single walled' when t.piping_double_wall = 'Y' then 'Double walled' end as "PipingWallType"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'PipingWallType', 'v_piping_wall_type', 'PipingWallType')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (231, ''' || "PipingWallType" ||  ''', ''' || "PipingWallType" || ''');'
from "TX_UST".v_piping_wall_type
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (231, 'Double walled', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (231, 'Single walled', 'Single walled');
-----------------------------------------------------------------------------------------------------------------
drop view "TX_UST".v_tank_corrosion_protection_sac_anode;
create view "TX_UST".v_tank_corrosion_protection_sac_anode as
select distinct t.facility_id,  t.tank_id,
	case when t.tank_corrosion_cathodic_factory = 'Y' or t.tank_corrosion_cathodic_field = 'Y' then 'Yes' end as "TankCorrosionProtectionSacrificialAnode"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'TankCorrosionProtectionSacrificialAnode', 'v_tank_corrosion_protection_sac_anode', 'TankCorrosionProtectionSacrificialAnode')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (232, ''' || "TankCorrosionProtectionSacrificialAnode" ||  ''', ''' || "TankCorrosionProtectionSacrificialAnode" || ''');'
from "TX_UST".v_tank_corrosion_protection_sac_anode
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (232, 'Yes', 'Yes');
-----------------------------------------------------------------------------------------------------------------
drop view "TX_UST".v_tank_corrosion_protection_sac_anode_install_retro;
create view "TX_UST".v_tank_corrosion_protection_sac_anode_install_retro as
select distinct t.facility_id,  t.tank_id,
	case when t.tank_corrosion_cathodic_factory = 'Y' then 'Installed' when t.tank_corrosion_cathodic_field = 'Y' then 'Retrofitted' else 'Unknown' end as "TankCorrosionProtectionAnodeInstalledOrRetrofitted"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'TankCorrosionProtectionAnodeInstalledOrRetrofitted', 'v_tank_corrosion_protection_sac_anode_install_retro', 'TankCorrosionProtectionAnodeInstalledOrRetrofitted')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (233, ''' || "TankCorrosionProtectionAnodeInstalledOrRetrofitted" ||  ''', ''' || "TankCorrosionProtectionAnodeInstalledOrRetrofitted" || ''');'
from "TX_UST".v_tank_corrosion_protection_sac_anode_install_retro
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (233, 'Installed', 'Installed');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (233, 'Retrofitted', 'Retrofitted');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (233, 'Unknown', 'Unknown');
-----------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'TankCorrosionProtectionCathodicNotRequired', 'tanks', 'tank_corrosion_not_required')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (234, ''' || "tank_corrosion_not_required" ||  ''', '''');'
from "TX_UST".tanks
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (234, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (234, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
drop view "TX_UST".v_tank_corrosion_protection_other;
create view "TX_UST".v_tank_corrosion_protection_other as
select distinct t.facility_id,  t.tank_id,
case when t.tank_corrosion_external_dielectric = 'Y' or t.tank_corrosion_composite = 'Y' or t.tank_corrosion_coated = 'Y'
			or t.tank_corrosion_frp = 'Y' or t.tank_corrosion_external_jacket = 'Y' then 'Yes' end as "TankCorrosionProtectionOther"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'TankCorrosionProtectionOther', 'v_tank_corrosion_protection_other', 'TankCorrosionProtectionOther')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (235, ''' || "TankCorrosionProtectionOther" ||  ''', ''' || "TankCorrosionProtectionOther" || ''');'
from "TX_UST".v_tank_corrosion_protection_other
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (235, 'Yes', 'Yes');

-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'PipingCorrosionProtectionCathodicNotRequired', 'tanks', 'piping_corrosion_not_required')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (236, ''' || "piping_corrosion_not_required" ||  ''', '''');'
from "TX_UST".tanks
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (236, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (236, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'PipingCorrosionProtectionExternalCoating', 'tanks', 'piping_corrosion_external_dielectric')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (237, ''' || "piping_corrosion_external_dielectric" ||  ''', '''');'
from "TX_UST".tanks
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (237, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (237, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
drop view "TX_UST".v_piping_corrosion_protection_other;
create view "TX_UST".v_piping_corrosion_protection_other as
select distinct t.facility_id,  t.tank_id,
case when t.piping_corrosion_cathodic_factory = 'Y' or t.piping_corrosion_cathodic_field = 'Y'
			or t.piping_corrosion_frp = 'Y' or t.piping_corrosion_flex = 'Y' or t.piping_corrosion_isolated = 'Y' 
			or t.piping_corrosion_dual = 'Y' then 'Yes' end as "PipingCorrosionProtectionOther"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'PipingCorrosionProtectionOther', 'v_piping_corrosion_protection_other', 'PipingCorrosionProtectionOther')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (238, ''' || "PipingCorrosionProtectionOther" ||  ''', ''' || "PipingCorrosionProtectionOther" || ''');'
from "TX_UST".v_piping_corrosion_protection_other
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (238, 'Yes', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'FlowShutoffDevice', 'compartments', 'sp_flow_restrictor')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (239, ''' || "sp_flow_restrictor" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (239, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (239, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'FlowShutoffDevice', 'compartments', 'sp_flow_restrictor')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (240, ''' || "sp_flow_restrictor" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (240, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (240, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'HighLevelAlarm', 'compartments', 'sp_alarm')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (241, ''' || "sp_alarm" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (241, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (241, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
create view "TX_UST".v_spill_bucket as
select distinct c.facility_id, c.tank_id, c.compartment_id,
	case when c.sp_tight_fill_container_bucket_sump = 'Y' or c.sp_factory_container_bucket_sump = 'Y' then 'Yes' end as "SpillBucketInstalled"
from "TX_UST".compartments  c;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'SpillBucketInstalled', 'v_spill_bucket', 'SpillBucketInstalled')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (242, ''' || "SpillBucketInstalled" ||  ''', ''' || "SpillBucketInstalled" || ''');'
from "TX_UST".v_spill_bucket
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (242, 'Yes', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'AutomaticTankGauging', 'compartments', 'compartment_rd_automatic_tank_gauge')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (243, ''' || "compartment_rd_automatic_tank_gauge" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (243, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (243, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'AutomaticTankGaugingReleaseDetection', 'compartments', 'compartment_rd_automatic_tank_gauge')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (243, ''' || "compartment_rd_automatic_tank_gauge" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (244, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (244, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'AutomaticTankGaugingContinuousLeakDetection', 'compartments', 'compartment_rd_automatic_tank_gauge')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (245, 'Y', 'Unknown');
-----------------------------------------------------------------------------------------------------------------
create view "TX_UST".v_manual_tank_gauging as
select distinct c.facility_id, c.tank_id, c.compartment_id,
	case when c.compartment_rd_manual_tank_gauge = 'Y' or c.compartment_rd_monthly_tank_gauge = 'Y' then 'Yes' end as "ManualTankGauging"
from "TX_UST".compartments  c;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'ManualTankGauging', 'v_manual_tank_gauging', 'ManualTankGauging')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (246, ''' || "ManualTankGauging" ||  ''', ''' || "ManualTankGauging" || ''');'
from "TX_UST".v_manual_tank_gauging
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (246, 'Yes', 'Yes');
-----------------------------------------------------------------------------------------------------------------
update ust_element_db_mapping set  element_name = 'StatisticalInventoryReconciliation', state_table_name = 'compartments', state_column_name = 'compartment_rd_sir'
where id = 247;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (247, ''' || "compartment_rd_sir" ||  ''', '''');'
from "TX_UST".compartments
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (247, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (247, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'GroundwaterMonitoring', 'compartments', 'compartment_rd_gw_monitoring')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (248, ''' || "compartment_rd_gw_monitoring" ||  ''', '''');'
from "TX_UST".compartments
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (248, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (248, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'VaporMonitoring', 'compartments', 'compartment_rd_vapor_monitoring')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (249, ''' || "compartment_rd_vapor_monitoring" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (249, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (249, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'ElectronicLineLeak', 'compartments', 'piping_rd_auto_line_leak_detector')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (250, ''' || "piping_rd_auto_line_leak_detector" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (250, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (250, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'AutomatedIntersticialMonitoring', 'compartments', 'piping_rd_interstitial_monitoring')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (251, ''' || "piping_rd_interstitial_monitoring" ||  ''', '''');'
from "TX_UST".compartments
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (251, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (251, 'Y', 'Yes');
-----------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'HighPressure', 'tanks', 'piping_type')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (252, ''' || "piping_type" ||  ''', '''');'
from "TX_UST".tanks
order by 1;
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (252, 'P', 'Yes');
-----------------------------------------------------------------------------------------------------------------
create view "TX_UST".v_pipe_secondary_containment as
select distinct facility_id, tank_id, 
	case when t.piping_double_wall = 'Y' then 'Double walled' 
	     when t.piping_synthetic_trench_liner = 'Y' or t.piping_rigid_trench_liner = 'Y' then 'Trench liner' end as "PipeSecondaryContainment"
from "TX_UST".tanks t;

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'PipeSecondaryContainment', 'v_pipe_secondary_containment', 'PipeSecondaryContainment')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (253, ''' || "PipeSecondaryContainment" ||  ''', ''' || "PipeSecondaryContainment" || ''');'
from "TX_UST".v_pipe_secondary_containment
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (253, 'Double walled', 'Double walled');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (253, 'Trench liner', 'Trench liner');
-----------------------------------------------------------------------------------------------------------------
drop view "TX_UST".v_safe_suction;

select facility_id, tank_id , count(*) from 
	(select distinct t.facility_id, t.tank_id, c.piping_rd_exempt 
	from "TX_UST".tanks t join "TX_UST".compartments c on t.facility_id = c.facility_id and t.tank_id = c.tank_id
	where t.piping_type = 'S') a  
group by facility_id, tank_id having count(*) > 1;

create view "TX_UST".v_safe_suction as
select distinct t.facility_id, t.tank_id, 
	case when c.piping_rd_exempt = 'Y' then 'Yes' end as "SafeSuction"
from "TX_UST".tanks t join "TX_UST".compartments c on t.facility_id = c.facility_id and t.tank_id = c.tank_id
where t.piping_type = 'S';

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'SafeSuction', 'v_safe_suction', 'SafeSuction')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (254, 'Yes', 'Yes');


update ust_element_value_mappings set epa_comments = 'Per OUST, Safe Suction does not require release detection, so a "Yes" in the RD exempt column means Safe Suction'
where element_db_mapping_id = 254;
-----------------------------------------------------------------------------------------------------------------

create view "TX_UST".v_american_suction as
select distinct t.facility_id, t.tank_id, 
	case when c.piping_rd_exempt = 'N' then 'Yes' end as "AmericanSuction"
from "TX_UST".tanks t join "TX_UST".compartments c on t.facility_id = c.facility_id and t.tank_id = c.tank_id
where t.piping_type = 'S';

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'AmericanSuction', 'v_american_suction', 'AmericanSuction')
returning id;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (255, 'Yes', 'Yes');


update ust_element_value_mappings set epa_comments = 'Per OUST, American Suction requires release detection, so a "NO" in the RD exempt column means American Suction'
where element_db_mapping_id = 255;


-----------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-04-12', 'InterstitialMonitoringContinualElectric', 'compartments', 'compartment_rd_interstitial_monitoring')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (257, ''' || "compartment_rd_interstitial_monitoring" ||  ''', '''');'
from "TX_UST".compartments
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (257, 'N', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (257, 'Y', 'Yes');

update ust_element_value_mappings set epa_comments = 'Per OUST, nearly all interstitial monitoring is electric. Per Alex, OK to assume electric if not otherwise states' 
where element_db_mapping_id = 257;

-----------------------------------------------------------------------------------------------------------------
select distinct substance from (
	select substance_stored1 as substance from "TX_UST".compartments union all
	select substance_stored2 from "TX_UST".compartments union all
	select substance_stored3 from "TX_UST".compartments) a 
where substance is not null 
order by 1;

select * from v_ust_element_mapping where element_name like '%Substance%' and lower(state_value) like '%xyl%';

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('TX', '2023-03-07', 'CompartmentSubstanceStored', 'compartments', 'substance_stored1')
returning id;

update ust_element_db_mapping set mapping_date = '2023-04-05' where id = 127;
delete from ust_element_value_mappings where element_db_mapping_id = 127;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '>B20','Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '>E10','Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '1-A','Jet fuel A', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '1-AB','Jet fuel A', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '1-BUTANOL','Biofuel/bioheat', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '1 PA','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '1,1,1-TRICHLOROETHANE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '1,2-DICHLOROPROPANE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '100 LL','Unknown aviation gas or jet fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '140 SOLVENT','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '2-ETHYL-HEXYL-ACRYLATE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '2,4-D, SALTS AND ESTERS','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '291 BLEND TOLUENE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '3-A','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '3-J, CLEANER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '3,4-DICHLORO-PROPIONATE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '33 CON','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '7720877','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '8','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '85% AMINE (MEA)','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '8ES300','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, '99','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'A/C SOAP','OTher', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ACETONE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ACFT. SOAP','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ACID','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ACID/ALKAL RINSE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ACRYLONITRILE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ADDITIVE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ADDITIVES (ALL)','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AGR SOLVENT-HAZARDOUS SEL','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ALCOHOL','Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ALCOHOL BLENDED FUELS','Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ALIPHATIC HYDROCARBONS','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ALKALINE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ALUM','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AMBITROL','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AMINE (DEA)','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AMINE WASTE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AMMONIA','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AMS','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AROMATIC 100(C8-C10)','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ASPHALT','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AVIATION GASOLINE','Unknown aviation gas or jet fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'AVIATION JET FUELS','Unknown aviation gas or jet fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'B P CAPTAIN','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BENZENE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BENZOFLEX 9-88','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BENZOIC ACID','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BIO DIESEL','Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BLANKET WASH','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BLANKETWASH','Oher', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BOILER BLOWDOWN & BRINE R','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BRINE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BUNKER C','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BUTANE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BUTYL ACETATE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BUTYL ACRYLATE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'BUTYL CELLOSOLVE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'C-3 FLUID','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CAD ZINC','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CADMIUM ACETATE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CAL FLUID SPENT','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CALIBRATING FLUID','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CAR WASH MTL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CARBON','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CAUSTIC','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CAUSTIC LIQUID 50%','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CAUSTIC SODA','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CELLOSOLVE ACETATE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CELLOSOLVE EP','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CHROMATE H20','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CHROMATE H2O','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CHROMIC ACID','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CHROMIUM','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CHROMIUM COMPOUND','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CLEANING SOLV''T','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CLEANING SOLVENTS','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CLUTCH FLUID','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CONAPSOL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CONCRETE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CONDENSATE WATER/OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CONDENSATES, VAC. TOWER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'COPPER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CR. BEARING SLUDGE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CREOSOTE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CROP SPRAY OIL','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CRUDE OIL','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CURED PHENOLIC RESIN','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CUSHION SAND','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'CYCLOHEXANONE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DE-ICING FLUID','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DETERGENT ADDITIVE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DEXRON','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DIESEL','Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DIESEL ADDITIVE','Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DIESEL BASE ROAD MATERIAL','Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DIESEL DYE','Off-road diesel/dyed diesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DIETHANOLAMINE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DILUTE HEL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DISTILLATE FUEL OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DISTILLATE FUEL OILS','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DISTILLATES, HT LT NAPH','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DOWTHERM','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DRAWING OIL','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DRILLING FLUID','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DRILLING MUD','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DRLG MUD','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'DROMUS OIL','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'EFFLUENT SLUDGE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'EMER. OVERFLOW TANK','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'EMPTY','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'EMSOL CLEANER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'EMULSION','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ENAMEL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'EPOXY-ACRYLIC-AMINO','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHANOL','Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHANOLAMINE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYL ACETATE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYL ACRYLATE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYL ALCOHOL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYL ETHER','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYL HEXYL ACRYLATE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYL KETONE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYLENE DICHLORIDE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYLENE GLYCOL','Antifreeze', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ETHYLENE OXIDE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FERRIC SULPHATE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FERTILIZER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FLAMMABLE INK','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FLAMMABLE SOLVENT','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FLARE CONDENSATE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FLAVOR PROCESS WASH','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FLOW-THROUGH PROCESS TANK','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FLUORIDE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FORMALDEHYDE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FUEL MIX','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FUEL OIL','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FUEL OIL FOR HEATING BUTA','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FUEL OIL, RESIDUAL','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FUELOIL/SOLVENTS','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'FUTURE USE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GAS & DIESEL DRAIN TANK','Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GAS ADDITIVE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GAS BLAST','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GAS/AV GAS','Unknown aviation gas or jet fuel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GAS/DIESEL','Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GASOHOL','Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GASOLINE','Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GASOLINE ADDITIVE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GEAR OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GLYCOL ETHER EB','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GRAVEL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GREASE','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GREASE (SUMP)','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GREASE TRAP SYSTEM','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GREASE/HYD OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'GRIT TRAP','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'H20/OIL MIX','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'H2O & HYDROCARBONS','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'H2O/PETRO LIQ','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HAZARDONS WASTES','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HAZARDOUS WASTE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HEATING OIL','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HEATING OIL TANKS','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HEPTANE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HEXANE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HEXYLENE GLYCOL','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HFRS-2','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HYDRAULIC FLUID','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HYDRAULIC LIFT OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HYDROCHLORIC ACID','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HYDROFLUOSILICIA AC','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'HYDROGEN SULFIDE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'IIAAC','0', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'INDUSTRIAL SOLVENTS','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'INK OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'INTERFACE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'IPA','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ISOPENTANE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ISOPROPYL ALCOHOL','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'JOURNAL BOX OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'K001','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'KEROSENE','Kerosene', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'KEROSENE TO A BOILER','Kerosene', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'KT-2','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'KWIK-DRI','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'L/L RADIOACTIVE WASTE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LAB REAGENTS','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LAB WASTE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LACQUER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LACTOL SPIRITS','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LEAD','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LIGHT HYDROCARBONS','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LINSEED OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LIQUID ASPHALT','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LIQUIFIED PETROLEUM GAS','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LPG','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LUBE OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LUBRICANTS','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LUBRICANTS TRANSMISSION F','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'LUBRIZOL 9888','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'M1BK','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MALEIC ANHYDRIDE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MC-30','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MC-30 OIL','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MC-30, SURFACTANTS','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MC 30','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MC30','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MC30 PRIME','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MEA & WATER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHANE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHANOL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHOXY-2-PROPANOL 1','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHYL ETHYL KETONE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHYL ISOBUTYL KETONE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHYL MERCAPTAN','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHYL METHACRYLATE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'METHYLENE CHLORIDE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MIAK','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MIBK','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MICROBIAL & WATER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MINERAL OIL','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MINERAL SPIRITS','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MIX HYDROCARBON','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MIXED HYDROCARBONS','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MIXED PETRO','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MIXED PRODUCT','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MOBIL 600W LUB OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MOBIL DTE13 LUB OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MOBIL HM LUB OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MOP OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'MOSTLY WATER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'N-PROPYL ACETATE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NAPHTHA','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NAPTHOL SP.','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NEUT ACID','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NEW OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NEW TANKS ONLY WATER ACC.','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NEW TANKS, ONLY WATER ACC','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NITRIC ACID','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NITROGEN','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NITROGEN DIOXIDE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NO MINERAL SPIRITS','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NORPAR 12','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'NORPAR 13','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OAKLITE FORM 59','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OFF-SPEC PRODUCT','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OFF SPEC PROD','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OIL DECANT TANK','Used oil/waste oil', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OIL SLUDGE','Used oil/waste oil', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OIL WATER SEPARATOR','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OILY WATER & HYDROCARBONS','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ORG.SOLVENT MIX','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OTHER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OTHER PETROLEUM PRODUCT','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OTHER WATER & OIL SPILLOV','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OVERFLOW','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OVERFLOW TANK/OIL/W SEP','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OVERFLOW TK FOR OIL/W SEP','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'OWS LEG','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PAINT','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PAINT & THINNERS','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PAINT STRIPPER','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PAINT THINNER','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PAINTS,TOLUENE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PALATINOL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PD-680','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PD680','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PENTANE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PERCHLOROETHYLENE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PESTICIDES','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PET SOLVENT','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PETRO/WATER','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PETROL NAPHTHA SLUDE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PETROLEUM','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PHENOL','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PHOSGENE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PHTHALIC ANHYDRIDE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PLASTICIZER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PLASTISOL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PLATING TANK W/ELECTRO-LE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PM ACETATE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'POLYESTER RESIN','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'POLYESTOR RESIN','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'POTASSIUM HYDROXIDE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PRE-TREATMENT','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROD. ADDITIVE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROD. COMINGLE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PRODUCED WATER','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PRODUCT ADDITIVE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PRODUCT COMINGLE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PRODUCT RECOVERY','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROPANE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROPANOL','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROPIONALDEHYDE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROPYL ALCOHOL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROPYLENE GLYCOL','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROPYLENE OXIDE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'PROSOL 48','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'QUENCH OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'RECLAMITE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'REFRIGERANT OIL','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'RESIDUAL FUEL OILS','Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'RESIN','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ROLLER WASH','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'RUB SOLV 1001','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'RUBBER MAKERS CE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'RUBBER PROCESS OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'RUBBER SOLVENT NAPH','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SAND','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SAND/OIL INTERCEPTOR','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SC-150','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SC 150','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SDA 39C','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SEPTIC TANK','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SEWAGE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SHELL-SOL','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SHOP RUN-OFF','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SLUDGE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SLUDGE/SAND TRAP','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SODIUM HYDROXIDE','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLUBLE OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLUTION SODIUM','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLVENT-VARSOL','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLVENT MIX/THF/TOLU','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLVENT THF-TOLUENE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLVENT THF/TOLUENE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLVENTS','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLVENTS & PLATING W','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOLVESSO 100','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SOYBEAN OIL','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'STODDARD SOLVENT','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'STYRENE','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'STYRENE & POLYESTER','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'STYRENE MIX','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'STYRENE POLYMER','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SULFONATE RESINS,','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SULFUR','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SULFURIC ACID','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SUMP TANK','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SUMP WASTE','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'SYNTHETIC OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TANK BTMS','0', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TCE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TEMP WASTE LIQUIDS','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TERGITOL NP-9','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TEST WELL','0', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TETRAHYDROFURAN','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TEXANOL','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TEXTILE SPIRITS','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'THINNER','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'THINNER B5','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TOLUENE','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TOLUOL','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TOLUOL/ACETONE','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TRACE PESTICIDES','Hazardous Substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TRANSFER FLUID','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TRANSFORMER OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TRANSFORMER OILS','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TRANSMISSION FLUID','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TREATMENT OIL','Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TRIETHYLENE GLYCOL','Hazardous substance', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TRIM-SOL COOLANT','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'TYPEWASH #2','Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'ULTRA 201 9888','Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'UNK PETRO MIX','Petroleum product', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (127, 'UNKNOWN','Unknown', 'Y');


select ust_id, facility_id, tank_id, compartment_id, substance_stored1, substance_stored2, substance_stored3
from "TX_UST".compartments  
where substance_stored1 is not null and (substance_stored2 is not null or substance_stored3 is not null) and (substance_stored3 <> '')
order by 1, 2, 3, 4, 5;

select * from ust_element_value_mappings where element_db_mapping_id in (select id from ust_element_db_mapping where state = 'TX');

update ust_element_value_mappings 
set epa_approved = 'Y' where element_db_mapping_id in (select id from ust_element_db_mapping where state = 'TX');


-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

drop view "TX_UST".v_ust_base;

create view "TX_UST".v_ust_base as 
select 
	f.facility_id as "FacilityID",
	f.facility_name as "FacilityName",
	ft.epa_value "FacilityType1",
	f.site_address as "FacilityAddress1",
	f.site_city as "FacilityCity",
	f.site_location_county as "FacilityCounty",
	f.site_zip as "FacilityZipCode",
	f.site_state as "FacilityState",
	6 as "FacilityEPARegion",
	f.facility_contact_organization_name as "FacilityOperatorCompanyName", 
	f.facility_contact_last_name as "FacilityOperatorLastName",
	f.facility_contact_first_name as "FacilityOperatorFirstName",
	f.facility_contact_mailing_address as "FacilityOperatorAddress1",
	f.facility_contact_mailing_city as "FacilityOperatorCity",
	f.facility_contact_mailing_zip as "FacilityOperatorZipCode",
	f.facility_contact_mailing_state as "FacilityOperatorState",
	f.facility_contact_mailing_phone_number || ' ' || f.facility_contact_mailing_phone_number  as "FacilityOperatorPhoneNumber",
	f.facility_contact_email as "FacilityOperatorEmail",
	frg.epa_value as "FinancialResponsibilityGuarantee",
	frlc.epa_value as "FinancialResponsibilityLetterOfCredit",
	frlg.epa_value as "FinancialResponsibilityLocalGovernmentFinancialTest",
	frrr.epa_value as "FinancialResponsibilityRiskRetentionGroup",
	frsi.epa_value as "FinancialResponsibilitySelfInsuranceFinancialTest",
	frsb.epa_value as "FinancialResponsibilitySuretyBond",
	frtf.epa_value as "FinancialResponsibilityTrustFund",
	fro.epa_value as "FinancialResponsibilityOtherMethod",
	case when frg.epa_value is not null or frlc.epa_value is not null or frlg.epa_value is not null 
	       or frrr.epa_value is not null or frsi.epa_value is not null or frsb.epa_value is not null 
	       or frtf.epa_value is not null or fro.epa_value is not null then 'Yes' else 'Unknown' end as "FinancialResponsibilityObtained",
	cmp.epa_value as "Compliance",
	t.tank_id as "TankID",
	fr.epa_value as "FederallyRegulated",
	ts.epa_value as "TankStatus",
	eg.epa_value as "EmergencyGenerator",
	t.tank_registration_date as "InstallationDate",
	case when t.number_of_compartments::integer > 1 then 'Yes' when t.number_of_compartments::integer = 1 then 'No' end as "CompartmentalizedUST",
	case when t.number_of_compartments = '' then null::integer else t.number_of_compartments::integer end as "NumberOfCompartments",
	c.compartment_id as "CompartmentID",
	sub.epa_value as "CompartmentSubstanceStored", 
	case when t.tank_capacity_gallons = '' then null
		 else t.tank_capacity_gallons::integer end as "TankCapacityGallons",
	case when c.capacity_gallons = '' then null
		 else c.capacity_gallons::integer end as "CompartmentCapacityGallons",
	el.epa_value as "ExcavationLiner",
	twt.epa_value as "TankWallType",
	md.epa_value as "MaterialDescription",
	pmd.epa_value "PipingMaterialDescription",
	pfc.epa_value "PipingFlexConnector",
	pwt.epa_value as "PipingWallType",
	tcpsa.epa_value as "TankCorrosionProtectionSacrificialAnode",
	tcpair.epa_value as "TankCorrosionProtectionAnodeInstalledOrRetrofitted",
	tcpcnr.epa_value "TankCorrosionProtectionCathodicNotRequired",
	tcpo.epa_value as "TankCorrosionProtectionOther",
	pcpcnr.epa_value as "PipingCorrosionProtectionCathodicNotRequired",
	pcpec.epa_value as "PipingCorrosionProtectionExternalCoating",
	pcpo.epa_value as "PipingCorrosionProtectionOther",
	fsd.epa_value as "FlowShutoffDevice",
	hla.epa_value as "HighLevelAlarm",
	sbi.epa_value as "SpillBucketInstalled", 
	atg.epa_value as "AutomaticTankGauging",
	atgrd.epa_value as "AutomaticTankGaugingReleaseDetection",
	atgcld.epa_value as "AutomaticTankGaugingContinuousLeakDetection",
	mtg.epa_value as "ManualTankGauging",
	sir.epa_value as "StatisticalInventoryReconciliation",
	gw.epa_value as "GroundwaterMonitoring",
	vm.epa_value as "VaporMonitoring",
	ell.epa_value as "ElectronicLineLeak",
	aim.epa_value as "AutomatedIntersticialMonitoring",
	ss.epa_value as "SafeSuction", 
	ass.epa_value as "AmericanSuction",
	hp.epa_value as "HighPressure",
	psc.epa_value as "PipeSecondaryContainment",
	imce.epa_value as "InterstitialMonitoringContinualElectric"
from "TX_UST".facilities f left join "TX_UST".tanks t on f.facility_id = t.facility_id
	left join "TX_UST".compartments c on t.ust_id = c.ust_id  
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FacilityType1') ft on f.facility_type = ft.state_value 
	left join (select distinct facility_id, mechanism_type from "TX_UST".financial_assurance) fa on f.facility_id = fa.facility_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilitySelfInsuranceFinancialTest') frsi 
		on fa.mechanism_type = frsi.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilityGuarantee') frg
		on fa.mechanism_type = frg.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilityRiskRetentionGroup') frrr
		on fa.mechanism_type = frrr.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilityLetterOfCredit') frlc
		on fa.mechanism_type = frlc.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilityLocalGovernmentFinancialTest') frlg
		on fa.mechanism_type = frlg.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilityOtherMethod') fro
		on fa.mechanism_type = fro.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilitySuretyBond') frsb
		on fa.mechanism_type = frsb.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FinancialResponsibilityTrustFund') frtf
		on fa.mechanism_type = frtf.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FederallyRegulated') fr
		on t.tank_regulatory_status = fr.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'TankStatus') ts
		on t.tank_status = ts.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'EmergencyGenerator') eg
		on t.tank_status = eg.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'CompartmentSubstanceStored') sub
		on c.substance_stored1 = sub.state_value	
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'Compliance') cmp
		on f.enforcement_action = cmp.state_value	
	left join "TX_UST".v_excavation_liner vel on t.facility_id = vel.facility_id and t.tank_id = vel.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'ExcavationLiner') el on vel."ExcavationLiner" = el.state_value
	left join "TX_UST".v_tank_wall_type vtwt on t.facility_id = vtwt.facility_id and t.tank_id = vtwt.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'TankWallType') twt on vtwt."TankWallType" = twt.state_value
	left join "TX_UST".v_material_description vmd on t.facility_id = vmd.facility_id and t.tank_id = vmd.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'MaterialDescription') md on vmd."MaterialDescription" = md.state_value
	left join "TX_UST".v_piping_material_description vpmd on t.facility_id = vpmd.facility_id and t.tank_id = vpmd.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'PipingMaterialDescription') pmd on vpmd."PipingMaterialDescription" = pmd.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'PipingFlexConnector') pfc on t.piping_connector_flex = pfc.state_value
	left join "TX_UST".v_piping_wall_type vpwt on t.facility_id = vpwt.facility_id and t.tank_id = vpwt.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'PipingWallType') pwt on vpwt."PipingWallType" = pwt.state_value
	left join "TX_UST".v_tank_corrosion_protection_sac_anode vsac on t.facility_id = vsac.facility_id and t.tank_id = vsac.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'TankCorrosionProtectionSacrificialAnode') tcpsa on vsac."TankCorrosionProtectionSacrificialAnode" = tcpsa.state_value
	left join "TX_UST".v_tank_corrosion_protection_sac_anode_install_retro vsacir on t.facility_id = vsacir.facility_id and t.tank_id = vsacir.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'TankCorrosionProtectionAnodeInstalledOrRetrofitted') tcpair on vsacir."TankCorrosionProtectionAnodeInstalledOrRetrofitted" = tcpair.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'TankCorrosionProtectionCathodicNotRequired') tcpcnr on t.tank_corrosion_not_required = tcpcnr.state_value
	left join "TX_UST".v_tank_corrosion_protection_other vtcpo on t.facility_id = vtcpo.facility_id and t.tank_id = vtcpo.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'TankCorrosionProtectionOther') tcpo on vtcpo."TankCorrosionProtectionOther" = tcpo.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'PipingCorrosionProtectionCathodicNotRequired') pcpcnr on t.piping_corrosion_not_required = pcpcnr.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'PipingCorrosionProtectionExternalCoating') pcpec on t.piping_corrosion_external_dielectric = pcpec.state_value
	left join "TX_UST".v_piping_corrosion_protection_other vpcpo on t.facility_id = vpcpo.facility_id and t.tank_id = vpcpo.tank_id
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'PipingCorrosionProtectionOther') pcpo on vpcpo."PipingCorrosionProtectionOther" = pcpo.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'FlowShutoffDevice') fsd on c.sp_flow_restrictor = fsd.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'HighLevelAlarm') hla on c.sp_alarm = hla.state_value
	left join "TX_UST".v_spill_bucket vsb on c.facility_id = vsb.facility_id  and c.tank_id = vsb.tank_id and c.compartment_id = vsb.compartment_id 
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'SpillBucketInstalled') sbi on vsb."SpillBucketInstalled" = sbi.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'AutomaticTankGauging') atg on c.compartment_rd_automatic_tank_gauge = atg.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'AutomaticTankGaugingReleaseDetection') atgrd on c.compartment_rd_automatic_tank_gauge = atgrd.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'AutomaticTankGaugingContinuousLeakDetection') atgcld on c.compartment_rd_automatic_tank_gauge = atgcld.state_value
	left join "TX_UST".v_manual_tank_gauging vmtg on c.facility_id = vmtg.facility_id  and c.tank_id = vmtg.tank_id and c.compartment_id = vmtg.compartment_id 
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'ManualTankGauging') mtg on vmtg."ManualTankGauging" = mtg.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'StatisticalInventoryReconciliation') sir on c.compartment_rd_sir = sir.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'GroundwaterMonitoring') gw on c.compartment_rd_gw_monitoring = gw.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'VaporMonitoring') vm on c.compartment_rd_vapor_monitoring = vm.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'ElectronicLineLeak') ell on c.piping_rd_auto_line_leak_detector = ell.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'AutomatedIntersticialMonitoring') aim on c.piping_rd_interstitial_monitoring = aim.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'HighPressure') hp on t.piping_type = hp.state_value
	left join "TX_UST".v_pipe_secondary_containment vpsc on t.facility_id = vpsc.facility_id  and t.tank_id = vpsc.tank_id 
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'PipeSecondaryContainment') psc on vpsc."PipeSecondaryContainment" = psc.state_value
	left join "TX_UST".v_safe_suction vss on t.facility_id = vss.facility_id  and t.tank_id = vss.tank_id 
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'SafeSuction') ss on vss."SafeSuction" = ss.state_value
	left join "TX_UST".v_american_suction vas on t.facility_id = vas.facility_id  and t.tank_id = vas.tank_id 
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'AmericanSuction') ass on vas."AmericanSuction" = ass.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'TX' and element_name = 'InterstitialMonitoringContinualElectric') imce on c.compartment_rd_interstitial_monitoring = imce.state_value
	;



select distinct tank_regulatory_status 
from "TX_UST".tanks;

EMERG POWER GENERATOR
EXEMPT
EXEMPT NON-USE SINCE 1974
EXEMPT REM  WITHIN 60 DAYS
EXEMPT REM WITHIN 60 DAYS
FULLY REGULATED
OIL WATER SEPARATOR
WASTEWATER TREATMENT


select count(*) from "TX_UST".tanks where tank_regulatory_status in ('FULLY REGULATED','OIL WATER SEPARATOR','EMERG POWER GENERATOR');
186607
176079
176092
176909

select u."FacilityID", u."TankID", "TankStatus", tank_regulatory_status
from ust u join "TX_UST".tanks t on u."FacilityID" = t.facility_id and u."TankID" = t.tank_id
where u.organization_id = 'TX'
and tank_regulatory_status in ('FULLY REGULATED','OIL WATER SEPARATOR','EMERG POWER GENERATOR')

delete
from  ust u 
where organization_id = 'TX' and exists 
	(select 1 from "TX_UST".tanks t where  u."FacilityID" = t.facility_id and u."TankID" = t.tank_id
	and (tank_regulatory_status = 'WASTEWATER TREATMENT' or tank_regulatory_status like 'EXEMPT%' or tank_regulatory_status = 'OIL WATER SEPARATOR')) ;
9926

select * into tx_ust_bkup from ust where organization_id = 'TX'

select count(*)
from  ust u 
where organization_id = 'TX' and exists 
	(select 1 from "TX_UST".tanks t where  u."FacilityID" = t.facility_id and u."TankID" = t.tank_id
	and tank_regulatory_status = 'EMERG POWER GENERATOR') ;

EMERG POWER GENERATOR - 1214
1227

delete
from  ust u 
where organization_id = 'TX' and exists 
	(select 1 from "TX_UST".tanks t where  u."FacilityID" = t.facility_id and u."TankID" = t.tank_id
	and tank_regulatory_status = 'EMERG POWER GENERATOR') ;

select distinct element_db_mapping_id, element_name, state_table_name, state_column_name 
from v_ust_element_mapping where state = 'TX'
order by 1;

create index facility_facility_id on "TX_UST".facilities(facility_id);
create index tank_facility_id on "TX_UST".tanks(facility_id);
create index tank_tank_id on "TX_UST".tanks(tank_id);
create index compartment_facility_id on "TX_UST".compartments (facility_id);
create index compartment_tank_id on "TX_UST".compartments (tank_id);
create index compartment_comparment_id on "TX_UST".compartments (compartment_id);

	
select facility_status, count(*)
from "TX_UST".facilities f  join "TX_UST".tanks t on f.facility_id = t.facility_id
where site_address  = ''
group by facility_status;

 

-----------------------------------------------------------------------------------------------------------------


select * from "TX_UST".v_ust order by "FacilityID","TankID","CompartmentID";


select element_name, state_value, epa_value
from v_ust_element_mapping
where state = 'TX'
order by element_name, state_value;

select * from tank_status 