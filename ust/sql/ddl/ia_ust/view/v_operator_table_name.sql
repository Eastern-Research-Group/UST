create or replace view "ia_ust"."v_operator_table_name" as
 SELECT DISTINCT o."orgName" AS orgname,
    au."ustID" AS ustid,
    au."affTypeID" AS afftypeid,
    row_number() OVER (PARTITION BY au."ustID" ORDER BY au."startDate" DESC, au."lastChanged" DESC) AS row_num
   FROM ((ia_ust.trelafftoust au
     JOIN ia_ust.tblaffiliation af ON ((au."affID" = af."affID")))
     JOIN ia_ust.tblorganization o ON ((af."orgID" = (o."orgID")::double precision)))
  WHERE (au."affTypeID" = ANY (ARRAY[(4)::bigint, (23)::bigint, (24)::bigint]));