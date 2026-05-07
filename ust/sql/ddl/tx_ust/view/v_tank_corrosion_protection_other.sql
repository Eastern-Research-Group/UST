create or replace view "tx_ust"."v_tank_corrosion_protection_other" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN (((t.tank_corrosion_external_dielectric)::text = 'Y'::text) OR ((t.tank_corrosion_composite)::text = 'Y'::text) OR ((t.tank_corrosion_coated)::text = 'Y'::text) OR ((t.tank_corrosion_frp)::text = 'Y'::text) OR ((t.tank_corrosion_external_jacket)::text = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionOther"
   FROM tx_ust.tanks t;