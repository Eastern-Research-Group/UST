create or replace view "trustd_ust"."v_substances" as
 SELECT ut_tank_system_comp.tank_system_comp_id,
    ut_substance_type_id.ut_substance_type_id
   FROM trustd_ust.ut_tank_system_comp,
    LATERAL unnest(string_to_array(ut_tank_system_comp.substances, ':'::text)) ut_substance_type_id(ut_substance_type_id);