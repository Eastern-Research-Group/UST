create or replace view "dc_ust"."v_cert_of_installation_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.cert_of_installation_id
   FROM (v_ust_element_mapping a
     LEFT JOIN cert_of_installations b ON (((a.epa_value)::text = (b.cert_of_installation)::text)))
  WHERE ((a.ust_control_id = 30) AND ((a.epa_column_name)::text = 'cert_of_installation_id'::text));