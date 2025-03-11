create or replace view "tx_ust"."v_manual_tank_gauging" as
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    c.compartment_id,
        CASE
            WHEN (((c.compartment_rd_manual_tank_gauge)::text = 'Y'::text) OR ((c.compartment_rd_monthly_tank_gauge)::text = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "ManualTankGauging"
   FROM tx_ust.compartments c;