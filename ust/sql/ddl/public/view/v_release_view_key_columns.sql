create or replace view "public"."v_release_view_key_columns" as
 SELECT a.view_name,
    a.column_name,
    a.sort_order AS column_sort_order,
    b.sort_order AS view_sort_order
   FROM (release_view_key_columns a
     JOIN release_template_data_tables b ON (((a.view_name)::text = (b.view_name)::text)))
  ORDER BY b.sort_order, a.sort_order;