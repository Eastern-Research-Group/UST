create or replace view "ia_ust"."v_ust_tank" as
 SELECT DISTINCT (t."ustID")::text AS facility_id,
    (t."tankID")::integer AS tank_id,
        CASE
            WHEN (ts2.tank_status_id IS NULL) THEN 8
            ELSE ts2.tank_status_id
        END AS tank_status_id,
        CASE
            WHEN ((us."statusDescription" ~~ 'non-regulated%'::text) OR (us."statusDescription" ~~ '%exempt%'::text) OR (us."statusDescription" ~~ '%ust distrib%'::text) OR (us."statusDescription" ~~ '%deleted%'::text) OR (us."statusDescription" ~~ '%1974%'::text)) THEN 'No'::text
            WHEN (us."statusDescription" = 'Other'::text) THEN 'Unknown'::text
            ELSE 'Yes'::text
        END AS federally_regulated,
        CASE
            WHEN (us."statusDescription" ~~ 'Emergency power generator tank%'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS emergency_generator,
        CASE
            WHEN (tankcount.countoftanks > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS multiple_tanks,
    (tankclosuredate."tankDate")::date AS tank_closure_date,
    (tankinstalldate."tankDate")::date AS tank_installation_date,
        CASE
            WHEN (tc.countofcomps > 1) THEN 'Yes'::text
            WHEN (tc.countofcomps = 1) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    (tc.countofcomps)::integer AS number_of_compartments,
    md.tank_material_description_id,
        CASE
            WHEN (epic."externalProtectionID" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (epil."externalProtectionID" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
        CASE
            WHEN (epo."externalProtectionID" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_other,
    coi.cert_of_installation_id,
        CASE
            WHEN (cio."installationID" = 4) THEN 'Tank and Piping Tested for Leaks During and After Installation'::text
            WHEN (cio."installationID" = 7) THEN 'Unknown'::text
            ELSE NULL::text
        END AS cert_of_installation_other
   FROM (((((((((((((((ia_ust.tbltank t
     LEFT JOIN ( SELECT tbltankcompartment."tankID",
            count(tbltankcompartment."tankCompartmentID") AS countofcomps
           FROM ia_ust.tbltankcompartment
          GROUP BY tbltankcompartment."tankID") tc ON ((tc."tankID" = t."tankID")))
     LEFT JOIN ia_ust.erg_tank_status ts ON ((t."tankID" = ts."tankID")))
     LEFT JOIN tank_statuses ts2 ON (((ts.compartment_status)::text = (ts2.tank_status)::text)))
     LEFT JOIN ia_ust.v_tank_statuses_table us ON (((us."ustID" = t."ustID") AND (us.row_num = 1))))
     LEFT JOIN ( SELECT tbltank."ustID",
            count(tbltank."tankID") AS countoftanks
           FROM ia_ust.tbltank
          GROUP BY tbltank."ustID") tankcount ON ((t."ustID" = tankcount."ustID")))
     LEFT JOIN ia_ust.v_tank_closure_table tankclosuredate ON (((tankclosuredate."tankID" = t."tankID") AND (tankclosuredate.row_num = 1))))
     LEFT JOIN ia_ust.v_tank_install_table tankinstalldate ON (((tankinstalldate."tankID" = t."tankID") AND (tankinstalldate.row_num = 1))))
     LEFT JOIN ia_ust.tlkmaterialconstruction mc ON (((mc."materialConstructionID")::double precision = t."materialConstructionID")))
     LEFT JOIN ia_ust.v_tank_material_description_xwalk md ON ((mc."matConDescription" = (md.organization_value)::text)))
     LEFT JOIN ( SELECT DISTINCT ON (ep."tankID") ep."tankID",
            ep."externalProtectionID"
           FROM ia_ust.treltanktoexternalprote ep
          WHERE (ep."externalProtectionID" = 4)
          ORDER BY ep."tankID", ep."lastChanged" DESC) epic ON ((t."tankID" = epic."tankID")))
     LEFT JOIN ( SELECT DISTINCT ON (ep."tankID") ep."tankID",
            ep."externalProtectionID"
           FROM ia_ust.treltanktoexternalprote ep
          WHERE (ep."externalProtectionID" = ANY (ARRAY[(5)::bigint, (6)::bigint, (7)::bigint, (8)::bigint]))
          ORDER BY ep."tankID", ep."lastChanged" DESC) epil ON ((t."tankID" = epil."tankID")))
     LEFT JOIN ( SELECT DISTINCT ON (ep."tankID") ep."tankID",
            ep."externalProtectionID"
           FROM ia_ust.treltanktoexternalprote ep
          WHERE (ep."externalProtectionID" = ANY (ARRAY[(9)::bigint, (10)::bigint]))
          ORDER BY ep."tankID", ep."lastChanged" DESC) epo ON ((t."tankID" = epo."tankID")))
     LEFT JOIN ia_ust.v_cert_install_table ci ON (((ci."tankID" = t."tankID") AND (ci.row_num = 1))))
     LEFT JOIN ia_ust.v_cert_of_installation_xwalk coi ON (((ci."installationID")::text = (coi.organization_value)::text)))
     LEFT JOIN ( SELECT DISTINCT ON (ci_1."tankID") ci_1."tankID",
            ci_1."installationID"
           FROM ia_ust.v_cert_install_table ci_1
          WHERE (ci_1."installationID" = ANY (ARRAY[(4)::bigint, (7)::bigint]))
          ORDER BY ci_1."tankID", ci_1.row_num) cio ON (((cio."tankID")::text = (t."tankID")::text)))
  WHERE (t."tankID" IS NOT NULL);