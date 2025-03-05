create or replace view "trustd_ust"."v_tank_attributes" as
 SELECT v_ut_tank_system.tank_system_id,
    ut_tank_attribute_type_id.ut_tank_attribute_type_id
   FROM trustd_ust.v_ut_tank_system,
    LATERAL unnest(string_to_array(v_ut_tank_system.tank_attributes, ':'::text)) ut_tank_attribute_type_id(ut_tank_attribute_type_id);