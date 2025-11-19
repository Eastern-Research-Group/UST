create or replace view "sd_ust"."v_ust_tank" as
 SELECT DISTINCT (a."FacilityNumber")::character varying(50) AS facility_id,
    (a."TankNumber")::integer AS tank_id,
    (a."TankNumber")::character varying(50) AS tank_name,
    COALESCE(d.tank_status_id, 8) AS tank_status_id,
        CASE
            WHEN (a."TankRemovedYear" = ANY (ARRAY['04/10/1991'::text, '11/15/1989'::text])) THEN to_date(a."TankRemovedYear", 'mm/dd/yyyy'::text)
            ELSE to_date(((a."TankRemovedYear")::character varying)::text, 'yyyy'::text)
        END AS tank_closure_date,
        CASE
            WHEN (a."TankInstalledYear" = '1899'::double precision) THEN NULL::date
            ELSE to_date(((a."TankInstalledYear")::character varying)::text, 'yyyy'::text)
        END AS tank_installation_date,
        CASE
            WHEN (a."TankCompartmentNumber" > (1)::double precision) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    sd_ust.getmaxcompartment((a."FacilityNumber")::character varying, a."TankNumber") AS number_of_compartments,
    b.tank_material_description_id,
        CASE
            WHEN (a."TankConstructionName" = ANY (ARRAY['DW/STIP3'::text, 'DW/STIP3/Compart'::text, 'STIP3'::text, 'STIP3/Compart'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (a."TankConstructionName" = ANY (ARRAY['Lined w/ Impressed'::text, 'Steel/Impressed'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (a."TankConstructionName" = ANY (ARRAY['Lined Interior'::text, 'Lined w/ Impressed'::text, 'Painted Steel w/ Lining'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    c.tank_secondary_containment_id
   FROM (((sd_ust.tanks a
     LEFT JOIN sd_ust.v_tank_material_description_xwalk b ON ((a."TankConstructionName" = (b.organization_value)::text)))
     LEFT JOIN sd_ust.v_tank_secondary_containment_xwalk c ON ((a."TankConstructionName" = (c.organization_value)::text)))
     LEFT JOIN sd_ust.v_tank_status_xwalk d ON ((a."StatusName" = (d.organization_value)::text)))
  WHERE (a."FacilityType" = 'UST'::text);