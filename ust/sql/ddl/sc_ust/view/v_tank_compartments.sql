create or replace view "sc_ust"."v_tank_compartments" as
 SELECT v_compartments.site_num,
    v_compartments.tank_num,
    count(*) AS number_of_compartments
   FROM sc_ust.v_compartments
  GROUP BY v_compartments.site_num, v_compartments.tank_num;