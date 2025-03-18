create or replace view "trustd_ust"."v_piping_attributes" as
 SELECT ut_tank_system_comp.tank_system_comp_id,
    ut_piping_attribute_type_id.ut_piping_attribute_type_id
   FROM trustd_ust.ut_tank_system_comp,
    LATERAL unnest(string_to_array(ut_tank_system_comp.piping_attributes, ':'::text)) ut_piping_attribute_type_id(ut_piping_attribute_type_id);