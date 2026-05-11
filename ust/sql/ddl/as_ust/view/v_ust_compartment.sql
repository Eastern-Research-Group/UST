create or replace view "as_ust"."v_ust_compartment" as
 SELECT DISTINCT c.facility_id,
    a.tank_id,
    a.compartment_id,
    b.compartment_status_id,
    a.overfill_prevention_high_level_alarm,
    (a.spill_bucket_installed)::character varying(3) AS spill_bucket_installed,
    (a.concrete_berm_installed)::character varying(3) AS concrete_berm_installed,
    a.tank_automatic_tank_gauging_release_detection,
    a.automatic_tank_gauging_continuous_leak_detection,
    a.tank_manual_tank_gauging,
    a.tank_tightness_testing,
    a.tank_inventory_control
   FROM ((as_ust.erg_compartment a
     LEFT JOIN as_ust.v_compartment_status_xwalk b ON (((a.compartment_status)::text = (b.organization_value)::text)))
     LEFT JOIN as_ust.v_ust_facility c ON (((a.facility_id)::text = (c.facility_id)::text)));