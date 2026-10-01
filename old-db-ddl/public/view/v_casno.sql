CREATE OR REPLACE VIEW public.v_casno AS
 SELECT DISTINCT v_chemical_list.casno
   FROM v_chemical_list;
