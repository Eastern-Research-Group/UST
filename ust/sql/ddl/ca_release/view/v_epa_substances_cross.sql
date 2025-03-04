create or replace view "ca_release"."v_epa_substances_cross" as
 SELECT a."GLOBAL_ID",
    a.epa_value AS substance1,
    b.epa_value AS substance2,
    c.epa_value AS substance3,
    d.epa_value AS substance4,
    e.epa_value AS substance5
   FROM ((((( SELECT v_epa_substances."GLOBAL_ID",
            v_epa_substances.epa_value
           FROM ca_release.v_epa_substances
          WHERE (v_epa_substances.rn = 1)) a
     LEFT JOIN ( SELECT v_epa_substances."GLOBAL_ID",
            v_epa_substances.epa_value
           FROM ca_release.v_epa_substances
          WHERE (v_epa_substances.rn = 2)) b ON ((a."GLOBAL_ID" = b."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_substances."GLOBAL_ID",
            v_epa_substances.epa_value
           FROM ca_release.v_epa_substances
          WHERE (v_epa_substances.rn = 3)) c ON ((a."GLOBAL_ID" = c."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_substances."GLOBAL_ID",
            v_epa_substances.epa_value
           FROM ca_release.v_epa_substances
          WHERE (v_epa_substances.rn = 4)) d ON ((a."GLOBAL_ID" = d."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_substances."GLOBAL_ID",
            v_epa_substances.epa_value
           FROM ca_release.v_epa_substances
          WHERE (v_epa_substances.rn = 5)) e ON ((a."GLOBAL_ID" = e."GLOBAL_ID")));