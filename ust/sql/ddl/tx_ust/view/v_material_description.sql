create or replace view "tx_ust"."v_material_description" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN ((t.tank_material_steel)::text = 'Y'::text) THEN 'Steel'::text
            WHEN ((t.tank_material_frp)::text = 'Y'::text) THEN 'Fiberglass reinforced plastic'::text
            WHEN ((t.tank_material_concrete)::text = 'Y'::text) THEN 'Concrete'::text
            WHEN ((t.tank_material_jacketed)::text = 'Y'::text) THEN 'Jacketed steel'::text
            WHEN ((t.tank_material_coated)::text = 'Y'::text) THEN 'Epoxy coated steel'::text
            ELSE NULL::text
        END AS "MaterialDescription"
   FROM tx_ust.tanks t;