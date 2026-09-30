CREATE OR REPLACE VIEW public.vw_lookup_values AS
 SELECT 'cert_of_installations'::text AS table_name,
    'cert_of_installation_id'::text AS column_name,
    cert_of_installations.cert_of_installation AS epa_value
   FROM cert_of_installations
UNION ALL
 SELECT 'compartment_statuses'::text AS table_name,
    'compartment_status_id'::text AS column_name,
    compartment_statuses.compartment_status AS epa_value
   FROM compartment_statuses
UNION ALL
 SELECT 'coordinate_sources'::text AS table_name,
    'coordinate_source_id'::text AS column_name,
    coordinate_sources.coordinate_source AS epa_value
   FROM coordinate_sources
UNION ALL
 SELECT 'dispenser_udc_wall_types'::text AS table_name,
    'dispenser_udc_wall_type_id'::text AS column_name,
    dispenser_udc_wall_types.dispenser_udc_wall_type AS epa_value
   FROM dispenser_udc_wall_types
UNION ALL
 SELECT 'facility_types'::text AS table_name,
    'facility_type_id'::text AS column_name,
    facility_types.facility_type AS epa_value
   FROM facility_types
UNION ALL
 SELECT 'owner_types'::text AS table_name,
    'owner_type_id'::text AS column_name,
    owner_types.owner_type AS epa_value
   FROM owner_types
UNION ALL
 SELECT 'pipe_tank_top_sump_wall_types'::text AS table_name,
    'pipe_tank_top_sump_wall_type_id'::text AS column_name,
    pipe_tank_top_sump_wall_types.pipe_tank_top_sump_wall_type AS epa_value
   FROM pipe_tank_top_sump_wall_types
UNION ALL
 SELECT 'piping_styles'::text AS table_name,
    'piping_style_id'::text AS column_name,
    piping_styles.piping_style AS epa_value
   FROM piping_styles
UNION ALL
 SELECT 'piping_wall_types'::text AS table_name,
    'piping_wall_type_id'::text AS column_name,
    piping_wall_types.piping_wall_type AS epa_value
   FROM piping_wall_types
UNION ALL
 SELECT 'spill_bucket_wall_types'::text AS table_name,
    'spill_bucket_wall_type_id'::text AS column_name,
    spill_bucket_wall_types.spill_bucket_wall_type AS epa_value
   FROM spill_bucket_wall_types
UNION ALL
 SELECT 'substances'::text AS table_name,
    'substance_id'::text AS column_name,
    substances.substance AS epa_value
   FROM substances
UNION ALL
 SELECT 'tank_locations'::text AS table_name,
    'tank_location_id'::text AS column_name,
    tank_locations.tank_location AS epa_value
   FROM tank_locations
UNION ALL
 SELECT 'tank_material_descriptions'::text AS table_name,
    'tank_material_description_id'::text AS column_name,
    tank_material_descriptions.tank_material_description AS epa_value
   FROM tank_material_descriptions
UNION ALL
 SELECT 'tank_secondary_containments'::text AS table_name,
    'tank_secondary_containment_id'::text AS column_name,
    tank_secondary_containments.tank_secondary_containment AS epa_value
   FROM tank_secondary_containments
UNION ALL
 SELECT 'tank_statuses'::text AS table_name,
    'tank_status_id'::text AS column_name,
    tank_statuses.tank_status AS epa_value
   FROM tank_statuses
UNION ALL
 SELECT 'causes'::text AS table_name,
    'cause_id'::text AS column_name,
    causes.cause AS epa_value
   FROM causes
UNION ALL
 SELECT 'corrective_action_strategies'::text AS table_name,
    'corrective_action_strategy_id'::text AS column_name,
    corrective_action_strategies.corrective_action_strategy AS epa_value
   FROM corrective_action_strategies
UNION ALL
 SELECT 'sources'::text AS table_name,
    'source_id'::text AS column_name,
    sources.source AS epa_value
   FROM sources;
