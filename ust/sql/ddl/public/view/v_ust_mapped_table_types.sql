create or replace view "public"."v_ust_mapped_table_types" as
 SELECT a.ust_control_id,
    a.epa_table_name,
    a.organization_table_name,
    b.table_type
   FROM (( SELECT v_ust_mapped_table_types_all.ust_control_id,
            v_ust_mapped_table_types_all.epa_table_name,
            v_ust_mapped_table_types_all.organization_table_name,
            min(v_ust_mapped_table_types_all.sort_order) AS sort_order
           FROM v_ust_mapped_table_types_all
          GROUP BY v_ust_mapped_table_types_all.ust_control_id, v_ust_mapped_table_types_all.epa_table_name, v_ust_mapped_table_types_all.organization_table_name) a
     JOIN v_ust_mapped_table_types_all b ON (((a.ust_control_id = b.ust_control_id) AND ((a.epa_table_name)::text = (b.epa_table_name)::text) AND ((a.organization_table_name)::text = (b.organization_table_name)::text) AND (a.sort_order = b.sort_order))));