select distinct
	t."ï»¿SiteID" as "FacilityID",
	f."ProgFacName" as "FacilityName",
	null as "OwnerType",
	fac_type.epa_value as "FacilityType1",
	null as "FacilityType2",
	f."Address1" as "FacilityAddress1",
	f."Address2" as "FacilityAddress2",
	f."Locality" as "FacilityCity",
	f."County" as "FacilityCounty",
	f."ZIPCode" as "FacilityZipCode",
	null as "FacilityPhoneNumber",
	'NY' as "FacilityState",
	'2' as "FacilityEPARegion",
	null as "FacilityTribalSite",
	null as "FacilityTribe",
	utm."CONVERTED_LAT" as "FacilityLatitude",
	utm."CONVERTED_LONG" as "FacilityLongitude",
	null as "FacilityCoordinateSource",
	own."Company" as "FacilityOwnerCompanyName",
	own."ContactName" as "FacilityOwnerLastName", --contains first, last, and sometimes company names
	null as "FacilityOwnerFirstName",
	own."address1" as "FacilityOwnerAddress1",
	own."Address2" as "FacilityOwnerAddress2",
	own."City" as "FacilityOwnerCity",
	null as "FacilityOwnerCounty",
	own."ZIPCode" as "FacilityOwnerZipCode",
	own."State" as "FacilityOwnerState",
	own."Phone" as "FacilityOwnerPhoneNumber",
	own."eMail" as "FacilityOwnerEmail",
	oper."Company" as "FacilityOwnerOperatorName",
	oper."ContactName" as "FacilityOperatorLastName", --contains first, last, and sometimes company names
	null as "FacilityOperatorFirstName",
	oper."address1" as "FacilityOperatorAddress1",
	oper."Address2" as "FacilityOperatorAddress2",
	oper."City" as "FacilityOperatorCity",
	null as "FacilityOperatorCounty",
	oper."ZIPCode" as "FacilityOperatorZipCode",
	oper."State" as "FacilityOperatorState",
	oper."Phone" as "FacilityOperatorPhoneNumber",
	oper."eMail" as "FacilityOperatorEmail",
	null as "FinancialResponsibilityBondRatingTest",
	null as "FinancialResponsibilityCommercialInsurance",
	null as "FinancialResponsibilityGuarantee",
	null as "FinancialResponsibilityLetterOfCredit",
	null as "FinancialResponsibilityLocalGovernmentFinancialTest",
	null as "FinancialResponsibilityRiskRetentionGroup",
	null as "FinancialResponsibilitySelfInsuranceFinancialTest",
	null as "FinancialResponsibilityStateFund",
	null as "FinancialResponsibilitySuretyBond",
	null as "FinancialResponsibilityTrustFund",
	null as "FinancialResponsibilityOtherMethod",
	null as "FinancialResponsibilityNotRequired",
	null as "FinancialResponsibilityObtained",
	null as "Compliance",
	t."TankNo" as "TankID", --this is the ID assigned by the owner or operator. Or we can use "TankID" which is computer generated
null as "TankLocation", --"TankLoc" column is a code; metadata refers to lookup table TankLocCodes but doesn't provide the mapping
	null as "FederallyRegulated",
	tank_status.epa_value as "TankStatus",
	null as "FieldConstructed",
	null as "EmergencyGenerator",
	null as "AirportHydrantSystem",
	null as "MultipleTanks",
	t."CloseDate" as "ClosureDate",
	t."InstDate" as "InstallationDate",
	null as "CompartmentalizedUST",
	null as "NumberofCompartments",
	null as "TankSubstanceStored",
	null as "CompartmentID",
	null as "CompartmentSubstanceStored",
	t."CapacGal" as "TankCapacityGallons",
	null as "CompartmentCapacityGallons",
	null as "LinedTank",
	exc.epa_value as "ExcavationLiner",
	exc.epa_value as "TankWallType",
	mat.epa_value as "MaterialDescription", 
	null as "TankRepaired",
	null as "TankRepairDate",
	null as "CertofInstallation",
	pmat.epa_value as "PipingMaterialDescription", 
	null as "PipingFlexConnector",
	null as "PipingStyle",
	null as "PipingWallType",
	case when t."UDC_IND" = 1 then 'Yes' when t."UDC_IND" = 0 then 'No' end as "PipingUDC", 
	null as "PipingRepaired",
	null as "PipingRepairDate",
	null as "TankCorrosionProtectionSacrificialAnode",
	null as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
	tcic.epa_value as "TankCorrosionProtectionImpressedCurrent",
	tcic_ir.epa_value as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
	tcnr.epa_value as "TankCorrosionProtectionCathodicNotRequired",
	tcil.epa_value as "TankCorrosionProtectionInteriorLining",
	tco.epa_value as "TankCorrosionProtectionOther",
	null as "TankCorrosionProtectionUnknown",
	null as "TankCorrosionProtectionLinedPostinstallation",
	sac.epa_value as "PipingCorrosionProtectionSacrificialAnodes",
	sac_ir.epa_value as "PipingCorrosionProtectionAnodesInstalledOrRetrofitted",
	imp.epa_value as "PipingCorrosionProtectionImpressedCurrent",
	imp_ir.epa_value as "PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
	null as "PipingCorrosionProtectionCathodicNotRequired",
	ext.epa_value as "PipingCorrosionProtectionExternalCoating",
	null as "PipingCorrosionProtectionOther",
	null as "PipingCorrosionProtectionUnknown",
	bfv.epa_value as "BallFloatValve",
	fsd.epa_value as "FlowShutoffDevice",
	hla.epa_value as "HighLevelAlarm",
	null as "OverfillProtectionPrimary",
	null as "OverfillProtectionSecondary",
	null as "PrimaryOverfillInstallDate",
	null as "SecondaryOverfillInstallDate",
	sb.epa_value as "SpillBucketInstalled",
	null as "SpillBucketWallType",
	null as "DrainPresent",
	null as "PumpPresent",
	imce.epa_value as "InterstitialMonitoringContinualElectric",
	imm.epa_value as "InterstitialMonitoringManual",
	atg.epa_value as "AutomaticTankGauging",
	null as "AutomaticTankGaugingReleaseDetection",
	null as "AutomaticTankGaugingContinuousLeakDetection",
	null as "ManualTankGauging",
	sir.epa_value as "StatisticalInventoryReconciliation",
	null "TankTightnessTesting", --metadata refers to tightness testing but there is no lookup available for the codes so verify
	gwm.epa_value as "GroundwaterMonitoring",
	null as "SubpartK",
	vm.epa_value as "VaporMonitoring",
	null as "ElectronicLineLeak",
	null as "MechanicalLineLeak",
	null as "AutomatedIntersticialMonitoring",
	null as "SafeSuction",
	null as "AmericanSuction",
	null as "PipingSubpartK",
	hp.epa_value as "HighPressure",
	null as "PrimaryReleaseDetectionType",
	null as "SecondReleaseDetectionType",
	psc.epa_value as "PipeSecondaryContainment",
	null as "PipeInstallDate",
	null as "USTReportedRelease",
	null as "AssociatedLUSTID",
	null as "LastInspectionDate"
from bstank t left join bsfoil f on t."ï»¿SiteID" = f."SiteID" 
	left join (select * from bsaffil where "AffiliationType" = 'Facility Operator') oper on t."ï»¿SiteID" = oper."SiteID" 
	left join (select * from bsaffil where "AffiliationType" = 'Facility Owner') own on t."ï»¿SiteID" = own."SiteID" 
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'NY' and element_name = 'FacilityType1') fac_type
		on f."SiteType" = fac_type.state_value
	left join (select state_value, epa_value from v_ust_element_mapping where state = 'NY' and element_name = 'TankStatus') tank_status
		on t."TankStatus" = tank_status.state_value			
	left join (select distinct "ï»¿SiteID", "tankID", epa_value 
				from bsmat x join v_ust_element_mapping y on x."matname" = y.state_value 
				where state = 'NY' and element_name = 'MaterialDescription') mat
		on t."ï»¿SiteID" = mat."ï»¿SiteID" and t."TankID" = mat."tankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where  state = 'NY' and element_name = 'BallFloatValve' and "Type" = 'Overfill') bfv
		on t."ï»¿SiteID" = bfv."ï»¿siteid" and t."TankID" = bfv."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where  state = 'NY' and element_name = 'FlowShutoffDevice' and "Type" = 'Overfill') fsd
		on t."ï»¿SiteID" = fsd."ï»¿siteid" and t."TankID" = fsd."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where  state = 'NY' and element_name = 'HighLevelAlarm' and "Type" = 'Overfill') hla
		on t."ï»¿SiteID" = hla."ï»¿siteid" and t."TankID" = hla."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'PipingCorrosionProtectionSacrificialAnodes' and "Type" = 'Pipe External Protection') sac
		on t."ï»¿SiteID" = sac."ï»¿siteid" and t."TankID" = sac."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'PipingCorrosionProtectionAnodesInstalledOrRetrofitted' and "Type" = 'Pipe External Protection') sac_ir
		on t."ï»¿SiteID" = sac_ir."ï»¿siteid" and t."TankID" = sac_ir."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'PipingCorrosionProtectionImpressedCurrent' and "Type" = 'Pipe External Protection') imp
		on t."ï»¿SiteID" = imp."ï»¿siteid" and t."TankID" = imp."TankID"		
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted' and "Type" = 'Pipe External Protection') imp_ir
		on t."ï»¿SiteID" = imp_ir."ï»¿siteid" and t."TankID" = imp_ir."TankID"		
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'PipingCorrosionProtectionExternalCoating' and "Type" = 'Pipe External Protection') ext 
		on t."ï»¿SiteID" = ext."ï»¿siteid" and t."TankID" = ext."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'PipingMaterialDescription' and "Type" = 'Pipe Type') pmat 
		on t."ï»¿SiteID" = pmat."ï»¿siteid" and t."TankID" = pmat."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'InterstitialMonitoringContinualElectric' and "Type" = 'Piping Leak Detection') imce 
		on t."ï»¿SiteID" = imce."ï»¿siteid" and t."TankID" = imce."TankID"
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'InterstitialMonitoringManual' and "Type" = 'Piping Leak Detection') imm 
		on t."ï»¿SiteID" = imm."ï»¿siteid" and t."TankID" = imm."TankID"		
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'GroundwaterMonitoring' and "Type" = 'Piping Leak Detection') gwm 
		on t."ï»¿SiteID" = gwm."ï»¿siteid" and t."TankID" = gwm."TankID"	
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'StatisticalInventoryReconciliation' and "Type" = 'Piping Leak Detection') sir 
		on t."ï»¿SiteID" = sir."ï»¿siteid" and t."TankID" = sir."TankID"			
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'VaporMonitoring' and "Type" = 'Piping Leak Detection') vm 
		on t."ï»¿SiteID" = vm."ï»¿siteid" and t."TankID" = vm."TankID"				
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'HighPressure' and "Type" = 'Piping Leak Detection') hp
		on t."ï»¿SiteID" = hp."ï»¿siteid" and t."TankID" = hp."TankID"					
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'PipeSecondaryContainment' and "Type" = 'Piping Secondary Containment') psc
		on t."ï»¿SiteID" = psc."ï»¿siteid" and t."TankID" = psc."TankID"		
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'SpillBucketInstalled' and "Type" = 'Spill Prevention') sb
		on t."ï»¿SiteID" = sb."ï»¿siteid" and t."TankID" = sb."TankID"					
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'TankCorrosionProtectionImpressedCurrent' and "Type" = 'Tank External Protection') tcic
		on t."ï»¿SiteID" = tcic."ï»¿siteid" and t."TankID" = tcic."TankID"				
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted' and "Type" = 'Tank External Protection') tcic_ir
		on t."ï»¿SiteID" = tcic_ir."ï»¿siteid" and t."TankID" = tcic_ir."TankID"				
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'TankCorrosionProtectionInteriorLining' and "Type" = 'Tank External Protection') tcil
		on t."ï»¿SiteID" = tcil."ï»¿siteid"	and t."TankID" = tcil."TankID"			
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'TankCorrosionProtectionOther' and "Type" = 'Tank External Protection') tco
		on t."ï»¿SiteID" = tco."ï»¿siteid" and t."TankID" = tco."TankID"				
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'TankCorrosionProtectionCathodicNotRequired' and "Type" = 'Tank External Protection') tcnr
		on t."ï»¿SiteID" = tcnr."ï»¿siteid"	 and t."TankID" = tcnr."TankID"				
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'AutomaticTankGauging' and "Type" = 'Tank Leak Detection') atg
		on t."ï»¿SiteID" = atg."ï»¿siteid" and t."TankID" = atg."TankID"			
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'ExcavationLiner' and "Type" = 'Tank Secondary Containment') exc
		on t."ï»¿SiteID" = exc."ï»¿siteid"and t."TankID" = exc."TankID"				
	left join (select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where state = 'NY' and element_name = 'TankWallType' and "Type" = 'Tank Secondary Containment') twt
		on t."ï»¿SiteID" = twt."ï»¿siteid" and t."TankID" = twt."TankID"						
	left join (select distinct "ï»¿SiteID", "tankID", epa_value 
				from bsmat x join v_ust_element_mapping y on x."matname" = y.state_value 
				where state = 'NY' and element_name = 'TankSubstanceStored') sub
		on t."ï»¿SiteID" = sub."ï»¿SiteID" and t."TankID" = sub."tankID"	
	left join "NY_converted" utm on t."ï»¿SiteID" = utm."SiteID" 
where "Subpart" = 2 --Subpart 2 contains requirements for USTs (underground storage tanks) subject to EPA UST regulations and DEC requirements.     
and t."TankStatus" <> 'Tank Converted to Non-Regulated Use'  --exclude per Alex
order by t."ï»¿SiteID", t."TankNo";

