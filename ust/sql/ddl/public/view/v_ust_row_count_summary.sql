create or replace view "public"."v_ust_row_count_summary" as
 SELECT a.table_name,
    a.num_rows,
    b.sort_order,
    a.ust_control_id
   FROM (( SELECT v_ust_facility.ust_control_id,
            'Facility'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_facility
          GROUP BY v_ust_facility.ust_control_id
        UNION ALL
         SELECT v_ust_tank.ust_control_id,
            'Tank'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_tank
          GROUP BY v_ust_tank.ust_control_id
        UNION ALL
         SELECT v_ust_compartment.ust_control_id,
            'Compartment'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_compartment
          GROUP BY v_ust_compartment.ust_control_id
        UNION ALL
         SELECT v_ust_piping.ust_control_id,
            'Piping'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_piping
          GROUP BY v_ust_piping.ust_control_id
        UNION ALL
         SELECT v_ust_tank_substance.ust_control_id,
            'Tank Substance'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_tank_substance
          GROUP BY v_ust_tank_substance.ust_control_id
        UNION ALL
         SELECT v_ust_compartment_substance.ust_control_id,
            'Compartment Substance'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_compartment_substance
          GROUP BY v_ust_compartment_substance.ust_control_id
        UNION ALL
         SELECT v_ust_facility_dispenser.ust_control_id,
            'Facility Dispenser'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_facility_dispenser
          GROUP BY v_ust_facility_dispenser.ust_control_id
        UNION ALL
         SELECT v_ust_tank_dispenser.ust_control_id,
            'Tank Dispenser'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_tank_dispenser
          GROUP BY v_ust_tank_dispenser.ust_control_id
        UNION ALL
         SELECT v_ust_compartment_dispenser.ust_control_id,
            'Compartment Dispenser'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_compartment_dispenser
          GROUP BY v_ust_compartment_dispenser.ust_control_id) a
     JOIN ust_template_data_tables b ON ((a.table_name = (b.template_tab_name)::text)));