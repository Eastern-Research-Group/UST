create or replace view "hi_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    c.compartment_id,
    cs.compartment_status_id,
    (x."TankCapacity")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x."OverfillBallFloat" = false) THEN 'No'::text
            WHEN (x."OverfillBallFloat" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (x."OverfillFlapper" = false) THEN 'No'::text
            WHEN (x."OverfillFlapper" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (x."OverfillAlarm" = false) THEN 'No'::text
            WHEN (x."OverfillAlarm" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (x."SpillInstalled" = false) THEN 'No'::text
            WHEN (x."SpillInstalled" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."TankInterstitialDblWalled" = false) THEN 'No'::text
            WHEN (x."TankInterstitialDblWalled" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankATG" = false) THEN 'No'::text
            WHEN (x."TankATG" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (x."TankManualGauge" = false) THEN 'No'::text
            WHEN (x."TankManualGauge" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (x."TankSIR" = false) THEN 'No'::text
            WHEN (x."TankSIR" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (x."TankTightness" = false) THEN 'No'::text
            WHEN (x."TankTightness" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (x."TankInventoryControl" = false) THEN 'No'::text
            WHEN (x."TankInventoryControl" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (x."TankGWMonitor" = false) THEN 'No'::text
            WHEN (x."TankGWMonitor" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (x."TankVaporMonitor" = false) THEN 'No'::text
            WHEN (x."TankVaporMonitor" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN (x."TankLDOther" = false) THEN 'No'::text
            WHEN (x."TankLDOther" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM ((hi_ust."tblTank" x
     JOIN hi_ust.erg_compartment_id c ON ((((x."FacilityID")::text = (c.facility_id)::text) AND ((x."TankID")::text = (c.tank_id)::text) AND (x."AltTankID" = (c.tank_name)::text))))
     LEFT JOIN hi_ust.v_compartment_status_xwalk cs ON ((x."TankStatusDesc" = (cs.organization_value)::text)));