create or replace view "sd_release"."v_ust_release_substance" as
 SELECT DISTINCT s.substance_id,
    (x.id)::character varying(50) AS release_id,
    (x.amount)::double precision AS quantity_released,
    (x.units)::character varying(20) AS unit
   FROM (sd_release.spill_reports_all x
     JOIN sd_release.v_substance_xwalk s ON (((x.material)::text = (s.organization_value)::text)))
  WHERE ((s.substance_id IS NOT NULL) AND ((x.sor_type)::text = 'UST'::text) AND ((x.regulated)::text = 'true'::text) AND ((x.cause_type)::text <> ALL (ARRAY[('no Release'::character varying)::text, ('No Release'::character varying)::text])));