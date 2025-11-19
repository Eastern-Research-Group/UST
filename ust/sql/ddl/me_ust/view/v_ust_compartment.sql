create or replace view "me_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    (x."CHAMBER ID")::integer AS compartment_id,
    cs.compartment_status_id,
    (x."VOLUME IN GALLONS")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'AUTOMATIC_TANK_GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'AUTOMATIC_TANK_GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'CONTINUOUS_GROUNDWATER_MON'::text) THEN 'Yes'::text
            WHEN (x."TANK LEAK DETECTION" = 'MANUAL_GROUNDWATER_SAMPLE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'SIA_INVENTORY_ANALYSIS'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (x."TANK LEAK DETECTION" <> ALL (ARRAY['AUTOMATIC_TANK_GAUGE'::text, 'MONTHLY_SIR'::text, 'SIA_INVENTORY_ANALYSIS'::text, 'CONTINUOUS_GROUNDWATER_MON'::text, 'CONTINUOUS_VAPOR_GAUGE'::text, 'UNKNOWN'::text, 'NONE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'MONTHLY_SIR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'CONTINUOUS_VAPOR_MONITORING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN (x."OVERFILL PROTECTION" = 'SPILL CONTAINMENT'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."OVERFILL PROTECTION" = ANY (ARRAY['VENT_BALL'::text, 'VENT_WHISTLE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (x."OVERFILL PROTECTION" = 'UNKNOWN'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_unknown,
        CASE
            WHEN (x."OVERFILL PROTECTION" = ANY (ARRAY['PRESSURE_DROP_TUBE'::text, 'DROP_TUBE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (x."OVERFILL PROTECTION" = 'LEVEL_GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (x."OVERFILL PROTECTION" = ANY (ARRAY['ELECTRONIC'::text, 'MECHANICAL'::text, 'MECH_ELEC'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other
   FROM (me_ust.tanks x
     LEFT JOIN me_ust.v_compartment_status_xwalk cs ON ((x."TANK STATUS LABEL" = (cs.organization_value)::text)))
  WHERE ((x."TANK STATUS LABEL" <> ALL (ARRAY['ACTIVE NON-REGULATED'::text, 'NEVER INSTALLED'::text, 'PLANNED FOR INSTALLATION'::text, 'TRANSFER'::text])) AND (NOT (EXISTS ( SELECT 1
           FROM me_ust.erg_unregulated_tanks unreg
          WHERE ((((x."REGISTRATION NUMBER")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TANK NUMBER")::integer = unreg.tank_id))))));