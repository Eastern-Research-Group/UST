create or replace view "tx_ust"."v_piping_material_description" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN ((t.piping_material_steel)::text = 'Y'::text) THEN 'Steel'::text
            WHEN ((t.piping_material_frp)::text = 'Y'::text) THEN 'Fiberglass reinforced plastic'::text
            WHEN ((t.piping_material_concrete)::text = 'Y'::text) THEN 'Other'::text
            WHEN ((t.piping_material_jacketed)::text = 'Y'::text) THEN 'Other'::text
            WHEN ((t.piping_material_flex_pipe)::text = 'Y'::text) THEN 'Flex piping'::text
            ELSE NULL::text
        END AS "PipingMaterialDescription"
   FROM tx_ust.tanks t;