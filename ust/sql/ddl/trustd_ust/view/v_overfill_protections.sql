create or replace view "trustd_ust"."v_overfill_protections" as
 SELECT ut_tank_system_comp.tank_system_comp_id,
    ut_overfill_protection_type_id.ut_overfill_protection_type_id
   FROM trustd_ust.ut_tank_system_comp,
    LATERAL unnest(string_to_array(ut_tank_system_comp.overfill_protections, ':'::text)) ut_overfill_protection_type_id(ut_overfill_protection_type_id);