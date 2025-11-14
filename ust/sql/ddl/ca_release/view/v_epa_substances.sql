create or replace view "ca_release"."v_epa_substances" as
 SELECT a."GLOBAL_ID",
    a.epa_value,
    row_number() OVER (PARTITION BY a."GLOBAL_ID" ORDER BY a.epa_value) AS rn
   FROM ( SELECT DISTINCT substances_deagg."GLOBAL_ID",
            substances_deagg.epa_value
           FROM ca_release.substances_deagg
          WHERE (substances_deagg.epa_value IS NOT NULL)) a;