create or replace view "tx_ust"."v_tank_corrosion_protection_sac_anode" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN (((t.tank_corrosion_cathodic_factory)::text = 'Y'::text) OR ((t.tank_corrosion_cathodic_field)::text = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionSacrificialAnode"
   FROM tx_ust.tanks t;