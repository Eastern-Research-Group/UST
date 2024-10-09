create or replace view "public"."v_ust_elements" as
 SELECT get_template_element_tabs(a.element_id) AS "Template Tabs",
    a.element_name AS "Element Name",
    a.element_description AS "Element Description",
    a.element_type AS "Element Type",
    a.element_size AS "Size",
    a.required AS "Required",
    a.allowed_values AS "Allowed Values",
        CASE
            WHEN ((a.database_lookup_table)::text = ANY (ARRAY[('states'::character varying)::text, ('facility_types'::character varying)::text, ('substances'::character varying)::text])) THEN (('[See '::text || initcap(replace((a.database_lookup_table)::text, '_'::text, ' '::text))) || ' tab]'::text)
            WHEN (a.database_lookup_table IS NOT NULL) THEN get_lookup_table_contents((a.database_lookup_table)::text, (a.database_lookup_column)::text)
            ELSE NULL::text
        END AS "Business Rule",
    a.notes AS "Notes"
   FROM ((ust_elements a
     JOIN ust_elements_tables b ON ((a.element_id = b.element_id)))
     JOIN ust_element_table_sort_order c ON (((b.table_name)::text = (c.table_name)::text)))
  WHERE ((a.generic_template)::text = 'Y'::text)
  GROUP BY a.element_id, a.element_name, a.element_description, a.element_size, a.required, a.allowed_values, a.notes, c.sort_order, b.sort_order
  ORDER BY c.sort_order, b.sort_order;