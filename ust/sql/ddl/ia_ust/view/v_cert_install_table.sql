create or replace view "ia_ust"."v_cert_install_table" as
 SELECT DISTINCT ci."tankID",
    ci."installationID",
    row_number() OVER (PARTITION BY ci."tankID" ORDER BY ci."createdDate" DESC, ci."lastChanged" DESC) AS row_num
   FROM ia_ust.treltanktoinstallation ci;