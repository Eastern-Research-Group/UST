create or replace view "public"."v_ust_bad_mapping" as
 SELECT DISTINCT b.ust_control_id,
    c.database_lookup_table,
    a.epa_value
   FROM ((ust_element_value_mapping a
     JOIN ust_element_mapping b ON ((a.ust_element_mapping_id = b.ust_element_mapping_id)))
     JOIN ust_elements c ON (((b.epa_column_name)::text = (c.database_column_name)::text)))
  WHERE ((((c.database_lookup_table)::text = 'facility_types'::text) AND (NOT ((a.epa_value)::text IN ( SELECT facility_types.facility_type
           FROM facility_types)))) OR (((c.database_lookup_table)::text = 'coordinate_source'::text) AND (NOT ((a.epa_value)::text IN ( SELECT coordinate_sources.coordinate_source
           FROM coordinate_sources)))) OR (((c.database_lookup_table)::text = 'owner_types'::text) AND (NOT ((a.epa_value)::text IN ( SELECT owner_types.owner_type
           FROM owner_types)))) OR (((c.database_lookup_table)::text = 'pipe_tank_top_sump_wall_types'::text) AND (NOT ((a.epa_value)::text IN ( SELECT pipe_tank_top_sump_wall_types.pipe_tank_top_sump_wall_type
           FROM pipe_tank_top_sump_wall_types)))) OR (((c.database_lookup_table)::text = 'piping_styles'::text) AND (NOT ((a.epa_value)::text IN ( SELECT piping_styles.piping_style
           FROM piping_styles)))) OR (((c.database_lookup_table)::text = 'piping_wall_types'::text) AND (NOT ((a.epa_value)::text IN ( SELECT piping_wall_types.piping_wall_type
           FROM piping_wall_types)))) OR (((c.database_lookup_table)::text = 'spill_bucket_wall_types'::text) AND (NOT ((a.epa_value)::text IN ( SELECT spill_bucket_wall_types.spill_bucket_wall_type
           FROM spill_bucket_wall_types)))) OR (((c.database_lookup_table)::text = 'substances'::text) AND (NOT ((a.epa_value)::text IN ( SELECT substances.substance
           FROM substances)))) OR (((c.database_lookup_table)::text = 'tank_locations'::text) AND (NOT ((a.epa_value)::text IN ( SELECT tank_locations.tank_location
           FROM tank_locations)))) OR (((c.database_lookup_table)::text = 'tank_material_descriptions'::text) AND (NOT ((a.epa_value)::text IN ( SELECT tank_material_descriptions.tank_material_description
           FROM tank_material_descriptions)))) OR (((c.database_lookup_table)::text = 'tank_secondary_containments'::text) AND (NOT ((a.epa_value)::text IN ( SELECT tank_secondary_containments.tank_secondary_containment
           FROM tank_secondary_containments)))) OR (((c.database_lookup_table)::text = 'compartment_statuses'::text) AND (NOT ((a.epa_value)::text IN ( SELECT compartment_statuses.compartment_status
           FROM compartment_statuses)))) OR (((c.database_lookup_table)::text = 'tank_statuses'::text) AND (NOT ((a.epa_value)::text IN ( SELECT tank_statuses.tank_status
           FROM tank_statuses)))))
  ORDER BY b.ust_control_id, c.database_lookup_table, a.epa_value;