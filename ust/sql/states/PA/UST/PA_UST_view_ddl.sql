


/*********** v_ust_facility ***********/


--View definition for pa_ust.v_ust_facility:
 SELECT DISTINCT x."FACILITY_ID" AS facility_id,
    x."FACILITY_NAME" AS facility_name,
    x."FACILITY_ADDRESS1" AS facility_address1,
    x."FACILITY_ADDRESS2" AS facility_address2,
    x."FACILITY_CITY" AS facility_city,
    x."FACILITY_COUNTY" AS facility_county,
    x."FACILITY_ZIP" AS facility_zip_code,
    x."FACILITY_STATE" AS facility_state,
    x."Y" AS facility_latitude,
    x."X" AS facility_longitude,
    x."TANK_OWNER_NAME" AS facility_owner_company_name
   FROM pa_ust.facilities x;;




/*********** v_ust_tank ***********/


--View definition for pa_ust.v_ust_tank:
 SELECT DISTINCT x."OTHER_ID" AS facility_id,
    ("right"(x."SEQ_NUMBER", 3))::integer AS tank_id,
    ts.tank_status_id,
        CASE
            WHEN (eg.emergency_generator = 'NO - EMER GEN'::text) THEN 'No'::text
            WHEN (eg.emergency_generator = 'YES - EMER GEN'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS emergency_generator,
    (x."DATE_INSTALLED")::date AS tank_installation_date,
    tmx.tank_material_description_id,
    tcp.tank_corrosion_protection_sacrificial_anode,
    tcp.tank_corrosion_protection_impressed_current,
    tcp.tank_corrosion_protection_interior_lining,
    tscx.tank_secondary_containment_id
   FROM ((((((((pa_ust.tanks x
     LEFT JOIN pa_ust.v_tank_status_xwalk ts ON ((x."STATUS" = (ts.organization_value)::text)))
     LEFT JOIN pa_ust.v_em_gen eg ON (((x."OTHER_ID" = eg.facility_id) AND (x."PF_NAME" = eg.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = eg.tank_id))))
     LEFT JOIN ( SELECT v_tank_mat.facility_id,
            v_tank_mat.facility_name,
            v_tank_mat.tank_id,
            min(v_tank_mat.row_num) AS ranking
           FROM pa_ust.v_tank_mat
          GROUP BY v_tank_mat.facility_id, v_tank_mat.facility_name, v_tank_mat.tank_id) tm_r ON (((x."OTHER_ID" = tm_r.facility_id) AND (x."PF_NAME" = tm_r.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = tm_r.tank_id))))
     LEFT JOIN pa_ust.v_tank_mat tm ON (((tm_r.facility_id = tm.facility_id) AND (tm_r.facility_name = tm.facility_name) AND (tm_r.tank_id = tm.tank_id) AND (tm.row_num = tm_r.ranking))))
     LEFT JOIN pa_ust.v_tank_material_description_xwalk tmx ON ((tm.tank_material_description = (tmx.organization_value)::text)))
     LEFT JOIN pa_ust.v_tank_cp tcp ON (((x."OTHER_ID" = tcp.facility_id) AND (x."PF_NAME" = tcp.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = tcp.tank_id))))
     LEFT JOIN pa_ust.v_tank_sec_cont tsc ON (((x."OTHER_ID" = tsc.facility_id) AND (x."PF_NAME" = tsc.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = tsc.tank_id))))
     LEFT JOIN pa_ust.v_tank_secondary_containment_xwalk tscx ON ((tsc.tank_secondary_containment = (tscx.organization_value)::text)));;




/*********** v_ust_tank_substance ***********/


--View definition for pa_ust.v_ust_tank_substance:
 SELECT DISTINCT x."OTHER_ID" AS facility_id,
    ("right"(x."SEQ_NUMBER", 3))::integer AS tank_id,
    s.substance_id
   FROM (pa_ust.tanks x
     LEFT JOIN pa_ust.v_substance_xwalk s ON ((x."SUBSTANCE_CODE" = (s.organization_value)::text)));;




/*********** v_ust_compartment ***********/


--View definition for pa_ust.v_ust_compartment:
 SELECT DISTINCT x."OTHER_ID" AS facility_id,
    ("right"(x."SEQ_NUMBER", 3))::integer AS tank_id,
    c.compartment_id,
    cs.compartment_status_id,
    (x."CAPACITY")::integer AS compartment_capacity_gallons,
    o.overfill_prevention_ball_float_valve,
    o.overfill_prevention_flow_shutoff_device,
    o.overfill_prevention_high_level_alarm,
    o.overfill_prevention_other,
    o.overfill_prevention_not_required,
    sp.spill_bucket_installed,
    sp.spill_prevention_not_required,
    swx.spill_bucket_wall_type_id,
    trd.tank_interstitial_monitoring,
    trd.tank_automatic_tank_gauging_release_detection,
    trd.tank_manual_tank_gauging,
    trd.tank_statistical_inventory_reconciliation,
    trd.tank_tightness_testing,
    trd.tank_inventory_control,
    trd.tank_groundwater_monitoring,
    trd.tank_vapor_monitoring
   FROM (((((((pa_ust.tanks x
     LEFT JOIN pa_ust.erg_compartment_id c ON (((x."OTHER_ID" = (c.facility_id)::text) AND (("right"(x."SEQ_NUMBER", 3))::integer = c.tank_id))))
     LEFT JOIN pa_ust.v_compartment_status_xwalk cs ON ((x."STATUS" = (cs.organization_value)::text)))
     LEFT JOIN pa_ust.v_overfill o ON (((x."OTHER_ID" = o.facility_id) AND (x."PF_NAME" = o.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = o.tank_id))))
     LEFT JOIN pa_ust.v_spill_prevention sp ON (((x."OTHER_ID" = sp.facility_id) AND (x."PF_NAME" = sp.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = sp.tank_id))))
     LEFT JOIN pa_ust.v_spill_wall_type sw ON (((x."OTHER_ID" = sw.facility_id) AND (x."PF_NAME" = sw.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = sw.tank_id))))
     LEFT JOIN pa_ust.v_spill_bucket_wall_type_xwalk swx ON ((sw.spill_bucket_wall_type = (swx.organization_value)::text)))
     LEFT JOIN pa_ust.v_tank_rd trd ON (((x."OTHER_ID" = trd.facility_id) AND (x."PF_NAME" = trd.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = trd.tank_id))));;




/*********** v_ust_piping ***********/


--View definition for pa_ust.v_ust_piping:
 SELECT DISTINCT x."OTHER_ID" AS facility_id,
    ("right"(x."SEQ_NUMBER", 3))::integer AS tank_id,
    p.compartment_id,
    (p.piping_id)::character varying(50) AS piping_id,
    psx.piping_style_id,
    ps.safe_suction,
    ps.american_suction,
    pm.piping_material_frp,
    pm.piping_material_stainless_steel,
    pm.piping_material_steel,
    pm.piping_material_copper,
    pm.piping_material_flex,
    pm.piping_material_no_piping,
    pm.piping_material_other,
    pm.piping_material_unknown,
    fc.piping_flex_connector,
    cp.piping_corrosion_protection_sacrificial_anode,
    cp.piping_corrosion_protection_cathodic_not_required,
    pr.piping_line_leak_detector,
    pr.piping_line_test_annual,
    pr.piping_line_test3yr,
    pr.piping_groundwater_monitoring,
    pr.piping_vapor_monitoring,
    pr.piping_interstitial_monitoring,
    pr.piping_statistical_inventory_reconciliation,
    tts.pipe_tank_top_sump,
    pwtx.piping_wall_type_id,
    ar.pipe_trench_liner,
    ar.pipe_secondary_containment_other
   FROM ((((((((((((((pa_ust.tanks x
     LEFT JOIN pa_ust.erg_compartment_id c ON (((x."OTHER_ID" = (c.facility_id)::text) AND (("right"(x."SEQ_NUMBER", 3))::integer = c.tank_id))))
     LEFT JOIN pa_ust.erg_piping_id p ON (((x."OTHER_ID" = (p.facility_id)::text) AND (("right"(x."SEQ_NUMBER", 3))::integer = p.tank_id) AND (c.compartment_id = p.compartment_id))))
     LEFT JOIN ( SELECT v_piping_style.facility_id,
            v_piping_style.facility_name,
            v_piping_style.tank_id,
            min(v_piping_style.row_num) AS ranking
           FROM pa_ust.v_piping_style
          GROUP BY v_piping_style.facility_id, v_piping_style.facility_name, v_piping_style.tank_id) ps_r ON (((x."OTHER_ID" = ps_r.facility_id) AND (x."PF_NAME" = ps_r.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = ps_r.tank_id))))
     LEFT JOIN pa_ust.v_piping_style ps ON (((ps_r.facility_id = ps.facility_id) AND (ps_r.facility_name = ps.facility_name) AND (ps_r.tank_id = ps.tank_id) AND (ps_r.ranking = ps.row_num))))
     LEFT JOIN pa_ust.v_piping_style_xwalk psx ON ((ps.piping_style = (psx.organization_value)::text)))
     LEFT JOIN pa_ust.v_piping_material pm ON (((x."OTHER_ID" = pm.facility_id) AND (x."PF_NAME" = pm.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = pm.tank_id))))
     LEFT JOIN pa_ust.v_flex_connector fc ON (((x."OTHER_ID" = fc.facility_id) AND (x."PF_NAME" = fc.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = fc.tank_id))))
     LEFT JOIN pa_ust.v_corrosion_protection cp ON (((x."OTHER_ID" = cp.facility_id) AND (x."PF_NAME" = cp.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = cp.tank_id))))
     LEFT JOIN pa_ust.v_piping_rd pr ON (((x."OTHER_ID" = pr.facility_id) AND (x."PF_NAME" = pr.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = pr.tank_id))))
     LEFT JOIN pa_ust.v_tank_top_sump tts ON (((x."OTHER_ID" = tts.facility_id) AND (x."PF_NAME" = tts.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = tts.tank_id))))
     LEFT JOIN ( SELECT v_piping_wall_type.facility_id,
            v_piping_wall_type.facility_name,
            v_piping_wall_type.tank_id,
            min(v_piping_wall_type.row_num) AS ranking
           FROM pa_ust.v_piping_wall_type
          GROUP BY v_piping_wall_type.facility_id, v_piping_wall_type.facility_name, v_piping_wall_type.tank_id) pwt_r ON (((x."OTHER_ID" = pwt_r.facility_id) AND (x."PF_NAME" = pwt_r.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = pwt_r.tank_id))))
     LEFT JOIN pa_ust.v_piping_wall_type pwt ON (((pwt_r.facility_id = pwt.facility_id) AND (pwt_r.facility_name = pwt.facility_name) AND (pwt_r.tank_id = pwt.tank_id) AND (pwt_r.ranking = pwt.row_num))))
     LEFT JOIN pa_ust.v_piping_wall_type_xwalk pwtx ON ((pwt."DESCRIPTION_1" = (pwtx.organization_value)::text)))
     LEFT JOIN ( SELECT a."FAC_ID",
            a."F_NAME",
            a."TANK_NAME",
            max(
                CASE
                    WHEN (a."DESCRIPTION_1" = 'TRENCH LINER'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS pipe_trench_liner,
            max(
                CASE
                    WHEN (a."DESCRIPTION_1" = 'JACKETED'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS pipe_secondary_containment_other
           FROM pa_ust.attributes a
          GROUP BY a."FAC_ID", a."F_NAME", a."TANK_NAME") ar ON (((x."OTHER_ID" = ar."FAC_ID") AND (x."PF_NAME" = ar."F_NAME") AND (("right"(x."SEQ_NUMBER", 3))::integer = ar."TANK_NAME"))));;




/*********** v_ust_tank_dispenser ***********/


--View definition for pa_ust.v_ust_tank_dispenser:
 SELECT DISTINCT x."OTHER_ID" AS facility_id,
    ("right"(x."SEQ_NUMBER", 3))::integer AS tank_id,
    (di.dispenser_id)::character varying(50) AS dispenser_id,
    d.dispenser_udc
   FROM ((pa_ust.tanks x
     LEFT JOIN pa_ust.erg_dispenser_id di ON (((x."OTHER_ID" = (di.facility_id)::text) AND (("right"(x."SEQ_NUMBER", 3))::integer = di.tank_id))))
     LEFT JOIN pa_ust.v_dispenser d ON (((x."OTHER_ID" = d.facility_id) AND (x."PF_NAME" = d.facility_name) AND (("right"(x."SEQ_NUMBER", 3))::integer = d.tank_id))));;

