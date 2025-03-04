create or replace view "az_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankName")::integer AS tank_id,
    c.compartment_id,
    (x."CompartmentName")::character varying(50) AS compartment_name,
    cx.compartment_status_id,
    (x."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
    (x."OverfillPreventionBallFloatValve")::character varying(7) AS overfill_prevention_ball_float_valve,
    (x."OverfillPreventionFlowShutoffDevice")::character varying(7) AS overfill_prevention_flow_shutoff_device,
    (x."OverfillPreventionHighLevelAlarm")::character varying(7) AS overfill_prevention_high_level_alarm,
    (x."SpillBucketInstalled")::character varying(3) AS spill_bucket_installed,
    (x."ConcreteBermInstalled")::character varying(3) AS concrete_berm_installed,
    (x."TankInterstitialMonitoring")::character varying(7) AS tank_interstitial_monitoring,
    (x."TankAutomaticTankGaugingReleaseDetection")::character varying(7) AS tank_automatic_tank_gauging_release_detection,
    (x."TankManualTankGauging")::character varying(7) AS tank_manual_tank_gauging,
    (x."TankStatisticalInventoryReconciliation")::character varying(7) AS tank_statistical_inventory_reconciliation,
    (x."TankTightnessTesting")::character varying(7) AS tank_tightness_testing,
    (x."TankInventoryControl")::character varying(7) AS tank_inventory_control,
    (x."TankGroundwaterMonitoring")::character varying(7) AS tank_groundwater_monitoring,
    (x."TankVaporMonitoring")::character varying(7) AS tank_vapor_monitoring
   FROM ((az_ust.ust_compartment x
     JOIN az_ust.erg_compartment c ON (((x."FacilityID" = (c.facility_id)::text) AND ((x."TankName")::integer = c.tank_id) AND (x."CompartmentName" = (c.compartment_name)::text))))
     LEFT JOIN az_ust.v_compartment_status_xwalk cx ON ((x."CompartmentStatus" = (cx.organization_value)::text)));