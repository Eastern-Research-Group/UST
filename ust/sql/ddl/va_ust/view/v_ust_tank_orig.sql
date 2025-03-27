create or replace view "va_ust"."v_ust_tank_orig" as
 SELECT DISTINCT (a.tank_facility_id)::character varying(50) AS facility_id,
    (a.index)::integer AS tank_id,
    (a.tank_number)::character varying(50) AS tank_name,
    e.tank_status_id,
    (a.federally_regulated_tank)::character varying(7) AS federally_regulated,
        CASE
            WHEN (lower((a.other_contents)::text) ~~ '%em%gen%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS emergency_generator,
    (a.date_closed)::date AS tank_closure_date,
    (a.install_date)::date AS tank_installation_date,
    c.tank_material_description_id,
        CASE
            WHEN (c.tank_material_description_id = ANY (ARRAY[5, 6])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN ((x.tank_material_impressed_current)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((x.tank_material_impressed_current)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN ((x.tank_material_lined_interior)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((x.tank_material_lined_interior)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    d.tank_secondary_containment_id
   FROM ((((((va_ust.tanks a
     LEFT JOIN va_ust.erg_va_tank_materials z ON (((a.index)::text = (z.index)::text)))
     LEFT JOIN va_ust.erg_va_tank_secondary_containment y ON (((a.index)::text = (y.index)::text)))
     LEFT JOIN va_ust.usttankmaterials x ON (((a.index)::text = (x.index)::text)))
     LEFT JOIN va_ust.v_tank_material_description_xwalk c ON ((z.tank_material_description = (c.organization_value)::text)))
     LEFT JOIN va_ust.v_tank_secondary_containment_xwalk d ON ((y.secondary_containment = (d.organization_value)::text)))
     LEFT JOIN va_ust.v_tank_status_xwalk e ON (((a.tank_status)::text = (e.organization_value)::text)))
  WHERE (((a.tank_type)::text = 'UST'::text) AND ((a.federally_regulated_tank)::text = 'Yes'::text));