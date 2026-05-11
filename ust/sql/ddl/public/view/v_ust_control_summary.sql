create or replace view "public"."v_ust_control_summary" as
 SELECT ust_control.ust_control_id,
    1 AS sort_order,
    'organization_id'::text AS summary_item,
    ust_control.organization_id AS summary_detail
   FROM ust_control
UNION ALL
 SELECT ust_control.ust_control_id,
    2 AS sort_order,
    'date_received'::text AS summary_item,
    (ust_control.date_received)::character varying AS summary_detail
   FROM ust_control
UNION ALL
 SELECT ust_control.ust_control_id,
    3 AS sort_order,
    'date_processed'::text AS summary_item,
    (ust_control.date_processed)::character varying AS summary_detail
   FROM ust_control
UNION ALL
 SELECT ust_control.ust_control_id,
    4 AS sort_order,
    'data_source'::text AS summary_item,
    ust_control.data_source AS summary_detail
   FROM ust_control
UNION ALL
 SELECT ust_control.ust_control_id,
    5 AS sort_order,
    'comments'::text AS summary_item,
    ust_control.comments AS summary_detail
   FROM ust_control
UNION ALL
 SELECT ust_control.ust_control_id,
    6 AS sort_order,
    'organization_compartment_flag'::text AS summary_item,
    ust_control.organization_compartment_flag AS summary_detail
   FROM ust_control;