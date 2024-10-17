create table ower_type_mapping (sd_value varchar(100), epa_value varchar(100));
insert into ower_type_mapping values ('Commercial','Commercial');
insert into ower_type_mapping values ('Federal Government','Federal Government - Non Military');
insert into ower_type_mapping values ('Local Government','Local Government');
insert into ower_type_mapping values ('Mom & Pop Facility','Private');
insert into ower_type_mapping values ('Private or Corporate','Private');
insert into ower_type_mapping values ('State Government','State Government - Non Military');

create table tank_status_mapping (sd_value varchar(100), epa_value varchar(100));
insert into tank_status_mapping values ('Removed','Closed (removed from ground)');
insert into tank_status_mapping values ('Current','Currently in use');
insert into tank_status_mapping values ('Temporary Closure','Temporarily out of service');
insert into tank_status_mapping values ('Abandoned in Place','Abandoned');
insert into tank_status_mapping values ('Temporarily Out Of Use','Temporarily out of service');

create table "SD_UST".substance_mapping (sd_value varchar(100), epa_value varchar(100));
insert into "SD_UST".substance_mapping values ('10% Ethanol','Gasoline E-10 (E1-E10)');
insert into "SD_UST".substance_mapping values ('Additive','Petroleum products');
insert into "SD_UST".substance_mapping values ('Anti Freeze','Antifreeze');
insert into "SD_UST".substance_mapping values ('Aviation Gas','Aviation gasoline');
insert into "SD_UST".substance_mapping values ('Biodiesel','Diesel fuel (b-unknown)');
insert into "SD_UST".substance_mapping values ('Cleaning Solvent','Solvent');
insert into "SD_UST".substance_mapping values ('Diesel','Diesel fuel (b-unknown)');
insert into "SD_UST".substance_mapping values ('Diesel/Diesel','Diesel fuel (b-unknown)');
insert into "SD_UST".substance_mapping values ('Diesel/Diesel clear','Diesel fuel (b-unknown)');
insert into "SD_UST".substance_mapping values ('Diesel/E85',' E-85/Flex Fuel (E51-E83)');
insert into "SD_UST".substance_mapping values ('E-10%20%30%','Ethanol blend gasoline (e-unknown)');
insert into "SD_UST".substance_mapping values ('E-30','Gasoline/ethanol blends E16-E50');
insert into "SD_UST".substance_mapping values ('E-85',' E-85/Flex Fuel (E51-E83)');
insert into "SD_UST".substance_mapping values ('Ethanol','Ethanol blend gasoline (e-unknown)');
insert into "SD_UST".substance_mapping values ('Fuel Oil','Heating/fuel oil # unknown');
insert into "SD_UST".substance_mapping values ('Gas/Diesel','Diesel fuel (b-unknown)');
insert into "SD_UST".substance_mapping values ('Gas/E85',' E-85/Flex Fuel (E51-E83)');
insert into "SD_UST".substance_mapping values ('Gas/Gas','Gasoline (unknown type)');
insert into "SD_UST".substance_mapping values ('Gasoline','Gasoline (unknown type)');
insert into "SD_UST".substance_mapping values ('Hazardous Substance','Hazardous substance');
insert into "SD_UST".substance_mapping values ('Heating Oil','Heating/fuel oil # unknown');
insert into "SD_UST".substance_mapping values ('Hydraulic Fluid','Petroleum products');
insert into "SD_UST".substance_mapping values ('Jet Fuel A','Jet fuel A');
insert into "SD_UST".substance_mapping values ('JP-10','Jet Fuel A');
insert into "SD_UST".substance_mapping values ('JP-8','Jet Fuel A');
insert into "SD_UST".substance_mapping values ('Kerosene','Kerosene');
insert into "SD_UST".substance_mapping values ('Lube Oil','Lube/motor oil (new)');
insert into "SD_UST".substance_mapping values ('Mixture','Other');
insert into "SD_UST".substance_mapping values ('Motor Oil','Lube/motor oil (new)');
insert into "SD_UST".substance_mapping values ('Petroleum','Petroleum products');
insert into "SD_UST".substance_mapping values ('Spent Solvent','Solvent');
insert into "SD_UST".substance_mapping values ('Transmission Fluid','Petroleum products');
insert into "SD_UST".substance_mapping values ('Unknown','Unknown');
insert into "SD_UST".substance_mapping values ('Used Oil','Used oil/waste oil');


----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'OwnerType', 'UST', 'OwnerType')
returning id;

select distinct "SD_UST" from "SD_UST"."UST" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (184, ''' || "OwnerType" ||  ''', '''');'
from "SD_UST"."UST" 
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (184, 'Commercial', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (184, 'Federal Government', 'Federal Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (184, 'Local Government', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (184, 'Mom & Pop Facility', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (184, 'Private or Corporate', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (184, 'State Government', 'State Government - Non Military');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'TankStatus', 'UST', 'TankStatus')
returning id;

select distinct "SD_UST" from "SD_UST"."UST" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (185, ''' || "TankStatus" ||  ''', '''');'
from "SD_UST"."UST" 
order by 1;	

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (185, 'Abandoned in Place', 'Abandoned');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (185, 'Current', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (185, 'Removed', 'Closed (removed from ground)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (185, 'Temporarily Out Of Use', 'Temporarily out of service');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (185, 'Temporary Closure', 'Temporarily out of service');

select * from ust_element_value_mappings where element_db_mapping_id = 185;


----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'TankSubstanceStored', 'UST', 'TankSubstanceStored')
returning id;

select distinct "SD_UST" from "SD_UST"."UST" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, ''' || sd_value ||  ''', ''' || epa_value || ''');'
from "SD_UST".substance_mapping
order by 1;


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, '10% Ethanol', 'Gasoline E-10 (E1-E10)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Additive', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Anti Freeze', 'Antifreeze');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Aviation Gas', 'Aviation gasoline');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Biodiesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Cleaning Solvent', 'Solvent');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Diesel/Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Diesel/Diesel clear', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Diesel/E85', ' E-85/Flex Fuel (E51-E83)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'E-10%20%30%', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'E-30', 'Gasoline/ethanol blends E16-E50');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'E-85', ' E-85/Flex Fuel (E51-E83)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Ethanol', 'Ethanol blend gasoline (e-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Fuel Oil', 'Heating/fuel oil # unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Gas/Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Gas/E85', ' E-85/Flex Fuel (E51-E83)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Gas/Gas', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Gasoline', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Hazardous Substance', 'Hazardous substance');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Heating Oil', 'Heating/fuel oil # unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Hydraulic Fluid', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Jet Fuel A', 'Jet fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'JP-10', 'Jet Fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'JP-8', 'Jet Fuel A');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Kerosene', 'Kerosene');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Lube Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Mixture', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Motor Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Petroleum', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Spent Solvent', 'Solvent');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Transmission Fluid', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (186, 'Used Oil', 'Used oil/waste oil');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'FlowShutoffDevice', 'UST', 'AutomaticShutoffDevice')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (187, ''' || "AutomaticShutoffDevice" ||  ''', ''Yes'');'
from "SD_UST"."UST" 
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (187, 'Automatic Shutoff Device', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'BallFloatValve', 'UST', 'BallFloatValve')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (188, ''' || "BallFloatValve" ||  ''', ''Yes'');'
from "SD_UST"."UST" 
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (188, 'Ball Float Valves', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'HighLevelAlarm', 'UST', 'OverfillAlarm')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (189, ''' || "OverfillAlarm" ||  ''', ''Yes'');'
from "SD_UST"."UST" 
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (189, 'Overfill Alarm', 'Yes');

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'ElectronicLineLeak', 'UST', 'ElectronicLineLeakDetector')
returning id;

select distinct "ElectronicLineLeakDetector" from "SD_UST"."UST" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (190, ''' || "ElectronicLineLeakDetector" ||  ''', ''Yes'');'
from "SD_UST"."UST" where "ElectronicLineLeakDetector" = 'Electronic LLD'
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (190, 'Electronic LLD', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('SD', '2023-03-30', 'MechanicalLineLeak', 'UST', 'MechanicalLineLeakDetector')
returning id;

select distinct "MechanicalLineLeakDetector" from "SD_UST"."UST" order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (191, ''' || "MechanicalLineLeakDetector" ||  ''', ''Yes'');'
from "SD_UST"."UST" where "MechanicalLineLeakDetector" = 'Mechanical LLD'
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (191, 'Mechanical LLD', 'Yes');


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

drop view  "SD_UST".v_ust_base;

select distinct "SpillBucketInstalled" from "SD_UST"."UST" order by 1;

select "InstallationDate",
	case when "InstallationDate" = 0 or "InstallationDate" is null then null 
	else ("InstallationDate" || '-01-01')::date end
from "SD_UST"."UST" 
	     

select "FacilityID", "FederallyRegulated" 
		           from "SD_UST".v_ust_base 
		           where length("FederallyRegulated") > 7

select distinct 	"ElectronicLineLeak" from 	"SD_UST".v_ust_base            
		     
select * from 

drop view "SD_UST".v_ust_base;
CREATE OR REPLACE VIEW "SD_UST".v_ust_base
AS SELECT DISTINCT u."FacilityNumber" AS "FacilityID",
    u."FacilityName",
    ot.epa_value AS "OwnerType",
    u."FacilityAddress1",
    u."FacilityAddress2",
    u."FacilityCity",
    u."FacilityCounty",
    u."FacilityZipCode",
    u."FacilityPhoneNumber",
        CASE
            WHEN u."FacilityState" = 'SOUTH DAKOTA'::text THEN 'SD'::text
            ELSE NULL::text
        END AS "FacilityState",
    u."FacilityEPARegion",
    u."FacilityLatitudeValue" AS "FacilityLatitude",
    u."FacilityLongitudeValue" AS "FacilityLongitude",
    u."FacilityOwnerCompanyName",
    u."FacilityOwnerAddress1",
    u."FacilityOwnerAddress2",
    u."FacilityOwnerCity",
    u."FacilityOwnerCounty",
    u."FacilityOwnerZip" AS "FacilityOwnerZipCode",
        CASE
            WHEN u."FacilityOwnerStateName" = 'SOUTH DAKOTA'::text THEN 'SD'::text
            ELSE NULL::text
        END AS "FacilityOwnerState",
    u."FacilityOwnerOperatorName" AS "FacilityOperatorCompanyName",
    u."FinancialResponsibilityStateFund",
        CASE
            WHEN u."FinancialResponsibilityBondRatingTest" IS NOT NULL OR u."FinancialResponsibilityCommercialInsurance" IS NOT NULL OR u."FinancialResponsibilityGuarantee" IS NOT NULL OR u."FinancialResponsibilityLetterOfCredit" IS NOT NULL OR u."FinancialResponsibilityLocalGovernmentFinancialTest" IS NOT NULL OR u."FinancialResponsibilityRiskRetentionGroup" IS NOT NULL OR u."FinancialResponsibilitySelfInsuranceFinancialTest" IS NOT NULL OR u."FinancialResponsibilityStateFund" IS NOT NULL OR u."FinancialResponsibilitySuretyBond" IS NOT NULL OR u."FinancialResponsibilityTrustFund" IS NOT NULL OR u."FinancialResponsibilityOtherMethod" IS NOT NULL THEN 'Yes'::text
            ELSE NULL::text
        END AS "FinancialResponsibilityObtained",
    u."TankID",
    ts.epa_value as "TankStatus",
        CASE
            WHEN u."InstallationDate" = 0::double precision OR u."InstallationDate" IS NULL THEN NULL::date
            ELSE (u."InstallationDate" || '-01-01'::text)::date
        END AS "InstallationDate",
    u."NumberofCompartments" AS "NumberOfCompartments",
    u."TankCapacityGallons",
    u."MaterialDescription",
    u."PipingMaterialDescription",
    u."PipingStyle",
    bfv.epa_value AS "BallFloatValve",
    fsd.epa_value AS "FlowShutoffDevice",
    hla.epa_value AS "HighLevelAlarm",
    case when u."SpillBucketInstalled" is not null then 'Yes' end as "SpillBucketInstalled",
    case when u."InterstitialMonitoringManual" is not null then 'Yes' end as "InterstitialMonitoringManual",
    case when u."AutomaticTankGauging" is not null then 'Yes' end as "AutomaticTankGauging",
    case when u."ManualTankGauging" is not null then 'Yes' end as "ManualTankGauging",
    case when u."StatisticalInventoryReconciliation" is not null then 'Yes' end as "StatisticalInventoryReconciliation",
    case when u."TankTightnessTesting" is not null then 'Yes' end as "TankTightnessTesting",
    case when u."GroundwaterMonitoring" is not null then 'Yes' end as "GroundwaterMonitoring",
    case when u."VaporMonitoring" is not null then 'Yes' end as "VaporMonitoring",
    ell.epa_value AS "ElectronicLineLeak",
    mll.epa_value AS "MechanicalLineLeak",
    case when u."USTReportedRelease" is not null then 'Yes' end as "USTReportedRelease",
        CASE
            WHEN u."LastInspectionDate" = '00:00:00'::text OR u."LastInspectionDate" IS NULL THEN NULL::date
            ELSE u."LastInspectionDate"::date
        END AS "LastInspectionDate"
   FROM "SD_UST"."UST" u
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'OwnerType'::text) ot ON u."OwnerType" = ot.state_value::text
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'TankStatus'::text) ts ON u."TankStatus" = ts.state_value::text
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'TankSubstanceStored'::text) tss ON u."OwnerType" = tss.state_value::text
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'BallFloatValve'::text) bfv ON u."BallFloatValve" = bfv.state_value::text
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'FlowShutoffDevice'::text) fsd ON u."AutomaticShutoffDevice" = fsd.state_value::text
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'HighLevelAlarm'::text) hla ON u."OverfillAlarm" = hla.state_value::text
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'ElectronicLineLeak'::text) ell ON u."ElectronicLineLeakDetector" = ell.state_value::text
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE v_ust_element_mapping.state::text = 'SD'::text AND v_ust_element_mapping.element_name::text = 'MechanicalLineLeak'::text) mll ON u."MechanicalLineLeakDetector" = mll.state_value::text
  WHERE u."FacilityNumber" IS NOT NULL;

select distinct element_db_mapping_id, element_name, state_table_name, state_column_name from v_ust_element_mapping where state = 'SD' order by 1;


Abandoned in Place	Abandoned
Current	Currently in use
Removed	Closed (removed from ground)
Temporarily Out Of Use	Temporarily out of service
Temporary Closure	Temporarily out of service

select distinct "TankStatus" from "SD_UST"."UST";

select distinct "TankStatus" from "SD_UST".v_ust_base ;


select * from ust where state = 'SD';

select * from ust where state = 'SD';
