create or replace view "hi_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
    cx.compartment_status_id,
        CASE
            WHEN (x."OverfillPreventionBallFloatValve" = true) THEN 'Yes'::text
            WHEN (x."OverfillPreventionBallFloatValve" = false) THEN 'No'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (x."TankInterstitialMonitoring" = true) THEN 'Yes'::text
            WHEN (x."TankInterstitialMonitoring" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankManualTankGauging" = true) THEN 'Yes'::text
            WHEN (x."TankManualTankGauging" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (x."TankStatisticalInventoryReconciliation" = true) THEN 'Yes'::text
            WHEN (x."TankStatisticalInventoryReconciliation" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (x."OverfillPreventionFlowShutoffDevice" = true) THEN 'Yes'::text
            WHEN (x."OverfillPreventionFlowShutoffDevice" = false) THEN 'No'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (x."OverfillPreventionHighLevelAlarm" = true) THEN 'Yes'::text
            WHEN (x."OverfillPreventionHighLevelAlarm" = false) THEN 'No'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (x."SpillBucketInstalled" = true) THEN 'Yes'::text
            WHEN (x."SpillBucketInstalled" = false) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."TankAutomaticTankGaugingReleaseDetection" = true) THEN 'Yes'::text
            WHEN (x."TankAutomaticTankGaugingReleaseDetection" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (x."TankTightnessTesting" = true) THEN 'Yes'::text
            WHEN (x."TankTightnessTesting" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (x."TankInventoryControl" = true) THEN 'Yes'::text
            WHEN (x."TankInventoryControl" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (x."TankGroundwaterMonitoring" = true) THEN 'Yes'::text
            WHEN (x."TankGroundwaterMonitoring" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (x."TankVaporMonitoring" = true) THEN 'Yes'::text
            WHEN (x."TankVaporMonitoring" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN (x."TankOtherReleaseDetection" = true) THEN 'Yes'::text
            WHEN (x."TankOtherReleaseDetection" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM (((hi_ust.compartment x
     JOIN hi_ust.erg_compartment_id t ON (((((x."FacilityID")::character varying(50))::text = (t.facility_id)::text) AND (((x."TankID")::character varying(50))::text = (t.tank_name)::text))))
     JOIN hi_ust.tank ut ON (((((x."FacilityID")::character varying(50))::text = ut."FacilityID") AND (x."TankID" = ut."TankID"))))
     LEFT JOIN hi_ust.v_compartment_status_xwalk cx ON ((ut."TankStatus" = (cx.organization_value)::text)));