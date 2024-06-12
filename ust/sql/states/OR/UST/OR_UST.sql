drop table Piping_Material_Sort;
create table Piping_Material_Sort (PipingMaterialTypeId integer, Name varchar(50), EPA_mapping varchar(50), Sort_Order integer);
insert into Piping_Material_Sort (PipingMaterialTypeId, Name)
select PipingMaterialTypeId, Name from PipingMaterialType
where PipingMaterialTypeId in (1,2,3,4,5,6,7,10,14);
update Piping_Material_Sort set EPA_mapping = 'Steel', Sort_Order = 6 where PipingMaterialTypeId = 1;
update Piping_Material_Sort set EPA_mapping = 'Steel', Sort_Order = 5 where PipingMaterialTypeId = 2;
update Piping_Material_Sort set EPA_mapping = 'Galvanized Steel', Sort_Order = 3 where PipingMaterialTypeId = 3;
update Piping_Material_Sort set EPA_mapping = 'Fiberglass Reinforced Plastic', Sort_Order = 1 where PipingMaterialTypeId = 4;
update Piping_Material_Sort set EPA_mapping = 'Copper', Sort_Order =  2 where PipingMaterialTypeId = 5;
update Piping_Material_Sort set EPA_mapping = 'Flex Piping', Sort_Order =  4 where PipingMaterialTypeId = 6;
update Piping_Material_Sort set EPA_mapping = 'Other', Sort_Order =  8 where PipingMaterialTypeId = 7;
update Piping_Material_Sort set EPA_mapping = 'Unknown', Sort_Order = 9 where PipingMaterialTypeId = 10;
update Piping_Material_Sort set EPA_mapping = 'Stainess Steel', Sort_Order = 7 where PipingMaterialTypeId = 14;


drop table Piping_Style_Sort;
create table Piping_Style_Sort (PipingTypeId integer, Name varchar(50), EPA_mapping varchar(100), Sort_Order integer);
insert into Piping_Style_Sort (PipingTypeId, Name) select PipingTypeId, Name from PipingType where PipingTypeId between 1 and 4;
update Piping_Style_Sort set EPA_mapping = 'Suction', Sort_Order =  2 where PipingTypeId = 1;
update Piping_Style_Sort set EPA_mapping = 'Suction', Sort_Order =  1 where PipingTypeId = 2;
update Piping_Style_Sort set EPA_mapping = 'Pressure', Sort_Order = 3 where PipingTypeId = 3;
update Piping_Style_Sort set EPA_mapping = 'Non-operational ( e.g., fill line, vent line, gravity)', Sort_Order = 4 where PipingTypeId = 4;


select distinct
	f.FacilityId as "FacilityID", f.Name as "FacilityName",
	case when f.BusinessType = 1 then 'Commercial'
	     when f.BusinessType = 2 then 'Private' --is this right?
	     when f.BusinessType = 3 then 'Federal Government - Non Military'
	     when f.BusinessType = 4 then 'State Government - Non Military'
	     when f.BusinessType = 5 then 'Local Government' end as "OwnerType",
	loc.LINE_1_ADDR as "FacilityAddress1",
	loc.CITY_TXT as "FacilityCity",
	loc.ZIP_CD as "FacilityZipCode",
	loc.LAT_DECIMAL_COORD as "FacilityLatitude",
	loc.LONG_DECIMAL_COORD as "FacilityLongitude",
	--"FacilityCoordinateSource", is there a lookup for Owners_and_Permittees_Locations.LAT_LONG_METH_CD?
	'OR' as "FacilityState", 10 as "FacilityEPARegion",
	case when f.IsIndianLand  = 1 then 'Yes' when f.IsIndianLand = 0 then 'No' end as "FacilityTribalSite",
	o.LastName as "FacilityOwnerLastName",
	o.FirstName as "FacilityOwnerFirstName",
	o.Street as "FacilityOwnerAddress1",
	o.City as "FacilityOwnerCity",
	o.ZIP as "FacilityOwnerZipCode",
	o.State as "FacilityOwnerState",
	o.Phone as "FacilityOwnerPhoneNumber",
	p.LastName as "FacilityOperatorLastName",
	p.FirstName as "FacilityOperatorFirstName",
	p.Street as "FacilityOperatorAddress1",
	p.City as "FacilityOperatorCity",
	p.ZIP as "FacilityOperatorZipCode",
	p.State as "FacilityOperatorState",
	p.Phone as "FacilityOperatorPhoneNumber"--,
	--case when fr.FinancialResponsibilityTypeId = 2 then 'Yes' end as "FinancialResponsibilityCommercialInsurance",
	--case when fr.FinancialResponsibilityTypeId = 3 then 'Yes' end as "FinancialResponsibilityGuarantee",
	--case when fr.FinancialResponsibilityTypeId = 5 then 'Yes' end as "FinancialResponsibilityLetterOfCredit",
	--case when fr.FinancialResponsibilityTypeId = 7 then 'Yes' end as "FinancialResponsibilityLocalGovernmentFinancialTest",
	--case when fr.FinancialResponsibilityTypeId = 1 then 'Yes' end as "FinancialResponsibilitySelfInsuranceFinancialTest",
	--case when fr.FinancialResponsibilityTypeId = 4 then 'Yes' end as "FinancialResponsibilitySuretyBond",
	--case when fr.FinancialResponsibilityTypeId = 6 then 'Yes' end as "FinancialResponsibilityTrustFund",
	--case when fr.FinancialResponsibilityTypeId = 13 then 'Yes' end as "FinancialResponsibilityOtherMethod",
	--t.TankCode as "TankID",
	--case when f.IsRegulatedFacility = 1 then 'Yes' else 'No' end "FederallyRegulated",
	--case when t.TankStatusTypeId in (1,3,6,8) then 'Currently in use' 
	--     when t.TankStatusTypeId = 4 then 'Closed (removed from ground)' 
	--	 when t.TankStatusTypeId = 2 then 'Closed (status unknown)' end as "TankStatus",
	--case when mn.TankId is not null then 'Yes' end as "ManifoldedTanks",
	--t.DecommissionDate as "ClosureDate",
	--t.InstallationDate,
	--case when ts.SubstanceTypeId = 1 then 'Gasoline (unknown type)'
	--     when ts.SubstanceTypeId = 2 then 'Diesel fuel (b-unknown)'
	--	 when ts.SubstanceTypeId = 3 then 'Ethanol blend gasoline (e-unknown)'
	--	 when ts.SubstanceTypeId = 4 then 'Kerosene'
	--	 when ts.SubstanceTypeId = 5 then 'Heating/fuel oil # unknown'
	--	 when ts.SubstanceTypeId = 6 then 'Used oil/waste oil'
	--	 when ts.SubstanceTypeId in (7,11,12) then 'Other'
	--	 when ts.SubstanceTypeId = 14 then 'Racing fuel/leaded gasoline'
	--	 when ts.SubstanceTypeId = 15 then '100% biodiesel (not federally regulated)'
	--	 when ts.SubstanceTypeId = 16 then 'Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less'
	--	 when ts.SubstanceTypeId = 17 then 'Ethanol blend gasoline (e-unknown)' end as "TankSubstance",
	--t.EstimatedCapacityGallons as "TankGapacityGallons",
	--case when ex.TankId is not null then 'Yes' end as "ExcavationLiner",
	--case when mt.TankId = 1 then 'Asphalt Coated or Bare Steel'  
	--	 when mt.TankId = 2 then 'Cathodically Protected Steel' 
	--	 when mt.TankId = 3 then 'Coated and Cathodically Protected Steel'  
	--	 when mt.TankId = 4 then 'Composite/Clad (Steel w/Fiberglass Reinforced Plastic)' 
	--	 when mt.TankId in (5,13) then 'Fiberglass Reinforced Plastic' 
	--	 when mt.TankId = 9 then 'Jacketed Steel' 
	--	 when mt.TankId = 10 then 'Other' 
	--	 when mt.TankId = 11 then 'Unknown' end as "MaterialType",
	--case when t.TankLastRepairDate is not null then 'Yes' end as "TankRepaired",
	--t.TankLastRepairDate as "TankRepairDate",
	--mat."PipingMaterialDescription", 
	--style."PipingStyle",
	--case when db.TankId is not null then 'Double Walled' end as "TankWallType",
	--case when t.PipeLastRepairDate is not null then 'Yes' end as "PipingRepaired",
	--t.PipeLastRepairDate as "PipingRepairDate",
	--case when t.CorrosionProtectionTypeID = 2 then 'Yes' end as "TankCorrosionProtectionSacrificialAnode",
	--case when t.CorrosionProtectionTypeID = 2 then 'Unknown' end as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
	--case when t.CorrosionProtectionTypeID = 1 then 'Yes' end as "TankCorrosionProtectionImpressedCurrent",
	--case when t.CorrosionProtectionTypeID = 1 then 'Unknown' end as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
	----Assume Tank.CorrosionProtectionTypeID refers to the tank, but we also have similar fields for piping                                                            
	--case when t.OverfillDeviceTypeID = 2 then 'Yes' end as "AutomaticShutoffDevice",
	--case when t.OverfillDeviceTypeID = 1 then 'Yes' end as "OverfillAlarm",
	--case when t.OverfillDeviceTypeID = 3 then 'Yes' end as "BallFloatValve",
	--case when t.SpillDeviceTypeID in (1,2) then 'Yes' 
	--     when t.SpillDeviceTypeID = 3 then 'No' end as "SpillBucketInstalled",
	--case when atg.TankId is not null then 'Yes' end as "AutomaticTankGauging",
	--case when mtg.TankId is not null then 'Yes' end as "ManualTankGauging",
	--case when sir.TankId is not null then 'Yes' end as "StatisticalInventoryReconciliation",
	--case when tt.TankId is not null then 'Yes' end as "TankTightnessTesting",
	--case when gw.TankId is not null then 'Yes' end as "GroundwaterMonitoring",
	--case when vm.TankId is not null then 'Yes' end as "VaporMonitoring",
	--case when el.TankId is not null then 'Yes' end as "ElectronicLineLeakDetector",
	--case when me.TankId is not null then 'Yes' end as "MechanicalLineLeakDetector",
	--case when im.TankId is not null then 'Yes' end as "AutomatedIntersticialMonitoring",
	--case when ss.TankId is not null then 'Yes' end as "SafeSuction",
	--case when us.TankId is not null then 'Yes' end as "AmericanSafeSuction",
	--case when hp.TankId is not null then 'Yes' end as "HighPressure",
	--t.DateUpdated as "DataCurrentDate"
from Facility f left join FinancialResponsibility fr on f.FacilityId = fr.FacilityId
	left join Tank t on f.FacilityId = t.FacilityId
	left join Owners_and_Permittees_Locations loc on f.FacilityId = loc.FacilityId
	left join (select * from Owners_and_Permittees where AffilTypeCd = 'OWN') o on f.FacilityId = o.FacilityID
	left join (select * from Owners_and_Permittees where AffilTypeCd = 'PMT') p on f.FacilityId = p.FacilityID
	left join TankSubstance ts on t.TankId = ts.TankId
	left join (select TankId from TankConstruction where ConstructionTypeId = 12) mn on t.TankId = mn.TankId
	left join (select TankId from TankConstruction where ConstructionTypeId = 7) ex on t.TankId = ex.TankId
	left join (select TankId from TankConstruction where ConstructionTypeId = 8) db on t.TankId = db.TankId
	left join (select TankId, EPA_mapping as "PipingMaterialDescription" from 
				(select TankId, min(Sort_Order) as Sort_order
				from TankPipingMaterial a join Piping_Material_Sort b on a.PipingMaterialTypeId = b.PipingMaterialTypeId
				group by TankId) x join Piping_Material_Sort y on x.Sort_Order = y.Sort_Order) mat on t.TankId = mat.TankId
	left join (select TankId, EPA_mapping as "PipingStyle" from 
				(select TankId, min(Sort_Order) as Sort_Order
				from TankPipingType a join Piping_Style_Sort b on a.PipingTypeId = b.PipingTypeId
				group by TankId) x join Piping_Style_Sort y on x.Sort_Order = y.Sort_Order) style on t.TankId = style.TankId
	left join (select TankId, ConstructionTypeId from TankConstruction where ConstructionTypeId in (1, 2, 3, 4, 5, 9, 10, 11, 13)) mt on t.TankId = mt.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 4) atg on t.TankId = atg.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 4) mtg on t.TankId = mtg.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 16) sir on t.TankId = sir.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 2) tt on t.TankId = tt.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 8) gw on t.TankId = gw.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 6) vm on t.TankId = vm.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 23) el on t.TankId = el.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 22) me on t.TankId = me.TankId
	left join (select TankId from TankReleaseDetection where ReleaseDetectionTypeId = 11) im on t.TankId = im.TankId
	left join (select TankId from TankPipingType where PipingTypeId = 1) ss on t.TankId = ss.TankId
	left join (select TankId from TankPipingType where PipingTypeId = 2) us on t.TankId = us.TankId
	left join (select TankId from TankPipingType where PipingTypeId = 3) hp on t.TankId = hp.TankId
;


select * from Piping_Material_Sort order by Sort_order;

select TankId, EPA_mapping from 
	(select TankId, min(Sort_Order) as Sort_order
	from TankPipingMaterial a join Piping_Material_Sort b on a.PipingMaterialTypeId = b.PipingMaterialTypeId
	group by TankId) x join Piping_Material_Sort y on x.Sort_order = y.Sort_order
where TankId = 19897

select * 
from TankPipingMaterial x join PipingMaterialType y on x.PipingMaterialTypeId = y.PipingMaterialTypeId
where x.TankId = 19897

in (
	select TankId, count(*) from 
		(select TankId, a.PipingMaterialTypeId, Name
		from TankPipingMaterial a join PipingMaterialType b on a.PipingMaterialTypeId = b.PipingMaterialTypeId
		where a.PipingMaterialTypeId in (1,2,3,4,5,6,7,10,14)) a 
	group by TankId having count(*) > 1);

order by 1, 2;

select * from PipingType;

 (
	select TankId, count(*) from 
		(select TankId, a.PipingTypeId, Name
		from TankPipingType a join PipingType b on a.PipingTypeId = b.PipingTypeId
		where a.PipingTypeId in (1,2,3)) a 
	group by TankId having count(*) > 1);

select * from  TankPipingType a join PipingType b on a.PipingTypeId = b.PipingTypeId
where TankId = 11407;

select * from INFORMATION_SCHEMA.columns where column_name like '%Material%';

select * from TankPipingMaterial;

select c.table_name, column_name
from INFORMATION_SCHEMA.columns c join INFORMATION_SCHEMA.tables t on c.table_name = t.table_name and c.table_schema = t.table_schema
where table_type like '%TABLE' and 
upper(column_name) like upper('%inspect%') order by 1, 2;



select * from InspectionType;

select * from PipingType;
PipingTypeId	Name
1	"Safe Suction" (no valve at tank)
2	"U.S. Suction" (valve at tank)
3	Pressure
4	Gravity Feed
5	None


select * from ReleaseDetectionType where TankPipeFlag = 'PIPE';

select * from Tank where SpillDeviceInd is not null;



select * from SpillDeviceType;
SpillDeviceTypeId	Name
1	Spill Bucket
2	Spill Catchment Basin
3	No Spill Prevention Required
4	Spill Device Type Unknown

select * from OverfillDeviceType;
OverfillDeviceTypeId	Name
1	Overfill Alarm
2	Automatic Shutoff Device
3	Ball Float Valve
4	No Overfill Prevention Required
5	Overfill Device Type Unknown



select distinct CorrosionProtectionTypeID from Tank;


select * from PipingMaterialType;
1	Bare Steel	Steel
2	Bare Steel, Wrapped	Steel
3	Galvanized Steel	Galvanized Steel
4	Fiberglass Reinforced Plastic	Fiberglass Reinforced Plastic
5	Copper	Copper
6	Flexible Plastic	Flex Piping
10	Unknown	Unknown
12	None	No Piping


select * from TankPipingMaterial;

select TankId from TankPipingMaterial
where PipingMaterialTypeId in (1,2,3,4,5,6,12)
group by TankId having count(*) > 1;



select * from Tank 
where LiningDate is not null
order by FacilityId, TankCode;


select TankId from TankPipingType
group by TankId having count(*) > 1;

select * from TankPipingMaterial where TankId = 206;

select * from ConstructionType;


select * from TankSubstance;

select * from SubstanceType;

select * from ConstructionType;

select distinct TempCloseDate from Tank order by 1;

select * from TankStatusType order by 1;

select FacilityId, TankCode, count(*) from Tank group by FacilityId, TankCode having count(*) > 1;
 
select * from Facility;

select * from FinancialResponsibility;

select * from FinancialResponsibilityType;


select distinct BusinessType from Facility;
0
3
1
4
5
NULL
2

select * from ContactType;

select * from INFORMATION_SCHEMA.columns where column_name like '%Type' and table_name <> 'v_ust'
order by COLUMN_NAME , TABLE_NAME ;

select distinct businesstype from Owners_and_Permittees_Locations oapl  order by 1;

select * from vwFacilityLocation;

select table_name from INFORMATION_SCHEMA.tables where table_type like '%TABLE' and table_name like '%Type%' order by table_name;

select * from ConstructionType;

select * from ContactType;
ContactTypeId	Name
1	Legal Owner
14	Permittee
15	Owner
16	Frmr owner
17	Frmr legal owner
30	Invoicee
31	Mail Contact





------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'MaterialDescription','ConstructionType','Name');



insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'TankSubstance', 'SubstanceType', 'Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'OwnerType', 'SubstanceType', 'Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FacilityType', 'businesstype', 'Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'TankCorrosionProtectionSacrificialAnode', 'corrosionprotectiontype', 'Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'TankCorrosionProtectionImpressedCurrent', 'corrosionprotectiontype', 'Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'TankCorrosionProtectionImpressedCurrent', 'corrosionprotectiontype', 'Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityBondRatingTest','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityCommercialInsurance','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityGuarantee','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityLetterOfCredit','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityLocalGovernmentFinancialTest','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityRiskRetentionGroup','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilitySelfInsuranceFinancialTest','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityStateFund','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilitySuretyBond','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityTrustFund','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FinancialResponsibilityOtherMethod','FinancialResponsibilityType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'TankStatus','TankStatusType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'BallFloatValve','OverfillDeviceType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'FlowShutoffDevice','OverfillDeviceType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'HighLevelAlarm','OverfillDeviceType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'SpillBucketInstalled','SpillDeviceType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'AutomaticTankGauging','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'ManualTankGauging','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'StatisticalInventoryReconciliation','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'TankTightnessTesting','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'GroundwaterMonitoring','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'VaporMonitoring','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'ElectronicLineLeak','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'MechanicalLineLeak','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'AutomatedIntersticialMonitoring','ReleaseDetectionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'SafeSuction','PipingType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'AmericanSafeSuction','PipingType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'HighPressure','PipingType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'PipingMaterialDescription','PipingMaterialType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'MultipleTanks','ConstructionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'ExcavationLiner','ConstructionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'TankWallType','ConstructionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'LinedTank','ConstructionType','Name');
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR','2022-10-04', 'PipingStyle','PipingType','Name');

select * from pipingtype;

delete from ust_element_db_mapping where state = 'OR' 
and element_name in ('FinancialResponsibilityStateFund','FinancialResponsibilityRiskRetentionGroup',
'FinancialResponsibilityBondRatingTest','FinancialResponsibilityCommercialInsurance');

delete from public.ust_element_db_mapping where state = 'OR' and element_name = 'PipingFlexConnector';	

update ust_element_db_mapping set element_name = 'OwerType' where state = 'OR' and element_name = 'FacilityType1';


select * from substances;	

select * from SubstanceType; 


select id, element_name, state_table_name, state_column_name  
from ust_element_db_mapping 
where state = 'OR' 
and id not in (select element_db_mapping_id from ust_element_value_mappings)
--and state_table_name = 'FinancialResponsibilityType'
order by state_table_name, element_name;
	
select 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (' || id || ', '''', '''');--' || element_name
from ust_element_db_mapping 
where state = 'OR' 
and id not in (select element_db_mapping_id from ust_element_value_mappings)
and state_table_name = 'PipingType'
order by 1;

select * from ust_element_db_mapping where state = 'OR' and element_name like '%Pressure';

select * from pipingtype t 

1	"Safe Suction" (no valve at tank)
2	"U.S. Suction" (valve at tank)
3	Pressure
4	Gravity Feed
5	None


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (41, '"Safe Suction" (no valve at tank)', 'Suction');--PipingStyle
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (41, '"U.S. Suction" (valve at tank)', 'Suction');--PipingStyle
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (41, 'Pressure', 'Pressure');--PipingStyle
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (41, 'Gravity Feed', 'Non-operational ( e.g., fill line, vent line, gravity)');--PipingStyle
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Gasoline', 'Gasoline (unknown type)');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Diesel', 'Diesel fuel (b-unknown)');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Gasohol', 'Ethanol blend gasoline (e-unknown)');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Kerosene', 'Kerosene');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Heating Oil', 'Heating/fuel oil # unknown');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Used Oil', 'Used oil/waste oil');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Mixture of Substance', 'Other');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Hazardous Substance', 'Hazardous substance');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Other', 'Other');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Leaded Gasoline', 'Racing fuel/leaded gasoline');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Biodiesel', '100% biodiesel (not federally regulated)');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Diesel > 20% biodiesel', 'Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (34, 'Gasoline > 10% ethanol', 'Ethanol blend gasoline (e-unknown)');--TankSubstance
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (33, 'Active', 'Currently in use');--TankStatus
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (33, 'Abandoned', 'Abandoned');--TankStatus
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (33, 'Discovered', 'Abandoned');--TankStatus
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (33, 'Filled', 'Closed (in place)');--TankStatus
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (33, 'Removed', 'Closed (removed from ground)');--TankStatus
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (33, 'Hoist', 'Closed (general)');--TankStatus
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (30, 'Spill Bucket', 'Yes');--SpillBucketInstalled
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (30, 'Spill Catchment Basin', 'Yes');--SpillBucketInstalled
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (30, 'No Spill Prevention Required', 'No');--SpillBucketInstalled
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (30, 'Spill Device Type Unknown', 'Unknown');--SpillBucketInstalled
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Bare Steel', 'Steel');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Bare Steel, Wrapped', 'Steel');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Galvanized Steel', 'Galvanized steel');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Copper', 'Copper');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Flexible Plastic', 'Flex piping');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Corrugated Stainless steel  in flexible plastic', 'Stainless steel');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Cathodically Protected', 'Other');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (28, 'Unknown', 'Unknown');--PipingMaterialDescription
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (32, 'Impressed Current', 'Yes');--TankCorrosionProtectionImpressedCurrent
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (40, 'Galvanic', 'Yes');--TankCorrosionProtectionSacrificialAnode	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (7, 'Retail', 'Commercial');--FacilityType1
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (7, 'Non-Retail', 'Private');--FacilityType1
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (7, 'Federal Government', 'Federal Government - Non Military');--FacilityType1
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (7, 'State Government', 'State Government - Non Military');--FacilityType1
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (7, 'Local Government', 'Local Government');--FacilityType1
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Asphalt Coated or Bare Steel', 'Asphalt coated or bare steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Cathodically Protected Steel', 'Cathodically protected steel (without coating)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Coated and Cathodically Protected Steel (Stip3)', 'Coated and cathodically protected steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Composite (Steel Clad with Fiberglass)', 'Composite/clad (steel w/fiberglass reinforced plastic)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Fiberglass Reinforced Plastic (Retrofit)', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Polyethylene Tank Jacket', 'Jacketed steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Concrete', 'Concrete');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (24, 'Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (36, 'Double Walled', 'Double');--TankWallType
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (39, 'Lined Interior', 'Yes');--LinedTank
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (26, 'Manifolded', 'Yes');--MultipleTanks
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6, 'Excavation Liner', 'Yes');--ExcavationLiner
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (19, 'Automatic Shutoff Device', 'Yes');--FlowShutoffDevice
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (21, 'Overfill Alarm', 'Yes');--HighLevelAlarm
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (4, 'Ball Float Valve', 'Yes');--BallFloatValve
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (10, 'Guarantee', 'Yes');--FinancialResponsibilityGuarantee
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (11, 'Letter of Credit', 'Yes');--FinancialResponsibilityLetterOfCredit
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (12, 'Local Government', 'Yes');--FinancialResponsibilityLocalGovernmentFinancialTest
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (13, 'Data From Invoice', 'Yes');--FinancialResponsibilityOtherMethod
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (15, 'Self Insurance', 'Yes');--FinancialResponsibilitySelfInsuranceFinancialTest
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (17, 'Surety Bond', 'Yes');--FinancialResponsibilitySuretyBond
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (18, 'Trust Fund', 'Yes');--FinancialResponsibilityTrustFund

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (1, '"U.S. Suction" (valve at tank)', 'Yes');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (29, '"Safe Suction" (no valve at tank)', 'Yes');

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (3, 'Automatic tank gauging', 'Yes');--AutomaticTankGauging
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (2, 'Interstitial Monitoring', 'Yes');--AutomatedIntersticialMonitoring
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (5, 'Electronic', 'Yes');--ElectronicLineLeak
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (20, 'Groundwater monitoring', 'Yes');--GroundwaterMonitoring
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (22, 'Pressure', 'Yes');--HighPressure
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (23, 'Manual tank gauging', 'Yes');--ManualTankGauging
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (25, 'Mechanical', 'Yes');--MechanicalLineLeak
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (31, 'SIR', 'Yes');--StatisticalInventoryReconciliation
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (35, 'Tank tightness testing', 'Yes');--TankTightnessTesting
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (37, 'Vapor monitoring', 'Yes');--VaporMonitoring
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (38, 'Automatic tank gauging', 'Yes');--AutomaticTankGauging



select * from ust_elements order by element_position ;

select b.element_name, b.state_table_name, b.state_column_name, v.state_value, v.epa_value
from ust_element_value_mappings v join ust_element_db_mapping b on v.element_db_mapping_id  = b.id
	join ust_elements e on b.element_name = e.element_name
where b.state = 'OR'
order by e.element_position, v.epa_value;


select e.element_name, 'null as "' || e.element_name || '",' as element_name_select, 
	b.state_table_name, b.state_column_name, v.state_value, v.epa_value 
from ust_elements e left join ust_element_db_mapping b on b.element_name = e.element_name 
	left join ust_element_value_mappings v on v.element_db_mapping_id = b.id
order by e.element_position;


select * from v_ust_element_mapping where element_name like '%Substance%'


update public.ust_element_db_mapping set element_name = 'TankSubstanceStored' where element_name = 'TankSubstance'

select * from ust_element_db_mapping where element_name like 'Facility%'

select * from public.ust_element_value_mappings order by id desc; where element_db_mapping_id = 24;

select * from public.ust_element_value_mappings  where element_db_mapping_id = 34;

delete from ust_element_value_mappings where id between 111 and 123;

select b.element_position, b.element_name, a.state_value, a.epa_value
from v_ust_element_mapping a join ust_elements b on a.element_name = b.element_name
where a.state = 'OR' order by 1, 3, 4;

select * from piping_style;