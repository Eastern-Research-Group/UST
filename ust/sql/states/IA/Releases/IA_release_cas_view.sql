CREATE OR REPLACE VIEW ia_release.v_ust_release_corrective_action_strategy
AS SELECT DISTINCT x."LUSTID"::character varying(50) AS release_id,
    c.corrective_action_strategy_id,
    x.corrective_action_strategy_start_date as corrective_action_strategy_start_date
   FROM ia_release.v_corrective_action_strategy x
     LEFT JOIN ia_release.v_corrective_action_strategy_xwalk c ON x.corrective_action_strategy_id = c.organization_value::text
  WHERE x.corrective_action_strategy_id IS NOT NULL;