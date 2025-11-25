create or replace view "va_ust"."v_ust_piping_orig" as
 SELECT DISTINCT z.tank_facility_id AS facility_id,
    (z.index)::integer AS tank_id,
    (y.index)::integer AS compartment_id,
    (a.index)::character varying(50) AS piping_id,
    b.piping_style_id,
        CASE
            WHEN ((a.pipe_material_fiberglass)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_fiberglass)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN ((a.pipe_material_galvanized_steel)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_galvanized_steel)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (lower((a.pipe_material_other_specify)::text) ~~ '%stainless%steel%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN ((a.pipe_material_cathodically_protected)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_cathodically_protected)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN ((a.pipe_material_copper)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_copper)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN ((a.pipe_material_polyflexible)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_polyflexible)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (lower((a.pipe_material_other_specify)::text) = 'no piping'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN ((a.pipe_material_other)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_other)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN ((a.pipe_material_unknown)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_unknown)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (lower((a.pipe_material_other_specify)::text) ~~ '%flex%connector%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_flex_connector,
        CASE
            WHEN ((a.pipe_material_cathodically_protected)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_cathodically_protected)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN ((a.pipe_material_impressed_current)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_impressed_current)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
        CASE
            WHEN ((a.pipe_material_other)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_other)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_other,
        CASE
            WHEN ((a.pipe_material_unknown)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.pipe_material_unknown)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_unknown,
        CASE
            WHEN ((y.pipe_rd_alld)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((y.pipe_rd_alld)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN ((y.pipe_rd_tightness_testing)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((y.pipe_rd_tightness_testing)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN ((y.pipe_rd_groundwater_monitoring)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((y.pipe_rd_groundwater_monitoring)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN ((y.pipe_rd_vapor_monitoring)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((y.pipe_rd_vapor_monitoring)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN ((y.pipe_rd_im_secondary_containment)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((y.pipe_rd_im_secondary_containment)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN ((y.pipe_rd_sir)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((y.pipe_rd_sir)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN ((y.pipe_rd_other)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((y.pipe_rd_other)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
    c.piping_wall_type_id
   FROM ((((va_ust.ustpipematerials a
     JOIN va_ust.tanks z ON ((((a.tank_facility_id)::text = (z.tank_facility_id)::text) AND ((a.tank_number)::text = (z.tank_number)::text) AND ((a.tank_owner_id)::text = (z.tank_owner_id)::text))))
     JOIN va_ust.usttankpipereleasedetection y ON ((((a.tank_facility_id)::text = (y.tank_facility_id)::text) AND ((a.tank_number)::text = (y.tank_number)::text) AND ((a.tank_owner_id)::text = (y.tank_owner_id)::text))))
     LEFT JOIN va_ust.v_piping_style_xwalk b ON (((a.piping_type)::text = (b.organization_value)::text)))
     LEFT JOIN va_ust.v_piping_wall_type_xwalk c ON (((y.pipe_rd_im_double_walled_tank)::text = (c.organization_value)::text)))
  WHERE (((a.tank_type)::text = 'UST'::text) AND ((z.federally_regulated_tank)::text = 'Yes'::text));