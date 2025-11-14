create or replace view "nh_ust"."v_ust_tank" as
 SELECT DISTINCT eti.tank_id,
    eti.facility_id,
    (a."TANK_NUMBER")::character varying(50) AS tank_name,
    d.tank_status_id,
        CASE
            WHEN (a."CONSTRUCTION_MATERIAL" = 'FIELD CONSTRUCTED'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS field_constructed,
    (a."PERMANENT_CLOSED_DATE")::date AS tank_closure_date,
    (a."DATE_INSTALLED")::date AS tank_installation_date,
        CASE
            WHEN (a."COMPARTMENT" = 'YES'::text) THEN 'Yes'::text
            WHEN (a."COMPARTMENT" = 'NO'::text) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    c.tank_material_description_id,
        CASE
            WHEN (TRIM(BOTH FROM upper(a."CORROSION_PROTECTION_TANK")) = ANY (ARRAY['REPAIRED SA'::text, 'SACRAFICIAL ANODE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (TRIM(BOTH FROM upper(a."CORROSION_PROTECTION_TANK")) = ANY (ARRAY['IMPRESSED CURRENT'::text, 'REPAIRED IC'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (a."CONSTRUCTION_MATERIAL_SECONDARY_CONTAINMENT" = 'YES'::text) THEN 9
            ELSE NULL::integer
        END AS tank_secondary_containment_id
   FROM (((((nh_ust.tanks a
     JOIN nh_ust.facilities fac ON (((a."FACILITY_ID" = fac."FACILITY_ID") AND (fac."FACILITY_TYPE" <> 'PROPOSED FACILITY'::text))))
     JOIN nh_ust.erg_tank_id eti ON (((a."FACILITY_ID" = (eti.facility_id)::integer) AND (a."TANK_NUMBER" = (eti.tank_name)::text))))
     LEFT JOIN nh_ust.v_tank_material_description_xwalk c ON ((a."CONSTRUCTION_MATERIAL" = (c.organization_value)::text)))
     LEFT JOIN nh_ust.erg_tank_status_values etsv ON (((a."FACILITY_ID" = etsv."FACILITY_ID") AND (a."TANK_NUMBER" = etsv."TANK_NUMBER"))))
     LEFT JOIN nh_ust.v_tank_status_xwalk d ON ((etsv.tank_status = (d.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM nh_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FACILITY_ID")::character varying(50))::text = (unreg.facility_id)::text) AND (eti.tank_id = unreg.tank_id)))));