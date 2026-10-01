CREATE OR REPLACE VIEW public.v_chemical_list AS
 SELECT chemical_list.casrn AS casno,
    chemical_list.preferred_name,
    chemical_list.iupac_name
   FROM chemical_list;
