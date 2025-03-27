create or replace view "az_ust"."v_ust_compartment" as
 SELECT DISTINCT (b."FacilityID")::character varying(50) AS facility_id,
    (b."TankName")::integer AS tank_id,
    a.compartment_id,
    (b."CompartmentName")::character varying(50) AS compartment_name,
    c.compartment_status_id,
    (b."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
    (b."OverfillPreventionBallFloatValve")::character varying(7) AS overfill_prevention_ball_float_valve,
    (b."OverfillPreventionFlowShutoffDevice")::character varying(7) AS overfill_prevention_flow_shutoff_device,
    (b."OverfillPreventionHighLevelAlarm")::character varying(7) AS overfill_prevention_high_level_alarm,
    (b."SpillBucketInstalled")::character varying(3) AS spill_bucket_installed,
    (b."ConcreteBermInstalled")::character varying(3) AS concrete_berm_installed,
    (b."TankInterstitialMonitoring")::character varying(7) AS tank_interstitial_monitoring,
    (b."TankAutomaticTankGaugingReleaseDetection")::character varying(7) AS tank_automatic_tank_gauging_release_detection,
    (b."TankManualTankGauging")::character varying(7) AS tank_manual_tank_gauging,
    (b."TankStatisticalInventoryReconciliation")::character varying(7) AS tank_statistical_inventory_reconciliation,
    (b."TankTightnessTesting")::character varying(7) AS tank_tightness_testing,
    (b."TankInventoryControl")::character varying(7) AS tank_inventory_control,
    (b."TankGroundwaterMonitoring")::character varying(7) AS tank_groundwater_monitoring,
    (b."TankVaporMonitoring")::character varying(7) AS tank_vapor_monitoring
   FROM ((az_ust.erg_compartment_id a
     LEFT JOIN az_ust.ust_compartment b ON (((b."FacilityID" = (a.facility_id)::text) AND ((b."TankName")::text = (a.tank_name)::text) AND ((a.compartment_name)::text = b."CompartmentName"))))
     LEFT JOIN az_ust.v_compartment_status_xwalk c ON ((b."CompartmentStatus" = (c.organization_value)::text)))
  WHERE ((EXISTS ( SELECT 1
           FROM az_ust.erg_v_ust_tank x
          WHERE ((b."FacilityID" = (x.facility_id)::text) AND (b."TankName" = x.tank_id)))) AND (NOT (EXISTS ( SELECT 1
           FROM az_ust.erg_unregulated_tanks unreg
          WHERE ((((b."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((b."TankName")::integer = unreg.tank_id))))));