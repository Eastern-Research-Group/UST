create or replace view "public"."v_casno" as
 SELECT DISTINCT v_chemical_list.casno
   FROM v_chemical_list;