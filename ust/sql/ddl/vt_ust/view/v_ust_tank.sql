create or replace view "vt_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."TankName" AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."EmergencyGenerator" AS emergency_generator,
    x."MultipleTanks" AS multiple_tanks,
        CASE
            WHEN (x."TankInstallationDate" IS NULL) THEN NULL::date
            ELSE (concat((floor(x."TankInstallationDate"))::text, '-01-01'))::date
        END AS tank_installation_date,
    x."CompartmentalizedUST" AS compartmentalized_ust,
    (x."NumberOfCompartments")::integer AS number_of_compartments,
    tm.tank_material_description_id,
        CASE
            WHEN (x."TankCorrosionProtectionSacrificialAnode" = 'No YES'::text) THEN 'Yes'::text
            ELSE x."TankCorrosionProtectionSacrificialAnode"
        END AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" AS tank_corrosion_protection_other,
    tsc.tank_secondary_containment_id
   FROM (((((vt_ust.tank x
     LEFT JOIN vt_ust.facility f ON ((x."FacilityID" = f."FacilityID")))
     LEFT JOIN vt_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN vt_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN vt_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN vt_ust.v_tank_secondary_containment_xwalk tsc ON ((x."TankSecondaryContainment" = (tsc.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))) AND (f."FacilityType1" <> 'Wombat'::text) AND (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))));