------------------------------------------------------------------------------------------------------------------------



/*********** v_ust_release_substance ***********/
--There are 5 rows in ks_release.v_ust_release_substance that do not exist in public.v_ust_release_substance

select * from ks_release.v_ust_release_substance a join substances sub on a.substance_id = sub.substance_id
where not exists
	(select 1 from public.v_ust_release_substance b join public.substances c on b."SubstanceReleased" = c.substance
	where a.release_id = b."ReleaseID" and a.substance_id = c."substance_id")
order by a.release_id,a.substance_id;

select * from 

--View definition for ks_release.v_ust_release_substance:
 SELECT DISTINCT (a.release_id)::character varying(50) AS release_id,
    b.substance_id,
        CASE
            WHEN ((lower(a.quantity_released) = 'unknown'::text) OR (lower(a.quantity_released) = 'minimal'::text) OR (lower(a.quantity_released) = lower('Approximately 2750 gallons'::text))) THEN NULL::double precision
            ELSE (a.quantity_released)::double precision
        END AS quantity_released,
    (a.unit)::character varying(20) AS unit
   FROM (ks_release.erg_substance_datarows_deagg a
     LEFT JOIN ks_release.v_substance_xwalk b ON (((a.substance)::text = (b.organization_value)::text)));


/*********** v_ust_release_source ***********/
--There are 3 rows in ks_release.v_ust_release_source that do not exist in public.v_ust_release_source

select * from ks_release.v_ust_release_source a
where not exists
	(select 1 from public.v_ust_release_source b join public.sources c on b."SourceOfRelease" = c.source
	where a.release_id = b."ReleaseID" and a.source_id = c."source_id")
order by a.release_id,a.source_id;

--View definition for ks_release.v_ust_release_source:
 SELECT DISTINCT (a.release_id)::character varying(50) AS release_id,
    b.source_id
   FROM (ks_release.erg_source_datarows_deagg a
     LEFT JOIN ks_release.v_source_xwalk b ON (((a.source)::text = (b.organization_value)::text)));


/*********** v_ust_release_cause ***********/
--There are 4 rows in ks_release.v_ust_release_cause that do not exist in public.v_ust_release_cause

select * from ks_release.v_ust_release_cause a
where not exists
	(select 1 from public.v_ust_release_cause b join public.causes c on b."CauseOfRelease" = c.cause
	where a.release_id = b."ReleaseID" and a.cause_id = c."cause_id")
order by a.release_id,a.cause_id;

--View definition for ks_release.v_ust_release_cause:
 SELECT DISTINCT (a.release_id)::character varying(50) AS release_id,
    b.cause_id
   FROM (ks_release.erg_cause_datarows_deagg a
     LEFT JOIN ks_release.v_cause_xwalk b ON (((a.cause)::text = (b.organization_value)::text)));