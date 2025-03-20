create or replace view "mp_ust"."v_compartment_status_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.compartment_status_id
   FROM (v_ust_element_mapping a
     LEFT JOIN compartment_statuses b ON (((a.epa_value)::text = (b.compartment_status)::text)))
  WHERE ((a.ust_control_id = 22) AND ((a.epa_column_name)::text = 'compartment_status_id'::text));