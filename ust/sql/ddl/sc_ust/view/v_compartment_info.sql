create or replace view "sc_ust"."v_compartment_info" as
 SELECT vc.site_num,
    vc.tank_num,
    vc.compartment_number,
        CASE
            WHEN ((op.capacity_gal IS NOT NULL) AND (op.capacity_gal >= COALESCE(sp.capacity_gal, (0)::bigint))) THEN op.capacity_gal
            WHEN ((sp.capacity_gal IS NOT NULL) AND ((sp.capacity_gal)::double precision >= COALESCE(opnr.capacity_gal, (0)::double precision))) THEN sp.capacity_gal
            WHEN ((opnr.capacity_gal IS NOT NULL) AND (opnr.capacity_gal >= COALESCE(spnr.capacity_gal, (0)::double precision))) THEN (opnr.capacity_gal)::bigint
            ELSE (spnr.capacity_gal)::bigint
        END AS capacity_gal,
        CASE
            WHEN (op.status_code IS NOT NULL) THEN op.status_code
            WHEN (sp.status_code IS NOT NULL) THEN sp.status_code
            WHEN (opnr.status_code IS NOT NULL) THEN opnr.status_code
            ELSE spnr.status_code
        END AS status_code,
        CASE
            WHEN (op.chemical_desc IS NOT NULL) THEN op.chemical_desc
            WHEN (sp.chemical_desc IS NOT NULL) THEN sp.chemical_desc
            WHEN (opnr.chemical_desc IS NOT NULL) THEN opnr.chemical_desc
            ELSE spnr.chemical_desc
        END AS chemical_desc,
        CASE
            WHEN (op.cas_no IS NOT NULL) THEN op.cas_no
            WHEN (sp.cas_no IS NOT NULL) THEN sp.cas_no
            WHEN (opnr.cas_no IS NOT NULL) THEN opnr.cas_no
            ELSE spnr.cas_no
        END AS cas_no
   FROM ((((sc_ust.v_compartments vc
     LEFT JOIN sc_ust."Overfill_Prevention" op ON (((vc.site_num = op.site_num) AND (vc.tank_num = op.tank_num) AND (vc.compartment_number = op.compartment_number))))
     LEFT JOIN sc_ust."Spill_Prevention_" sp ON (((vc.site_num = sp.site_num) AND (vc.tank_num = sp.tank_num) AND (vc.compartment_number = sp.compartment_number))))
     LEFT JOIN sc_ust."Overfill_Prevention_no_record_yet_08_02_21" opnr ON (((vc.site_num = opnr.site_num) AND (vc.tank_num = opnr.tank_num) AND (vc.compartment_number = opnr.compartment_number))))
     LEFT JOIN sc_ust."Spill_Prevention_no_record_yet_08_02_21" spnr ON (((vc.site_num = spnr.site_num) AND (vc.tank_num = spnr.tank_num) AND (vc.compartment_number = spnr.compartment_number))));