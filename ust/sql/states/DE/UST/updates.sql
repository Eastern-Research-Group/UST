------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--Create table de_ust.erg_piping_id
create table de_ust.erg_piping_id (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity);

--Populate table de_ust.erg_piping_id

insert into de_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct "FacilityID"::varchar(50), "TankName"::varchar(50), "TankID"::int, "CompartmentName"::varchar(50), "CompartmentID"::int from de_ust."piping";

--Record new mapping in public.ust_element_mapping
--ust_piping.piping_id
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name,
 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3)
 values (29, 'ust_piping', 'piping_id', 'erg_piping_id', 'piping_id', 'This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.',
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

update ust_element_mapping 
set epa_table_name = 'ust_tank'
where ust_element_mapping_id = 2179;

delete from ust_element_value_mapping
where ust_element_mapping_id in (2131,2132,2138,2142,2160,2161,2171,2178,2179,2183,2190,2221,2253);

ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentStatus" TO "Unknown";
ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentSubstanceStored" TO "CompartmentStatus";
ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentSubstanceCASNO" TO "CompartmentSubstanceStored";
ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentCapacityGallons" TO "CompartmentSubstanceCASNO";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionBallFloatValve" TO "CompartmentCapacityGallons";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionFlowShutoffDevice" TO "OverfillPreventionBallFloatValve";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionHighLevelAlarm" TO "OverfillPreventionFlowShutoffDevice";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionOther" TO "OverfillPreventionHighLevelAlarm";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionUnknown" TO "OverfillPreventionOther";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionNotRequired" TO "OverfillPreventionUnknown";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillBucketInstalled" TO "OverfillPreventionNotRequired";
ALTER TABLE de_ust.compartment RENAME COLUMN "ConcreteBermInstalled" TO "SpillBucketInstalled";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillPreventionOther" TO "ConcreteBermInstalled";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillPreventionNotRequired" TO "SpillPreventionOther";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillBucketWallType" TO "SpillPreventionNotRequired";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankInterstitialMonitoring" TO "SpillBucketWallType";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankAutomaticTankGaugingReleaseDetection" TO "TankInterstitialMonitoring";
ALTER TABLE de_ust.compartment RENAME COLUMN "AutomaticTankGaugingContinuousLeakDetection" TO "TankAutomaticTankGaugingReleaseDetection";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankManualTankGauging" TO "AutomaticTankGaugingContinuousLeakDetection";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankStatisticalInventoryReconciliation" TO "TankManualTankGauging";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankTightnessTesting" TO "TankStatisticalInventoryReconciliation";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankInventoryControl" TO "TankTightnessTesting";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankGroundwaterMonitoring" TO "TankInventoryControl";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankVaporMonitoring" TO "TankGroundwaterMonitoring";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankSubpartKTightnessTesting" TO "TankVaporMonitoring";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankSubpartKOther" TO "TankSubpartKTightnessTesting";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankOtherReleaseDetection" TO "TankSubpartKOther";
ALTER TABLE de_ust.compartment RENAME COLUMN "DispenserID" TO "TankOtherReleaseDetection";
ALTER TABLE de_ust.compartment RENAME COLUMN "DispenserUDC" TO "DispenserID";

update ust_control
set comments = concat(comments, '; There were column names that were switched around in the compartment table, here is the SQL that was used to fix them:
ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentStatus" TO "Unknown";
ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentSubstanceStored" TO "CompartmentStatus";
ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentSubstanceCASNO" TO "CompartmentSubstanceStored";
ALTER TABLE de_ust.compartment RENAME COLUMN "CompartmentCapacityGallons" TO "CompartmentSubstanceCASNO";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionBallFloatValve" TO "CompartmentCapacityGallons";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionFlowShutoffDevice" TO "OverfillPreventionBallFloatValve";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionHighLevelAlarm" TO "OverfillPreventionFlowShutoffDevice";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionOther" TO "OverfillPreventionHighLevelAlarm";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionUnknown" TO "OverfillPreventionOther";
ALTER TABLE de_ust.compartment RENAME COLUMN "OverfillPreventionNotRequired" TO "OverfillPreventionUnknown";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillBucketInstalled" TO "OverfillPreventionNotRequired";
ALTER TABLE de_ust.compartment RENAME COLUMN "ConcreteBermInstalled" TO "SpillBucketInstalled";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillPreventionOther" TO "ConcreteBermInstalled";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillPreventionNotRequired" TO "SpillPreventionOther";
ALTER TABLE de_ust.compartment RENAME COLUMN "SpillBucketWallType" TO "SpillPreventionNotRequired";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankInterstitialMonitoring" TO "SpillBucketWallType";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankAutomaticTankGaugingReleaseDetection" TO "TankInterstitialMonitoring";
ALTER TABLE de_ust.compartment RENAME COLUMN "AutomaticTankGaugingContinuousLeakDetection" TO "TankAutomaticTankGaugingReleaseDetection";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankManualTankGauging" TO "AutomaticTankGaugingContinuousLeakDetection";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankStatisticalInventoryReconciliation" TO "TankManualTankGauging";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankTightnessTesting" TO "TankStatisticalInventoryReconciliation";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankInventoryControl" TO "TankTightnessTesting";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankGroundwaterMonitoring" TO "TankInventoryControl";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankVaporMonitoring" TO "TankGroundwaterMonitoring";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankSubpartKTightnessTesting" TO "TankVaporMonitoring";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankSubpartKOther" TO "TankSubpartKTightnessTesting";
ALTER TABLE de_ust.compartment RENAME COLUMN "TankOtherReleaseDetection" TO "TankSubpartKOther";
ALTER TABLE de_ust.compartment RENAME COLUMN "DispenserID" TO "TankOtherReleaseDetection";
ALTER TABLE de_ust.compartment RENAME COLUMN "DispenserUDC" TO "DispenserID";')
where ust_control_id = 29;