create or replace view "public"."v_ust_control" as
 SELECT max(ust_control.ust_control_id) AS ust_control_id,
    ust_control.organization_id,
    ust_control.date_received,
    ust_control.date_processed,
    ust_control.data_source,
    ust_control.comments,
    ust_control.organization_compartment_flag
   FROM ust_control
  WHERE ((ust_control.organization_id IS NOT NULL) AND (ust_control.ust_control_id <> 7))
  GROUP BY ust_control.organization_id, ust_control.date_received, ust_control.date_processed, ust_control.data_source, ust_control.comments, ust_control.organization_compartment_flag;