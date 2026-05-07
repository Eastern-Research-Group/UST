create or replace view "ia_ust"."v_tank_install_table" as
 SELECT DISTINCT td."tankID",
    td."tankDate",
    row_number() OVER (PARTITION BY td."tankID" ORDER BY td."tankDate" DESC, td."lastChanged" DESC) AS row_num
   FROM ia_ust.tbltankdates td
  WHERE (td."dateTypeID" = 4);