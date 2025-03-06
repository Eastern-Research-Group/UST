------------------------------------------------------------------------------------------------------------------------



/*********** v_ust_tank_substance ***********/
--There are 1081 rows in me_ust.v_ust_tank_substance that do not exist in public.v_ust_tank_substance

select * from me_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;

--View definition for me_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM (me_ust.tanks x
     LEFT JOIN me_ust.v_substance_xwalk s ON ((x."PRODUCT STORED" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM me_ust.erg_unregulated_tanks unreg
          WHERE ((((x."REGISTRATION NUMBER")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TANK NUMBER")::integer = unreg.tank_id)))));


/*********** v_ust_compartment_substance ***********/
--There are 1153 rows in me_ust.v_ust_compartment_substance that do not exist in public.v_ust_compartment_substance

select * from me_ust.v_ust_compartment_substance a
where not exists
	(select 1 from public.v_ust_compartment_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.compartment_id,a.substance_id;

--View definition for me_ust.v_ust_compartment_substance:
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    x."CHAMBER ID" AS compartment_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM (me_ust.tanks x
     LEFT JOIN me_ust.v_substance_xwalk s ON ((x."PRODUCT STORED" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM me_ust.erg_unregulated_tanks unreg
          WHERE ((((x."REGISTRATION NUMBER")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TANK NUMBER")::integer = unreg.tank_id)))));


/*********** v_ust_piping ***********/
--There are 1171 rows in me_ust.v_ust_piping that do not exist in public.v_ust_piping

select * from me_ust.v_ust_piping a
where not exists
	(select 1 from public.v_ust_piping b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.piping_id = b."PipingID")
order by a.facility_id,a.tank_id,a.compartment_id,a.piping_id;

--View definition for me_ust.v_ust_piping:
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    (x."CHAMBER ID")::integer AS compartment_id,
    (t.piping_id)::text AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = ANY (ARRAY['SEC_CONT_CONTIN_ELEC_MON'::text, 'SEC_CONT_MANUAL_MON'::text, 'SECONDARY_CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'DOUBLE-WALLED CP STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'INLINE_LEAK_DETECTOR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['COPPER'::text, 'COPPER WITH SECONDARY CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'FLEXIBLE DOUBLE-WALLED PIPING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'GALVANIZED STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'NONE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'OTHER'::text) THEN 'Yes'::text
            WHEN (x."PIPE MATERIAL LABEL" <> ALL (ARRAY['GALVANIZED STEEL'::text, 'STAINLESS STEEL'::text, 'CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text, 'FLEXIBLE DOUBLE-WALLED PIPING'::text, 'NONE'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'STAINLESS STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN ((x."PIPE LEAK DETECTION" IS NOT NULL) AND (x."PIPE LEAK DETECTION" <> ALL (ARRAY['INLINE_LEAK_DETECTOR'::text, 'CONTINUOUS_VAPOR_MONITORING'::text, 'MONTHLY_SIR'::text, 'NONE'::text, 'UNKNOWN'::text]))) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'MONTHLY_SIR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'CONTINUOUS_VAPOR_MONITORING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring
   FROM ((me_ust.tanks x
     JOIN me_ust.erg_piping_id t ON ((((x."REGISTRATION NUMBER")::text = (t.facility_id)::text) AND ((x."TANK NUMBER")::text = (t.tank_id)::text) AND ((x."CHAMBER ID")::text = (t.compartment_id)::text))))
     LEFT JOIN me_ust.v_piping_style_xwalk ps ON ((x."CHAMBER_PUMP_TYPE_LABEL" = (ps.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM me_ust.erg_unregulated_tanks unreg
          WHERE ((((x."REGISTRATION NUMBER")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TANK NUMBER")::integer = unreg.tank_id)))));------------------------------------------------------------------------------------------------------------------------



/*********** v_ust_piping ***********/
--There are 1171 rows in me_ust.v_ust_piping that do not exist in public.v_ust_piping

select * from me_ust.v_ust_piping a
where not exists
	(select 1 from public.v_ust_piping b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.piping_id = b."PipingID")
order by a.facility_id,a.tank_id,a.compartment_id,a.piping_id;

--View definition for me_ust.v_ust_piping:
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    (x."CHAMBER ID")::integer AS compartment_id,
    (t.piping_id)::text AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = ANY (ARRAY['SEC_CONT_CONTIN_ELEC_MON'::text, 'SEC_CONT_MANUAL_MON'::text, 'SECONDARY_CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'DOUBLE-WALLED CP STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'INLINE_LEAK_DETECTOR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['COPPER'::text, 'COPPER WITH SECONDARY CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'FLEXIBLE DOUBLE-WALLED PIPING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'GALVANIZED STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'NONE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'OTHER'::text) THEN 'Yes'::text
            WHEN (x."PIPE MATERIAL LABEL" <> ALL (ARRAY['GALVANIZED STEEL'::text, 'STAINLESS STEEL'::text, 'CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text, 'FLEXIBLE DOUBLE-WALLED PIPING'::text, 'NONE'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'STAINLESS STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN ((x."PIPE LEAK DETECTION" IS NOT NULL) AND (x."PIPE LEAK DETECTION" <> ALL (ARRAY['INLINE_LEAK_DETECTOR'::text, 'CONTINUOUS_VAPOR_MONITORING'::text, 'MONTHLY_SIR'::text, 'NONE'::text, 'UNKNOWN'::text]))) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'MONTHLY_SIR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'CONTINUOUS_VAPOR_MONITORING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring
   FROM ((me_ust.tanks x
     JOIN me_ust.erg_piping_id t ON ((((x."REGISTRATION NUMBER")::text = (t.facility_id)::text) AND ((x."TANK NUMBER")::text = (t.tank_id)::text) AND ((x."CHAMBER ID")::text = (t.compartment_id)::text))))
     LEFT JOIN me_ust.v_piping_style_xwalk ps ON ((x."CHAMBER_PUMP_TYPE_LABEL" = (ps.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM me_ust.erg_unregulated_tanks unreg
          WHERE ((((x."REGISTRATION NUMBER")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TANK NUMBER")::integer = unreg.tank_id)))));