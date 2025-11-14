create or replace view "oust"."v_erg_lust_perf_meas_lustids" as
 SELECT DISTINCT v_lust.organization_id,
    v_lust."LUSTID",
    v_lust."LUSTStatus"
   FROM archive.v_lust;