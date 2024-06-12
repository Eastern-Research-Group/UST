select * from ust_element_db_mapping where state = 'NC';

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'TankStatus','VW_USTF_TANK_DETAIL_DATA_VIEW','TANK_STATUS');


select * from ust_element_value_mappings 
where element_db_mapping_id in (select id from ust_element_db_mapping where state = 'NC');


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (42, 'Abandoned', 'Abandoned', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (42, 'Current', 'Currently in use', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (42, 'Removed', 'Closed (removed from ground)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (42, 'Temporarily Closed', 'Temporarily out of service', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query, epa_approved)
values (42, 'Intent to Install','Y','Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query, epa_approved)
values (42, 'Never Installed','Y','Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query, epa_approved)
values (42, 'Transfer','Y','Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_approved)
values (42, 'Unknown','Y');

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'OwnerType', 'USTF_TANK_FACILITY_DATA_TABLE', 'TYPE_OWNER_KEY');

insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (43, '1', 'Federal-Non Billable', 'Federal Government - Non Military', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (43, '2', 'State Gov''t', 'State Government - Non Military', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (43, '3', 'Local Gov''t', 'Local Government', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (43, '5', 'Federal-Billable', 'Federal Government - Non Military', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (43, '4', 'Private/Corporate', 'Private', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (43, '0', 'Unknown', null, 'Y');


insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'TankSubstanceStored', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'PRODUCT');

select * from ust_element_db_mapping where state = 'NC' order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, '99.9% BIODIESEL', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'ACETONE', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'B99 Biodiesel', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Bio', 'Biofuel/bioheat', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'BIO-DIESEL (B99.9)', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'BIO-DIESEL(99.9)', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Bio Diesel 100%', '100% biodiesel (not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'BIODIESEL', 'Biofuel/bioheat', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'BIODIESEL (B99.9)', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'BIODIESEL(B99.9)', 'Diesel blend containing 99% to less than 100% biodiesel', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Car Wash Runoff', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'DEF', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'DEF NON REGULATED', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'DEF TANK', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Diesel', 'Diesel fuel (b-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Diesel Exhaust Fluid', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'DIESEL EXHAUST FLUID', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'DIESEL FUEL EXHAUST', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'ETHANOL', 'Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'ETHONAL > 10% GAS MIX', 'Ethanol blend gasoline (e-unknown)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'ETHYL ACETATE', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'FUEL ADDITIVE', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'FUEL ADDITIVE TANK', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Fuel Oil', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Gasoline Additive - Lubrizol 9888', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Gasoline, Aviation', 'Aviation gasoline', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Gasoline, Gas Mix', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Heating Oil/Fuel', 'Heating/fuel oil # unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Hexane', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Hydraulic Fluid', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'ISOPAR C', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'ISOPROPYL ALCOHOL', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Kerosene, Kero Mix', 'Kerosene', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'LUBRIZOL 9888', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'METHYL ETHYL KETONE', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Mixed OIl', 'Used oil/waste oil', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Motor Oil', 'Lube/motor oil (new)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Never Contained Product-Empty', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Never Used', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'NO PRODUCT EVER PLACED IN TANK', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'NON-ETH', 'Gasoline (non-ethanol)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'NOT INDICATED', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'O/W SEPARATOR', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil-Water Separator', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil-water seperator', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OIL WATER MIXTURE', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OIL WATER SEPARATION', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OIL WATER SEPARATOR', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'oil water seperator', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil, New/Used/Mix', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil/Water Mix', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OIL/WATER MIXED', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil/Water Sep', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OIL/WATER SEP', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil/Water Sep <= 1%', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil/Water Separator', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OIL/WATER SEPARATOR', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Oil/WaterSeparator', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OW SEP', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'OWS', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Petroleum', 'Petroleum products', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Petroleum Contact Water', 'Petroleum products', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'PROPYL CELLUSOLVE', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'STODDARD SOLVENT', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query, epa_approved) values (44, 'Tank never installed at location.', 'Y', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'TOLUENE', 'Solvent', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'ULTRAZOL 9888 MIXTURE', 'Gasoline (unknown type)', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'unk', 'Unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'UNK', 'Unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'Unknown', 'Unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved) values (44, 'water/petroleum', 'Petroleum products', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, exclude_from_query, epa_approved) values (44, 'ETHANOL', 'Y', 'Y');



select distinct "FINANCIAL_RESPONSIBILITY" from "USTF_TANK_FACILITY_DATA_TABLE"
2.0
1.0
11.0
10.0

select * from information_schema.columns where column_name = 'FINANCIAL_RESPONSIBILITY'

select * from ust_elements where element_name like 'FinancialRespon%' order by element_position ;
FinancialResponsibilityBondRatingTest
FinancialResponsibilityCommercialInsurance
FinancialResponsibilityGuarantee
FinancialResponsibilityLetterOfCredit
FinancialResponsibilityLocalGovernmentFinancialTest
FinancialResponsibilityRiskRetentionGroup
FinancialResponsibilitySelfInsuranceFinancialTest
FinancialResponsibilityStateFund
FinancialResponsibilitySuretyBond
FinancialResponsibilityTrustFund
FinancialResponsibilityOtherMethod
FinancialResponsibilityNotRequired
FinancialResponsibilityObtained


insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityBondRatingTest', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityCommercialInsurance', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityGuarantee', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityLetterOfCredit', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityLocalGovernmentFinancialTest', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityRiskRetentionGroup', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilitySelfInsuranceFinancialTest', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityStateFund', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilitySuretyBond', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityTrustFund', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityOtherMethod', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01', 'FinancialResponsibilityNotRequired', 'USTF_FINANCIAL_MECH_CD', 'DESCRIPTION');


select id, element_name from ust_element_db_mapping where state = 'NC' and element_name like 'Finan%';

select * from ust_element_value_mappings 
where element_db_mapping_id in 
	(select id from ust_element_db_mapping where state = 'NC' and element_name like 'Finan%');

delete from ust_element_db_mapping where id in (46, 52);

insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (45, '7', 'Local Gov. Bond Rating Test', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (47, '1', 'Corporate Guarantee', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (47, '9', 'Local Gov. Guarantee', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (48, '4', 'Letter of Credit', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (49, '8', 'Local Gov. Financial Test', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (50, '2', 'Insurance & Risk Retension', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (51, '11', 'Self-Insurance', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (53, '3', 'Surety Bond', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (54, '6', 'Private Trust Fund', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (55, '5', 'Insurance Pools', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (55, '10', 'Local Gov. Dedicated Fund', 'Yes', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_code, state_value, epa_value, epa_approved)
values (56, '0', 'None', 'Yes', 'Y');

case when "TANK_CONSTR" like 'Double Wall%' then 'Double' 
			 when "TANK_CONSTR" like 'Single Wall%' then 'Single' end as "TankWallType",
			 
select * from information_schema.columns where column_name = 'TANK_CONSTR'			 

insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01','TankWallType', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'TANK_CONSTR');

select id, element_name from ust_element_db_mapping where state = 'NC' order by 1 desc;

select distinct "TANK_CONSTR" from "VW_USTF_TANK_DETAIL_DATA_VIEW" 
where "TANK_CONSTR" like '%Wall%'
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Double Wall FRP', 'Double', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Double Wall Steel', 'Double', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Double Wall Steel/FRP', 'Double', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Double Wall Steel/Jacketed', 'Double', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Double Wall Steel/Polyurethane', 'Double', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Single Wall FRP', 'Single', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Single Wall Steel', 'Single', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Single Wall Steel/FRP', 'Single', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (57, 'Single Wall Steel/Polyurethane', 'Single', 'Y');


	case when "PIPING_CONSTR" like '%FRP%' then 'Fiberglass Reinforced Plastic'
		     when "PIPING_CONSTR" like '%Flex%' then 'Flex Piping'
			 when "PIPING_CONSTR" like '%Copper%' then 'Copper'
			 when "PIPING_CONSTR" like '%PVC%' then 'Other' --OK??
			 when "PIPING_CONSTR" like '%Plastic%' then 'Other' --OK??
			 when "PIPING_CONSTR" in ('UNK','Unknown') then 'Unknown' end as "PipingMaterialDescription",


select distinct "PIPING_CONSTR" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;		 

select * from ust_element_db_mapping where state = 'NC' order by 1 desc;

insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01','PipingMaterialDescription', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'PIPING_CONSTR');			 
		
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Double Wall FRP', 'Fiberglass Reinforced Plastic', 'Y'); 
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Single Wall FRP', 'Fiberglass Reinforced Plastic', 'Y'); 
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'SW Steel/FRP', 'Fiberglass Reinforced Plastic', 'Y'); 
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Single Wall Flex', 'Flex Piping', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Double Wall Flex', 'Flex Piping', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Single Wall Copper', 'Copper', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Copper', 'Copper', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'SW PVC', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Double Wall PVC', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Double Wall Metal/Plastic', 'Other', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'UNK', 'Unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Unknown', 'Unknown', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (58, 'Single Wall Steel', 'Steel', 'Y');


case when "PIPING_SYSTEM" like '%Suction%' then 'Suction'
		     when "PIPING_SYSTEM" like '%Pressur%' then 'Pressure'
			 when upper("PIPING_SYSTEM") like '%GRAVITY%' then 'Non-operational ( e.g., fill line, vent line, gravity)'
		     when "PIPING_SYSTEM" like '%Manifold Bar%' then 'Other' end as "PipingStyle",

	
select distinct "PIPING_SYSTEM" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;		 
European Suction
Gravity
GRAVITY
Gravity System
Manifold Bar
No Piping
Pressurized System
Suction System
Unknown

insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01','PipingStyle', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'PIPING_SYSTEM');			 

select * from ust_element_db_mapping where state = 'NC' order by 1 desc;

select * from public.piping_style ps 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'European Suction', 'Suction', 'Y');   
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'Gravity', 'Non-operational (e.g., fill line, vent line, gravity)', 'Y');  
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'GRAVITY', 'Non-operational (e.g., fill line, vent line, gravity)', 'Y');  
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'Gravity System', 'Non-operational (e.g., fill line, vent line, gravity)', 'Y');  
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'Manifold Bar', 'Other', 'Y');  
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'No Piping', null, 'Y');  
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'Pressurized System', 'Pressure', 'Y');  
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'Suction System', 'Suction', 'Y');  
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (59, 'Unknown', 'Unknown', 'Y');  	     
		     


		case when "PIPING_CONSTR" like 'Double Wall' then 'Double'
             when "PIPING_CONSTR" like 'Single Wall' or "PIPING_CONSTR" like 'SW%' then 'Single' end as "PipingWallType",

select distinct "PIPING_CONSTR" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;		 
Copper
Double Wall Flex
Double Wall FRP
Double Wall Metal/Plastic
Double Wall PVC
None
Single Wall Copper
Single Wall Flex
Single Wall FRP
Single Wall Steel
SW PVC
SW Steel/FRP
UNK
Unknown


insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-12-01','PipingWallType', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'PIPING_CONSTR');			 

select * from ust_element_db_mapping where state = 'NC' order by 1 desc;

select * from public.piping_wall_type pwt 

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Double Wall Flex', 'Double walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Double Wall FRP', 'Double walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Double Wall Metal/Plastic', 'Double walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Double Wall PVC', 'Double walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Single Wall Copper', 'Single walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Single Wall Flex', 'Single walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Single Wall FRP', 'Single walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Single Wall Steel', 'Single walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'SW PVC', 'Single walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'SW Steel/FRP', 'Single walled', 'Y');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, epa_approved)
values (60, 'Unknown', 'Unknown', 'Y');

		case when "OVERFILL_PROTECTION" = 'Auto Shutoff Device' then 'Yes' end as "AutomaticShutoffDevice",
		case when "OVERFILL_PROTECTION" = 'Overfill Alarm' then 'Yes' end as "OverfillAlarm",
		case when "OVERFILL_PROTECTION" = 'Ball Float Valve' then 'Yes' end as "BallFloatValve",
		case when "OVERFILL_PROTECTION" = 'Auto Shutoff Device' then 'Automatic Shutoff Device' 
			 when "OVERFILL_PROTECTION" = 'Overfill Alarm' then 'Overfill Alarm' 
			 when "OVERFILL_PROTECTION" = 'Ball Float Valve' then 'Ball Float Valve'
			 when "OVERFILL_PROTECTION" = 'Unknown' then 'Unknown'
			 when "OVERFILL_PROTECTION" = '25 Gal or Less Transfer' then 'Not Required' end as "OverfillProtectionMeans",
		case when "SPILL_PROTECTION" = 'Catchment Basin' then 'Yes' end as "SpillBucketInstalled",


insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','MaterialDescription', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'TANK_CONSTR');				
		
select * from ust_element_db_mapping order by 1 desc;

select distinct "TANK_CONSTR" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;

select * from public.material_description order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Concrete', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'CONCRETE', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Concrete Vault', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Double Wall FRP', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Double Wall Steel', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Double Wall Steel/FRP', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Double Wall Steel/Jacketed', 'Jacketed steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Double Wall Steel/Polyurethane', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'SINGLE WALL CONCRETE', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Single Wall FRP', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Single Wall Steel', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Single Wall Steel/FRP', 'Steel (NEC)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Single Wall Steel/Polyurethane', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, 'Unknown', 'Unknown');


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (92, '', '');

select * from information_schema.columns where column_name = 'OVERFILL_PROTECTION'
		

insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','BallFloatValve', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'OVERFILL_PROTECTION');				
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','FlowShutoffDevice', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'OVERFILL_PROTECTION');				
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','HighLevelAlarm', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'OVERFILL_PROTECTION');				

insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','OverfillProtectionPrimary', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'OVERFILL_PROTECTION');		

select id, element_name, state_table_name, state_column_name
from ust_element_db_mapping where state = 'NC' order by 1 desc;
95	HighLevelAlarm
94	FlowShutoffDevice
93	BallFloatValve

96	OverfillProtectionPrimary

select distinct "OVERFILL_PROTECTION" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;
25 Gal or Less Transfer
Auto Shutoff Device
Ball Float Valve
None
Overfill Alarm
Unknown

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (93, 'Ball Float Valve', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (94, 'Auto Shutoff Device', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (95, 'Overfill Alarm', 'Yes');

select * from public.overfill_protection order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, '', '');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, '25 Gal or Less Transfer', 'Not required');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Auto Shutoff Device', 'Flow shutoff device (flapper)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, luepa_value) values (96, 'Ball Float Valve', 'Ball float valve');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'None', 'Not required');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Overfill Alarm', 'High level alarm');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (96, 'Unknown', 'Unknown');

		case when "SPILL_PROTECTION" = 'Catchment Basin' then 'Yes' end as "SpillBucketInstalled",		

		
select * from information_schema.columns where column_name = 'LD_INTERSTL_PIP_SYSTEM_KEY'
		

insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','SpillBucketInstalled', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'SPILL_PROTECTION');				


select id, element_name, state_table_name, state_column_name
from ust_element_db_mapping where state = 'NC' order by 1 desc;
97	SpillBucketInstalled

select distinct "SPILL_PROTECTION" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (97, 'Catchment Basin', 'Yes');
	
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','InterstitialMonitoringContinualElectric', 'USTF_LD_INTERSTL_PIP_SYSTEM_CD', 'LD_INTERSTL_PIP_SYSTEM_KEY');				
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','InterstitialMonitoringManual', 'USTF_LD_INTERSTL_PIP_SYSTEM_CD', 'LD_INTERSTL_PIP_SYSTEM_KEY');

99	InterstitialMonitoringManual	USTF_LD_INTERSTL_PIP_SYSTEM_CD	LD_INTERSTL_PIP_SYSTEM_KEY
98	InterstitialMonitoringContinualElectric	USTF_LD_INTERSTL_PIP_SYSTEM_CD	LD_INTERSTL_PIP_SYSTEM_KEY


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Sump Sensor', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Vacuum', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Pressure', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (98, 'Hydrostatic', 'Yes');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (99, 'None', 'Yes');

----------------------------------------------------------------------------------------------------------------------------
select * from information_schema.columns where column_name = 'LD_SYSTEM_TANK';
		

insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','AutomaticTankGauging', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_TANK');		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','ManualTankGauging', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_TANK');		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','StatisticalInventoryReconciliation', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_TANK');		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','TankTightnessTesting', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_TANK');				


select id, element_name, state_table_name, state_column_name
from ust_element_db_mapping where state = 'NC' order by 1 desc;
103	TankTightnessTesting
102	StatisticalInventoryReconciliation
101	ManualTankGauging
100	AutomaticTankGauging

select distinct "LD_SYSTEM_TANK" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (100, 'Automatic Tank Gauging', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (101, 'Manual Tank Gauging', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (102, 'Statistical Inventory Reconciliation (SIR)', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (103, 'Inventory Control & TTT', 'Yes');
	
----------------------------------------------------------------------------------------------------------------------------
select * from information_schema.columns where column_name = 'LD_SYSTEM_PIPE';
		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','ElectronicLineLeak', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_PIPE');		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','MechanicalLineLeak', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_PIPE');		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','SafeSuction', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_PIPE');		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','PrimaryReleaseDetectionType', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_PIPE');		

select id, element_name, state_table_name, state_column_name
from ust_element_db_mapping where state = 'NC' order by 1 desc;
107	PrimaryReleaseDetectionType
106	SafeSuction
105	MechanicalLineLeak
104	ElectronicLineLeak

select distinct "LD_SYSTEM_PIPE" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;
ELLD
Exempt (European Style)
LD Not Req-EmerGen (< 11/1/2007)
LD Not Req-Heating
MLLD
None
Not Required
Other
Statistical Inventory Reconciliation (SIR)
UNK
Vapor Monitoring

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (104, 'ELLD', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (105, 'MLLD', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (106, 'Exempt (European Style)', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (107, 'ELLD', 'Line Test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (107, 'MLLD', 'Line Test');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (107, 'Statistical Inventory Reconciliation (SIR)', 'SIR');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (107, 'Vapor Monitoring', 'Vapor monitoring');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (107, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (107, 'UNK', 'Unknown');

----------------------------------------------------------------------------------------------------------------------------
select * from information_schema.columns where column_name = 'LD_SYSTEM_PIPE';
		
insert into  ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name) 
values ('NC','2023-02-21','ElectronicLineLeak', 'VW_USTF_TANK_DETAIL_DATA_VIEW', 'LD_SYSTEM_PIPE');		

select id, element_name, state_table_name, state_column_name
from ust_element_db_mapping where state = 'NC' order by 1 desc;


select distinct "LD_SYSTEM_PIPE" from "VW_USTF_TANK_DETAIL_DATA_VIEW" order by 1;


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (104, 'ELLD', 'Yes');
		case when "LD_SYSTEM_PIPE" in ('ELLD','MLLD') then 'Line Test'
		     when "LD_SYSTEM_PIPE" = 'Statistical Inventory Reconciliation (SIR)' then 'SIR'
		     when "LD_SYSTEM_PIPE" = 'Vapor Monitoring' then 'Vapor Monitoring'
		     when "LD_SYSTEM_PIPE" = 'Other' then 'Other'
		     when "LD_SYSTEM_PIPE" = 'UNK' then 'Unknown' end as "PrimaryReleaseDetectionType",

---------------------------------------------------------------------------------------------------------------------------------------

select count(*) from (
select distinct 
	   fown."FACILITY_ID" as "FacilityID",
	   f."FACILITY_NAME" as "FacilityName",
	   ot.epa_value as "OwnerType",
	   null as "FacilityType1",
	   null as "FacilityType2",
	   f."ADDRESS1" as "FacilityAddress1",
	   f."ADDRESS2" as "FacilityAddress2",
	   f."CITY" as "FacilityCity",
	   fcc."FIPS_COUNTY_DESC" as "FacilityCounty",
	   f."ZIP" as "FacilityZipCode",
	   f."PHONE" as "FacilityPhoneNumber",
	   f."STATE" as "FacilityState",
	   4 as "FacilityEPARegion",
	   null as "FacilityTribalSite",
	   null as "FacilityTribe",
	   f."LATITUDE" as "FacilityLatitude",
	   f."LONGITUDE" as "FacilityLongitude",
	   null as "StateCoordinateSource",
	   fown."OWNER_NAME" as "FacilityOwnerCompanyName",
	   null as "FacilityOwnerLastName",
	   null as "FacilityOwnerFirstName",
	   fown."ADDRESS1" as "FacilityOwnerAddress1",
	   fown."ADDRESS2" as "FacilityOwnerAddress2",
	   fown."CITY" as "FacilityOwnerCity",
	   fown."COUNTY_DESC" as "FacilityOwnerCounty",
	   fown."ZIP" as "FacilityOwnerZipCode",
	   fown."STATE" as "FacilityOwnerState",
	   fown."PHONE" as "FacilityOwnerPhoneNumber",
	   fown."EMAIL_ADDR" as "FacilityOwnerEmail",	   
	   fopr."OPERATOR_NAME" as "FacilityOperatorCompanyName",
	   null as "FacilityOperatorLastName",
	   null as "FacilityOperatorFirstName", 
	   fopr."ADDRESS1" as "FacilityOperatorAddress1",
	   fopr."ADDRESS2" as "FacilityOperatorAddress2",
	   fopr."CITY" as "FacilityOperatorCity",
	   fopr."COUNTY_DESC" as "FacilityOperatorCounty",
	   fopr."ZIP" as "FacilityOperatorZipCode",
	   fopr."STATE" as "FacilityOperatorState",
	   fopr."PHONE" as "FacilityOperatorPhoneNumber",
	   fopr."EMAIL_ADDR" as "FacilityOperatorEmail",	  
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 7 then 'Yes' end as "FinancialResponsibilityBondRatingTest",
--	   null as "FinancialResponsibilityCommercialInsurance", --can we can this from the lookup?
--	   case when tfd."FINANCIAL_RESPONSIBILITY" in (1,9) then 'Yes' end as "FinancialResponsibilityGuarantee", 
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 4 then 'Yes' end as "FinancialResponsibilityLetterOfCredit", 
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 8 then 'Yes' end as "FinancialResponsibilityLocalGovernmentFinancialTest", 
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 2 then 'Yes' end as "FinancialResponsibilityRiskRetentionGroup", 
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 11 then 'Yes' end as "FinancialResponsibilitySelfInsuranceFinancialTest", 
--	   null as "FinancialResponsibilityStateFund", 
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 3 then 'Yes' end as "FinancialResponsibilitySuretyBond", 
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 6 then 'Yes' end as "FinancialResponsibilityTrustFund", 
--	   case when tfd."FINANCIAL_RESPONSIBILITY" in (5,10) then 'Yes' end as "FinancialResponsibilityOtherMethod", --5 / Insurance Pools and 10 / Local Gov. Dedicated Fund
--	   case when tfd."FINANCIAL_RESPONSIBILITY" = 0 then 'Yes' end as "FinancialResponsibilityNotRequired", 
	   null as "FinancialResponsibilityObtained",
	   null as "Compliance",
	   ft."TANK_ID" as "TankID",
	   null as "TankLocation",
	   ft."REGULATED" as "FederallyRegulated",
	   null as "CompartmentID",
--	   case when ft."TANK_STATUS" = 'Abandoned' then 'Abandoned'
--			when ft."TANK_STATUS" = 'Current' then 'Currently in use'
--			when ft."TANK_STATUS" = 'Removed' then 'Closed (removed from ground)'
--			when ft."TANK_STATUS" = 'Temporarily Closed' then 'Temporarily out of service' end as "TankStatus",	
	   null as "FieldConstructed",
	   null as "EmergencyGenerator",
	   null as "AirportHydrantSystem",
	   ft."MANIFOLD_TANK" as "MultipleTanks",
	   ft."PERM_CLOSE_DATE" as "ClosureDate",
	   ft."INSTALLATION_DATE" as "InstallationDate",
	   ft."COMPARTMENT_TANK" as "CompartmentalizedUST",
	   null as "NumberOfCompartments",
--	   sm.epa_substance as "TankSubstanceStored",
		null as "CompartmentSubstanceStored",
		ft."CAPACITY" as "TankCapacityGallons", -- assume gallons	
		null as "CompartmentCapacityGallons",
		null as "LinedTank",
		null as "ExcavationLiner",
--		case when "TANK_CONSTR" like 'Double Wall%' then 'Double' 
--			 when "TANK_CONSTR" like 'Single Wall%' then 'Single' end as "TankWallType",
--		case when upper("TANK_CONSTR") like '%CONCRETE%' then 'Concrete' 	 
--	         when "TANK_CONSTR" like '%Steel%FRP%' then 'Composite/Clad (Steel w/Fiberglass Reinforced Plastic)'
--			 when "TANK_CONSTR" like '%FRP%' then 'Fiberglass Reinforced Plastic'
--	         when "TANK_CONSTR" like '%Jacketed%' then 'Jacketed Steel'
--	         when "TANK_CONSTR" like '%Polyurethane%' then 'Coated and Cathodically Protected Steel' --IS THIS RIGHT??
--			 when "TANK_CONSTR" like '%Steel%' then '' end as "MaterialDescription",
		null as "TankRepaired",
	    null as "TankRepairDate",
--		case when "PIPING_CONSTR" like '%FRP%' then 'Fiberglass Reinforced Plastic'
--		     when "PIPING_CONSTR" like '%Flex%' then 'Flex Piping'
--			 when "PIPING_CONSTR" like '%Copper%' then 'Copper'
--			 when "PIPING_CONSTR" like '%PVC%' then 'Other' --OK??
--			 when "PIPING_CONSTR" like '%Plastic%' then 'Other' --OK??
			 when "PIPING_CONSTR" in ('UNK','Unknown') then 'Unknown' end as "PipingMaterialDescription",
		"FLEX_CONNECTOR_TANK" as "PipingFlexConnector",
--		case when "PIPING_SYSTEM" like '%Suction%' then 'Suction'
--		     when "PIPING_SYSTEM" like '%Pressur%' then 'Pressure'
--			 when upper("PIPING_SYSTEM") like '%GRAVITY%' then 'Non-operational ( e.g., fill line, vent line, gravity)'
--		     when "PIPING_SYSTEM" like '%Manifold Bar%' then 'Other' end as "PipingStyle",
--		case when "PIPING_CONSTR" like 'Double Wall' then 'Double'
--             when "PIPING_CONSTR" like 'Single Wall' or "PIPING_CONSTR" like 'SW%' then 'Single' end as "PipingWallType",
		null as "PipingUDCForEveryDispenser",
		null as "PipingRepaired",
		null as "PipingRepairDate",
		null as "TankCorrosionProtectionSacrificialAnode",
		null as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
		null as "TankCorrosionProtectionImpressedCurrent",
		null as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
		null as "TankCorrosionProtectionCathodicNotRequired",
		null as "TankCorrosionProtectionInteriorLining",
		null as "TankCorrosionProtectionReason",
		null as "TankCorrosionProtectionLinedPostinstallation",
		null as "TankCorrosionProtectionOther",
		null as "TankCorrosionProtectionUnknown",
		null as "TankCorrosionProtectionLinedPostinstallation",
		null as "PipingCorrosionProtectionSacrificialAnodes",
		null as "PipingCorrosionProtectionAnodesInstalledOrRetrofitted",
		null as "PipingCorrosionProtectionImpressedCurrent",
		null as "PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
		null as "PipingCorrosionProtectionCathodicNotRequired",
		null as "PipingCorrosionProtectionExternalCoating",
		null as "PipingCorrosionProtectionOther",
		null as "PipingCorrosionProtectionUnknown",
--		null as "BallFloatValve",
--		null as "FlowShutoffDevice",
--		null as "HighLevelAlarm",
--		null as "OverfillProtectionPrimary",
--		null as "OverfillProtectionSecondary",
--		case when "OVERFILL_PROTECTION" = 'Auto Shutoff Device' then 'Yes' end as "AutomaticShutoffDevice",
--		case when "OVERFILL_PROTECTION" = 'Overfill Alarm' then 'Yes' end as "OverfillAlarm",
--		case when "OVERFILL_PROTECTION" = 'Ball Float Valve' then 'Yes' end as "BallFloatValve",
--		case when "OVERFILL_PROTECTION" = 'Auto Shutoff Device' then 'Automatic Shutoff Device' 
--			 when "OVERFILL_PROTECTION" = 'Overfill Alarm' then 'Overfill Alarm' 
--			 when "OVERFILL_PROTECTION" = 'Ball Float Valve' then 'Ball Float Valve'
--			 when "OVERFILL_PROTECTION" = 'Unknown' then 'Unknown'
--			 when "OVERFILL_PROTECTION" = '25 Gal or Less Transfer' then 'Not Required' end as "OverfillProtectionMeans",
--		case when "SPILL_PROTECTION" = 'Catchment Basin' then 'Yes' end as "SpillBucketInstalled",
		null as "SpillBucketWallType",
		null as "DrainPresent",
		null as "PumpPresent",
--		case when t."LD_INTERSTL_TK_SYSTEM_KEY" in (3,4) or t."LD_INTERSTL_PIP_SYSTEM_KEY" in (1,2,3,4) then 'Yes' end as "InterstitialMonitoringContinualElectric",
--		case when t."LD_INTERSTL_TK_SYSTEM_KEY" not in (3,4) and t."LD_INTERSTL_PIP_SYSTEM_KEY" not in (1,2,3,4) then 'Yes' end as "InterstitialMonitoringManual", --is this OK?
--		case when "LD_SYSTEM_TANK" = 'Automatic Tank Gauging' then 'Yes' end as "AutomaticTankGauging",
--		case when "LD_SYSTEM_TANK" = 'Manual Tank Gauging' then 'Yes' end as "ManualTankGauging",
--		case when "LD_SYSTEM_TANK" = 'Statistical Inventory Reconciliation (SIR)' then 'Yes' end as "StatisticalInventoryReconciliation",
--		case when "LD_SYSTEM_TANK" like '%TTT%' then 'Yes' end as "TankTightnessTesting",
		null as "GroundwaterMonitoring",
		null as "SubpartK",
		null as "VaporMonitoring",
--		case when "LD_SYSTEM_PIPE" = 'ELLD' then 'Yes' end as "ElectronicLineLeak",
--		case when "LD_SYSTEM_PIPE" = 'MLLD' then 'Yes' end as "MechanicalLineLeak",
		null as "AutomatedIntersticialMonitoring",
--		case when "LD_SYSTEM_PIPE" = 'Exempt (European Style)' then 'Yes' end as "SafeSuction", --is this right??
		null as "AmericanSuction",
		null as "PipingSubpartK",
		null as "HighPressure",
--		case when "LD_SYSTEM_PIPE" in ('ELLD','MLLD') then 'Line Test'
--		     when "LD_SYSTEM_PIPE" = 'Statistical Inventory Reconciliation (SIR)' then 'SIR'
--		     when "LD_SYSTEM_PIPE" = 'Vapor Monitoring' then 'Vapor Monitoring'
--		     when "LD_SYSTEM_PIPE" = 'Other' then 'Other'
--		     when "LD_SYSTEM_PIPE" = 'UNK' then 'Unknown' end as "PrimaryReleaseDetectionType",
		null as "SecondReleaseDetectionType",
		null as "PipeSecondaryContainment",
		null as "PipeInstallDate",
		case when lust.facility_id is not null then 'Yes' end as "USTReportedRelease",
		lust.lust_id as "AssociatedLUSTID",
		null as "LastInspectionDate"
from "USTF_FACILITY_DATA_TABLE" f 
	left join "VW_USTF_FACILITY_OWNER_DTLS_DATA_VIEW" fown on f."FACILITY_KEY" = fown."FACILITY_KEY"
	left join "VW_USTF_FACILITY_OPERATOR_DTLS_DATA_VIEW" fopr on f."FACILITY_KEY" = fopr."FACILITY_KEY"
	left join "VW_USTF_TANK_DETAIL_DATA_VIEW" ft on f."FACILITY_KEY" = ft."FACILITY_KEY"
	left join "USTF_TANK_DETAIL_DATA_TABLE" t on ft."TANK_KEY" = t."TANK_KEY"
	left join lust_lookup lust on fown."FACILITY_ID" = lust.facility_id
	left join "USTF_TANK_FACILITY_DATA_TABLE" tfd on f."FACILITY_KEY" = tfd."FACILITY_KEY"
	left join "USTF_TYPE_OWNER_CD" toc on tfd."TYPE_OWNER_KEY" = toc."TYPE_OWNER_KEY" 
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'NC' and element_name = 'OwnerType') ot 
		on toc."TYPE_OWNER_KEY" = ot.state_value
	

		select * from information_schema.columns where column_name = 'TYPE_OWNER_KEY'
	
	select * from v_ust_element_mapping 
	where state = 'NC' and element_name = 'OwnerType'

	select * from public.ust_element_db_mapping where id = 43;
update ust_element_db_mapping set state_table_name = 'USTF_TYPE_OWNER_CD' where id = 43;

	
	update public.ust_element_db_mapping 
	
	left join "FIPS_COUNTY_CODES" fcc on f."COUNTY_KEY" = fcc."FIPS_COUNTY_CODE"
where "TANK_STATUS" not in ('Intent to Install','Never Installed','Transfer')
and "PRODUCT" <> 'ETHANOL' and f."FACILITY_TYPE_KEY" = 0  
) a 
--UST vs non-UST 
order by fown."FACILITY_ID", ft."TANK_ID";

------------------------------------------------------------------------------------------------------

select distinct "TANK_STATUS" from "VW_USTF_TANK_DETAIL_DATA_VIEW"

select * from "VW_USTF_TANK_DETAIL_DATA_VIEW" where "TANK_STATUS"  in ('Intent to Install','Never Installed','Transfer')

select count(*) 
from "USTF_FACILITY_DATA_TABLE" f 
	--join "VW_USTF_REG_FACILITY_DATA_VIEW" reg on f."FACILITY_KEY" = reg."FACILITY_KEY"
	left join "VW_USTF_TANK_DETAIL_DATA_VIEW" ft on f."FACILITY_KEY" = ft."FACILITY_KEY"
where "TANK_STATUS" not in ('Intent to Install','Never Installed','Transfer')
and "PRODUCT" <> 'ETHANOL'
and f."FACILITY_TYPE_KEY" = 0;

SELECT COUNT(*) fROM (SELECT DISTINCT "FACILITY_ID" from "VW_USTF_FACILITY_OWNER_DTLS_DATA_VIEW") a;

select * from "VW_USTF_REG_FACILITY_DATA_VIEW"

SELECT * FROM "VW_USTF_FACILITY_TANK_DETAIL_DATA_VIEW"

select * from information_schema.columns where column_name = 'FACILITY_ID'

select count(*) from "USTF_FACILITY_DATA_TABLE";
34148
select count(*) from "VW_USTF_REG_FACILITY_DATA_VIEW";
7479
select count(*) from "VW_USTF_REG_FACILITY_DATA_VIEW" where "FACILITY_ID" is not null;

select * from "VW_USTF_REG_FACILITY_DATA_VIEW";
