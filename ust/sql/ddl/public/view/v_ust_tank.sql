create or replace view "public"."v_ust_tank" as
 SELECT DISTINCT c.ust_control_id,
    c.facility_id AS "FacilityID",
    b.tank_id AS "TankID",
    b.tank_name AS "TankName",
    tl.tank_location AS "TankLocation",
    ts.tank_status AS "TankStatus",
    b.federally_regulated AS "FederallyRegulated",
    b.field_constructed AS "FieldConstructed",
    b.emergency_generator AS "EmergencyGenerator",
    b.airport_hydrant_system AS "AirportHydrantSystem",
    b.multiple_tanks AS "MultipleTanks",
    b.tank_closure_date AS "TankClosureDate",
    b.tank_installation_date AS "TankInstallationDate",
    b.compartmentalized_ust AS "CompartmentalizedUST",
    b.number_of_compartments AS "NumberOfCompartments",
    tm.tank_material_description AS "TankMaterialDescription",
        CASE
            WHEN (x.cp_type = 'tank'::text) THEN (((b.tank_corrosion_protection_sacrificial_anode)::text || ' (inferred)'::text))::character varying
            ELSE b.tank_corrosion_protection_sacrificial_anode
        END AS "TankCorrosionProtectionSacrificialAnode",
    b.tank_corrosion_protection_impressed_current AS "TankCorrosionProtectionImpressedCurrent",
    b.tank_corrosion_protection_cathodic_not_required AS "TankCorrosionProtectionCathodicNotRequired",
    b.tank_corrosion_protection_interior_lining AS "TankCorrosionProtectionInteriorLining",
    b.tank_corrosion_protection_other AS "TankCorrosionProtectionOther",
    b.tank_corrosion_protection_unknown AS "TankCorrosionProtectionUnknown",
    tc.tank_secondary_containment AS "TankSecondaryContainment",
    ci.cert_of_installation AS "CertOfInstallation",
    b.cert_of_installation_other AS "CertOfInstallationOther",
    b.tank_comment AS "TankComment"
   FROM (((((((ust_tank b
     JOIN ust_facility c ON ((b.ust_facility_id = c.ust_facility_id)))
     LEFT JOIN tank_locations tl ON ((b.tank_location_id = tl.tank_location_id)))
     LEFT JOIN tank_material_descriptions tm ON ((b.tank_material_description_id = tm.tank_material_description_id)))
     LEFT JOIN tank_secondary_containments tc ON ((b.tank_secondary_containment_id = tc.tank_secondary_containment_id)))
     LEFT JOIN tank_statuses ts ON ((b.tank_status_id = ts.tank_status_id)))
     LEFT JOIN cert_of_installations ci ON ((b.cert_of_installation_id = ci.cert_of_installation_id)))
     LEFT JOIN v_cp_inferred x ON (((c.ust_control_id = x.ust_control_id) AND (x.cp_type = 'tank'::text))));