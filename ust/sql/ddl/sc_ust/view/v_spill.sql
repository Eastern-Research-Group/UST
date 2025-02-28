create or replace view "sc_ust"."v_spill" as
 SELECT vc.site_num,
    vc.tank_num,
    vc.compartment_number,
        CASE
            WHEN (sp.spill_prevent IS NOT NULL) THEN sp.spill_prevent
            ELSE spnr.spill_prevent
        END AS spill_prevent,
        CASE
            WHEN (sp.chemical_desc IS NOT NULL) THEN sp.chemical_desc
            ELSE spnr.chemical_desc
        END AS chemical_desc,
        CASE
            WHEN (sp.cas_no IS NOT NULL) THEN sp.cas_no
            ELSE spnr.cas_no
        END AS cas_no
   FROM ((sc_ust.v_compartments vc
     LEFT JOIN ( SELECT "Spill_Prevention_".site_num,
            "Spill_Prevention_".tank_num,
            "Spill_Prevention_".compartment_number,
            "Spill_Prevention_".spill_prevent,
            "Spill_Prevention_".chemical_desc,
            "Spill_Prevention_".cas_no
           FROM sc_ust."Spill_Prevention_") sp ON (((vc.site_num = sp.site_num) AND (vc.tank_num = sp.tank_num) AND (vc.compartment_number = sp.compartment_number))))
     LEFT JOIN ( SELECT "Spill_Prevention_no_record_yet_08_02_21".site_num,
            "Spill_Prevention_no_record_yet_08_02_21".tank_num,
            "Spill_Prevention_no_record_yet_08_02_21".compartment_number,
            "Spill_Prevention_no_record_yet_08_02_21".spill_prevent,
            "Spill_Prevention_no_record_yet_08_02_21".chemical_desc,
            "Spill_Prevention_no_record_yet_08_02_21".cas_no
           FROM sc_ust."Spill_Prevention_no_record_yet_08_02_21") spnr ON (((vc.site_num = spnr.site_num) AND (vc.tank_num = spnr.tank_num) AND (vc.compartment_number = spnr.compartment_number))));