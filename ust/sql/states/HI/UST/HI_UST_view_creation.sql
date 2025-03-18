----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_facility_dispenser as
select distinct
    "DispenserID"::character varying(50) as dispenser_id, 
      !!! "UDCInstalled"::character varying(7) as dispenser_udc   -- when UDCInstalled = TRUE then Yes, when UDCInstalled = FALSE then N
from hi_ust."dispenser" a
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_facility as
select distinct
    "FacilityID"::character varying(50) as facility_id, 
    "FacilityName"::character varying(100) as facility_name, 
    owner_type_id as owner_type_id, 
    facility_type_id as facility_type1, 
    "FacilityAddress1"::character varying(100) as facility_address1, 
    "FacilityAddress2"::character varying(100) as facility_address2, 
    "FacilityCity"::character varying(100) as facility_city, 
    "FacilityCounty"::character varying(100) as facility_county, 
    "FacilityZipCode"::character varying(10) as facility_zip_code, 
      !!! facility_state as facility_state,   -- when
    9::integer as facility_epa_region,
    "LatitudeMeasure"::double precision as facility_latitude, 
    "LongitudeMeasure"::double precision as facility_longitude, 
    coordinate_source_id as coordinate_source_id, 
    "FacilityOwnerCompanyName"::character varying(100) as facility_owner_company_name, 
      !!! "FinancialResponsibilityObtained"::character varying(7) as financial_responsibility_obtained,   -- when FinancialResponsibilityObtained = "Not Listed" then "Unknown"  -- when FinancialResponsibilityObtained = "Exempt, Stage Agency" then "No"  -- when FinancialResponsibilityObtained = "/" then null  -- when FinancialResponsibilityObtained is not null then "Yes
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_commercial_insurance,   -- when FinancialResponsibilityObtained = "commercial insurance" then "Yes"  -- when FinancialResponsibilityObtained = "Insurance" then "Yes"  -- when FinancialResponsibilityObtained = "nsurance" then "Yes"  -- when FinancialResponsibilityObtained is not "commercial insurance" and not "Insurance" and not "nsurance" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_guarantee,   -- when FinancialResponsibilityObtained = "Guarantee" then "Yes"  -- when FinancialResponsibilityObtained is not "Guarantee" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_letter_of_credit,   -- when FinancialResponsibilityObtained = "Letter of Credit" then "Yes"  -- when FinancialResponsibilityObtained is not "Letter of Credit" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_local_government_financial_test,   -- when FinancialResponsibilityObtained = "Local Gov"t Bond Rating" then "Yes"  -- when FinancialResponsibilityObtained is not "Local Gov"t Bond Rating" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_risk_retention_group,   -- when FinancialResponsibilityObtained = "Risk Retention Group" then "Yes"  -- when FinancialResponsibilityObtained is not "Risk Retention Group" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_self_insurance_financial_test,   -- when FinancialResponsibilityObtained = "Self Insured" then "Yes"  -- when FinancialResponsibilityObtained is not "Self Insured" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_state_fund,   -- when FinancialResponsibilityObtained = "State Fund" then "Yes"  -- when FinancialResponsibilityObtained is not "State Fund" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_surety_bond,   -- when FinancialResponsibilityObtained = "Surety Bond" then "Yes"  -- when FinancialResponsibilityObtained is not "Surety Bond" then "No
      !!! "FinancialResponsibilityObtained"::character varying(3) as financial_responsibility_trust_fund,   -- when FinancialResponsibilityObtained = "Trust Fund" then "Yes"  -- when FinancialResponsibilityObtained is not "Trust Fund" then "No
      !!! "FinancialResponsibilityObtained"::character varying(500) as financial_responsibility_other_method,   -- when FinancialResponsibilityObtained = "Other" then "Yes"  -- when FinancialResponsibilityObtained is not "Other" then "No
    "AssociatedLUSTID"::character varying(40) as associated_ust_release_id 
from hi_ust."facility" a
    left join hi_ust.v_coordinate_source_xwalk b on a."HorizontalCollectionMethodName" = b.organization_value
    left join hi_ust.v_facility_type_xwalk c on a."FacilityType1" = c.organization_value
    left join hi_ust.v_owner_type_xwalk d on a."OwnerType" = d.organization_value
    left join hi_ust.v_state_xwalk e on a."FacilityState" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_tank as
select distinct
    "tank_id"::integer as tank_id, 
    "TankID"::character varying(50) as tank_name, 
    tank_status_id as tank_status_id, 
      !!! "FederallyRegulated"::character varying(7) as federally_regulated,   -- when FederallyRegulated = TRUE then Yes, when FederallyRegulated = FALSE then N
      !!! "FieldConstructed"::character varying(7) as field_constructed,   -- when FieldConstructed = TRUE then Yes, when FieldConstructed = "" then N
      !!! "EmergencyGenerator"::character varying(7) as emergency_generator,   -- when EmergencyGenerator = TRUE then Yes, when EmergencyGenerator = FALSE then N
      !!! "AirportHydrantSystem"::character varying(7) as airport_hydrant_system,   -- when AirportHydrantSystem = 1.0 then Yes, when AirportHydrantSystem = "" then N
      !!! "MultipleTanks"::character varying(7) as multiple_tanks,   -- when MultipleTanks = TRUE then Yes, when MultipleTanks = FALSE then N
    "TankClosureDate"::date as tank_closure_date, 
    "TankInstallationDate"::date as tank_installation_date, 
      !!! "CompartmentalizedUST"::character varying(7) as compartmentalized_ust,   -- when CompartmentalizedUST = TRUE then Yes, when CompartmentalizedUST = FALSE then N
    tank_material_description_id as tank_material_description_id, 
      !!! "TankCorrosionProtectionSacrificialAnode"::character varying(7) as tank_corrosion_protection_sacrificial_anode,   -- when TankCorrosionProtectionSacrificialAnode = TRUE then Yes, when TankCorrosionProtectionSacrificialAnode = FALSE then N
      !!! "TankCorrosionProtectionImpressedCurrent"::character varying(7) as tank_corrosion_protection_impressed_current,   -- when TankCorrosionProtectionImpressedCurrent = TRUE then Yes, when TankCorrosionProtectionImpressedCurrent = FALSE then N
      !!! "TankCorrosionProtectionCathodicNotRequired"::character varying(7) as tank_corrosion_protection_cathodic_not_required,   -- when TankCorrosionProtectionCathodicNotRequired = TRUE then Yes, when TankCorrosionProtectionCathodicNotRequired = FALSE then N
      !!! "TankCorrosionProtectionInteriorLining"::character varying(7) as tank_corrosion_protection_interior_lining,   -- when TankCorrosionProtectionInteriorLining = TRUE then Yes, when TankCorrosionProtectionInteriorLining = FALSE then N
    tank_secondary_containment_id as tank_secondary_containment_id 
from hi_ust."tank" a
    left join hi_ust."erg_tank_id" b on a."FacilityID" = b."facility_id" and a."TankID" = b."tank_name" 
    left join hi_ust.v_tank_material_description_xwalk c on a."TankMaterialDescription" = c.organization_value
    left join hi_ust.v_tank_secondary_containment_xwalk d on a."TankSecondaryContainment" = d.organization_value
    left join hi_ust.v_tank_status_xwalk e on a."TankStatus" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_compartment as
select distinct
    "compartment_id"::integer as compartment_id, 
    compartment_status_id as compartment_status_id, 
      !!! "OverfillPreventionBallFloatValve"::character varying(7) as overfill_prevention_ball_float_valve,   -- when OverfillPreventionBallFloatValve = TRUE then Yes, when OverfillPreventionBallFloatValve = FALSE then N
      !!! "OverfillPreventionFlowShutoffDevice"::character varying(7) as overfill_prevention_flow_shutoff_device,   -- when OverfillPreventionFlowShutoffDevice = TRUE then Yes, when OverfillPreventionFlowShutoffDevice = FALSE then N
      !!! "OverfillPreventionHighLevelAlarm"::character varying(7) as overfill_prevention_high_level_alarm,   -- when OverfillPreventionHighLevelAlarm = TRUE then Yes, when OverfillPreventionHighLevelAlarm = FALSE then N
      !!! "SpillBucketInstalled"::character varying(3) as spill_bucket_installed,   -- when SpillBucketInstalled = TRUE then Yes, when SpillBucketInstalled = FALSE then N
      !!! "TankInterstitialMonitoring"::character varying(7) as tank_interstitial_monitoring,   -- when TankInterstitialMonitoring = TRUE then Yes, when TankInterstitialMonitoring = FALSE then N
      !!! "TankAutomaticTankGaugingReleaseDetection"::character varying(7) as tank_automatic_tank_gauging_release_detection,   -- when TankAutomaticTankGaugingReleaseDetection = TRUE then Yes, when TankAutomaticTankGaugingReleaseDetection = FALSE then N
      !!! "TankManualTankGauging"::character varying(7) as tank_manual_tank_gauging,   -- when TankManualTankGauging = TRUE then Yes, when TankManualTankGauging = FALSE then N
      !!! "TankStatisticalInventoryReconciliation"::character varying(7) as tank_statistical_inventory_reconciliation,   -- when TankStatisticalInventoryReconciliation = TRUE then Yes, when TankStatisticalInventoryReconciliation = FALSE then N
      !!! "TankTightnessTesting"::character varying(7) as tank_tightness_testing,   -- when TankTightnessTesting = TRUE then Yes, when TankTightnessTesting = FALSE then N
      !!! "TankInventoryControl"::character varying(7) as tank_inventory_control,   -- when TankInventoryControl = TRUE then Yes, when TankInventoryControl = FALSE then N
      !!! "TankGroundwaterMonitoring"::character varying(7) as tank_groundwater_monitoring,   -- when TankGroundwaterMonitoring = TRUE then Yes, when TankGroundwaterMonitoring = FALSE then N
      !!! "TankVaporMonitoring"::character varying(7) as tank_vapor_monitoring,   -- when TankVaporMonitoring = TRUE then Yes, when TankVaporMonitoring = FALSE then N
      !!! "TankOtherReleaseDetection"::character varying(7) as tank_other_release_detection   -- when TankOtherReleaseDetection = TRUE then Yes, when TankOtherReleaseDetection = FALSE then N
from hi_ust."compartment" a
    left join hi_ust."erg_compartment_id" b on a."facility_id" = b."facility_id" and a."tank_id" = b."tank_id" 
    left join hi_ust.v_compartment_status_xwalk c on a."TankStatus" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_piping as
select distinct
    "piping_id"::character varying(50) as piping_id, 
    piping_style_id as piping_style_id, 
      !!! "PipingCorrosionProtectionSacrificialAnode"::character varying(7) as piping_corrosion_protection_sacrificial_anode,   -- when PipingCorrosionProtectionSacrificialAnode = TRUE then Yes, when PipingCorrosionProtectionSacrificialAnode = FALSE then N
      !!! "PipingCorrosionProtectionImpressedCurrent"::character varying(7) as piping_corrosion_protection_impressed_current,   -- when PipingCorrosionProtectionImpressedCurrent = TRUE then Yes, when PipingCorrosionProtectionImpressedCurrent = FALSE then N
      !!! "PipingLineLeakDetector"::character varying(7) as piping_line_leak_detector,   -- when PipingLineLeakDetector = TRUE then Yes, when PipingLineLeakDetector = FALSE then N
      !!! "PipingLineTestAnnual"::character varying(7) as piping_line_test_annual,   -- when PipingLineTestAnnual = TRUE then Yes, when PipingLineTestAnnual = FALSE then N
      !!! "PipingGroundwaterMonitoring"::character varying(7) as piping_groundwater_monitoring,   -- when PipingGroundwaterMonitoring = TRUE then Yes, when PipingGroundwaterMonitoring = FALSE then N
      !!! "PipingVaporMonitoring"::character varying(7) as piping_vapor_monitoring,   -- when PipingVaporMonitoring = TRUE then Yes, when PipingVaporMonitoring = FALSE then N
      !!! "PipingStatisticalInventoryReconciliation"::character varying(7) as piping_statistical_inventory_reconciliation,   -- when PipingStatisticalInventoryReconciliation = TRUE then Yes, when PipingStatisticalInventoryReconciliation = FALSE then N
      !!! "PipingReleaseDetectionOther"::character varying(7) as piping_release_detection_other   -- when PipingReleaseDetectionOther = TRUE then Yes, when PipingReleaseDetectionOther = FALSE then N
from hi_ust."piping" a
    left join hi_ust."erg_piping_id" b on a."facility_id" = b."facility_id" and a."tank_id" = b."tank_id" and a."compartment_id" = b."compartment_id" 
    left join hi_ust.v_piping_style_xwalk c on a."PipingStyle" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_facility_dispenser as
select distinct
      !!! "DispenserID"::character varying(50) as dispenser_id,   -- case when a."DispenserID" is not null then a."DispenserID"::character varying(50)  --     else b.dispenser_id end as dispenser_id
      !!! "UDCInstalled"::character varying(7) as dispenser_udc   -- when UDCInstalled = TRUE then Yes, when UDCInstalled = FALSE then N
from hi_ust."dispenser" a
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_tank as
select distinct
    "tank_id"::integer as tank_id, 
    "TankID"::character varying(50) as tank_name, 
    tank_status_id as tank_status_id, 
      !!! "FederallyRegulated"::character varying(7) as federally_regulated,   -- when FederallyRegulated = TRUE then Yes, when FederallyRegulated = FALSE then N
      !!! "FieldConstructed"::character varying(7) as field_constructed,   -- when FieldConstructed = TRUE then Yes, when FieldConstructed = "" then N
      !!! "EmergencyGenerator"::character varying(7) as emergency_generator,   -- when EmergencyGenerator = TRUE then Yes, when EmergencyGenerator = FALSE then N
      !!! "AirportHydrantSystem"::character varying(7) as airport_hydrant_system,   -- when AirportHydrantSystem = 1.0 then Yes, when AirportHydrantSystem = "" then N
      !!! "MultipleTanks"::character varying(7) as multiple_tanks,   -- when MultipleTanks = TRUE then Yes, when MultipleTanks = FALSE then N
    "TankClosureDate"::date as tank_closure_date, 
    "TankInstallationDate"::date as tank_installation_date, 
      !!! "CompartmentalizedUST"::character varying(7) as compartmentalized_ust,   -- when CompartmentalizedUST = TRUE then Yes, when CompartmentalizedUST = FALSE then N
    tank_material_description_id as tank_material_description_id, 
      !!! "TankCorrosionProtectionSacrificialAnode"::character varying(7) as tank_corrosion_protection_sacrificial_anode,   -- when TankCorrosionProtectionSacrificialAnode = TRUE then Yes, when TankCorrosionProtectionSacrificialAnode = FALSE then N
      !!! "TankCorrosionProtectionImpressedCurrent"::character varying(7) as tank_corrosion_protection_impressed_current,   -- when TankCorrosionProtectionImpressedCurrent = TRUE then Yes, when TankCorrosionProtectionImpressedCurrent = FALSE then N
      !!! "TankCorrosionProtectionCathodicNotRequired"::character varying(7) as tank_corrosion_protection_cathodic_not_required,   -- when TankCorrosionProtectionCathodicNotRequired = TRUE then Yes, when TankCorrosionProtectionCathodicNotRequired = FALSE then N
      !!! "TankCorrosionProtectionInteriorLining"::character varying(7) as tank_corrosion_protection_interior_lining,   -- when TankCorrosionProtectionInteriorLining = TRUE then Yes, when TankCorrosionProtectionInteriorLining = FALSE then N
    tank_secondary_containment_id as tank_secondary_containment_id 
from hi_ust."tank" a
    left join hi_ust."erg_tank_id" b on a."FacilityID" = b."facility_id" and a."TankID" = b."tank_name" 
    left join hi_ust.v_tank_material_description_xwalk c on a."TankMaterialDescription" = c.organization_value
    left join hi_ust.v_tank_secondary_containment_xwalk d on a."TankSecondaryContainment" = d.organization_value
    left join hi_ust.v_tank_status_xwalk e on a."TankStatus" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_tank as
select distinct
    "tank_id"::integer as tank_id, 
    "TankID"::character varying(50) as tank_name, 
    tank_status_id as tank_status_id, 
      !!! "FederallyRegulated"::character varying(7) as federally_regulated,   -- when FederallyRegulated = TRUE then Yes, when FederallyRegulated = FALSE then N
      !!! "FieldConstructed"::character varying(7) as field_constructed,   -- when FieldConstructed = TRUE then Yes, when FieldConstructed = "" then N
      !!! "EmergencyGenerator"::character varying(7) as emergency_generator,   -- when EmergencyGenerator = TRUE then Yes, when EmergencyGenerator = FALSE then N
      !!! "AirportHydrantSystem"::character varying(7) as airport_hydrant_system,   -- when AirportHydrantSystem = 1.0 then Yes, when AirportHydrantSystem = "" then N
      !!! "MultipleTanks"::character varying(7) as multiple_tanks,   -- when MultipleTanks = TRUE then Yes, when MultipleTanks = FALSE then N
    "TankClosureDate"::date as tank_closure_date, 
    "TankInstallationDate"::date as tank_installation_date, 
      !!! "CompartmentalizedUST"::character varying(7) as compartmentalized_ust,   -- when CompartmentalizedUST = TRUE then Yes, when CompartmentalizedUST = FALSE then N
    tank_material_description_id as tank_material_description_id, 
      !!! "TankCorrosionProtectionSacrificialAnode"::character varying(7) as tank_corrosion_protection_sacrificial_anode,   -- when TankCorrosionProtectionSacrificialAnode = TRUE then Yes, when TankCorrosionProtectionSacrificialAnode = FALSE then N
      !!! "TankCorrosionProtectionImpressedCurrent"::character varying(7) as tank_corrosion_protection_impressed_current,   -- when TankCorrosionProtectionImpressedCurrent = TRUE then Yes, when TankCorrosionProtectionImpressedCurrent = FALSE then N
      !!! "TankCorrosionProtectionCathodicNotRequired"::character varying(7) as tank_corrosion_protection_cathodic_not_required,   -- when TankCorrosionProtectionCathodicNotRequired = TRUE then Yes, when TankCorrosionProtectionCathodicNotRequired = FALSE then N
      !!! "TankCorrosionProtectionInteriorLining"::character varying(7) as tank_corrosion_protection_interior_lining,   -- when TankCorrosionProtectionInteriorLining = TRUE then Yes, when TankCorrosionProtectionInteriorLining = FALSE then N
    tank_secondary_containment_id as tank_secondary_containment_id 
from hi_ust."tank" a
    left join hi_ust."erg_tank_id" b on a."FacilityID" = b."facility_id" and a."TankID" = b."tank_name" 
    left join hi_ust.v_tank_material_description_xwalk c on a."TankMaterialDescription" = c.organization_value
    left join hi_ust.v_tank_secondary_containment_xwalk d on a."TankSecondaryContainment" = d.organization_value
    left join hi_ust.v_tank_status_xwalk e on a."TankStatus" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;
