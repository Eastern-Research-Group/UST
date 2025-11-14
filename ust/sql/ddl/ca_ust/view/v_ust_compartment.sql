create or replace view "ca_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."CERS ID")::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
    cx.compartment_status_id,
    (x."Tank _Capacity _In Gallons")::integer AS compartment_capacity_gallons,
    (x."Ball Float")::character varying(7) AS overfill_prevention_ball_float_valve,
    (x."Fill Tube _Shut-Off _Valve")::character varying(7) AS overfill_prevention_flow_shutoff_device,
    (x."Audible/_Visual _Alarms")::character varying(7) AS overfill_prevention_high_level_alarm,
    (x."Exempt")::character varying(7) AS overfill_prevention_not_required,
    (x."Spill Bucket _Installed")::character varying(3) AS spill_bucket_installed,
    (x."Automatic _Tank _Gauging")::character varying(7) AS tank_automatic_tank_gauging_release_detection,
    (x."Continuous _Electronic _Tank Monitoring")::character varying(7) AS automatic_tank_gauging_continuous_leak_detection,
    (x."Weekly_Manual _Tank Gauge")::character varying(7) AS tank_manual_tank_gauging,
    (x."Monthly Statistical _Inventory _Reconciliation")::character varying(7) AS tank_statistical_inventory_reconciliation,
    (x."Tank _Integrity _Testing")::character varying(7) AS tank_tightness_testing,
    (x."Other_Monitoring")::character varying(7) AS tank_other_release_detection
   FROM ((ca_ust.tank x
     JOIN ca_ust.erg_compartment_id t ON (((((x."CERS ID")::character varying(50))::text = (t.facility_id)::text) AND (((x."CERS TankID")::character varying(50))::text = (t.tank_name)::text))))
     LEFT JOIN ca_ust.v_compartment_status_xwalk cx ON ((x."Type of Action" = (cx.organization_value)::text)));