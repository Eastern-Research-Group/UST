create or replace view "vt_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    (x."CompartmentID")::integer AS compartment_id,
    x."CompartmentName" AS compartment_name,
    cs.compartment_status_id,
    (floor(x."CompartmentCapacityGallons"))::integer AS compartment_capacity_gallons,
    x."OverfillPreventionBallFloatValve" AS overfill_prevention_ball_float_valve,
    x."OverfillPreventionFlowShutoffDevice" AS overfill_prevention_flow_shutoff_device,
    x."OverfillPreventionHighLevelAlarm" AS overfill_prevention_high_level_alarm,
    x."OverfillPreventionOther" AS overfill_prevention_other,
    x."OverfillPreventionUnknown" AS overfill_prevention_unknown,
    x."OverfillPreventionNotRequired" AS overfill_prevention_not_required,
        CASE
            WHEN (x."SpillBucketInstalled" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."SpillBucketInstalled" = 'No'::text) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
    x."ConcreteBermInstalled" AS concrete_berm_installed,
    x."SpillPreventionOther" AS spill_prevention_other,
    x."SpillPreventionNotRequired" AS spill_prevention_not_required,
    sb.spill_bucket_wall_type_id,
    x."TankInterstitialMonitoring" AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankAutomaticTankGaugingReleaseDetection" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'Unknown'::text
        END AS tank_automatic_tank_gauging_release_detection,
    x."TankManualTankGauging" AS tank_manual_tank_gauging,
    x."TankStatisticalInventoryReconciliation" AS tank_statistical_inventory_reconciliation
   FROM ((vt_ust.compartment x
     LEFT JOIN vt_ust.v_compartment_status_xwalk cs ON ((x."CompartmentStatus" = (cs.organization_value)::text)))
     LEFT JOIN vt_ust.v_spill_bucket_wall_type_xwalk sb ON ((x."SpillBucketWallType" = (sb.organization_value)::text)))
  WHERE (x."FacilityID" IN ( SELECT f."FacilityID"
           FROM vt_ust.facility f));