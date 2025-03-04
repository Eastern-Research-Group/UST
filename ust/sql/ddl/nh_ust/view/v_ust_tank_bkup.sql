create or replace view "nh_ust"."v_ust_tank_bkup" as
 SELECT DISTINCT (x."FACILITY_ID")::character varying(50) AS facility_id,
    et.tank_id,
    (x."TANK_NUMBER")::character varying(50) AS tank_name,
    ts.tank_status_id,
    (x."PERMANENT_CLOSED_DATE")::date AS tank_closure_date,
    (x."DATE_INSTALLED")::date AS tank_installation_date,
    (initcap(x."COMPARTMENT"))::character varying(7) AS compartmentalized_ust,
    md.tank_material_description_id,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."CORROSION_PROTECTION_TANK")) = ANY (ARRAY['REPAIRED SA'::text, 'SACRAFICIAL ANODE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."CORROSION_PROTECTION_TANK")) = ANY (ARRAY['IMPRESSED CURRENT'::text, 'REPAIRED IC'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current
   FROM (((nh_ust.tanks x
     JOIN nh_ust.erg_tank et ON ((((et.facility_id)::integer = x."FACILITY_ID") AND ((et.tank_name)::text = x."TANK_NUMBER"))))
     LEFT JOIN nh_ust.v_tank_status_xwalk ts ON ((x."STATUS" = (ts.organization_value)::text)))
     LEFT JOIN nh_ust.v_tank_material_description_xwalk md ON ((x."CONSTRUCTION_MATERIAL" = (md.organization_value)::text)));