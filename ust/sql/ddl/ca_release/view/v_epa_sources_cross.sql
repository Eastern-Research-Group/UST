create or replace view "ca_release"."v_epa_sources_cross" as
 SELECT a."GLOBAL_ID",
    a.epa_value AS source1,
    b.epa_value AS source2,
    c.epa_value AS source3,
    d.epa_value AS source4,
    e.epa_value AS source5,
    f.epa_value AS source6
   FROM (((((( SELECT v_epa_sources."GLOBAL_ID",
            v_epa_sources.epa_value
           FROM ca_release.v_epa_sources
          WHERE (v_epa_sources.rn = 1)) a
     LEFT JOIN ( SELECT v_epa_sources."GLOBAL_ID",
            v_epa_sources.epa_value
           FROM ca_release.v_epa_sources
          WHERE (v_epa_sources.rn = 2)) b ON ((a."GLOBAL_ID" = b."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_sources."GLOBAL_ID",
            v_epa_sources.epa_value
           FROM ca_release.v_epa_sources
          WHERE (v_epa_sources.rn = 3)) c ON ((a."GLOBAL_ID" = c."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_sources."GLOBAL_ID",
            v_epa_sources.epa_value
           FROM ca_release.v_epa_sources
          WHERE (v_epa_sources.rn = 4)) d ON ((a."GLOBAL_ID" = d."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_sources."GLOBAL_ID",
            v_epa_sources.epa_value
           FROM ca_release.v_epa_sources
          WHERE (v_epa_sources.rn = 5)) e ON ((a."GLOBAL_ID" = e."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_sources."GLOBAL_ID",
            v_epa_sources.epa_value
           FROM ca_release.v_epa_sources
          WHERE (v_epa_sources.rn = 6)) f ON ((a."GLOBAL_ID" = f."GLOBAL_ID")));