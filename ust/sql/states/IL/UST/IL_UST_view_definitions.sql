------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view il_ust.v_ust_facility as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."FacilityName" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    x."FacilityAddress1" AS facility_address1,
    x."FacilityAddress2" AS facility_address2,
    x."FacilityCity" AS facility_city,
    x."FacilityCounty" AS facility_county,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    s.facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    x."FacilityLatitude" AS facility_latitude,
    x."FacilityLongitude" AS facility_longitude,
    cs.coordinate_source_id,
    x."FinancialResponsibilityObtained" AS financial_responsibility_obtained,
    x."FinancialResponsibilityBondRatingTest" AS financial_responsibility_bond_rating_test,
    x."FinancialResponsibilityCommercialInsurance" AS financial_responsibility_commercial_insurance,
    frg."FinancialResponsibilityGuarantee" AS financial_responsibility_guarantee,
    x."FinancialResponsibilityLetterOfCredit" AS financial_responsibility_letter_of_credit,
    x."FinancialResponsibilityLocalGovernmentFinancialTest" AS financial_responsibility_local_government_financial_test,
    x."FinancialResponsibilityRiskRetentionGroup" AS financial_responsibility_risk_retention_group,
    frsift."FinancialResponsibilitySelfInsuranceFinancialTest" AS financial_responsibility_self_insurance_financial_test,
    x."FinancialResponsibilityTrustFund" AS financial_responsibility_trust_fund,
    x."FinancialResponsibilityOtherMethod" AS financial_responsibility_other_method,
    x."USTReportedRelease" AS ust_reported_release,
    x."AssociatedLUSTID" AS associated_ust_release_id
   FROM ((((((il_ust.facility x
     LEFT JOIN ( SELECT x_1."FacilityID",
            x_1."FinancialResponsibilityGuarantee",
            row_number() OVER (PARTITION BY x_1."FacilityID" ORDER BY x_1."FinancialResponsibilityGuarantee" DESC) AS row_num
           FROM il_ust.facility x_1) frg ON (((x."FacilityID" = frg."FacilityID") AND (frg.row_num = 1))))
     LEFT JOIN ( SELECT x_1."FacilityID",
            x_1."FinancialResponsibilitySelfInsuranceFinancialTest",
            row_number() OVER (PARTITION BY x_1."FacilityID" ORDER BY x_1."FinancialResponsibilitySelfInsuranceFinancialTest" DESC) AS row_num
           FROM il_ust.facility x_1) frsift ON (((x."FacilityID" = frsift."FacilityID") AND (frsift.row_num = 1))))
     LEFT JOIN il_ust.v_facility_type_xwalk ft ON ((x."FacilityType2" = (ft.organization_value)::text)))
     LEFT JOIN il_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN il_ust.v_state_xwalk s ON ((x." FacilityState" = (s.organization_value)::text)))
     LEFT JOIN il_ust.v_coordinate_source_xwalk cs ON ((x."FacilityCoordinateSource" = (cs.organization_value)::text)))
  WHERE (NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM il_ust.erg_unregulated_facilities)))
 and x."FacilityID"::varchar(50) not in (select facility_id from il_ust.erg_unregulated_facilities);



create or replace view il_ust.v_ust_tank as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    (x."TankName")::character varying(50) AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."FieldConstructed" AS field_constructed,
    x."EmergencyGenerator" AS emergency_generator,
    x."AirportHydrantSystem" AS airport_hydrant_system,
    x."MultipleTanks" AS multiple_tanks,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificailAnode" AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    tsc.tank_secondary_containment_id,
    coi.cert_of_installation_id
   FROM (((((il_ust.tank x
     LEFT JOIN il_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN il_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN il_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN il_ust.v_tank_secondary_containment_xwalk tsc ON ((x."TankSecondaryContainment" = (tsc.organization_value)::text)))
     LEFT JOIN il_ust.v_cert_of_installation_xwalk coi ON ((x."CertOfInstallation" = (coi.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from il_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view il_ust.v_ust_tank_substance as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."TankID" AS tank_id,
    s.substance_id,
    x."CompartmentSubstanceCASNO" AS substance_casno
   FROM (il_ust.compartment x
     LEFT JOIN il_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankName")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from il_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view il_ust.v_ust_compartment as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankID")::integer AS tank_id,
    (x."CompartmentID")::integer AS compartment_id,
    cs.compartment_status_id,
    (floor(x."CompartmentCapacityGallons"))::integer AS compartment_capacity_gallons,
    x."OverfillPreventionBallFloatValve" AS overfill_prevention_ball_float_valve,
    x."OverfillPreventionFlowShutoffDevice" AS overfill_prevention_flow_shutoff_device,
    x."OverfillPreventionHighLevelAlarm" AS overfill_prevention_high_level_alarm,
    x."OverfillPreventionOther" AS overfill_prevention_other,
    x."OverfillPreventionUnknown" AS overfill_prevention_unknown,
    x."OverfillPreventionNotRequired" AS overfill_prevention_not_required,
    x."SpillBucketInstalled" AS spill_bucket_installed,
    x."SpillPreventionOther" AS spill_prevention_other,
    x."SpillPreventionNotRequired" AS spill_prevention_not_required,
    sbw.spill_bucket_wall_type_id,
    x."TankAutomaticTankGaugingReleaseDetection" AS tank_automatic_tank_gauging_release_detection,
    x."AutomaticTankGaugingContinuousLeakDetection" AS automatic_tank_gauging_continuous_leak_detection,
    x."TankManualTankGauging" AS tank_manual_tank_gauging,
    x."TankStatisticalInventoryReconciliation" AS tank_statistical_inventory_reconciliation,
    x."TankTightnessTesting" AS tank_tightness_testing,
    x."TankInventoryControl" AS tank_inventory_control,
    x."TankGroundwaterMonitoring" AS tank_groundwater_monitoring,
    x."TankVaporMonitoring" AS tank_vapor_monitoring,
    x."TankSubpartKTightnessTesting" AS tank_subpart_k_tightness_testing,
    x."TankSubpartKOther" AS tank_subpart_k_other,
    x."TankOtherReleaseDetection" AS tank_other_release_detection
   FROM ((il_ust.compartment x
     LEFT JOIN il_ust.v_compartment_status_xwalk cs ON ((x."CompartmentStatus" = (cs.organization_value)::text)))
     LEFT JOIN il_ust.v_spill_bucket_wall_type_xwalk sbw ON ((x."SpillBucketWallType" = (sbw.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from il_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view il_ust.v_ust_compartment_substance as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."TankID" AS tank_id,
    x."CompartmentID" AS compartment_id,
    s.substance_id
   FROM (il_ust.compartment x
     LEFT JOIN il_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from il_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view il_ust.v_ust_piping as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."TankID" AS tank_id,
    (x."CompartmentID")::integer AS compartment_id,
    (x."PipingID")::character varying(50) AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."SafeSuction" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."SafeSuction" = 'No'::text) THEN 'No'::text
            ELSE 'Unknown'::text
        END AS safe_suction,
        CASE
            WHEN (x."AmericanSuction" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."AmericanSuction" = 'No'::text) THEN 'No'::text
            ELSE 'Unknown'::text
        END AS american_suction,
    x."HighPressureOrBulkPiping" AS high_pressure_or_bulk_piping,
    x."PipingMaterialFRP" AS piping_material_frp,
    x."PipingMaterialGalSteel" AS piping_material_gal_steel,
    x."PipingMaterialStainlessSteel" AS piping_material_stainless_steel,
    x."PipingMaterialSteel" AS piping_material_steel,
    x."PipingMaterialCopper" AS piping_material_copper,
    x."PipingMaterialFlex" AS piping_material_flex,
    x."PipingMaterialNoPiping" AS piping_material_no_piping,
    x."PipingFlexConnector" AS piping_flex_connector,
    x."PipingCorrosionProtectionSacrificialAnode" AS piping_corrosion_protection_sacrificial_anode,
    x."PipingCorrosionProtectionImpressedCurrent" AS piping_corrosion_protection_impressed_current,
    x."PipingCorrosionProtectionCathodicNotRequired" AS piping_corrosion_protection_cathodic_not_required,
    x."PipingCorrosionProtectionOther" AS piping_corrosion_protection_other,
    x."PipingCorrosionProtectionUnknown" AS piping_corrosion_protection_unknown,
    x."PipingLineLeakDetector" AS piping_line_leak_detector,
    x."PipingAutomatedIntersticialMonitoring" AS piping_automated_intersticial_monitoring,
    x."PipingLineTestAnnual" AS piping_line_test_annual,
    x."PipingLineTest3yr" AS piping_line_test3yr,
    x."PipingGroundwaterMonitoring" AS piping_groundwater_monitoring,
    x."PipingVaporMonitoring" AS piping_vapor_monitoring,
    x."PipingInterstitialMonitoring" AS piping_interstitial_monitoring,
    x."PipingSubpartKLineTest" AS piping_subpart_k_line_test,
    x."PipingSubpartKOther" AS piping_subpart_k_other,
    x."PipeTankTopSump" AS pipe_tank_top_sump,
    tt.pipe_tank_top_sump_wall_type_id,
    wt.piping_wall_type_id,
    x."PipeSecondaryContainmentOther" AS pipe_secondary_containment_other
   FROM (((il_ust.piping x
     LEFT JOIN il_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
     LEFT JOIN il_ust.v_pipe_tank_top_sump_wall_type_xwalk tt ON ((x."PipeTankTopSumpWallType" = (tt.organization_value)::text)))
     LEFT JOIN il_ust.v_piping_wall_type_xwalk wt ON ((x."PipingWallType" = (wt.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankName")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from il_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view il_ust.v_ust_facility_dispenser as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."DispenserID" AS dispenser_id,
    x."DispenserUDC" AS dispenser_udc
   FROM il_ust.facility_dispenser x
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE (((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text))))
 and x."FacilityID"::varchar(50) not in (select facility_id from il_ust.erg_unregulated_facilities);