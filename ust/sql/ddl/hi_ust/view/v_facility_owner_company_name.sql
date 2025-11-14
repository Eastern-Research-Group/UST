create or replace view "hi_ust"."v_facility_owner_company_name" as
 SELECT facility."FacilityID",
    max(facility."FacilityOwnerCompanyName") AS "FacilityOwnerCompanyName"
   FROM hi_ust.facility
  WHERE (facility."FacilityOwnerCompanyName" IS NOT NULL)
  GROUP BY facility."FacilityID";