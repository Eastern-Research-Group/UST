------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view ma_release.v_ust_release_substance as
 SELECT DISTINCT (a."LUSTID")::character varying(50) AS release_id,
    b.substance_id,
        CASE
            WHEN (c."LUSTID" IS NOT NULL) THEN NULL::double precision
            ELSE a.quantity_released
        END AS quantity_released,
        CASE
            WHEN (c."LUSTID" IS NOT NULL) THEN NULL::character varying
            ELSE (a.unit)::character varying(20)
        END AS unit
   FROM ((ma_release.vw_release_substances a
     LEFT JOIN ma_release.v_substance_xwalk b ON ((a.substance_released = (b.organization_value)::text)))
     LEFT JOIN ma_release.vw_duplicate_substances c ON (((a."LUSTID" = c."LUSTID") AND (a.substance_released = c.substance_released))))
  WHERE ((NOT (((a."LUSTID")::character varying(50))::text IN ( SELECT erg_unregulated_releases.release_id
           FROM ma_release.erg_unregulated_releases))) AND (NOT (((a."LUSTID")::character varying(50))::text IN ( SELECT erg_unregulated_releases.release_id
           FROM ma_release.erg_unregulated_releases))))
 and a."LUSTID"::varchar(50) not in (select release_id from ma_release.erg_unregulated_releases);