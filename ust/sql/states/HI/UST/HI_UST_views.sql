-- Facility

CREATE OR REPLACE VIEW hi_ust.v_ust_facility
AS SELECT DISTINCT x."FacilityID"::character varying(50) AS facility_id,
    x."FacilityName"::character varying(100) AS facility_name,
    ft.facility_type_id AS facility_type1,
    ot.owner_type_id as owner_type_id,
    x."FacilityAddress1"::character varying(100) AS facility_address1,
    x."FacilityAddress2"::character varying(100) as facility_address2,
    x."FacilityCity"::character varying(100) AS facility_city,
    x."FacilityCounty"::character varying(50) as facility_county,
    x."FacilityZipCode"::character varying(10) AS facility_zip_code,
    'HI'::text AS facility_state,
    9 AS facility_epa_region,
    x."LatitudeMeasure" AS facility_latitude,
    x."LongitudeMeasure" AS facility_longitude,
    x."HorizontalCollectionMethodName"::character varying(100) as coordinate_source_id,
    x."FacilityOwnerCompanyName"::character varying(100) AS facility_owner_company_name,
    x."AssociatedLUSTID"::character varying(50) as associated_ust_release_id,
        CASE
            when x."FinancialResponsibilityObtained" = 'Not Listed'::text then 'Unknown'::text
            when x."FinancialResponsibilityObtained" = 'Exempt, Stage Agency'::text then 'No'::text
            when x."FinancialResponsibilityObtained" = '/'::text then null::text
            when x."FinancialResponsibilityObtained" is null then null
            else 'Yes'::text
        END AS financial_responsibility_obtained,
    	case
    		when x."FinancialResponsibilityObtained" = 'commercial insurance'::text then 'Yes'::text
    		when x."FinancialResponsibilityObtained" = 'Insurance'::text then 'Yes'::text
    		when x."FinancialResponsibilityObtained" = 'nsurance'::text then 'Yes'::text
    	end as financial_responsibility_commercial_insurance,
    	case
    		when x."FinancialResponsibilityObtained" = 'Guarantee'::text then 'Yes'::text
    	end as financial_responsibility_guarantee,
    	case
    		when x."FinancialResponsibilityObtained" = 'Letter of Credit'::text then 'Yes'::text
    	end as financial_responsibility_letter_of_credit,
    	case
    		when x."FinancialResponsibilityObtained" like 'Local Gov_t Bond Rating'::text then 'Yes'::text
    	end as financial_responsibility_local_government_financial_test,
    	case
    		when x."FinancialResponsibilityObtained" = 'Other'::text then 'Yes'::text
    	end as financial_responsibility_other_method,
    	case
    		when x."FinancialResponsibilityObtained" = 'Risk Retention Group'::text then 'Yes'::text
    	end as financial_responsibility_risk_retention_group,
    	case 
    		when x."FinancialResponsibilityObtained" = 'Self Insured'::text then 'Yes'::text 
    	end as financial_responsibility_self_insurance_financial_test,
    	case 
    		when x."FinancialResponsibilityObtained" = 'State Fund'::text then 'Yes'::text 
    	end as financial_responsibility_state_fund,
    	case 
    		when x."FinancialResponsibilityObtained" = 'Surety Bond'::text then 'Yes'::text 
    	end as financial_responsibility_surety_bond,
    	case 
    		when x."FinancialResponsibilityObtained" = 'Trust Fund'::text then 'Yes'::text 
    	end as financial_responsibility_trust_fund
   FROM hi_ust.facility x
     LEFT JOIN hi_ust.v_facility_type_xwalk ft ON x."FacilityType1" = ft.organization_value::text
     left join hi_ust.v_owner_type_xwalk ot on x."OwnerType" = ot.organization_value::text;

-- Tank

CREATE OR REPLACE VIEW hi_ust.v_ust_tank
AS SELECT DISTINCT x."FacilityID"::character varying(50) AS facility_id,
    t.tank_id,
    x."TankID"::character varying(50) AS tank_name,
    	case
    		when x."EmergencyGenerator" = TRUE then 'Yes'::text
    		when x."EmergencyGenerator" = FALSE then 'No'::text
    		else null::text
    	end as emergency_generator,
    	case
    		when x."MultipleTanks" = TRUE then 'Yes'::text
    		when x."MultipleTanks" = FALSE then 'No'::text
    		else null::text
    	end as multiple_tanks,
    	case 
    		when x."TankCorrosionProtectionCathodicNotRequired" = TRUE then 'Yes'::text 
    		when x."TankCorrosionProtectionCathodicNotRequired" = FALSE then 'No'::text
    		else null::text
    	end as tank_corrosion_protection_cathodic_not_required,
    	case 
    		when x."TankCorrosionProtectionInteriorLining" = TRUE then 'Yes'::text 
    		when x."TankCorrosionProtectionInteriorLining" = FALSE then 'No'::text
    		else null::text
    	end as tank_corrosion_protection_interior_lining,
   	ts.tank_status_id,
    	case
    		when x."FederallyRegulated" = TRUE then 'Yes'::text 
    		when x."FederallyRegulated" = FALSE then 'No'::text
    		else null::text
    	end as federally_regulated,
    	case
    		when x."FieldConstructed" = 'true'::text then 'Yes'::text
    		else null::text
    	end as field_constructed,
    	case 
    		when x."AirportHydrantSystem" is not null then 'Yes'::text 
    		else null::text
    	end as airport_hydrant_system,
   	x."TankClosureDate"::date as tank_closure_date,
   	x."TankInstallationDate"::date as tank_installation_date,
    	case 
    		when x."CompartmentalizedUST" = TRUE then 'Yes'::text
    		when x."CompartmentalizedUST" = FALSE then 'No'::text 
    		else null::text
    	end as compartmentalized_ust,
   	tmd.tank_material_description_id,
    	case 
    		when x."TankCorrosionProtectionSacrificialAnode" = TRUE then 'Yes'::text 
    		when x."TankCorrosionProtectionSacrificialAnode" = FALSE then 'No'::text 
    		else null::text
    	end as tank_corrosion_protection_sacrificial_anode,
    	case
    		when x."TankCorrosionProtectionImpressedCurrent" = TRUE then 'Yes'::text 
    		when x."TankCorrosionProtectionImpressedCurrent" = FALSE then 'No'::text
    		else null::text
    	end as tank_corrosion_protection_impressed_current,
	tsc.tank_secondary_containment_id
	FROM hi_ust.tank x
		JOIN hi_ust.erg_tank_id t ON x."FacilityID"::character varying(50)::text = t.facility_id::text AND x."TankID"::character varying(50)::text = t.tank_name::text
     	left join hi_ust.v_tank_status_xwalk ts on x."TankStatus" = ts.organization_value::text
     	left join hi_ust.v_tank_material_description_xwalk tmd on x."TankMaterialDescription" = tmd.organization_value::text
     	left join hi_ust.v_tank_secondary_containment_xwalk tsc on x."TankSecondaryContainment" = tsc.organization_value::text;

-- Compartment

CREATE OR REPLACE VIEW hi_ust.v_ust_compartment
AS SELECT DISTINCT x."FacilityID"::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
    cx.compartment_status_id,
    x."TankID"::character varying(50) as tank_name,
    	case 
    		when x."OverfillPreventionBallFloatValve" = true then 'Yes'::text
    		when x."OverfillPreventionBallFloatValve" = false then 'No'::text
    		else null::text
    	end as overfill_prevention_ball_float_valve,
    	case
    		when x."TankInterstitialMonitoring" = true then 'Yes'::text 
    		when x."TankInterstitialMonitoring" = false then 'No'::text 
    		else null::text
    	end as tank_interstitial_monitoring,
    	case
    		when x."TankManualTankGauging" = true then 'Yes'::text 
    		when x."TankManualTankGauging" = false then 'No'::text 
    		else null::text
    	end as tank_manual_tank_gauging,
    	case 
    		when x."TankStatisticalInventoryReconciliation" = true then 'Yes'::text 
    		when x."TankStatisticalInventoryReconciliation" = false then 'No'::text 
    		else null::text
    	end as tank_statistical_inventory_reconciliation,
    	case 
    		when x."OverfillPreventionFlowShutoffDevice" = true then 'Yes'::text 
    		when x."OverfillPreventionFlowShutoffDevice" = false then 'No'::text 
    		else null::text
    	end as overfill_prevention_flow_shutoff_device,
    	case 
    		when x."OverfillPreventionHighLevelAlarm" = true then 'Yes'::text 
    		when x."OverfillPreventionHighLevelAlarm" = false then 'No'::text 
    		else null::text
    	end as overfill_prevention_high_level_alarm,
    	case
    		when x."SpillBucketInstalled" = true then 'Yes'::text 
    		when x."SpillBucketInstalled" = false then 'No'::text 
    		else null::text
    	end as spill_bucket_installed,
    	case 
    		when x."TankAutomaticTankGaugingReleaseDetection" = true then 'Yes'::text
    		when x."TankAutomaticTankGaugingReleaseDetection" = false then 'No'::text 
    		else null::text
    	end as tank_automatic_tank_gauging_release_detection,
    	case
    		when x."TankTightnessTesting" = true then 'Yes'::text 
    		when x."TankTightnessTesting" = false then 'No'::text 
    		else null::text
    	end as tank_tightness_testing,
    	case
    		when x."TankInventoryControl" = true then 'Yes'::text 
    		when x."TankInventoryControl" = false then 'No'::text 
    		else null::text
    	end as tank_inventory_control,
    	case 
    		when x."TankGroundwaterMonitoring" = true then 'Yes'::text 
    		when x."TankGroundwaterMonitoring" = false then 'No'::text 
    		else null::text
    	end as tank_groundwater_monitoring,
    	case 
    		when x."TankVaporMonitoring" = true then 'Yes'::text 
    		when x."TankVaporMonitoring" = false then 'No'::text 
    		else null::text
    	end as tank_vapor_monitoring,
    	case 
    		when x."TankOtherReleaseDetection" = true then 'Yes'::text 
    		when x."TankOtherReleaseDetection" = false then 'No'::text 
    		else null::text
    	end as tank_other_release_detection
   FROM hi_ust.compartment x
     JOIN hi_ust.erg_compartment_id t ON x."FacilityID"::character varying(50)::text = t.facility_id::text AND x."TankID"::character varying(50)::text = t.tank_name::text
     join hi_ust.tank ut on x."FacilityID"::character varying(50)::text = ut."FacilityID"::text
     LEFT JOIN hi_ust.v_compartment_status_xwalk cx ON ut."TankStatus" = cx.organization_value::text;

-- Piping

CREATE OR REPLACE VIEW hi_ust.v_ust_piping
AS SELECT DISTINCT x."FacilityID"::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
    t.piping_id::character varying(50) AS piping_id,
    x."TankID"::character varying(50) as tank_name,
    ps.piping_style_id,
        case
        	when x."PipingCorrosionProtectionSacrificialAnode" = true then 'Yes'::text 
        	when x."PipingCorrosionProtectionSacrificialAnode" = false then 'No'::text 
        	else null::text 
        end as piping_corrosion_protection_sacrificial_anode,
        case 
        	when x."PipingReleaseDetectionOther" = true then 'Yes'::text 
        	when x."PipingReleaseDetectionOther" = false then 'No'::text 
        	else null::text
        end as piping_release_detection_other,
        case
        	when x."PipingStatisticalInventoryReconciliation" = true then 'Yes'::text 
        	when x."PipingStatisticalInventoryReconciliation" = false then 'No'::text 
        	else null::text
        end as piping_statistical_inventory_reconciliation,
        case
        	when x."PipingCorrosionProtectionImpressedCurrent" = true then 'Yes'::text 
        	when x."PipingCorrosionProtectionImpressedCurrent" = false then 'No'::text
        	else null::text
        end as piping_corrosion_protection_impressed_current,
        case 
        	when x."PipingLineLeakDetector" = true then 'Yes'::text 
        	when x."PipingLineLeakDetector" = false then 'No'::text 
        	else null::text
        end as piping_line_leak_detector,
        case
        	when x."PipingLineTestAnnual" = true then 'Yes'::text 
        	when x."PipingLineTestAnnual" = false then 'No'::text 
        	else null::text
        end as piping_line_test_annual,
        case 
        	when x."PipingGroundwaterMonitoring" = true then 'Yes'::text 
        	when x."PipingGroundwaterMonitoring" = false then 'No'::text
        	else null::text
        end as piping_groundwater_monitoring,
        case 
        	when x."PipingVaporMonitoring" = true then 'Yes'::text 
        	when x."PipingVaporMonitoring" = false then 'No'::text 
        	else null::text
        end as piping_vapor_monitoring
   FROM hi_ust.piping x
     JOIN hi_ust.erg_piping_id t ON x."FacilityID"::character varying(50)::text = t.facility_id::text AND x."TankID"::character varying(50)::text = t.tank_name::text
     LEFT JOIN hi_ust.v_piping_style_xwalk ps ON x."PipingStyle" = ps.organization_value::text;

-- Facility Dispenser

create or replace view hi_ust.v_ust_facility_dispenser as
select distinct
     "FacilityID"::character varying(50) as facility_id,
    case 
	    when a."DispenserID" is not null then a."DispenserID"::text
    	else b.dispenser_id::text
    end as dispenser_id, 
    case 
	     when "UDCInstalled" = True then 'Yes' 
	     when "UDCInstalled" = False then 'No' 
	end as dispenser_udc   -- when UDCInstalled = TRUE then Yes, when UDCInstalled = FALSE then N
from hi_ust.dispenser a
     left join hi_ust.erg_dispenser_id b on a."FacilityID" = b.facility_id;
