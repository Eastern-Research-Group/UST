create or replace view "ut_release"."v_facility_type_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.facility_type_id
   FROM (v_release_element_mapping a
     LEFT JOIN facility_types b ON (((a.epa_value)::text = (b.facility_type)::text)))
  WHERE ((a.release_control_id = 11) AND ((a.epa_column_name)::text = 'facility_type_id'::text));