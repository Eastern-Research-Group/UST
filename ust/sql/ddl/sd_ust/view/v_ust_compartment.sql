create or replace view "sd_ust"."v_ust_compartment" as
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    c.compartment_id,
    (x."TankCompartmentNumber")::character varying(50) AS compartment_name,
    (x."TankCapacityAmount")::integer AS compartment_capacity_gallons,
        CASE x."TankOverfillProtection"
            WHEN 'Ball Float Valves'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE x."TankOverfillProtection"
            WHEN 'Automatic Shutoff Device'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE x."TankOverfillProtection"
            WHEN 'Overfill Alarm'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE x."TankOverfillProtection"
            WHEN 'Other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE x."TankSpillProtection"
            WHEN 'Spill Bucket'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."TankReleaseDetection" = ANY (ARRAY['Secondary Containment'::text, 'Double Walled'::text, 'Interstitial Monitoring'::text, 'Concrete Vault'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankReleaseDetection" = ANY (ARRAY['In-Tank Monitor'::text, 'Automatic Tank Gauging'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE x."TankReleaseDetection"
            WHEN 'Manual Gauging'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE x."TankReleaseDetection"
            WHEN 'S.I.R.'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE x."TankReleaseDetection"
            WHEN 'Tightness Testing'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE x."TankReleaseDetection"
            WHEN 'Inventory Control'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE x."TankReleaseDetection"
            WHEN 'Groundwater Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE x."TankReleaseDetection"
            WHEN 'Other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection,
        CASE x."TankReleaseDetection"
            WHEN 'Vapor Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
    COALESCE(ts.tank_status_id, 8) AS compartment_status_id
   FROM ((sd_ust.tanks x
     JOIN sd_ust.erg_compartment c ON (((x."FacilityNumber" = (c.facility_id)::text) AND (x."TankNumber" = (c.tank_id)::double precision))))
     LEFT JOIN sd_ust.v_tank_status_xwalk ts ON ((x."StatusName" = (ts.organization_value)::text)));