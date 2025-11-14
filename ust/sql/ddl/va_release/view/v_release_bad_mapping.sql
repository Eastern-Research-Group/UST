create or replace view "va_release"."v_release_bad_mapping" as
 SELECT DISTINCT b.release_control_id,
    c.database_lookup_table,
    a.epa_value
   FROM ((release_element_value_mapping a
     JOIN release_element_mapping b ON ((a.release_element_mapping_id = b.release_element_mapping_id)))
     JOIN release_elements c ON (((b.epa_column_name)::text = (c.database_column_name)::text)))
  WHERE ((((c.database_lookup_table)::text = 'cause'::text) AND (NOT ((a.epa_value)::text IN ( SELECT causes.cause
           FROM causes)))) OR (((c.database_lookup_table)::text = 'coordinate_source'::text) AND (NOT ((a.epa_value)::text IN ( SELECT coordinate_sources.coordinate_source
           FROM coordinate_sources)))) OR (((c.database_lookup_table)::text = 'corrective_action_strategy'::text) AND (NOT ((a.epa_value)::text IN ( SELECT corrective_action_strategies.corrective_action_strategy
           FROM corrective_action_strategies)))) OR (((c.database_lookup_table)::text = 'facility_type'::text) AND (NOT ((a.epa_value)::text IN ( SELECT facility_types.facility_type
           FROM facility_types)))) OR (((c.database_lookup_table)::text = 'how_release_detected'::text) AND (NOT ((a.epa_value)::text IN ( SELECT how_release_detected.how_release_detected
           FROM how_release_detected)))) OR (((c.database_lookup_table)::text = 'release_status'::text) AND (NOT ((a.epa_value)::text IN ( SELECT release_statuses.release_status
           FROM release_statuses)))) OR (((c.database_lookup_table)::text = 'sources'::text) AND (NOT ((a.epa_value)::text IN ( SELECT sources.source
           FROM sources)))) OR (((c.database_lookup_table)::text = 'state'::text) AND (NOT ((a.epa_value)::text IN ( SELECT states.state
           FROM states)))) OR (((c.database_lookup_table)::text = 'substances'::text) AND (NOT ((a.epa_value)::text IN ( SELECT substances.substance
           FROM substances)))))
  ORDER BY b.release_control_id, c.database_lookup_table, a.epa_value;