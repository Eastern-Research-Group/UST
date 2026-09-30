CREATE OR REPLACE VIEW public.v_dispenser AS
 SELECT DISTINCT x."FAC_ID" AS facility_id,
    x."F_NAME" AS facility_name,
    x."TANK_NAME" AS tank_id,
        CASE
            WHEN x."DESCRIPTION_1" = 'AT ALL DISPENSERS'::text THEN 'Yes'::text
            WHEN x."DESCRIPTION_1" = 'AT SOME DISPENSERS'::text THEN 'Yes'::text
            WHEN x."DESCRIPTION_1" = 'NONE'::text THEN 'No'::text
            ELSE NULL::text
        END AS dispenser_udc
   FROM pa_ust.attributes x
  WHERE x."DESCRIPTION" = 'UNDER-DISPENSER CONTAINMENT'::text;
