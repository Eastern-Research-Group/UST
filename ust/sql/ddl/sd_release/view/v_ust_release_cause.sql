create or replace view "sd_release"."v_ust_release_cause" as
 SELECT DISTINCT b.cause_id,
    (x.id)::character varying(50) AS release_id
   FROM (sd_release.spill_reports_all x
     JOIN sd_release.v_cause_xwalk b ON (((x.cause_type)::text = (b.organization_value)::text)))
  WHERE (((x.sor_type)::text = 'UST'::text) AND ((x.regulated)::text = 'true'::text) AND ((x.cause_type)::text <> ALL (ARRAY[('no Release'::character varying)::text, ('No Release'::character varying)::text])));