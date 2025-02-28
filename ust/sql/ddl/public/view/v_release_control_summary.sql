create or replace view "public"."v_release_control_summary" as
 SELECT release_control.release_control_id,
    1 AS sort_order,
    'organization_id'::text AS summary_item,
    release_control.organization_id AS summary_detail
   FROM release_control
UNION ALL
 SELECT release_control.release_control_id,
    2 AS sort_order,
    'date_received'::text AS summary_item,
    (release_control.date_received)::character varying AS summary_detail
   FROM release_control
UNION ALL
 SELECT release_control.release_control_id,
    3 AS sort_order,
    'date_processed'::text AS summary_item,
    (release_control.date_processed)::character varying AS summary_detail
   FROM release_control
UNION ALL
 SELECT release_control.release_control_id,
    4 AS sort_order,
    'data_source'::text AS summary_item,
    release_control.data_source AS summary_detail
   FROM release_control
UNION ALL
 SELECT release_control.release_control_id,
    5 AS sort_order,
    'comments'::text AS summary_item,
    release_control.comments AS summary_detail
   FROM release_control;