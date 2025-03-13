create or replace view "sd_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityNumber")::character varying(50) AS facility_id,
    (x."TankNumber")::integer AS tank_id,
    (x."TankNumber")::character varying(50) AS tank_name,
    COALESCE(ts.tank_status_id, 8) AS tank_status_id,
        CASE
            WHEN (x."TankRemovedYear" = ANY (ARRAY['04/10/1991'::text, '11/15/1989'::text])) THEN to_date(x."TankRemovedYear", 'mm/dd/yyyy'::text)
            ELSE to_date(((x."TankRemovedYear")::character varying)::text, 'yyyy'::text)
        END AS tank_closure_date,
        CASE
            WHEN (x."TankInstalledYear" = '1899'::double precision) THEN NULL::date
            ELSE to_date(((x."TankInstalledYear")::character varying)::text, 'yyyy'::text)
        END AS tank_installation_date,
        CASE
            WHEN (x."TankCompartmentNumber" > (1)::double precision) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    sd_ust.getmaxcompartment((x."FacilityNumber")::character varying, x."TankNumber") AS number_of_compartments,
    md.tank_material_description_id,
        CASE
            WHEN (x."TankConstructionName" = ANY (ARRAY['DW/STIP3'::text, 'DW/STIP3/Compart'::text, 'STIP3'::text, 'STIP3/Compart'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."TankConstructionName" = ANY (ARRAY['Lined w/ Impressed'::text, 'Steel/Impressed'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (x."TankConstructionName" = ANY (ARRAY['Lined Interior'::text, 'Lined w/ Impressed'::text, 'Painted Steel w/ Lining'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    sc.tank_secondary_containment_id
   FROM (((sd_ust.tanks x
     LEFT JOIN sd_ust.v_tank_status_xwalk ts ON ((x."StatusName" = (ts.organization_value)::text)))
     LEFT JOIN sd_ust.v_tank_material_description_xwalk md ON ((x."TankConstructionName" = (md.organization_value)::text)))
     LEFT JOIN sd_ust.v_tank_secondary_containment_xwalk sc ON ((x."TankConstructionName" = (sc.organization_value)::text)))
  WHERE (x."FacilityType" = 'UST'::text);