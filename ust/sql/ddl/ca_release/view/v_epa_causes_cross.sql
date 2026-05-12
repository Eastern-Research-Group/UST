create or replace view "ca_release"."v_epa_causes_cross" as
 SELECT a."GLOBAL_ID",
    a.epa_value AS cause1,
    b.epa_value AS cause2,
    c.epa_value AS cause3,
    d.epa_value AS cause4,
    e.epa_value AS cause5,
    f.epa_value AS cause6
   FROM (((((( SELECT v_epa_causes."GLOBAL_ID",
            v_epa_causes.epa_value
           FROM ca_release.v_epa_causes
          WHERE (v_epa_causes.rn = 1)) a
     LEFT JOIN ( SELECT v_epa_causes."GLOBAL_ID",
            v_epa_causes.epa_value
           FROM ca_release.v_epa_causes
          WHERE (v_epa_causes.rn = 2)) b ON ((a."GLOBAL_ID" = b."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_causes."GLOBAL_ID",
            v_epa_causes.epa_value
           FROM ca_release.v_epa_causes
          WHERE (v_epa_causes.rn = 3)) c ON ((a."GLOBAL_ID" = c."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_causes."GLOBAL_ID",
            v_epa_causes.epa_value
           FROM ca_release.v_epa_causes
          WHERE (v_epa_causes.rn = 4)) d ON ((a."GLOBAL_ID" = d."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_causes."GLOBAL_ID",
            v_epa_causes.epa_value
           FROM ca_release.v_epa_causes
          WHERE (v_epa_causes.rn = 5)) e ON ((a."GLOBAL_ID" = e."GLOBAL_ID")))
     LEFT JOIN ( SELECT v_epa_causes."GLOBAL_ID",
            v_epa_causes.epa_value
           FROM ca_release.v_epa_causes
          WHERE (v_epa_causes.rn = 6)) f ON ((a."GLOBAL_ID" = f."GLOBAL_ID")));