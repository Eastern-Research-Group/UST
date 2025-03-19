create or replace view "ia_ust"."v_release_table" as
 SELECT DISTINCT lu."ustID" AS ustid,
    lu."lustID" AS lustid,
    row_number() OVER (PARTITION BY lu."ustID" ORDER BY lu."startDate" DESC) AS row_num
   FROM ia_ust.tbllustsite lu;