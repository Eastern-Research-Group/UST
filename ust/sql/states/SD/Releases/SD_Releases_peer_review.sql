


/*********** v_ust_release_substance ***********/
--There are 2484 rows in sd_release.v_ust_release_substance that do not exist in public.v_ust_release_substance

select * from sd_release.v_ust_release_substance a
where not exists
	(select 1 from public.v_ust_release_substance b join public.substances c on b."SubstanceReleased" = c.substance
	where a.release_id = b."ReleaseID" and a.substance_id = c."substance_id")
order by a.release_id,a.substance_id;

--View definition for sd_release.v_ust_release_substance:
 SELECT DISTINCT (x.id)::character varying(50) AS release_id,
    s.substance_id,
    (x.amount)::double precision AS quantity_released,
    (x.units)::character varying(20) AS unit
   FROM ((sd_release.spill_reports_all x
     JOIN sd_release.erg_material_datarows_deagg d ON (((x.id)::text = (d.id)::text)))
     JOIN sd_release.v_substance_xwalk s ON (((d.material)::text = (s.organization_value)::text)))
  WHERE ((s.substance_id IS NOT NULL) AND (NOT (((x.id)::character varying(50))::text IN ( SELECT erg_unregulated_releases.release_id
           FROM sd_release.erg_unregulated_releases))) AND (NOT (EXISTS ( SELECT 1
           FROM sd_release.erg_unregulated_substances unregsub
          WHERE ((((d.id)::character varying(50))::text = (unregsub.release_id)::text) AND ((d.material)::text = (unregsub.organization_substance)::text))))));