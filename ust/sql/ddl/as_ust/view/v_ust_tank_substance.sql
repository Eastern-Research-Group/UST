create or replace view "as_ust"."v_ust_tank_substance" as
 SELECT DISTINCT a.facility_id,
    a.tank_id,
    b.substance_id
   FROM (as_ust.erg_tanksubstance a
     LEFT JOIN as_ust.v_substance_xwalk b ON (((a.tank_substance)::text = (b.organization_value)::text)));