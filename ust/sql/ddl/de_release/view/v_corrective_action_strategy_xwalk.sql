create or replace view "de_release"."v_corrective_action_strategy_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.corrective_action_strategy_id
   FROM (v_release_element_mapping a
     LEFT JOIN corrective_action_strategies b ON (((a.epa_value)::text = (b.corrective_action_strategy)::text)))
  WHERE ((a.release_control_id = 20) AND ((a.epa_column_name)::text = 'corrective_action_strategy_id'::text));