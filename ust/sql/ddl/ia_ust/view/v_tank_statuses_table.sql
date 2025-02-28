create or replace view "ia_ust"."v_tank_statuses_table" as
 SELECT DISTINCT tus."ustID",
    ts."statusDescription",
    row_number() OVER (PARTITION BY tus."ustID" ORDER BY tus."statusStartDate" DESC, tus."lastChanged" DESC) AS row_num
   FROM (ia_ust.trelusttostatus tus
     JOIN ia_ust.tlkstatus ts ON ((tus."statusID" = (ts."statusID")::double precision)));