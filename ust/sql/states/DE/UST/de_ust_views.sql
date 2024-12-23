create or replace view de_ust.v_ust_facility
as select distinct x."FacilityID" as facility_id,
	x."FacilityName" as facility_name,
	ot.owner_type_id,
	ft.facility_type_id as facility_type1,
	x."FacilityAddress1" as facility_address1,
	x."FacilityAddress2" as facility_address2,
	x."FacilityCity" as facility_city,
	x."FacilityCounty" as facility_county,
	x."FacilityZipCode" as facility_zip_code,
	s.facility_state,
	x."FacilityEPARegion"::int4 as facility_epa_region,
	x."FacilityLatitude" as facility_latitude,
	x."FacilityLongitude" as facility_longitude,
	cs.coordinate_source_id,
	x."FacilityOwnerCompanyName" as facility_owner_company_name,
	x."FacilityOperatorCompanyName" as facility_operator_company_name,
	case 
		when x."FinancialResponsibilityObtained" = 'Yes' then 'Yes'
		when x."FinancialResponsibilityObtained" = 'No' then 'No'
		else 'Unknown'
	end as financial_responsibility_obtained,
	case
		when x."FinancialResponsibilityBondRatingTest" = 'YES' then 'Yes'
		else 'No'
	end as financial_responsibility_bond_rating_test,
	case 
		when x."FinancialResponsibilityCommercialInsurance" = 'YES' then 'Yes'
		else 'No'
	end as financial_responsibility_commercial_insurance,
	case 
		when x."FinancialResponsibilityGuarantee" = 'YES' then 'Yes'
		else 'No'
	end as financial_responsibility_guarantee,
	case 
		when x."FinancialResponsibilityLetterOfCredit" = 'YES' then 'Yes'
		else 'No'
	end as financial_responsibility_letter_of_credit,
	case 
		when x."FinancialResponsibilityLocalGovernmentFinancialTest" = 'YES' then 'Yes'
		else 'No'
	end as financial_responsibility_local_government_financial_test,
	case 
		when x."FinancialResponsibilitySelfInsuranceFinancialTest" = 'YES' then 'Yes' 
		else 'No'
	end as financial_responsibility_self_insurance_financial_test,
	case 
		when x."FinancialResponsibilityStateFund" = 'Yes' then 'Yes'
		else 'No'
	end as financial_responsibility_state_fund,
	case 
		when x."FinancialResponsibilitySuretyBond" = 'YES' then 'Yes'
		else 'No'
	end as financial_responsibility_surety_bond,
	case 
		when x."FinancialResponsibilityTrustFund" = 'YES' then 'Yes'
		else 'No'
	end as financial_responsibility_trust_fund,
	case 
		when x."USTReportedRelease" = 'Yes' then 'Yes'
		else 'Unknown'
	end as ust_reported_release,
	x."AssociatedLUSTID" as associated_ust_release_id
from de_ust.facility x
	left join de_ust.v_owner_type_xwalk ot on x."OwnerType" = ot.organization_value::text
	left join de_ust.v_facility_type_xwalk ft on x."FacilityType1" = ft.organization_value::text
	left join de_ust.v_state_xwalk s on x."FacilityState" = s.organization_value::text
	left join de_ust.v_coordinate_source_xwalk cs on x."FacilityCoordinateSource" = cs.organization_value::text
where x."FacilityID" is not null 
	and x."FacilityState" is not null;
	
create or replace view de_ust.v_ust_tank as 
select distinct on (x."TankID") 
    x."FacilityID" as facility_id,
    x."TankID"::int4 as tank_id,
    x."TankName" as tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" as federally_regulated,
    x."FieldConstructed" as field_constructed,
    x."EmergencyGenerator" as emergency_generator,
    x."AirportHydrantSystem" as airport_hydrant_system,
    x."MultipleTanks" as multiple_tanks,
    x."TankClosureDate"::date as tank_closure_date,
    x."TankInstallationDate"::date as tank_installation_date,
    x."CompartmentalizedUST" as compartmentalized_ust,
    x."NumberOfCompartments"::int4 as number_of_compartments,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificialAnode" as tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" as tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" as tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" as tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" as tank_corrosion_protection_other,
    x."TankCorrosionProtectionUnknown" as tank_corrosion_protection_unknown,
    sc.tank_secondary_containment_id
from de_ust.tank x
left join de_ust.v_tank_location_xwalk tl on x."TankLocation" = tl.organization_value::text
left join de_ust.v_tank_status_xwalk ts on x."TankStatus" = ts.organization_value::text
left join de_ust.v_tank_material_description_xwalk tm on x."TankMaterialDescription" = tm.organization_value::text
left join de_ust.v_tank_secondary_containment_xwalk sc on x."TankSecondaryContainment" = sc.organization_value::text
order by x."TankID", 
         coalesce(x."TankClosureDate", '1970-01-01') desc, 
         coalesce(x."TankInstallationDate", '1970-01-01') desc;

create or replace view de_ust.v_ust_tank_substance
as select distinct x."FacilityID" as facility_id,
	x."TankID"::int4 as tank_id,
	s.substance_id,
	x."CompartmentSubstanceCASNO" as substance_casno
from de_ust.compartment x
	left join de_ust.v_substance_xwalk s on x."CompartmentSubstanceStored" = s.organization_value::text
where s.substance_id is not null;
	
create or replace view de_ust.v_ust_compartment
as select distinct x."FacilityID" as facility_id,
	x."TankID"::int4 as tank_id,
	case
		when x."CompartmentID"::int4 is null then 28718::int4
		else x."CompartmentID"::int4
	end as compartment_id,
	x."CompartmentName" as compartment_name,
	cs.compartment_status_id,
	x."CompartmentCapacityGallons"::int4 as compartment_capacity_gallons,
	case 
		when x."OverfillPreventionOther" = 'Yes' then 'Yes'
		when x."OverfillPreventionOther" = 'No' then 'No'
		else 'Unknown'
	end as overfill_prevention_other,
	x."OverfillPreventionUnknown" as overfill_prevention_unknown,
	x."OverfillPreventionNotRequired" as overfill_prevention_not_required,
	case 
		when x."SpillBucketInstalled" = 'Yes' then 'Yes'
		else 'No'
	end as spill_bucket_installed,
	x."SpillPreventionNotRequired" as spill_prevention_not_required,
	x."TankInterstitialMonitoring" as tank_interstitial_monitoring,
	x."TankAutomaticTankGaugingReleaseDetection" as tank_automatic_tank_gauging_release_detection,
	x."AutomaticTankGaugingContinuousLeakDetection" as automatic_tank_gauging_continuous_leak_detection,
	x."TankManualTankGauging" as tank_manual_tank_gauging,
	x."TankStatisticalInventoryReconciliation" as tank_statistical_inventory_reconciliation,
	x."TankTightnessTesting" as tank_tightness_testing,
	x."TankInventoryControl" as tank_inventory_control,
	x."TankGroundwaterMonitoring" as tank_groundwater_monitoring,
	x."TankVaporMonitoring" as tank_vapor_monitoring,
	x."TankSubpartKTightnessTesting" as tank_subpart_k_tightness_testing,
	x."TankSubpartKOther" as tank_subpart_k_other,
	x."TankOtherReleaseDetection" as tank_other_release_detection
from de_ust.compartment x
	left join de_ust.v_compartment_status_xwalk cs on x."CompartmentStatus" = cs.organization_value::text;
	
create or replace view de_ust.v_ust_compartment_substance
as select distinct x."FacilityID" as facility_id,
	x."TankID"::int4 as tank_id,
	x."CompartmentID"::int4 as compartment_id,
	s.substance_id
from de_ust.compartment x
	left join de_ust.v_substance_xwalk s on x."CompartmentSubstanceStored" = s.organization_value::text
where substance_id is not null;

create or replace view de_ust.v_ust_piping
as select distinct x."FacilityID" as facility_id,
	x."TankID"::int4 as tank_id,
	x."CompartmentID"::int4 as compartment_id,
	t.piping_id::text,
	ps.piping_style_id,
	x."SafeSuction" as safe_suction,
	x."AmericanSuction" as american_suction,
	x."HighPressureOrBulkPiping" as high_pressure_or_bulk_piping,
	x."PipingMaterialFRP" as piping_material_frp,
	x."PipingMaterialGalSteel" as piping_material_gal_steel,
	x."PipingMaterialStainlessSteel" as piping_material_stainless_steel,
	x."PipingMaterialSteel" as piping_material_steel,
	x."PipingMaterialCopper" as piping_material_copper,
	x."PipingMaterialFlex" as piping_material_flex,
	x."PipingMaterialNoPiping" as piping_material_no_piping,
	x."PipingMaterialOther" as piping_material_other,
	x."PipingMaterialUnknown" as piping_material_unknown,
	x."PipingCorrosionProtectionSacrificialAnode" as piping_corrosion_protection_sacrificial_anode,
	x."PipingCorrosionProtectionImpressedCurrent" as piping_corrosion_protection_impressed_current,
	x."PipingCorrosionProtectionCathodicNotRequired" as piping_corrosion_protection_cathodic_not_required,
	x."PipingCorrosionProtectionOther" as piping_corrosion_protection_other,
	x."PipingCorrosionProtectionUnknown" as piping_corrosion_protection_unknown,
	x."PipingLineLeakDetector" as piping_line_leak_detector,
	x."PipingAutomatedIntersticialMonitoring" as piping_automated_intersticial_monitoring,
	x."PipingLineTestAnnual" as piping_line_test_annual,
	x."PipingGroundwaterMonitoring" as piping_groundwater_monitoring,
	x."PipingVaporMonitoring" as piping_vapor_monitoring,
	x."PipingInterstitialMonitoring" as piping_interstitial_monitoring,
	x."PipingStatisticalInventoryReconciliation" as piping_statistical_inventory_reconciliation,
	x."PipingReleaseDetectionOther" as piping_release_detection_other,
	x."PipingSubpartKLineTest" as piping_subpart_k_line_test,
	x."PipingSubpartKOther" as piping_subpart_k_other,
	x."PipeTankTopSump" as pipe_tank_top_sump,
	wt.piping_wall_type_id,
	x."PipeSecondaryContainmentOther" as pipe_secondary_containment_other,
	x."PipeSecondaryContainmentUnknown" as pipe_secondary_containment_unknown
from de_ust.piping x
	JOIN de_ust.erg_piping_id t ON x."FacilityID"::character varying(50)::text = t.facility_id::text AND x."TankID"::character varying(50)::text = t.tank_id::text and x."CompartmentID"::text = t.compartment_id::text
	left join de_ust.v_piping_style_xwalk ps on x."PipingStyle" = ps.organization_value::text
	left join de_ust.v_piping_wall_type_xwalk wt on x."PipingWallType" = wt.organization_value::text;