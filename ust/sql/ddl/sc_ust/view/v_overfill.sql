create or replace view "sc_ust"."v_overfill" as
 SELECT vc.site_num,
    vc.tank_num,
    vc.compartment_number,
        CASE
            WHEN (op.overfill_method IS NOT NULL) THEN op.overfill_method
            ELSE opnr.overfill_method
        END AS overfill_method,
        CASE
            WHEN (op.chemical_desc IS NOT NULL) THEN op.chemical_desc
            ELSE opnr.chemical_desc
        END AS chemical_desc,
        CASE
            WHEN (op.cas_no IS NOT NULL) THEN op.cas_no
            ELSE opnr.cas_no
        END AS cas_no
   FROM ((sc_ust.v_compartments vc
     LEFT JOIN ( SELECT "Overfill_Prevention".site_num,
            "Overfill_Prevention".tank_num,
            "Overfill_Prevention".compartment_number,
            "Overfill_Prevention".overfill_method,
            "Overfill_Prevention".overfill_prevention,
            "Overfill_Prevention".chemical_desc,
            "Overfill_Prevention".cas_no
           FROM sc_ust."Overfill_Prevention") op ON (((vc.site_num = op.site_num) AND (vc.tank_num = op.tank_num) AND (vc.compartment_number = op.compartment_number))))
     LEFT JOIN ( SELECT "Overfill_Prevention_no_record_yet_08_02_21".site_num,
            "Overfill_Prevention_no_record_yet_08_02_21".tank_num,
            "Overfill_Prevention_no_record_yet_08_02_21".compartment_number,
            "Overfill_Prevention_no_record_yet_08_02_21".overfill_method,
            "Overfill_Prevention_no_record_yet_08_02_21".overfill_prevention,
            "Overfill_Prevention_no_record_yet_08_02_21".chemical_desc,
            "Overfill_Prevention_no_record_yet_08_02_21".cas_no
           FROM sc_ust."Overfill_Prevention_no_record_yet_08_02_21") opnr ON (((vc.site_num = opnr.site_num) AND (vc.tank_num = opnr.tank_num) AND (vc.compartment_number = opnr.compartment_number))));