create or replace view "ca_ust"."v_facility_type_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.facility_type_id
   FROM (v_ust_element_mapping a
     LEFT JOIN facility_types b ON (((a.epa_value)::text = (b.facility_type)::text)))
  WHERE ((a.ust_control_id = 18) AND ((a.epa_column_name)::text = 'facility_type1'::text));