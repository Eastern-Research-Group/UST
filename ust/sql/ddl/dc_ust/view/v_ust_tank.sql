create or replace view "dc_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankName")::integer AS tank_id,
    x."TankID" AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."EmergencyGenerator" AS emergency_generator,
    x."MultipleTanks" AS multiple_tanks,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
        CASE
            WHEN (c.comp_count > 1) THEN 'Yes'::text
            WHEN (c.comp_count = 1) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    (c.comp_count)::integer AS number_of_compartments,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificialAnode" AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" AS tank_corrosion_protection_other,
    x."TankCorrosionProtectionUnknown" AS tank_corrosion_protection_unknown,
    tsc.tank_secondary_containment_id,
    coi.cert_of_installation_id
   FROM ((((((dc_ust.tank x
     LEFT JOIN dc_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN dc_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN dc_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN dc_ust.v_tank_secondary_containment_xwalk tsc ON ((x."TankSecondaryContainment" = (tsc.organization_value)::text)))
     LEFT JOIN dc_ust.v_cert_of_installation_xwalk coi ON ((x."CertOfInstallation" = (coi.organization_value)::text)))
     LEFT JOIN ( SELECT compartment."TankID",
            count(compartment."CompartmentID") AS comp_count
           FROM dc_ust.compartment
          GROUP BY compartment."TankID") c ON ((x."TankID" = c."TankID")))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM dc_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankName")::integer = unreg.tank_id)))));