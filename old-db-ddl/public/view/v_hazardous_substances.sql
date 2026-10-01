CREATE OR REPLACE VIEW public.v_hazardous_substances AS
 SELECT DISTINCT x.substance
   FROM ( SELECT v_chemical_list.preferred_name AS substance
           FROM v_chemical_list
        UNION ALL
         SELECT v_chemical_list.iupac_name
           FROM v_chemical_list
          WHERE v_chemical_list.iupac_name IS NOT NULL) x;
