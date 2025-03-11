------------------------------------------------------------------------------------------------------------------------



/*********** v_ust_tank ***********/
--There are 71154 rows in il_ust.v_ust_tank that do not exist in public.v_ust_tank

select * from il_ust.v_ust_tank a
where not exists
	(select 1 from public.v_ust_tank b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID")
order by a.facility_id,a.tank_id;

--View definition for il_ust.v_ust_tank:
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
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_tank_substance ***********/
--There are 71154 rows in il_ust.v_ust_tank_substance that do not exist in public.v_ust_tank_substance

select * from il_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;

--View definition for il_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."TankID" AS tank_id,
    s.substance_id,
    x."CompartmentSubstanceCASNO" AS substance_casno
   FROM (il_ust.compartment x
     LEFT JOIN il_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_compartment ***********/
--There are 71154 rows in il_ust.v_ust_compartment that do not exist in public.v_ust_compartment

select * from il_ust.v_ust_compartment a
where not exists
	(select 1 from public.v_ust_compartment b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID")
order by a.facility_id,a.tank_id,a.compartment_id;

--View definition for il_ust.v_ust_compartment:
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
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_compartment_substance ***********/
--There are 71154 rows in il_ust.v_ust_compartment_substance that do not exist in public.v_ust_compartment_substance

select * from il_ust.v_ust_compartment_substance a
where not exists
	(select 1 from public.v_ust_compartment_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.compartment_id,a.substance_id;

--View definition for il_ust.v_ust_compartment_substance:
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."TankID" AS tank_id,
    x."CompartmentID" AS compartment_id,
    s.substance_id
   FROM (il_ust.compartment x
     LEFT JOIN il_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_piping ***********/
--There are 71154 rows in il_ust.v_ust_piping that do not exist in public.v_ust_piping

select * from il_ust.v_ust_piping a
where not exists
	(select 1 from public.v_ust_piping b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.piping_id = b."PipingID")
order by a.facility_id,a.tank_id,a.compartment_id,a.piping_id;

--View definition for il_ust.v_ust_piping:
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
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_facility_dispenser ***********/
--There are 2231 rows in il_ust.v_ust_facility_dispenser that do not exist in public.v_ust_facility_dispenser

select * from il_ust.v_ust_facility_dispenser a
where not exists
	(select 1 from public.v_ust_facility_dispenser b
	where a.facility_id = b."FacilityID" and a.dispenser_id = b."DispenserID")
order by a.facility_id,a.dispenser_id;

--View definition for il_ust.v_ust_facility_dispenser:
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."DispenserID" AS dispenser_id,
    x."DispenserUDC" AS dispenser_udc
   FROM il_ust.facility_dispenser x
  WHERE (NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM il_ust.erg_unregulated_facilities)));