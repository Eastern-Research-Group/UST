create or replace view "sc_ust"."v_compartments" as
 SELECT DISTINCT a.site_num,
    a.tank_num,
    a.compartment_number
   FROM ( SELECT "Overfill_Prevention".site_num,
            "Overfill_Prevention".tank_num,
            "Overfill_Prevention".compartment_number
           FROM sc_ust."Overfill_Prevention"
        UNION ALL
         SELECT "Spill_Prevention_".site_num,
            "Spill_Prevention_".tank_num,
            "Spill_Prevention_".compartment_number
           FROM sc_ust."Spill_Prevention_"
        UNION ALL
         SELECT "Overfill_Prevention_no_record_yet_08_02_21".site_num,
            "Overfill_Prevention_no_record_yet_08_02_21".tank_num,
            "Overfill_Prevention_no_record_yet_08_02_21".compartment_number
           FROM sc_ust."Overfill_Prevention_no_record_yet_08_02_21"
        UNION ALL
         SELECT "Spill_Prevention_no_record_yet_08_02_21".site_num,
            "Spill_Prevention_no_record_yet_08_02_21".tank_num,
            "Spill_Prevention_no_record_yet_08_02_21".compartment_number
           FROM sc_ust."Spill_Prevention_no_record_yet_08_02_21") a;