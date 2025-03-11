create or replace view "ca_release"."v_epa_causes" as
 SELECT a."GLOBAL_ID",
    a.epa_value,
    row_number() OVER (PARTITION BY a."GLOBAL_ID" ORDER BY a.epa_value) AS rn
   FROM ( SELECT DISTINCT causes_deagg."GLOBAL_ID",
            causes_deagg.epa_value
           FROM ca_release.causes_deagg
          WHERE (causes_deagg.epa_value IS NOT NULL)) a;