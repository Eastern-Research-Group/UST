create or replace view "ut_ust"."v_ust_tank" as
 SELECT DISTINCT (x.facility_id)::character varying(50) AS facility_id,
    (x.tank_id)::integer AS tank_id,
    vtsx.tank_status_id,
    (x."FEDERALREG")::character varying(7) AS federally_regulated,
    (x."TANKEMERGE")::character varying(7) AS emergency_generator,
    (x."DATECLOSE")::date AS tank_closure_date,
    (x."DATEINSTAL")::date AS tank_installation_date,
    vtmdx.tank_material_description_id,
        CASE x."TANKMATDES"
            WHEN 'Impressed Current Cathodic Protection'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE x."TANKMODSDE"
            WHEN 'Lined Interior'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    s.tank_secondary_containment_id,
        CASE
            WHEN (vtmdx.tank_material_description_id = ANY (ARRAY[5, 6])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE x."TANKMATDES"
            WHEN 'Epoxy Coated Steel (STIP2)'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_other
   FROM ((((ut_ust.ut_tank x
     LEFT JOIN ut_ust.v_tank_status_xwalk vtsx ON (((vtsx.organization_value)::text = TRIM(BOTH FROM ((x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text))))))
     LEFT JOIN ut_ust.v_tank_material_description_xwalk vtmdx ON (((vtmdx.organization_value)::text = x."TANKMATDES")))
     LEFT JOIN ut_ust.v_tank_secondary_containment_xwalk s ON (((s.organization_value)::text = x."TANKMODSDE")))
     LEFT JOIN ut_ust.erg_substance esm ON (((esm.facility_id = x.facility_id) AND (esm.tank_id = x.tank_id))))
  WHERE ((x."FEDERALREG" = 'Yes'::text) AND (x."TANKSTATUS" <> 'Install in Process'::text) AND (x.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE ((y."TANK" = 1) AND (y."OPENREGAST" = 0) AND (y."REGAST" = 0)))) AND (NOT (EXISTS ( SELECT 1
           FROM ut_ust.erg_unregulated_tanks unreg
          WHERE ((((x.facility_id)::character varying(50))::text = (unreg.facility_id)::text) AND ((x.tank_id)::integer = unreg.tank_id))))));