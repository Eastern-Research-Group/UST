create or replace view "ca_release"."v_epa_sources" as
 SELECT a."GLOBAL_ID",
    a.epa_value,
    row_number() OVER (PARTITION BY a."GLOBAL_ID" ORDER BY a.epa_value) AS rn
   FROM ( SELECT DISTINCT sources_deagg."GLOBAL_ID",
            sources_deagg.epa_value
           FROM ca_release.sources_deagg
          WHERE (sources_deagg.epa_value IS NOT NULL)) a;