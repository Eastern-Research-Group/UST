create or replace view "ok_ust"."v_ust_tank" as
 SELECT DISTINCT (a.tank_name)::integer AS tank_id,
    (a."FacilityID")::character varying(50) AS facility_id,
    d.tank_status_id,
        CASE
            WHEN (a."Manifold" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS multiple_tanks,
        CASE
            WHEN (a."Status" = ANY (ARRAY['CIU'::text, 'Xfer'::text, 'TOU'::text])) THEN NULL::date
            ELSE (a."ClosedDate")::date
        END AS tank_closure_date,
    (a."InstalledDate")::date AS tank_installation_date,
        CASE
            WHEN (a."Compartments" <> ALL (ARRAY['0'::bigint, '1'::bigint])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    (a."Compartments")::integer AS number_of_compartments,
    b.tank_material_description_id,
    c.tank_secondary_containment_id
   FROM (((((ok_ust."OK_UST_Data" a
     LEFT JOIN ok_ust.v_tank_material_description_xwalk b ON ((a."Tank Material" = (b.organization_value)::text)))
     LEFT JOIN ok_ust.v_tank_secondary_containment_xwalk c ON ((a."Tank Construction" = (c.organization_value)::text)))
     LEFT JOIN ok_ust.v_tank_status_xwalk d ON ((a."Status" = (d.organization_value)::text)))
     JOIN ok_ust."OK_UST_Facility_Data" z ON ((z.facility_id = a."FacilityID")))
     JOIN ok_ust.erg_compartments_deduplicated y ON ((y."FacilityID" = a."FacilityID")))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a.tank_name)::integer = unreg.tank_id)))));