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


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
select 
	f.facilityid as "FacilityID",
	f."Name" as "FacilityName",
	ot.epa_value as "OwnerType",
	null as "FacilityType1",
	null as "FacilityType2",
	loc.line_1_addr as "FacilityAddress1",
	null as "FacilityAddress2",	
	loc.city_txt as "FacilityCity",
	null as "FacilityCounty",	
	loc.zip_cd as "FacilityZipCode",
	null as "FacilityPhoneNumber",
	'OR' as "FacilityState", 
	10 as "FacilityEPARegion",
	case when f.IsIndianLand = B'1' then 'Yes' when f.IsIndianLand = B'0' then 'No' end as "FacilityTribalSite",
	null as "FacilityTribe",
	loc.lat_decimal_coord as "FacilityLatitude",
	loc.long_decimal_coord as "FacilityLongitude",
	'Unknown' as "FacilityCoordinateSource", 
	null as "FacilityOwnerCompanyName",
	o.lastname as "FacilityOwnerLastName",
	o.firstname as "FacilityOwnerFirstName",
	o.street as "FacilityOwnerAddress1",
	null as "FacilityOwnerAddress2",
	o.city as "FacilityOwnerCity",
	null as "FacilityOwnerCounty",	
	o.zip as "FacilityOwnerZipCode",
	o.state as "FacilityOwnerState",
	o.phone as "FacilityOwnerPhoneNumber",
	null as "FacilityOwnerEmail",
	null as "FacilityOwnerOperatorName",
	p.lastname as "FacilityOperatorLastName",
	p.firstname as "FacilityOperatorFirstName",
	p.street as "FacilityOperatorAddress1",
	null as "FacilityOperatorAddress2",	
	p.city as "FacilityOperatorCity",
	null as "FacilityOperatorCounty",	
	p.zip as "FacilityOperatorZipCode",
	p.state as "FacilityOperatorState",
	p.phone as "FacilityOperatorPhoneNumber",
	null as "FacilityOperatorEmail",	
	null as "FinancialResponsibilityBondRatingTest",
	null as "FinancialResponsibilityCommercialInsurance",
	frg.epa_value as "FinancialResponsibilityGuarantee",
	frlc.epa_value as "FinancialResponsibilityLetterOfCredit",
	frlg.epa_value as "FinancialResponsibilityLocalGovernmentFinancialTest",
	null as "FinancialResponsibilityRiskRetentionGroup",
	frsi.epa_value as "FinancialResponsibilitySelfInsuranceFinancialTest",
	null as "FinancialResponsibilityStateFund",
	frsb.epa_value as "FinancialResponsibilitySuretyBond",
	frtf.epa_value as "FinancialResponsibilityTrustFund",
	fro.epa_value as "FinancialResponsibilityOtherMethod",
	null as "FinancialResponsibilityNotRequired",
	case when fr.facilityid is not null then 'Yes' end as "FinancialResponsibilityObtained",
	null as "Compliance",
	t.tankcode as "TankID",
	null as "TankLocation",
	case when f.isregulatedfacility = B'1' then 'Yes' else 'No' end "FederallyRegulated",
	ts.epa_value as "TankStatus",
	null as "FieldConstructed",
	null as "EmergencyGenerator",
	null as "AirportHydrantSystem",
	mt.epa_value as "MultipleTanks",
	t.DecommissionDate as "ClosureDate",
	t.InstallationDate,
	null as "CompartmentalizedUST",
	null as "NumberofCompartments",
	tsub.epa_value as "TankSubstanceStored",
	null as "CompartmentID",
	null as "CompartmentSubstanceStored",
    t.EstimatedCapacityGallons as "TankGapacityGallons",
	null as "CompartmentCapacityGallons",
	lt.epa_value as "LinedTank",
	el.epa_value as "ExcavationLiner",
	wt.epa_value as "TankWallType",
	md.epa_value as "MaterialDescription", 
	case when t.tanklastrepairdate is not null then 'Yes' end as "TankRepaired",
	t.tanklastrepairdate as "TankRepairDate",
	null as "CertofInstallation",	
	pmd.epa_value as "PipingMaterialDescription", 	
	null as "PipingFlexConnector",
	ps.epa_value as "PipingStyle",
	null as "PipingWallType",
	null as "PipingUDCForEveryDispenser",
	case when t.PipeLastRepairDate is not null then 'Yes' end as "PipingRepaired",
	t.PipeLastRepairDate as "PipingRepairDate",
	case when cpt."Name" = 'Galvanic' then 'Yes' end as "TankCorrosionProtectionSacrificialAnode",
	case when cpt."Name" = 'Galvanic' then 'Unknown' end as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
	case when cpt."Name" = 'Impressed Current' then 'Yes' end as "TankCorrosionProtectionImpressedCurrent",
	case when cpt."Name" = 'Impressed Current' then 'Yes' end as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
	null as "TankCorrosionProtectionCathodicNotRequired",
	null as "TankCorrosionProtectionInteriorLining",
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
	case when odt."Name" = 'Ball Float Valve' then 'Yes' end as "BallFloatValve",
	case when odt."Name" = 'Automatic Shutoff Device' then 'Yes' end as "FlowShutoffDevice",
	case when odt."Name" = 'Overfill Alarm' then 'Yes' end as "HighLevelAlarm",
	null as "OverfillProtectionPrimary",
	null as "OverfillProtectionSecondary",
	null as "PrimaryOverfillInstallDate",
	null as "SecondaryOverfillInstallDate",
	sb.epa_value as "SpillBucketInstalled",	     
	null as "SpillBucketWallType",
	null as "DrainPresent",
	null as "PumpPresent",
	null as "InterstitialMonitoringContinualElectric",
	null as "InterstitialMonitoringManual",
	atg.epa_value as "AutomaticTankGauging",
	null as "AutomaticTankGaugingReleaseDetection",
	null as "AutomaticTankGaugingContinuousLeakDetection",
	mtg.epa_value as "ManualTankGauging",
	sir.epa_value as "StatisticalInventoryReconciliation",
	tt.epa_value as "TankTightnessTesting",
	gw.epa_value as "GroundwaterMonitoring",
	null as "SubpartK",	
	vm.epa_value as "VaporMonitoring",
	ell.epa_value as "ElectronicLineLeak",
	mll.epa_value as "MechanicalLineLeak",
	im.epa_value as "AutomatedIntersticialMonitoring",
	ss.epa_value as "SafeSuction",
	us.epa_value as "AmericanSafeSuction",
	null as "PipingSubpartK",
	hp.epa_value as "HighPressure",	
	null as "PrimaryReleaseDetectionType",
	null as "SecondReleaseDetectionType",
	null as "PipeSecondaryContainment",
	null as "PipeInstallDate",
	null as "USTReportedRelease",
	null as "AssociatedLUSTID",
	null as "LastInspectionDate"
from facility f 
	left join businesstype b on f.businesstype = b."BusinessType"
	left join v_ust_element_mapping ot on ot.state_value = b."Name" and ot.state = 'OR' and ot.element_name = 'OwerType'
	left join owners_and_permittees_locations loc on f.facilityid = loc.facilityid
	left join (select distinct facilityid, firstname, lastname, phone, street, city, state, zip from owners_and_permittees where affiltypecd = 'OWN') o on f.facilityid = o.facilityid --owners
	left join (select distinct facilityid, firstname, lastname, phone, street, city, state, zip from owners_and_permittees where affiltypecd = 'PMT') p on f.facilityid = p.facilityid --operators
	left join (select distinct facilityid, epa_value from financialresponsibility a 
					join financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and c.state = 'OR' and c.element_name = 'FinancialResponsibilityGuarantee') frg on f.facilityid  = frg.facilityid 
	left join (select distinct facilityid, epa_value from financialresponsibility a 
					join financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and c.state = 'OR' and c.element_name = 'FinancialResponsibilityLetterOfCredit') frlc on f.facilityid  = frlc.facilityid 					
	left join (select distinct facilityid, epa_value from financialresponsibility a 
					join financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and c.state = 'OR' and c.element_name = 'FinancialResponsibilityLocalGovernmentFinancialTest') frlg on f.facilityid  = frlg.facilityid 	
	left join (select distinct facilityid, epa_value from financialresponsibility a 
					join financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and c.state = 'OR' and c.element_name = 'FinancialResponsibilitySelfInsuranceFinancialTest') frsi on f.facilityid  = frsi.facilityid 		
	left join (select distinct facilityid, epa_value from financialresponsibility a 
					join financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and c.state = 'OR' and c.element_name = 'FinancialResponsibilitySuretyBond') frsb on f.facilityid  = frsb.facilityid 		
	left join (select distinct facilityid, epa_value from financialresponsibility a 
					join financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and c.state = 'OR' and c.element_name = 'FinancialResponsibilityTrustFund') frtf on f.facilityid  = frtf.facilityid 		
	left join (select distinct facilityid, epa_value from financialresponsibility a 
					join financialresponsibilitytype b on a.financialresponsibilitytypeid = b.financialresponsibilitytypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
					and c.state = 'OR' and c.element_name = 'FinancialResponsibilityOtherMethod') fro on f.facilityid  = fro.facilityid 		
	left join (select distinct facilityid from financialresponsibility) fr on f.facilityid = fr.facilityid 
	left join tank t on f.facilityid = t.facilityid
	left join (select tankstatustypeid, epa_value from tankstatustype a join v_ust_element_mapping b 
	               on a."Name" = b.state_value and b.state = 'OR' and b.element_name = 'TankStatus') ts on t.tankstatustypeid = ts.tankstatustypeid
	left join (select distinct tankid, epa_value from tankconstruction a 
					join constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'MultipleTanks') mt on t.tankid = mt.tankid			
	left join (select distinct tankid, epa_value from tanksubstance a 
					join substancetype b on a.substancetypeid = b.substancetypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'TankSubstanceStored') tsub on t.tankid = tsub.tankid			
	left join (select distinct tankid, epa_value from tankconstruction a 
					join constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'LinedTank') lt on t.tankid = lt.tankid			
	left join (select distinct tankid, epa_value from tankconstruction a 
					join constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'ExcavationLiner') el on t.tankid = el.tankid			
	left join (select distinct tankid, epa_value from tankconstruction a 
					join constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'TankWallType') wt on t.tankid = wt.tankid			
	left join (select distinct tankid, epa_value from tankconstruction a 
					join constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'MaterialDescription') md 
						on t.tankid = md.tankid			
	left join (select distinct tankid, epa_value from tankconstruction a 
					join constructiontype b on a.constructiontypeid = b.constructiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'PipingMaterialDescription') pmd 
						on t.tankid = pmd.tankid			
	left join (select distinct tankid, epa_value from tankpipingtype a 
					join pipingtype b on a.pipingtypeid = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value and c.state = 'OR' and c.element_name = 'PipingStyle'
				where isactive = b'1') ps on t.tankid = ps.tankid			
	left join corrosionprotectiontype cpt on cpt."CorrosionProtectionType" = t.corrosionprotectiontypeid --TankCorrosionProtectionSacrificialAnode, TankCorrosionProtectionImpressedCurrent 
	left join overfilldevicetype odt on t.overfilldevicetypeid = odt.overfilldevicetypeid --BallFloatValve, FlowShutoffDevice, HighLevelAlarm
	left join (select distinct spilldevicetypeid, epa_value from spilldevicetype a 
					join v_ust_element_mapping b on a."Name" = b.state_value and b.state = 'OR' and b.element_name = 'SpillBucketInstalled') sb 
						on t.spilldevicetypeid = sb.spilldevicetypeid
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'AutomaticTankGauging' and c.state_value = 'Automatic tank gauging') atg on t.tankid = atg.tankid
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'ManualTankGauging' and c.state_value = 'Manual tank gauging') mtg on t.tankid = mtg.tankid	
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'StatisticalInventoryReconciliation' and c.state_value = 'SIR') sir on t.tankid = sir.tankid	
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'TankTightnessTesting' and c.state_value = 'Tank tightness testing') tt on t.tankid = tt.tankid	
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'GroundwaterMonitoring' and c.state_value = 'Groundwater monitoring') gw on t.tankid = gw.tankid	
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'VaporMonitoring' and c.state_value = 'Vapor monitoring') vm on t.tankid = vm.tankid
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'ElectronicLineLeak' and c.state_value = 'Electronic') ell on t.tankid = ell.tankid	
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'MechanicalLineLeak' and c.state_value = 'Mechanical') mll on t.tankid = mll.tankid
	left join (select distinct tankid, epa_value from tankreleasedetection a 
					join releasedetectiontype b on a.releasedetectiontypeid = b.releasedetectiontypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'AutomatedIntersticialMonitoring' and c.state_value = 'Interstitial Monitoring') im on t.tankid = im.tankid
	left join (select distinct tankid, epa_value from tankpipingtype a 
					join pipingtype b on a.pipingtypeid  = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'SafeSuction' and c.state_value = '"Safe Suction" (no valve at tank)') ss on t.tankid = ss.tankid
	left join (select distinct tankid, epa_value from tankpipingtype a 
					join pipingtype b on a.pipingtypeid  = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'AmericanSuction' and c.state_value = '"U.S. Suction" (valve at tank)') us on t.tankid = us.tankid			
	left join (select distinct tankid, epa_value from tankpipingtype a 
					join pipingtype b on a.pipingtypeid  = b.pipingtypeid 
					join v_ust_element_mapping c on b."Name" = c.state_value 
				and c.state = 'OR' and c.element_name = 'HighPressure' and c.state_value = 'Pressure') hp on t.tankid = hp.tankid	
	left join tankstatustype tst on t.tankstatustypeid = tst.tankstatustypeid 
where tst."Name" not in ('Unregulated','Change in Service')
order by f.facilityid, t.tankid;



