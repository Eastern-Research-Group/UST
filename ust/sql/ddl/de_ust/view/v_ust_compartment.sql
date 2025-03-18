create or replace view "de_ust"."v_ust_compartment" as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
        CASE
            WHEN ((x."CompartmentID")::integer IS NULL) THEN 28718
            ELSE (x."CompartmentID")::integer
        END AS compartment_id,
    x."CompartmentName" AS compartment_name,
    cs.compartment_status_id,
    (x."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x."OverfillPreventionOther" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."OverfillPreventionOther" = 'No'::text) THEN 'No'::text
            ELSE 'Unknown'::text
        END AS overfill_prevention_other,
    x."OverfillPreventionUnknown" AS overfill_prevention_unknown,
    x."OverfillPreventionNotRequired" AS overfill_prevention_not_required,
        CASE
            WHEN (x."SpillBucketInstalled" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS spill_bucket_installed,
    x."SpillPreventionNotRequired" AS spill_prevention_not_required,
    x."TankInterstitialMonitoring" AS tank_interstitial_monitoring,
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
   FROM (de_ust.compartment x
     LEFT JOIN de_ust.v_compartment_status_xwalk cs ON ((x."CompartmentStatus" = (cs.organization_value)::text)));