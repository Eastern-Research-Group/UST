CREATE OR REPLACE VIEW hi_release.v_ust_release_cause
AS SELECT DISTINCT x."LUSTID"::character varying(50) AS release_id,
c.cause_id
   FROM hi_release.release x
	 	LEFT JOIN hi_release.v_cause_xwalk c on x."CauseOfRelease1" = c.organization_value::text
where x."CauseOfRelease1" is not null