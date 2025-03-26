CREATE OR REPLACE VIEW hi_release.v_ust_release_source
AS SELECT DISTINCT x."LUSTID"::character varying(50) AS release_id,
s.source_id
   FROM hi_release.release x
	 	LEFT JOIN hi_release.v_source_xwalk s on x."SourceOfRelease1" = s.organization_value::text
where x."SourceOfRelease1" is not null;