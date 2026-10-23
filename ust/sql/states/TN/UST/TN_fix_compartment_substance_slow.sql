-- TN compartment-substance parent-check performance fix.
-- Project only facility_id before the EXISTS check instead of expanding the
-- full DISTINCT facility view. Eligibility joins and exclusions are preserved.
-- v_facilities contributes only its ID and constant TN state; its optional GIS
-- joins cannot affect existence and are omitted.
-- Keep this parent subquery in sync if facility eligibility rules change.

CREATE OR REPLACE VIEW tn_ust.v_ust_compartment_substance AS
 SELECT DISTINCT a."Facility Id Ust"::character varying(50) AS facility_id,
    a."Tank Id"::integer AS tank_id,
    a."Compartment Id"::integer AS compartment_id,
    b.substance_id
   FROM tn_ust.tn_compartments_merged a
     LEFT JOIN tn_ust.v_substance_xwalk b ON a."Product" = b.organization_value::text
  WHERE b.substance_id IS NOT NULL AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg_fac
          WHERE a."Facility Id Ust"::character varying::text = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg_tank
          WHERE a."Facility Id Ust"::character varying::text = unreg_tank.facility_id::text AND a."Tank Id"::integer = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM (SELECT a.facility_id FROM (
    SELECT "FACILITY_ID_UST"::character varying(50) AS facility_id,
           'TN'::character varying(2) AS facility_state
    FROM tn_ust.tn_facilities_merged
) a
     LEFT JOIN tn_ust.v_owner_types b ON a.facility_id::text = b.facility_id::text
     LEFT JOIN ( SELECT tn_facilities_merged."FACILITY_ID_UST",
            max(tn_facilities_merged."OWNER_NAME") AS "OWNER_NAME",
            max(tn_facilities_merged."FACILITY_TYPE") AS "FACILITY_TYPE"
           FROM tn_ust.tn_facilities_merged
          GROUP BY tn_facilities_merged."FACILITY_ID_UST") c ON a.facility_id::text = c."FACILITY_ID_UST"::text
     LEFT JOIN ( SELECT tn_environmental_sites."Facilityid",
            max(tn_environmental_sites.release_id::text) AS release_id
           FROM tn_ust.tn_environmental_sites
          GROUP BY tn_environmental_sites."Facilityid") d ON a.facility_id::text = d."Facilityid"
     LEFT JOIN tn_ust.v_facility_type_xwalk e ON c."FACILITY_TYPE" = e.organization_value::text
     LEFT JOIN tn_ust.v_owner_type_xwalk f ON b.owner_type = f.organization_value::text
     LEFT JOIN tn_ust.v_state_xwalk g ON a.facility_state::text = g.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg
          WHERE a.facility_id::text = unreg.facility_id::text)) AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(f.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(g.exclude_from_query, 'N'::character varying)::text <> 'Y'::text) parent
          WHERE parent.facility_id::text = a."Facility Id Ust"::character varying::text)) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;
