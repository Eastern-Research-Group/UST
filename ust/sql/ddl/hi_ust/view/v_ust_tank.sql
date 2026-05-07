create or replace view "hi_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."AltTankID" AS tank_name,
    ts.tank_status_id,
        CASE
            WHEN (x."Exempt" = true) THEN 'No'::text
            WHEN (x."Exempt" = false) THEN 'Yes'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN (x."EmergGenSoleUse" = true) THEN 'Yes'::text
            WHEN (x."EmergGenSoleUse" = false) THEN 'No'::text
            ELSE NULL::text
        END AS emergency_generator,
        CASE
            WHEN (mt.multi_tank_count > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS multiple_tanks,
    (x."DateClosed")::date AS tank_closure_date,
    (x."InstalledDate")::date AS tank_installation_date,
        CASE
            WHEN (x."Compartment" = true) THEN 'Yes'::text
            WHEN (x."Compartment" = false) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    tm.tank_material_description_id,
        CASE
            WHEN (x."TankCorrosionProtectionSacrificialAnodes" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionSacrificialAnodes" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."TankCorrosionProtectionImpressedCurrent" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionImpressedCurrent" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (x."TankCorrosionProtectionNonCorrodible" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionNonCorrodible" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_cathodic_not_required,
        CASE
            WHEN (x."TankCorrosionProtectionInteriorLining" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionInteriorLining" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    sc.tank_secondary_containment_id
   FROM ((((hi_ust."tblTank" x
     LEFT JOIN hi_ust.v_tank_status_xwalk ts ON ((x."TankStatusDesc" = (ts.organization_value)::text)))
     LEFT JOIN ( SELECT "tblTank"."FacilityID",
            count("tblTank"."TankID") AS multi_tank_count
           FROM hi_ust."tblTank"
          GROUP BY "tblTank"."FacilityID") mt ON ((x."FacilityID" = mt."FacilityID")))
     LEFT JOIN hi_ust.v_tank_material_description_xwalk tm ON ((x."TankMatDesc" = (tm.organization_value)::text)))
     LEFT JOIN hi_ust.v_tank_secondary_containment_xwalk sc ON ((x."TankModsDesc" = (sc.organization_value)::text)));