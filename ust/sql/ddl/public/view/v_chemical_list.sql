create or replace view "public"."v_chemical_list" as
 SELECT chemical_list.casrn AS casno,
    chemical_list.preferred_name,
    chemical_list.iupac_name
   FROM chemical_list;