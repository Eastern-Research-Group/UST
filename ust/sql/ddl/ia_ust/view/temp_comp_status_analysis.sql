create or replace view "ia_ust"."temp_comp_status_analysis" as
 SELECT a."tankID",
    a."tankCompartmentID",
    b."compStatusID",
    c."statusDescription",
    d.epa_value,
    e.status_hierarchy,
    e.status_comment
   FROM ((((ia_ust.tbltankcompartment a
     JOIN ia_ust.trelcomptostatus b ON ((a."tankCompartmentID" = b."tankCompartmentID")))
     JOIN ia_ust.tlkcompstatus c ON ((b."compStatusID" = c."compStatusID")))
     LEFT JOIN ( SELECT v_ust_element_mapping.organization_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE ((v_ust_element_mapping.ust_control_id = 32) AND ((v_ust_element_mapping.epa_column_name)::text = 'compartment_status_id'::text))) d ON ((c."statusDescription" = (d.organization_value)::text)))
     LEFT JOIN compartment_statuses e ON (((d.epa_value)::text = (e.compartment_status)::text)))
  WHERE ((b."statusEndDate" IS NULL) AND (d.epa_value IS NOT NULL));