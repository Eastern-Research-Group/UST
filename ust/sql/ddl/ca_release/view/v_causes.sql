create or replace view "ca_release"."v_causes" as
 SELECT x.r,
    x."GLOBAL_ID",
    x.epa_value
   FROM ( SELECT row_number() OVER (PARTITION BY s."GLOBAL_ID" ORDER BY s.epa_value) AS r,
            s."GLOBAL_ID",
            s.epa_value
           FROM ( SELECT DISTINCT causes_deagg."GLOBAL_ID",
                    causes_deagg.epa_value
                   FROM ca_release.causes_deagg) s) x
  WHERE (x.r <= 3)
  ORDER BY x."GLOBAL_ID", x.epa_value;