create or replace view "trustd_ust"."v_tank_release_detections" as
 SELECT ut_tank_system_comp.tank_system_comp_id,
    ut_release_detection_type_id.ut_release_detection_type_id
   FROM trustd_ust.ut_tank_system_comp,
    LATERAL unnest(string_to_array(ut_tank_system_comp.tank_release_detections, ':'::text)) ut_release_detection_type_id(ut_release_detection_type_id);