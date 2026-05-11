create or replace view "ia_ust"."v_ust_tank_substance" as
 SELECT DISTINCT x."ustID" AS facility_id,
    t."tankID" AS tank_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM ((((ia_ust.tblustsite x
     LEFT JOIN ia_ust.tbltank t ON ((x."ustID" = t."ustID")))
     LEFT JOIN ia_ust.tbltankcompartment c ON ((t."tankID" = c."tankID")))
     LEFT JOIN ia_ust.tlkcompcontent cc ON ((c."contentID" = (cc."contentID")::double precision)))
     LEFT JOIN ia_ust.v_substance_xwalk s ON ((cc."contentDescription" = (s.organization_value)::text)))
  WHERE (t."tankID" IS NOT NULL);