--these two tables were sent as Excel files by the state
create table businesstype ("BusinessType" int not null primary key, "Name" text);
insert into businesstype values (0,'NULL');
insert into businesstype values (1,'Retail');
insert into businesstype values (2,'Non-Retail');
insert into businesstype values (3,'Federal Government');
insert into businesstype values (4,'State Government');
insert into businesstype values (5,'Local Government');

create table corrosionprotectiontype ("CorrosionProtectionType" int not null primary key, "Name" text);
insert into corrosionprotectiontype values (1,'Impressed Current');
insert into corrosionprotectiontype values (2,'Galvanic');

--------------------------------------------------------------------------------------------------------------------


select * from ust_element_db_mapping where state = 'OR';

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR', '2023-03-28', 'FacilityTribalSite', 'facility', 'isindianland')
returning id;

select distinct "isindianland" from "OR_UST".facility order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (165, ''' || "isindianland"::varchar ||  ''', '''');'
from "OR_UST".facility order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (165, '0', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (165, '1', 'Yes');
--------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR', '2023-03-28', 'FacilityTribalSite', 'facility', 'isindianland')
returning id;

select distinct "isindianland" from "OR_UST".facility order by 1;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (165, ''' || "isindianland"::varchar ||  ''', '''');'
from "OR_UST".facility order by 1;
--------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values ('OR', '2023-03-28', 'TankCorrosionProtectionSacrificialAnode', 'corrosionprotectiontype', 'Name', 'tank', 'corrosionprotectiontypeid', 'CorrosionProtectionType')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (166, ''' || "Name" ||  ''', ''Yes'');'
from "OR_UST".corrosionprotectiontype where "Name" = 'Galvanic'
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (166, 'Galvanic', 'Yes');
--------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values ('OR', '2023-03-28', 'TankCorrosionProtectionImpressedCurrent', 'corrosionprotectiontype', 'Name', 'tank', 'corrosionprotectiontypeid', 'CorrosionProtectionType')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (167, ''' || "Name" ||  ''', ''Yes'');'
from "OR_UST".corrosionprotectiontype where "Name" = 'Impressed Current'
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (167, 'Impressed Current', 'Yes');

--------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('OR', '2023-03-28', 'FederallyRegulated', 'facility', 'isregulatedfacility')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (168, ''' || "isregulatedfacility"::varchar ||  ''', '''');'
from "OR_UST".facility 
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (168, '0', 'No');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (168, '1', 'Yes'); 
--------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values ('OR', '2023-03-28', 'BallFloatValve', 'overfilldevicetype', 'Name', 'tank', 'overfilldevicetypeid', 'overfilldevicetypeid')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (169, ''' || "Name" ||  ''', ''Yes'');'
from "OR_UST".overfilldevicetype 
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (169, 'Ball Float Valve', 'Yes');
--------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values ('OR', '2023-03-28', 'FlowShutoffDevice', 'overfilldevicetype', 'Name', 'tank', 'overfilldevicetypeid', 'overfilldevicetypeid')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (170, ''' || "Name" ||  ''', ''Yes'');'
from "OR_UST".overfilldevicetype 
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (170, 'Automatic Shutoff Device', 'Yes');
--------------------------------------------------------------------------------------------------------------------

insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk)
values ('OR', '2023-03-28', 'HighLevelAlarm', 'overfilldevicetype', 'Name', 'tank', 'overfilldevicetypeid', 'overfilldevicetypeid')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (171, ''' || "Name" ||  ''', ''Yes'');'
from "OR_UST".overfilldevicetype 
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (171, 'Overfill Alarm', 'Yes');
--------------------------------------------------------------------------------------------------------------------
select * from "OR_UST".overfilldevicetype;

left join overfilldevicetype odt on t.overfilldevicetypeid = odt.overfilldevicetypeid --BallFloatValve, FlowShutoffDevice, HighLevelAlarm
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

select * from ust_control where organization_id = 'OR'

create or replace view "OR_UST".v_ust_base as 
select distinct 
	f.facilityid as "FacilityID",
	f."Name" as "FacilityName",
	ot.epa_value as "OwnerType",
	loc.line_1_addr as "FacilityAddress1",
	loc.city_txt as "FacilityCity",
	loc.zip_cd as "FacilityZipCode",
	'OR' as "FacilityState", 
	10 as "FacilityEPARegion",
	fts.epa_value as "FacilityTribalSite",
	loc.lat_decimal_coord as "FacilityLatitude",
	loc.long_decimal_coord as "FacilityLongitude",
	'Unknown' as "FacilityCoordinateSource", 
	o.lastname as "FacilityOwnerLastName",
	o.firstname as "FacilityOwnerFirstName",
	o.street as "FacilityOwnerAddress1",
	o.city as "FacilityOwnerCity",
	o.zip as "FacilityOwnerZipCode",
	o.state as "FacilityOwnerState",
	o.phone as "FacilityOwnerPhoneNumber",
	p.lastname as "FacilityOperatorLastName",
	p.firstname as "FacilityOperatorFirstName",
	p.street as "FacilityOperatorAddress1",
	p.city as "FacilityOperatorCity",
	p.zip as "FacilityOperatorZipCode",
	p.state as "FacilityOperatorState",
	p.phone as "FacilityOperatorPhoneNumber",
	frg.epa_value as "FinancialResponsibilityGuarantee",
	frlc.epa_value as "FinancialResponsibilityLetterOfCredit",
	frlg.epa_value as "FinancialResponsibilityLocalGovernmentFinancialTest",
	frsi.epa_value as "FinancialResponsibilitySelfInsuranceFinancialTest",
	frsb.epa_value as "FinancialResponsibilitySuretyBond",
	frtf.epa_value as "FinancialResponsibilityTrustFund",
	fro.epa_value as "FinancialResponsibilityOtherMethod",
	case when fr.facilityid is not null then 'Yes' end as "FinancialResponsibilityObtained",
	t.tankcode as "TankID",
	freg.epa_value as "FederallyRegulated",
	ts.epa_value as "TankStatus",
	mt.epa_value as "MultipleTanks",
	t.DecommissionDate as "ClosureDate",
	t.InstallationDate,
	tsub.epa_value as "TankSubstanceStored",
    t.EstimatedCapacityGallons as "TankGapacityGallons",
	lt.epa_value as "LinedTank",
	el.epa_value as "ExcavationLiner",
	wt.epa_value as "TankWallType",
	md.epa_value as "MaterialDescription", 
	case when t.tanklastrepairdate is not null then 'Yes' end as "TankRepaired",
	t.tanklastrepairdate as "TankRepairDate",
	pmd.epa_value as "PipingMaterialDescription", 	
	ps.epa_value as "PipingStyle",
	case when t.PipeLastRepairDate is not null then 'Yes' end as "PipingRepaired",
	t.PipeLastRepairDate as "PipingRepairDate",
	tcpsa.epa_value as "TankCorrosionProtectionSacrificialAnode",
	case when tcpsa.epa_value is not null then 'Unknown' end as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
	tcpic.epa_value as "TankCorrosionProtectionImpressedCurrent",
	case when tcpic.epa_value is not null then 'Unknown' end as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
	bfv.epa_value as "BallFloatValve",
	fsd.epa_value as "FlowShutoffDevice",
	hla.epa_value as "HighLevelAlarm",
	sb.epa_value as "SpillBucketInstalled",	     
	atg.epa_value as "AutomaticTankGauging",
	mtg.epa_value as "ManualTankGauging",
	sir.epa_value as "StatisticalInventoryReconciliation",
	tt.epa_value as "TankTightnessTesting",
	gw.epa_value as "GroundwaterMonitoring",
	vm.epa_value as "VaporMonitoring",
	ell.epa_value as "ElectronicLineLeak",
	mll.epa_value as "MechanicalLineLeak",
	im.epa_value as "AutomatedIntersticialMonitoring",
	ss.epa_value as "SafeSuction",
	us.epa_value as "AmericanSafeSuction",
	hp.epa_value as "HighPressure"
from "OR_UST".facility f 
	left join "OR_UST".businesstype b on f.businesstype = b."BusinessType"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 7 and element_name = 'FacilityTribalSite') fts on f."isindianland"::varchar = fts.state_value
	left join v_ust_element_mapping ot on ot.state_value = b."Name" and control_id = 7 and ot.element_name = 'OwerType'
	left join "OR_UST".owners_and_permittees_locations loc on f.facilityid = loc.facilityid
	left join (select distinct facilityid, firstname, lastname, phone, street, city, state, zip from "OR_UST".owners_and_permittees where affiltypecd = 'OWN') o on f.facilityid = o.facilityid --owners
	left join (select distinct facilityid, firstname, lastname, phone, street, city, state, zip from "OR_UST".owners_and_permittees where affiltypecd = 'PMT') p on f.facilityid = p.facilityid --operators
	left join (select distinct facilityid, epa_value from "OR_UST".financialresponsibility a 
					join "OR_UST".financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and control_id = 7 and c.element_name = 'FinancialResponsibilityGuarantee') frg on f.facilityid  = frg.facilityid 
	left join (select distinct facilityid, epa_value from "OR_UST".financialresponsibility a 
					join "OR_UST".financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and control_id = 7 and c.element_name = 'FinancialResponsibilityLetterOfCredit') frlc on f.facilityid  = frlc.facilityid 					
	left join (select distinct facilityid, epa_value from "OR_UST".financialresponsibility a 
					join "OR_UST".financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and control_id = 7 and c.element_name = 'FinancialResponsibilityLocalGovernmentFinancialTest') frlg on f.facilityid  = frlg.facilityid 	
	left join (select distinct facilityid, epa_value from "OR_UST".financialresponsibility a 
					join "OR_UST".financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and control_id = 7 and c.element_name = 'FinancialResponsibilitySelfInsuranceFinancialTest') frsi on f.facilityid  = frsi.facilityid 		
	left join (select distinct facilityid, epa_value from "OR_UST".financialresponsibility a 
					join "OR_UST".financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and control_id = 7 and c.element_name = 'FinancialResponsibilitySuretyBond') frsb on f.facilityid  = frsb.facilityid 		
	left join (select distinct facilityid, epa_value from "OR_UST".financialresponsibility a 
					join "OR_UST".financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and control_id = 7 and c.element_name = 'FinancialResponsibilityTrustFund') frtf on f.facilityid  = frtf.facilityid 		
	left join (select distinct facilityid, epa_value from "OR_UST".financialresponsibility a 
					join "OR_UST".financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and control_id = 7 and c.element_name = 'FinancialResponsibilityOtherMethod') fro on f.facilityid  = fro.facilityid 		
	left join (select distinct facilityid from "OR_UST".financialresponsibility) fr on f.facilityid = fr.facilityid 
	left join "OR_UST".tank t on f.facilityid = t.facilityid
	left join (select tankstatustypeid, epa_value from "OR_UST".tankstatustype a join v_ust_element_mapping b 
	               on a."Name" = b.state_value and control_id = 7 and b.element_name = 'TankStatus') ts on t.tankstatustypeid = ts.tankstatustypeid
	left join (select distinct tankid, epa_value from "OR_UST".tankconstruction a 
					join "OR_UST".constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'MultipleTanks') mt on t.tankid = mt.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tanksubstance a 
					join "OR_UST".substancetype b on a.substancetypeid = b.substancetypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'TankSubstanceStored') tsub on t.tankid = tsub.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tankconstruction a 
					join "OR_UST".constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'LinedTank') lt on t.tankid = lt.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tankconstruction a 
					join "OR_UST".constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'ExcavationLiner') el on t.tankid = el.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tankconstruction a 
					join "OR_UST".constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'TankWallType') wt on t.tankid = wt.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tankconstruction a 
					join "OR_UST".constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'MaterialDescription') md 
						on t.tankid = md.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tankconstruction a 
					join "OR_UST".constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'PipingMaterialDescription') pmd 
						on t.tankid = pmd.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tankpipingtype a 
					join "OR_UST".pipingtype b on a.pipingtypeid = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and control_id = 7 and c.element_name = 'PipingStyle'
				where isactive = '1') ps on t.tankid = ps.tankid			
	left join "OR_UST".corrosionprotectiontype cpt on cpt."CorrosionProtectionType" = t.corrosionprotectiontypeid --TankCorrosionProtectionSacrificialAnode, TankCorrosionProtectionImpressedCurrent 
	left join (select distinct spilldevicetypeid, epa_value from "OR_UST".spilldevicetype a 
					join v_ust_element_mapping b on a."Name" = b.state_value and control_id = 7 and b.element_name = 'SpillBucketInstalled') sb 
						on t.spilldevicetypeid = sb.spilldevicetypeid
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'AutomaticTankGauging' and c.state_value = 'Automatic tank gauging') atg on t.tankid = atg.tankid
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'ManualTankGauging' and c.state_value = 'Manual tank gauging') mtg on t.tankid = mtg.tankid	
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'StatisticalInventoryReconciliation' and c.state_value = 'SIR') sir on t.tankid = sir.tankid	
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'TankTightnessTesting' and c.state_value = 'Tank tightness testing') tt on t.tankid = tt.tankid	
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'GroundwaterMonitoring' and c.state_value = 'Groundwater monitoring') gw on t.tankid = gw.tankid	
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'VaporMonitoring' and c.state_value = 'Vapor monitoring') vm on t.tankid = vm.tankid
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'ElectronicLineLeak' and c.state_value = 'Electronic') ell on t.tankid = ell.tankid	
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'MechanicalLineLeak' and c.state_value = 'Mechanical') mll on t.tankid = mll.tankid
	left join (select distinct tankid, epa_value from "OR_UST".tankreleasedetection a 
					join "OR_UST".releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'AutomatedIntersticialMonitoring' and c.state_value = 'Interstitial Monitoring') im on t.tankid = im.tankid
	left join (select distinct tankid, epa_value from "OR_UST".tankpipingtype a 
					join "OR_UST".pipingtype b on a.pipingtypeid  = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'SafeSuction' and c.state_value = '"Safe Suction" (no valve at tank)') ss on t.tankid = ss.tankid
	left join (select distinct tankid, epa_value from "OR_UST".tankpipingtype a 
					join "OR_UST".pipingtype b on a.pipingtypeid  = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'AmericanSuction' and c.state_value = '"U.S. Suction" (valve at tank)') us on t.tankid = us.tankid			
	left join (select distinct tankid, epa_value from "OR_UST".tankpipingtype a 
					join "OR_UST".pipingtype b on a.pipingtypeid  = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and control_id = 7 and c.element_name = 'HighPressure' and c.state_value = 'Pressure') hp on t.tankid = hp.tankid	
	left join "OR_UST".tankstatustype tst on t.tankstatustypeid = tst.tankstatustypeid 
	left join "OR_UST".corrosionprotectiontype cptt on t.corrosionprotectiontypeid = cptt."CorrosionProtectionType"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 7 and element_name = 'TankCorrosionProtectionSacrificialAnode') tcpsa on tcpsa.state_value = cptt."Name" 
	left join "OR_UST".corrosionprotectiontype cptt2 on t.corrosionprotectiontypeid = cptt."CorrosionProtectionType"
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 7 and element_name = 'TankCorrosionProtectionImpressedCurrent') tcpic on tcpic.state_value = cptt2."Name" 
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 7 and element_name = 'FederallyRegulated') freg on freg.state_value = f.isregulatedfacility::varchar
	left join "OR_UST".overfilldevicetype odtt on t.overfilldevicetypeid = odtt.overfilldevicetypeid
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 7 and element_name = 'BallFloatValve') bfv on bfv.state_value = odtt.overfilldevicetypeid::varchar 
	left join "OR_UST".overfilldevicetype odtt2 on t.overfilldevicetypeid = odtt.overfilldevicetypeid
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 7 and element_name = 'FlowShutoffDevice') fsd on fsd.state_value = odtt2.overfilldevicetypeid::varchar 
	left join "OR_UST".overfilldevicetype odtt3 on t.overfilldevicetypeid = odtt.overfilldevicetypeid
	left join (select state_value, epa_value from v_ust_element_mapping where control_id = 7 and element_name = 'HighLevelAlarm') hla on hla.state_value = odtt3.overfilldevicetypeid::varchar 
where tst."Name" not in ('Unregulated','Change in Service')
order by f.facilityid, t.tankid;

select * 
into ust_or_bkup
from ust where control_id = 7;

delete from ust where control_id = 7;

select *
into ust_facilities_or_bkup 
from ust_facilities where control_id = 7;

select * into ust_geocode_or_bkup
from ust_geocode  where control_id = 7;


select distinct element_db_mapping_id, element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk 
from v_ust_element_mapping where control_id = 7 order by 1;