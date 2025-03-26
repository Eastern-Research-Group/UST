CREATE OR REPLACE VIEW ia_release.v_ust_release_cause
AS SELECT DISTINCT x."LUSTID"::character varying(50) AS release_id,
    c.cause_id
   FROM ia_release.v_cause x
     LEFT JOIN ia_release.v_cause_xwalk c ON x.cause_id = c.organization_value::text
  WHERE x.cause_id IS NOT NULL;