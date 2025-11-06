create or replace view "dc_ust"."v_ust_piping" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (t."TankName")::integer AS tank_id,
    (c."CompartmentName")::integer AS compartment_id,
    x."PipingID" AS piping_id,
    ps.piping_style_id,
    x."Safe Suction" AS safe_suction,
    x."American Suction" AS american_suction,
    x."Piping Material FRP" AS piping_material_frp,
    x."Piping Material Gal Steel" AS piping_material_gal_steel,
    x."Piping Material Stainless Steel" AS piping_material_stainless_steel,
    x."Piping Material Steel" AS piping_material_steel,
    x."Piping Material Copper" AS piping_material_copper,
    x."Piping Material Flex" AS piping_material_flex,
    x."Piping Material No Piping" AS piping_material_no_piping,
    x."Piping Material Other" AS piping_material_other,
    x."Piping Material Unknown" AS piping_material_unknown,
    x."Piping Corrosion Protection Sacrificial Anode" AS piping_corrosion_protection_sacrificial_anode,
    x."Piping Corrosion Protection Impressed Current" AS piping_corrosion_protection_impressed_current,
    x."Piping Corrosion Protection Cathodic Not Required" AS piping_corrosion_protection_cathodic_not_required,
    x."Piping Corrosion Protection Other" AS piping_corrosion_protection_other,
    x."Piping Corrosion Protection Unknown" AS piping_corrosion_protection_unknown,
    x."Piping Line Leak Detector" AS piping_line_leak_detector,
    x."Piping Automated Intersticial Monitoring" AS piping_automated_interstitial_monitoring,
    x."Piping Line Test Annual" AS piping_line_test_annual,
    x."Piping Line Test3yr" AS piping_line_test3yr,
    x."Piping Groundwater Monitoring" AS piping_groundwater_monitoring,
    x."Piping Vapor Monitoring" AS piping_vapor_monitoring,
    x."Piping Interstitial Monitoring" AS piping_interstitial_monitoring,
    x."Piping Statistical Inventory Reconciliation" AS piping_statistical_inventory_reconciliation,
    x."Piping Release Detection Other" AS piping_release_detection_other,
    x."Piping Subpart KLine Test" AS piping_subpart_k_line_test,
    x."Piping Subpart KOther" AS piping_subpart_k_other,
    x."Pipe Tank Top Sump" AS pipe_tank_top_sump,
    pw.piping_wall_type_id,
    x."Pipe Trench Liner" AS pipe_trench_liner,
    x."Pipe Secondary Containment Other" AS pipe_secondary_containment_other,
    x."Pipe Secondary Containment Unknown" AS pipe_secondary_containment_unknown
   FROM ((((dc_ust.piping x
     JOIN dc_ust.tank t ON ((((x."FacilityID")::text = (t."FacilityID")::text) AND (x."TankID" = t."TankID"))))
     JOIN dc_ust.compartment c ON ((((x."FacilityID")::text = (c."FacilityID")::text) AND (x."CompartmentID" = c."CompartmentID"))))
     LEFT JOIN dc_ust.v_piping_style_xwalk ps ON ((x."Piping Style" = (ps.organization_value)::text)))
     LEFT JOIN dc_ust.v_piping_wall_type_xwalk pw ON ((x."Piping Wall Type" = (pw.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM dc_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((t."TankName")::integer = unreg.tank_id)))));