create or replace view "ok_release"."v_release_status_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.release_status_id
   FROM (v_release_element_mapping a
     LEFT JOIN release_statuses b ON (((a.epa_value)::text = (b.release_status)::text)))
  WHERE ((a.release_control_id = 13) AND ((a.epa_column_name)::text = 'release_status_id'::text));