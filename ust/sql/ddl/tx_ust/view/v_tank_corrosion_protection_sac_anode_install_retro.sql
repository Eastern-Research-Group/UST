create or replace view "tx_ust"."v_tank_corrosion_protection_sac_anode_install_retro" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN ((t.tank_corrosion_cathodic_factory)::text = 'Y'::text) THEN 'Installed'::text
            WHEN ((t.tank_corrosion_cathodic_field)::text = 'Y'::text) THEN 'Retrofitted'::text
            ELSE 'Unknown'::text
        END AS "TankCorrosionProtectionAnodeInstalledOrRetrofitted"
   FROM tx_ust.tanks t;