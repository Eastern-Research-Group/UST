create or replace view "il_ust"."v_ust_compartment" as
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
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))));