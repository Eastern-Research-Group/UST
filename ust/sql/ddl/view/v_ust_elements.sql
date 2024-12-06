create or replace view "public"."v_ust_elements" as
 SELECT public.get_template_element_tabs(a.element_id) AS "Template Tabs",
    a.element_name AS "Element Name",
    a.element_description AS "Element Description",
    a.element_type AS "Element Type",
    a.element_size AS "Size",
    a.required AS "Required",
    a.allowed_values AS "Allowed Values",
        CASE
            WHEN ((a.database_lookup_table)::text = ANY (ARRAY[('states'::character varying)::text, ('facility_types'::character varying)::text, ('substances'::character varying)::text])) THEN (('[See '::text || initcap(replace((a.database_lookup_table)::text, '_'::text, ' '::text))) || ' tab]'::text)
            WHEN (a.database_lookup_table IS NOT NULL) THEN get_lookup_table_contents((a.database_lookup_table)::text, (a.database_lookup_column)::text)
            ELSE (a.business_rule)::text
        END AS "Business Rule",
    a.notes AS "Notes"
   FROM (( SELECT ts.element_id,
            ts.table_sort_order,
            min(cs.sort_order) AS column_sort_order
           FROM (( SELECT x.element_id,
                    min(z.sort_order) AS table_sort_order
                   FROM ((ust_elements x
                     JOIN ust_elements_tables y ON ((x.element_id = y.element_id)))
                     JOIN ust_element_table_sort_order z ON (((y.table_name)::text = (z.table_name)::text)))
                  GROUP BY x.element_id) ts
             JOIN ust_elements_tables cs ON ((ts.element_id = cs.element_id)))
          GROUP BY ts.element_id, ts.table_sort_order) s
     JOIN ust_elements a ON ((a.element_id = s.element_id)))
  ORDER BY s.table_sort_order, s.column_sort_order;