create or replace view "de_release"."v_release_discovered_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.release_discovered_id
   FROM (v_release_element_mapping a
     LEFT JOIN release_discovered b ON (((a.epa_value)::text = (b.release_discovered)::text)))
  WHERE ((a.release_control_id = 20) AND ((a.epa_column_name)::text = 'release_discovered_id'::text));