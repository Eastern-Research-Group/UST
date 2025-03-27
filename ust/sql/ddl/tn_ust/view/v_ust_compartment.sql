create or replace view "tn_ust"."v_ust_compartment" as
 SELECT DISTINCT (a."Tank Id")::integer AS tank_id,
    (a."Facility Id Ust")::character varying(50) AS facility_id,
    (a."Compartment Id")::integer AS compartment_id,
    (a."Compartment Letter")::character varying(50) AS compartment_name,
    c.compartment_status_id,
    (a."Compartment Capacity")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (a."Overfill Prevention" = 'Ball Float Valves'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (a."Overfill Prevention" = 'Automatic Shut Off Device'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (a."Overfill Prevention" = 'Overfill Alarm'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (a."Overfill Prevention" = 'Vent Whistle'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN (a."Overfill Prevention" = 'unknown'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_unknown,
        CASE
            WHEN (a."Overfill Prevention" = 'Not Required'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_not_required,
        CASE
            WHEN (a."Spill Bucket Installation Date" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (a."Spill Prevention" = 'Not Required'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_prevention_not_required,
    d.spill_bucket_wall_type_id,
        CASE
            WHEN (a."Compartment Release Detection" = 'Interstitial Monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (a."Compartment Release Detection" = 'Automatic Tank Gauging'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (a."Compartment Release Detection" = 'Continuous In Tank Leak Detection System - CITLDS'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (a."Compartment Release Detection" = ANY (ARRAY['Manual Tank Gauging'::text, 'Manual Tank Gauging and Tank Tightness Testing'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (a."Compartment Release Detection" = 'Statistical Inventory Reconciliation (SIR)'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (a."Compartment Release Detection" = 'Manual Tank Gauging and Tank Tightness Testing'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (a."Compartment Release Detection" = 'Inventory Control'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (a."Compartment Release Detection" = 'Ground Water Monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (a."Compartment Release Detection" = ANY (ARRAY['deferred'::text, 'Other or No method'::text, 'Tank LD Not Listed'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM (((tn_ust.tn_compartments a
     JOIN tn_ust.erg_status y ON (((a."Tank Id" = y."Tank Id") AND (a."Facility Id Ust" = y."Facility Id Ust") AND (a."Compartment Id" = y."Compartment Id"))))
     LEFT JOIN tn_ust.v_compartment_status_xwalk c ON ((y.status_combined = (c.organization_value)::text)))
     LEFT JOIN tn_ust.v_spill_bucket_wall_type_xwalk d ON ((a."Spill Prevention" = (d.organization_value)::text)))
  WHERE (((a."Regulated Status" = 'Regulated'::text) OR (a."Regulated Status" IS NULL)) AND (NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility Id Ust")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."Tank Id")::integer = unreg.tank_id))))));