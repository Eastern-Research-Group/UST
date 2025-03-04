create or replace view "dc_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (t."TankName")::integer AS tank_id,
    (x."CompartmentName")::integer AS compartment_id,
    x."CompartmentID" AS compartment_name,
    cs.compartment_status_id,
    (x."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
    x."OverfillPreventionBallFloatValve" AS overfill_prevention_ball_float_valve,
    x."OverfillPreventionFlowShutoffDevice" AS overfill_prevention_flow_shutoff_device,
    x."OverfillPreventionHighLevelAlarm" AS overfill_prevention_high_level_alarm,
    x."OverfillPreventionOther" AS overfill_prevention_other,
    x."OverfillPreventionUnknown" AS overfill_prevention_unknown,
    x."SpillBucketInstalled" AS spill_bucket_installed,
    x."TankInterstitialMonitoring" AS tank_interstitial_monitoring,
    x."TankAutomaticTankGaugingReleaseDetection" AS tank_automatic_tank_gauging_release_detection,
    x."AutomaticTankGauging ContinuousLeakDetection" AS automatic_tank_gauging_continuous_leak_detection,
    x."TankManualTankGauging" AS tank_manual_tank_gauging,
    x."TankStatisticalInventoryReconciliation" AS tank_statistical_inventory_reconciliation,
    x."TankTightnessTesting" AS tank_tightness_testing,
    x."TankInventoryControl" AS tank_inventory_control,
    x."TankGroundwaterMonitoring" AS tank_groundwater_monitoring,
    x."TankVaporMonitoring" AS tank_vapor_monitoring,
    x."TankSubpartKTightnessTesting" AS tank_subpart_k_tightness_testing,
    x."TankSubpartKOther" AS tank_subpart_k_other,
    x."TankOtherReleaseDetection" AS tank_other_release_detection
   FROM ((dc_ust.compartment x
     JOIN dc_ust.tank t ON ((((x."FacilityID")::text = (t."FacilityID")::text) AND (x."TankID" = t."TankID"))))
     LEFT JOIN dc_ust.v_compartment_status_xwalk cs ON ((x."CompartmentStatus" = (cs.organization_value)::text)));