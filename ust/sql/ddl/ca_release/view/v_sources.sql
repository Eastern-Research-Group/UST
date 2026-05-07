create or replace view "ca_release"."v_sources" as
 SELECT x.r,
    x."GLOBAL_ID",
    x.epa_value
   FROM ( SELECT row_number() OVER (PARTITION BY s."GLOBAL_ID" ORDER BY s.epa_value) AS r,
            s."GLOBAL_ID",
            s.epa_value
           FROM ( SELECT DISTINCT sources_deagg."GLOBAL_ID",
                    sources_deagg.epa_value
                   FROM ca_release.sources_deagg) s) x
  WHERE (x.r <= 3)
  ORDER BY x."GLOBAL_ID", x.epa_value;