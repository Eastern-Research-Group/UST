create or replace view "dc_release"."erg_facility_types" as
 SELECT DISTINCT x."Facility ID" AS facility_id,
        CASE
            WHEN ((x."Facility Type" = 'Other'::text) AND (f."OwnerType" = ANY (ARRAY['Federal Government - Non Military'::text, 'Military'::text, 'Local Government'::text]))) THEN f."OwnerType"
            ELSE x."Facility Type"
        END AS facility_type1
   FROM (dc_release.release x
     LEFT JOIN ( SELECT facility."FACILITYID",
            facility."FacilityType1",
            facility."OwnerType"
           FROM dc_release.facility) f ON ((x."Facility ID" = f."FACILITYID")));