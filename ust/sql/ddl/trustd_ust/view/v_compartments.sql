create or replace view "trustd_ust"."v_compartments" as
 SELECT c.tank_system_id,
    c.num_compartments,
        CASE
            WHEN ((c.compartmentalized IS NOT NULL) OR (c.num_compartments > 1)) THEN 'Yes'::text
            ELSE NULL::text
        END AS compartmentalized
   FROM ( SELECT a.tank_system_id,
                CASE
                    WHEN (b.tank_system_id IS NOT NULL) THEN 'Yes'::text
                    ELSE NULL::text
                END AS compartmentalized,
            a.num_compartments
           FROM (( SELECT ut_tank_system_comp.tank_system_id,
                    count(*) AS num_compartments
                   FROM trustd_ust.ut_tank_system_comp
                  GROUP BY ut_tank_system_comp.tank_system_id) a
             LEFT JOIN ( SELECT x.tank_system_id
                   FROM (trustd_ust.v_tank_attributes x
                     JOIN trustd_ust.ut_tank_attribute_type y ON (((x.ut_tank_attribute_type_id)::integer = y.ut_tank_attribute_type_id)))
                  WHERE (y.ut_tank_attribute_desc = 'Compartmentalized'::text)) b ON ((a.tank_system_id = b.tank_system_id)))) c;