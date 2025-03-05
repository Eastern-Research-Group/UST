create or replace view "hi_ust"."v_associated_release_id" as
 SELECT facility."FacilityID",
    max(facility."AssociatedLUSTID") AS "AssociatedLUSTID"
   FROM hi_ust.facility
  WHERE ((facility."AssociatedLUSTID" IS NOT NULL) AND (facility."AssociatedLUSTID" <> ALL (ARRAY['susptected'::text, 'suspected release'::text, 'Suspected'::text, 'suspected'::text, 'suspect'::text, 'exempt tank'::text])))
  GROUP BY facility."FacilityID";