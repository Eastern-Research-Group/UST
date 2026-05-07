create or replace view "ca_ust"."v_ust_tank" as
 SELECT DISTINCT (x."CERS ID")::character varying(50) AS facility_id,
    t.tank_id,
    (x."CERS TankID")::character varying(50) AS tank_name,
    ts.tank_status_id,
        CASE
            WHEN (x."Tank Use" = 'Airport Hydrant System'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS airport_hydrant_system,
    (x."Date UST _Permanently _Closed")::date AS tank_closure_date,
    (x."Date UST _System _Installed")::date AS tank_installation_date,
        CASE
            WHEN (x."Tank _Configuration" = 'One in a Compartmented Unit'::text) THEN 'Yes'::text
            WHEN (x."Tank _Configuration" = 'A Stand-alone Tank'::text) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    (x."Number of _Compartments _in the Unit")::integer AS number_of_compartments,
    md.tank_material_description_id,
    (x."Sacrificial_Anode")::character varying(7) AS tank_corrosion_protection_sacrificial_anode,
    (x."Impressed_Current")::character varying(7) AS tank_corrosion_protection_impressed_current,
    (x."Isolation")::character varying(7) AS tank_corrosion_protection_other,
    sc.tank_secondary_containment_id
   FROM ((((ca_ust.tank x
     JOIN ca_ust.erg_tank_id t ON (((((x."CERS ID")::character varying(50))::text = (t.facility_id)::text) AND (((x."CERS TankID")::character varying(50))::text = (t.tank_name)::text))))
     LEFT JOIN ca_ust.v_tank_status_xwalk ts ON ((x."Type of Action" = (ts.organization_value)::text)))
     LEFT JOIN ca_ust.v_tank_material_description_xwalk md ON ((x."Tank Primary _Containment _Construction " = (md.organization_value)::text)))
     LEFT JOIN ca_ust.v_tank_secondary_containment_xwalk sc ON ((x."Tank Secondary _Containment _Construction " = (sc.organization_value)::text)));