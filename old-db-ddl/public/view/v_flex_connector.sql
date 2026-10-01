CREATE OR REPLACE VIEW public.v_flex_connector AS
 SELECT DISTINCT x."FAC_ID" AS facility_id,
    x."F_NAME" AS facility_name,
    x."TANK_NAME" AS tank_id,
        CASE
            WHEN x."DESCRIPTION" = 'Piping Flexible Connectors'::text AND (x."DESCRIPTION_1" = ANY (ARRAY['Unprotected Metallic Components (incl wrapped or coated)'::text, 'Cathodically Protected, Metallic'::text, 'Flexible Coupling w/ Protected Metallic Ends'::text, 'Completely Inside Containment Sump, Secondary Pipe or Liner'::text, 'Completely Jacketed w/ Sealed Boot'::text, 'Not in Contact w/ Ground'::text])) THEN 'Yes'::text
            WHEN x."DESCRIPTION" = 'FLEX - TANK END'::text AND x."DESCRIPTION_1" = 'OTHER'::text THEN 'Yes'::text
            WHEN x."DESCRIPTION" = 'FLEX - DISPENSER END'::text AND x."DESCRIPTION_1" = 'OTHER'::text THEN 'Yes'::text
            WHEN x."DESCRIPTION" = 'FLEX - TANK END'::text AND (x."DESCRIPTION_1" = ANY (ARRAY['UNPROTECTED METALLIC COMPONENTS (INCL WRAPPED OR COATED)'::text, 'CATHODICALLY PROTECTED, METALLIC'::text, 'FLEXIBLE COUPLING W/ PROTECTED METALLIC ENDS'::text, 'COMPLETELY INSIDE CONTAINMENT SUMP, SECONDARY PIPE OR LINER'::text, 'COMPLETELY JACKETED W/ SEALED BOOT'::text, 'NOT IN CONTACT W/ GROUND'::text])) THEN 'Yes'::text
            WHEN x."DESCRIPTION" = 'FLEX - DISPENSER END'::text AND (x."DESCRIPTION_1" = ANY (ARRAY['UNPROTECTED METALLIC COMPONENTS (INCL WRAPPED OR COATED)'::text, 'CATHODICALLY PROTECTED, METALLIC'::text, 'FLEXIBLE COUPLING W/ PROTECTED METALLIC ENDS'::text, 'COMPLETELY INSIDE CONTAINMENT SUMP, SECONDARY PIPE OR LINER'::text, 'COMPLETELY JACKETED W/ SEALED BOOT'::text, 'NOT IN CONTACT W/ GROUND'::text])) THEN 'Yes'::text
            WHEN x."DESCRIPTION" = 'Piping Flexible Connectors'::text AND x."DESCRIPTION_1" = 'None'::text THEN 'No'::text
            WHEN x."DESCRIPTION" = 'FLEX - TANK END'::text AND x."DESCRIPTION_1" = 'NONE'::text THEN 'No'::text
            WHEN x."DESCRIPTION" = 'FLEX - DISPENSER END'::text AND x."DESCRIPTION_1" = 'NONE'::text THEN 'No'::text
            ELSE NULL::text
        END AS piping_flex_connector
   FROM pa_ust.attributes x
  WHERE x."DESCRIPTION" = ANY (ARRAY['Piping Flexible Connectors'::text, 'FLEX - TANK END'::text, 'FLEX - DISPENSER END'::text]);
