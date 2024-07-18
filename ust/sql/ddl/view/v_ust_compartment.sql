create or replace view "public"."v_ust_compartment" as
 SELECT c.ust_control_id,
    c.facility_id AS "FacilityID",
    b.tank_id AS "TankID",
    b.tank_name AS "TankName",
    a.compartment_id AS "CompartmentID",
    a.compartment_name AS "CompartmentName",
    cs.compartment_status AS "CompartmentStatus",
    s.substance AS "CompartmentSubstanceStored",
    ts.substance_casno AS "CompartmentSubstanceCASNO",
    a.compartment_capacity_gallons AS "CompartmentCapacityGallons",
    a.overfill_prevention_ball_float_valve AS "OverfillPreventionBallFloatValve",
    a.overfill_prevention_flow_shutoff_device AS "OverfillPreventionFlowShutoffDevice",
    a.overfill_prevention_high_level_alarm AS "OverfillPreventionHighLevelAlarm",
    a.overfill_prevention_other AS "OverfillPreventionOther",
    a.overfill_prevention_unknown AS "OverfillPreventionUnknown",
    a.overfill_prevention_not_required AS "OverfillPreventionNotRequired",
    a.spill_bucket_installed AS "SpillBucketInstalled",
    a.concrete_berm_installed AS "ConcreteBermInstalled",
    a.spill_prevention_other AS "SpillPreventionOther",
    a.spill_prevention_not_required AS "SpillPreventionNotRequired",
    sb.spill_bucket_wall_type AS "SpillBucketWallType",
    a.tank_interstitial_monitoring AS "TankInterstitialMonitoring",
    a.tank_automatic_tank_gauging_release_detection AS "TankAutomaticTankGaugingReleaseDetection",
    a.automatic_tank_gauging_continuous_leak_detection AS "AutomaticTankGaugingContinuousLeakDetection",
    a.tank_manual_tank_gauging AS "TankManualTankGauging",
    a.tank_statistical_inventory_reconciliation AS "TankStatisticalInventoryReconciliation",
    a.tank_tightness_testing AS "TankTightnessTesting",
    a.tank_inventory_control AS "TankInventoryControl",
    a.tank_groundwater_monitoring AS "TankGroundwaterMonitoring",
    a.tank_vapor_monitoring AS "TankVaporMonitoring",
    a.tank_subpart_k_tightness_testing AS "TankSubpartKTightnessTesting",
    a.tank_subpart_k_other AS "TankSubpartKOther",
    a.tank_other_release_detection AS "TankOtherReleaseDetection",
    a.dispenser_id AS "DispenserID",
    a.dispenser_udc AS "DispenserUDC"
   FROM (((((((ust_compartment a
     JOIN ust_tank b ON ((a.ust_tank_id = b.ust_tank_id)))
     JOIN ust_facility c ON ((b.ust_facility_id = c.ust_facility_id)))
     LEFT JOIN ust_compartment_substance csb ON ((a.ust_compartment_id = csb.ust_compartment_id)))
     LEFT JOIN ust_tank_substance ts ON ((csb.ust_tank_substance_id = ts.ust_tank_substance_id)))
     LEFT JOIN substances s ON ((ts.substance_id = s.substance_id)))
     LEFT JOIN compartment_statuses cs ON ((cs.compartment_status_id = a.compartment_status_id)))
     LEFT JOIN spill_bucket_wall_types sb ON ((sb.spill_bucket_wall_type_id = a.spill_bucket_wall_type_id)));