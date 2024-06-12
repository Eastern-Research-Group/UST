SELECT 
 g.FacilityID as FacilityID,
 g.name as FacilityName,
 CASE WHEN fed.ownerid IS NOT NULL THEN 'Federal Government - Non Military'
      WHEN state.ownerid IS NOT NULL THEN 'State Government - Non Military'
      WHEN localg.ownerid IS NOT NULL THEN 'Local Government'
 	  WHEN commercial.ownerid IS NOT NULL THEN 'Commercial'
 	  WHEN private.ownerid IS NOT NULL THEN 'Private' END as OwnerType,
 null as FacilityType1,
 null as FacilityType2,
 g.address as FacilityAddress1,
 g.address2 as FacilityAddress2,
 g.zip as FacilityZipCode,
 c.countyname as FacilityCounty,
 f.facareacode || f.facphoneprefix || f.facphonesuffix as FacilityPhoneNumber,
 'MO' as FacilityState,
 '7' as FacilityEPARegion,
 null as FacilityTribalSite,
 null as FacilityTribe,
 ll.converted_lat as FacilityLatitude, 
 ll.converted_long as FacilityLongitude, 
 null as FacilityCoordinateSource,
 o.name as FacilityOwnerCompanyName, --this appears to sometimes be a first/last name but it's only one field and can't programmatically know which are person's names and which company names
 null as FacilityOwnerLastName, 
 null as FacilityOwnerFirstName,
 o.address as FacilityOwnerAddress1,
 o.address2 as FacilityOwnerAddress2,
 o.city as FacilityOwnerCity,
 o.county as FacilityOwnerCounty,
 o.zip as FacilityOwnerZipCode,
 o.state as FacilityOwnerState,
 o.areacode || o.phoneprefix || o.phonesuffix as FacilityOwnerPhoneNumber,
 o.ow_email as FacilityOwnerEmail,
 f.contact as FacilityOperatorName,
 null as FacilityOperatorLastName, 
 null as FacilityOperatorFirstName,
 null as FacilityOperatorAddress1,
 null as FacilityOperatorAddress2,
 null as FacilityOperatorCity,
 null as FacilityOperatorCounty,
 null as FacilityOperatorZipCode,
 null as FacilityOperatorState,
 f.contactareacode || f.contactphoneprefix || f.contactphonesuffix as FacilityOperatorPhoneNumber, 
 f.emailaddress1 as FacilityOperatorEmail, 
 null as FinancialResponsibilityBondRatingTest,
 null as FinancialResponsibilityCommercialInsurance,
 null as FinancialResponsibilityGuarantee,
 null as FinancialResponsibilityLetterOfCredit,
 null as FinancialResponsibilityLocalGovernmentFinancialTest,
 null as FinancialResponsibilityRiskRetentionGroup,
 null as FinancialResponsibilitySelfInsuranceFinancialTest,
 null as FinancialResponsibilityStateFund,
 null as FinancialResponsibilitySuretyBond,
 null as FinancialResponsibilityTrustFund,
 null as FinancialResponsibilityOtherMethod,
 null as FinancialResponsibilityNotRequired,
 null as FinancialResponsibilityObtained, 
 null as Compliance, 
 t.tankid as TankID,
 case when t.TankType = 'A' then '' -- EPA values are Aboveground (tank bottom  abovegrade), Aboveground (tank bottom on-grade), and Partially Buried
      when t.TankType = 'B' then 'Underground (entirely buried)' end as TankLocation,
 null as FederallyRegulated,
 tc.COMPARTMENTNO  as CompartmentID,
 CASE WHEN t.status IN ('C','N') THEN 'Currently in use'
      WHEN t.status = 'P' THEN 'Closed (in place)' 
      WHEN t.status = 'R' THEN 'Closed (removed from ground)' 
      WHEN t.status = 'S' THEN 'Closed (general)' --CHANGE IN service
      WHEN t.status = 'T' THEN 'Closed (general)' END as TankStatus, --OUT OF use
 null as FieldConstructed,
 null as EmergencyGenerator,
 null as AirportHydrantSystem,
 null as ManifoldedTanks,
 null as MultipleTanks,
 t.dateclosed as ClosureDate,
 t.TANKINSTALLATIONDATE  as InstallationDate,
 CASE WHEN tn.numcompartments > 1 THEN 'Yes' ELSE 'No' end as CompartmentalizedUST,
 tn.numcompartments as NumberofCompartments,
 null as TankSubstanceStored,
 CASE WHEN tc.SUBSTANCE = 'E' THEN 'E-85/Flex Fuel (E51-E83)'
      WHEN tc.substance = 'Y' THEN '95% renewable diesel, 5% biodiesel'
      WHEN tc.substance = 'A' THEN 'Aviation gasoline'
      WHEN tc.substance = 'D' THEN 'Diesel fuel (b-unknown)'
      WHEN tc.substance = 'F' THEN 'Gasoline (non-ethanol)'
      WHEN tc.substance IN ('U','M','P','R') THEN 'Gasoline (unknown type)'
      WHEN tc.substance = 'C' THEN 'Gasoline E-15 (E-11-E15)'
      WHEN tc.substance = 'B' THEN 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol' --E98/ Ethanol; mapping IS probably wrong
      WHEN tc.substance = 'T' THEN 'Hazardous substance'
      WHEN tc.substance = 'J' THEN 'Jet fuel'
      WHEN tc.substance = 'K' THEN 'Kerosene'
      WHEN tc.substance = 'N' THEN 'Lube/motor oil (new)'
      WHEN tc.substance = 'G' THEN 'Off-road diesel/dyed diesel'
      WHEN tc.substance = 'O' THEN 'Other'
      WHEN tc.substance = 'V' THEN 'Petroleum products'
      WHEN tc.substance = 'W' THEN 'Used oil/waste oil'
      WHEN tc.substance = 'Z' THEN 'Unknown'
      END as CompartmentSubstanceStored,
 null as TankCapacityGallons,
 tc.capacity as CompartmentCapacityGallons,
 null as LinedTank,
 null as ExcavationLiner,
 CASE WHEN t.tankdoublewall = -1 THEN 'Double' 
      WHEN t.tankdoublewall = 0 THEN 'Single' END as TankWallType, 
 CASE WHEN t.TANKMATERIAL = 0 THEN 'Unknown'
      WHEN t.TANKMATERIAL = 1 THEN 'Asphalt coated or bare steel' 
      WHEN t.TANKMATERIAL = 2 THEN 'Composite/clad (steel w/fiberglass reinforced plastic)' 
      WHEN t.TANKMATERIAL = 3 THEN 'Fiberglass reinforced plastic' 
      WHEN t.TANKMATERIAL = 4 THEN 'Other' end as MaterialDescription,
 null as TankRepaired,
 null as TankRepairDate,
 CASE WHEN tc.PIPEMATERIAL = 3 THEN 'Copper'
 	  WHEN tc.PIPEMATERIAL = 2 THEN 'Fiberglass Reinforced Plastic'
 	  WHEN tc.PIPEMATERIAL IN (6,7,8,10,11) THEN 'Flex Piping'
 	  WHEN tc.PIPEMATERIAL = 5 THEN 'No Piping'
 	  WHEN tc.PIPEMATERIAL in (4,9) THEN 'Other'
 	  WHEN tc.PIPEMATERIAL = 1 THEN 'Steel'
 	  WHEN tc.PIPEMATERIAL = 0 THEN 'Unknown'
 	  WHEN tc.PIPEMATERIAL = 12 THEN '' --???
 	END as PipingMaterialDescription,
 null as PipingFlexConnector,
 CASE WHEN tc.PIPESYSTEM IN (0,2,3) THEN 'Suction'
 	  WHEN tc.PIPESYSTEM  = 1 THEN 'Pressure'
 	  WHEN tc.PIPESYSTEM  = 4 THEN 'Non-operational ( e.g., fill line, vent line, gravity)'
 	  WHEN tc.PIPESYSTEM  = 8 THEN '' --Manifold
 	 end as PipingStyle,
 CASE WHEN tc.pipedoublewall = -1 THEN 'Double'
      WHEN tc.pipedoublewall = 0 THEN 'Single' END as PipingWallType, 
 null as PipingUDCForEveryDispenser,
 null as PipingRepaired,
 null as PipingRepairDate,
 CASE WHEN t.TANKEXTERNALPROTECTION = 2 THEN 'Yes' END as TankCorrosionProtectionSacrificialAnode,
 CASE WHEN t.TANKEXTERNALPROTECTION = 2 THEN 'Unknown' END as TankCorrosionProtectionAnodesInstalledOrRetrofitted,
 CASE WHEN t.TANKEXTERNALPROTECTION = 1 THEN 'Yes' END as TankCorrosionProtectionImpressedCurrent,
 CASE WHEN t.TANKEXTERNALPROTECTION = 1 THEN 'Unknown' END as TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted,
 null as TankCorrosionProtectionCathodicNotRequired, 
 null as TankCorrosionProtectionInteriorLining,
 null as TankCorrosionProtectionOther,
 null as TankCorrosionProtectionUnknown,
 null as TankCorrosionProtectionLinedPostinstallation,
 CASE WHEN tc.PIPEPROTECTION = 2 THEN 'Yes' end as PipingCorrosionProtectionSacrificialAnodes,
 CASE WHEN tc.PIPEPROTECTION = 2 THEN 'Unknown' end as PipingCorrosionProtectionAnodesInstalledOrRetrofitted,
 CASE WHEN tc.PIPEPROTECTION = 1 THEN 'Yes' end as PipingCorrosionProtectionImpressedCurrent,
 CASE WHEN tc.PIPEPROTECTION = 1 THEN 'Unknown' end as PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted,
 CASE WHEN tc.PIPEPROTECTION = 6 THEN 'Yes' end as PipingCorrosionProtectionCathodicNotRequired, 
 null as PipingCorrosionProtectionExternalCoating,
 null as PipingCorrosionProtectionOther,
 null as PipingCorrosionProtectionUnknown,  
 CASE WHEN ballvalve.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as BallFloatValve,
 CASE WHEN autoshutoff.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as FlowShutoffDevice,
 CASE WHEN alarm.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as HighLevelAlarm,
 null as OverfillProtectionPrimary,
 null as OverfillProtectionSecondary,
 null as PrimaryOverfillInstallDate,
 null as SecondaryOverfillInstallDate,
 CASE WHEN tc.spillprotection = -1 THEN 'Yes' 
      WHEN tc.spillprotection = 0 THEN 'No' END as SpillBucketInstalled, 
 null as SpillBucketWallType,
 null as DrainPresent,
 null as PumpPresent,
 null as InterstitialMonitoringContinualElectric,
 null as InterstitialMonitoringManual,
 CASE WHEN atg.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as AutomaticTankGauging,
 CASE WHEN atg.TANKCOMPARTMENTPK IS NOT NULL THEN 'Unknown' end as AutomaticTankGaugingReleaseDetection,
 CASE WHEN atg.TANKCOMPARTMENTPK IS NOT NULL THEN 'Unknown' end as AutomaticTankGaugingContinuousLeakDetection,
 CASE WHEN mtg.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as ManualTankGauging,
 CASE WHEN sir.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as StatisticalInventoryReconciliation,
 CASE WHEN tt.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as TankTightnessTesting,
 CASE WHEN gw.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as GroundwaterMonitoring,
 null as SubpartK,
 CASE WHEN vapor.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as VaporMonitoring,
 CASE WHEN elld.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as ElectronicLineLeak,
 CASE WHEN alld.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as MechanicalLineLeak,
 CASE WHEN atm.TANKCOMPARTMENTPK IS NOT NULL THEN 'Yes' end as AutomatedIntersticialMonitoring,
 null as SafeSuction,
 null as AmericanSafeSuction,
 null as PipingSubpartK,
 null as HighPressure,
 null as PrimaryReleaseDetectionType, 
 null as SecondReleaseDetectionType,
 null as PipeSecondaryContainment,
 null as PipeInstallDate,
 CASE WHEN rem.FACILITYID IS NOT NULL THEN 'Yes' end as USTReportedRelease,
 rem.remid as AssociatedLUSTID,
 null as LastInspectionDate
FROM tblFacility f LEFT JOIN tblFacilityLookup fl ON f.facilityid = fl.facilityid 
LEFT JOIN tblOwner o ON fl.ownerid = o.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'H') commercial ON o.ownerid = commercial.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'F') fed ON o.ownerid = fed.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass IN ('C','L','O','Z')) localg ON o.ownerid = localg.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass IN ('M','N','P')) private ON o.ownerid = private.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'S') state ON o.ownerid = state.ownerid
LEFT JOIN tblGeoSite g ON f.FACILITYID  = g.FACILITYID  
LEFT JOIN tblGeoSite_LatLong ll ON f.FACILITYID = ll.FACILITYID
LEFT JOIN tblcounty c ON g.county = c.COUNTYCODE 
LEFT JOIN tblTank t ON f.facilityid = t.facilityid
LEFT JOIN tblTankByCompartment tc ON t.tankpk = tc.tankpk 
LEFT JOIN (SELECT TANKPK, COUNT(*) as NUMCOMPARTMENTS FROM tblTankByCompartment GROUP BY TANKPK) TN 
	ON t.tankpk = tn.tankpk
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 1) autoshutoff 
	ON tc.TANKCOMPARTMENTPK = autoshutoff.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 2) ballvalve 
	ON tc.TANKCOMPARTMENTPK = ballvalve.TANKCOMPARTMENTPK	
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 3) alarm 
	ON tc.TANKCOMPARTMENTPK = alarm.TANKCOMPARTMENTPK	
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 5) interstitial 
	ON tc.TANKCOMPARTMENTPK = interstitial.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 1) atg  
	ON tc.TANKCOMPARTMENTPK = atg.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 3) mtg  
	ON tc.TANKCOMPARTMENTPK = mtg.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 6) sir 
	ON tc.TANKCOMPARTMENTPK = sir.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 2) tt 
	ON tc.TANKCOMPARTMENTPK = tt.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 8) gw 
	ON tc.TANKCOMPARTMENTPK = gw.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 7) vapor 
	ON tc.TANKCOMPARTMENTPK = vapor.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 1) elld
	ON tc.TANKCOMPARTMENTPK = elld.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE ELECTRONICORMECHANICALLLD = 2) alld
	ON tc.TANKCOMPARTMENTPK = alld.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 3) atm
	ON tc.TANKCOMPARTMENTPK = atm.TANKCOMPARTMENTPK
LEFT JOIN (SELECT FACILITYID, max(remid) remid FROM tblRemediation GROUP BY FACILITYID) rem
	ON f.FACILITYID = rem.FACILITYID
WHERE ownerinactivewfacility = 0;
