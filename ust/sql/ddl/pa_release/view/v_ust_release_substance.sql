create or replace view "pa_release"."v_ust_release_substance" as
 SELECT DISTINCT (x."INCIDENT_ID")::character varying(50) AS release_id,
    s.substance_id
   FROM (pa_release."Tank_Cleanup_Incidents" x
     JOIN pa_release.v_substance_xwalk s ON ((x."SUBSTANCE" = (s.organization_value)::text)))
  WHERE ((s.substance_id IS NOT NULL) AND (x."INCIDENT_TYPE" <> 'AST'::text));