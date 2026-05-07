create or replace view "pa_release"."v_ust_release_source" as
 SELECT DISTINCT (a."INCIDENT_ID")::character varying(50) AS release_id,
    b.source_id
   FROM (pa_release."Tank_Cleanup_Incidents" a
     JOIN pa_release.v_source_xwalk b ON ((a."SOURCE_CAUSE_OF_RELEASE" ~~ (('%'::text || (b.organization_value)::text) || '%'::text))))
  WHERE ((b.epa_value IS NOT NULL) AND (a."INCIDENT_TYPE" <> 'AST'::text));