create or replace view "az_ust"."v_ust_tank" as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankName")::integer AS tank_id,
    (a."TankName")::character varying(50) AS tank_name,
    b.tank_location_id,
    e.tank_status_id,
    (a."FederallyRegulated")::character varying(7) AS federally_regulated,
    (a."FieldConstructed")::character varying(7) AS field_constructed,
    (a."EmergencyGenerator")::character varying(7) AS emergency_generator,
    (a."AirportHydrantSystem")::character varying(7) AS airport_hydrant_system,
    (a."TankClosureDate")::date AS tank_closure_date,
    (a."TankInstallationDate")::date AS tank_installation_date,
    (a."CompartmentalizedUST")::character varying(7) AS compartmentalized_ust,
    (a."NumberOfCompartments")::integer AS number_of_compartments,
    c.tank_material_description_id,
    (a."TankCorrosionProtectionSacrificialAnode")::character varying(7) AS tank_corrosion_protection_sacrificial_anode,
    (a."TankCorrosionProtectionImpressedCurrent")::character varying(7) AS tank_corrosion_protection_impressed_current,
    (a."TankCorrosionProtectionInteriorLining")::character varying(7) AS tank_corrosion_protection_interior_lining,
    d.tank_secondary_containment_id
   FROM ((((az_ust.ust_tank a
     LEFT JOIN az_ust.v_tank_location_xwalk b ON ((a."TankLocation" = (b.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_material_description_xwalk c ON ((a."TankMaterialDescription" = (c.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_secondary_containment_xwalk d ON ((a."TankSecondaryContainment" = (d.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_status_xwalk e ON ((a."TankStatus" = (e.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM az_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankName")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
           FROM az_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankName")::integer = unreg.tank_id))))));