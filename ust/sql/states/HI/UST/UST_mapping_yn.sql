update ust_element_mapping
set query_logic = 'when OverfillPreventionBallFloatValve = TRUE then Yes, when OverfillPreventionBallFloatValve = FALSE then No'
where ust_element_mapping_id = 1392;

update ust_element_mapping
set query_logic = 'when OverfillPreventionFlowShutoffDevice = TRUE then Yes, when OverfillPreventionFlowShutoffDevice = FALSE then No'
where ust_element_mapping_id = 1393;

update ust_element_mapping
set query_logic = 'when OverfillPreventionHighLevelAlarm = TRUE then Yes, when OverfillPreventionHighLevelAlarm = FALSE then No'
where ust_element_mapping_id = 1394;

update ust_element_mapping
set query_logic = 'when SpillBucketInstalled = TRUE then Yes, when SpillBucketInstalled = FALSE then No'
where ust_element_mapping_id = 1395;

update ust_element_mapping
set query_logic = 'when TankAutomaticTankGaugingReleaseDetection = TRUE then Yes, when TankAutomaticTankGaugingReleaseDetection = FALSE then No'
where ust_element_mapping_id = 1397;

update ust_element_mapping
set query_logic = 'when TankGroundwaterMonitoring = TRUE then Yes, when TankGroundwaterMonitoring = FALSE then No'
where ust_element_mapping_id = 1402;

update ust_element_mapping
set query_logic = 'when TankInterstitialMonitoring = TRUE then Yes, when TankInterstitialMonitoring = FALSE then No'
where ust_element_mapping_id = 1396;

update ust_element_mapping
set query_logic = 'when TankInventoryControl = TRUE then Yes, when TankInventoryControl = FALSE then No'
where ust_element_mapping_id = 1401;

update ust_element_mapping
set query_logic = 'when TankManualTankGauging = TRUE then Yes, when TankManualTankGauging = FALSE then No'
where ust_element_mapping_id = 1398;

update ust_element_mapping
set query_logic = 'when TankOtherReleaseDetection = TRUE then Yes, when TankOtherReleaseDetection = FALSE then No'
where ust_element_mapping_id = 1404;

update ust_element_mapping
set query_logic = 'when TankStatisticalInventoryReconciliation = TRUE then Yes, when TankStatisticalInventoryReconciliation = FALSE then No'
where ust_element_mapping_id = 1399;

update ust_element_mapping
set query_logic = 'when TankTightnessTesting = TRUE then Yes, when TankTightnessTesting = FALSE then No'
where ust_element_mapping_id = 1400;

update ust_element_mapping
set query_logic = 'when TankVaporMonitoring = TRUE then Yes, when TankVaporMonitoring = FALSE then No'
where ust_element_mapping_id = 1403;

update ust_element_mapping
set query_logic = 'when UDCInstalled = TRUE then Yes, when UDCInstalled = FALSE then No'
where ust_element_mapping_id = 1419;

update ust_element_mapping
set query_logic = 'when FinancialResponsibilityObtained = "commercial insurance" then Yes, 
when FinancialResponsibilityObtained = "Guarantee" then Yes,
when FinancialResponsibilityObtained = "Insurance" then Yes,
when FinancialResponsibilityObtained = "Letter of Credit" then Yes,
when FinancialResponsibilityObtained = "Local  Bond Rating" then Yes,
when FinancialResponsibilityObtained = "nsurance" then Yes,
when FinancialResponsibilityObtained = "Other" then Yes,
when FinancialResponsibilityObtained = "Risk Retention Group" then Yes,
when FinancialResponsibilityObtained = "Self Insured" then Yes,
when FinancialResponsibilityObtained = "Exempt, Stage Agency" then No,
when FinancialResponsibilityObtained = "Not Listed" then Unknown'
where ust_element_mapping_id = 1370;

update ust_element_mapping
set query_logic = 'when PipingCorrosionProtectionImpressedCurrent = TRUE then Yes, when PipingCorrosionProtectionImpressedCurrent = FALSE then No'
where ust_element_mapping_id = 1409;

update ust_element_mapping
set query_logic = 'when PipingCorrosionProtectionSacrificialAnode = TRUE then Yes, when PipingCorrosionProtectionSacrificialAnode = FALSE then No'
where ust_element_mapping_id = 1408;

update ust_element_mapping
set query_logic = 'when PipingGroundwaterMonitoring = TRUE then Yes, when PipingGroundwaterMonitoring = FALSE then No'
where ust_element_mapping_id = 1412;

update ust_element_mapping
set query_logic = 'when PipingLineLeakDetector = TRUE then Yes, when PipingLineLeakDetector = FALSE then No'
where ust_element_mapping_id = 1410;

update ust_element_mapping
set query_logic = 'when PipingLineTestAnnual = TRUE then Yes, when PipingLineTestAnnual = FALSE then No'
where ust_element_mapping_id = 1411;

update ust_element_mapping
set query_logic = 'when PipingReleaseDetectionOther = TRUE then Yes, when PipingReleaseDetectionOther = FALSE then No'
where ust_element_mapping_id = 1415;

update ust_element_mapping
set query_logic = 'when PipingStatisticalInventoryReconciliation = TRUE then Yes, when PipingStatisticalInventoryReconciliation = FALSE then No'
where ust_element_mapping_id = 1414;

update ust_element_mapping
set query_logic = 'when PipingVaporMonitoring = TRUE then Yes, when PipingVaporMonitoring = FALSE then No'
where ust_element_mapping_id = 1413;

update ust_element_mapping
set query_logic = 'when AirportHydrantSystem = 1.0 then Yes, when AirportHydrantSystem = "" then No'
where ust_element_mapping_id = 1378;

update ust_element_mapping
set query_logic = 'when CompartmentalizedUST = TRUE then Yes, when CompartmentalizedUST = FALSE then No'
where ust_element_mapping_id = 1382;

update ust_element_mapping
set query_logic = 'when EmergencyGenerator = TRUE then Yes, when EmergencyGenerator = FALSE then No'
where ust_element_mapping_id = 1377;

update ust_element_mapping
set query_logic = 'when FederallyRegulated = TRUE then Yes, when FederallyRegulated = FALSE then No'
where ust_element_mapping_id = 1375;

update ust_element_mapping
set query_logic = 'when FieldConstructed = TRUE then Yes, when FieldConstructed = "" then No'
where ust_element_mapping_id = 1376;

update ust_element_mapping
set query_logic = 'when MultipleTanks = TRUE then Yes, when MultipleTanks = FALSE then No'
where ust_element_mapping_id = 1379;

update ust_element_mapping
set query_logic = 'when TankCorrosionProtectionCathodicNotRequired = TRUE then Yes, when TankCorrosionProtectionCathodicNotRequired = FALSE then No'
where ust_element_mapping_id = 1386;

update ust_element_mapping
set query_logic = 'when TankCorrosionProtectionImpressedCurrent = TRUE then Yes, when TankCorrosionProtectionImpressedCurrent = FALSE then No'
where ust_element_mapping_id = 1385;

update ust_element_mapping
set query_logic = 'when TankCorrosionProtectionInteriorLining = TRUE then Yes, when TankCorrosionProtectionInteriorLining = FALSE then No'
where ust_element_mapping_id = 1387;

update ust_element_mapping
set query_logic = 'when TankCorrosionProtectionSacrificialAnode = TRUE then Yes, when TankCorrosionProtectionSacrificialAnode = FALSE then No'
where ust_element_mapping_id = 1384;
