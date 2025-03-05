create or replace view "ca_release"."v_substances" as
 SELECT x.r,
    x."GLOBAL_ID",
    x.epa_value
   FROM ( SELECT row_number() OVER (PARTITION BY s."GLOBAL_ID" ORDER BY s.epa_value) AS r,
            s."GLOBAL_ID",
            s.epa_value
           FROM ( SELECT DISTINCT substances_deagg."GLOBAL_ID",
                    substances_deagg.epa_value
                   FROM ca_release.substances_deagg) s) x
  WHERE (x.r <= 5)
  ORDER BY x."GLOBAL_ID", x.epa_value;