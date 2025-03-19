create or replace view "ca_release"."v_corrective_actions" as
 SELECT x.r,
    x."GLOBAL_ID",
    x."ACTION",
    x."DATE"
   FROM ( SELECT row_number() OVER (PARTITION BY c."GLOBAL_ID" ORDER BY c."DATE" DESC) AS r,
            c."GLOBAL_ID",
            c."ACTION",
            c."DATE"
           FROM ( SELECT regulatory_activities."GLOBAL_ID",
                    regulatory_activities."ACTION",
                    max(regulatory_activities."DATE") AS "DATE"
                   FROM ca_release.regulatory_activities
                  WHERE ((regulatory_activities."ACTION_TYPE" = 'REMEDIATION'::text) AND (regulatory_activities."ACTION" IS NOT NULL))
                  GROUP BY regulatory_activities."GLOBAL_ID", regulatory_activities."ACTION") c) x
  WHERE (x.r <= 3)
  ORDER BY x."GLOBAL_ID", x."DATE" DESC;