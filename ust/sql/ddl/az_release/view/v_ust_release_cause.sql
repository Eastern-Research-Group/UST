create or replace view "az_release"."v_ust_release_cause" as
 SELECT DISTINCT (a."LUSTID")::character varying(50) AS release_id,
    b.cause_id,
    a.cause_comment
   FROM (az_release.v_cause_mapping a
     JOIN causes b ON ((a.epa_cause = (b.cause)::text)));