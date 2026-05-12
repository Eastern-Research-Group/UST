create or replace view "az_ust"."v_owner_type_mapping" as
 SELECT DISTINCT a."FacilityID",
    a."FacilityOwnerCompanyName",
        CASE
            WHEN (b."MilitaryFlag" = 'Y'::text) THEN 'Military'::text
            WHEN (b."MilitaryFlag" = 'N'::text) THEN (b."OwnerType" || ' - Non Military'::text)
            ELSE a."OwnerType"
        END AS "OwnerType"
   FROM (az_ust.ust_facility a
     LEFT JOIN az_ust.erg_ower_type_military_mapping b ON (((a."FacilityOwnerCompanyName" = b."FacilityOwnerCompanyName") AND (a."OwnerType" = b."OwnerType"))))
  WHERE (a."OwnerType" IS NOT NULL);