create or replace view "me_ust"."v_ust_tank" as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    tl.tank_location_id,
    ts.tank_status_id,
        CASE
            WHEN (x."FED REGULATED" = 'Y'::text) THEN 'Yes'::text
            WHEN (x."FED REGULATED" = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN ((x."TANK STATUS" = 'REMOVED'::text) AND (NULLIF(x."TANK STATUS DATE", ' '::text) IS NOT NULL)) THEN (NULLIF(x."TANK STATUS DATE", ' '::text))::date
            WHEN ((x."TANK STATUS" = 'ABANDONED_IN_PLACE'::text) AND (NULLIF(x."TANK STATUS DATE", ' '::text) IS NOT NULL)) THEN (NULLIF(x."TANK STATUS DATE", ' '::text))::date
            ELSE NULL::date
        END AS tank_closure_date,
    (NULLIF(x."DATE TANK INSTALLED", ' '::text))::date AS tank_installation_date,
    tm.tank_material_description_id,
        CASE
            WHEN (tm.tank_material_description_id = ANY (ARRAY[5, 6])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode
   FROM (((me_ust.tanks x
     LEFT JOIN me_ust.v_tank_location_xwalk tl ON ((x."TANK ABOVE BELOW" = (tl.organization_value)::text)))
     LEFT JOIN me_ust.v_tank_status_xwalk ts ON ((x."TANK STATUS" = (ts.organization_value)::text)))
     LEFT JOIN me_ust.v_tank_material_description_xwalk tm ON ((x."TANK MATERIAL LABEL" = (tm.organization_value)::text)))
  WHERE (x."TANK STATUS" <> ALL (ARRAY['ACTIVE_NON_REGULATED'::text, 'NEVER_INSTALLED'::text, 'PLANNED'::text, 'TRANSFER'::text]));