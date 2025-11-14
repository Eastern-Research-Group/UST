create or replace view "sd_ust"."v_piping_style_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.piping_style_id
   FROM (v_ust_element_mapping a
     LEFT JOIN piping_styles b ON (((a.epa_value)::text = (b.piping_style)::text)))
  WHERE ((a.ust_control_id = 9) AND ((a.epa_column_name)::text = 'piping_style_id'::text));