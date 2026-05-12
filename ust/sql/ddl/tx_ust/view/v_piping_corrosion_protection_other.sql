create or replace view "tx_ust"."v_piping_corrosion_protection_other" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN (((t.piping_corrosion_cathodic_factory)::text = 'Y'::text) OR ((t.piping_corrosion_cathodic_field)::text = 'Y'::text) OR ((t.piping_corrosion_frp)::text = 'Y'::text) OR ((t.piping_corrosion_flex)::text = 'Y'::text) OR ((t.piping_corrosion_isolated)::text = 'Y'::text) OR ((t.piping_corrosion_dual)::text = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "PipingCorrosionProtectionOther"
   FROM tx_ust.tanks t;