create or replace view "tn_ust"."v_ust_tank" as
 SELECT DISTINCT (a."Tank Id")::integer AS tank_id,
    (a."Tank Number")::character varying(50) AS tank_name,
    (a."Facility Id Ust")::character varying(50) AS facility_id,
    d.tank_status_id,
        CASE
            WHEN (a."Regulated Status" = 'Regulated'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN (a."Emergency Generator" = 'Emergency Generator'::text) THEN 'Yes'::text
            WHEN (a."Emergency Generator" = 'Not Emergency Generator'::text) THEN 'No'::text
            ELSE NULL::text
        END AS emergency_generator,
    (a."Date Tank Closed")::date AS tank_closure_date,
    (a."Date Tank Installed")::date AS tank_installation_date,
        CASE
            WHEN (z.compartment_count > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    (z.compartment_count)::integer AS number_of_compartments,
    c.tank_material_description_id,
        CASE
            WHEN (c.tank_material_description_id = ANY (ARRAY[5, 6])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode
   FROM ((((tn_ust.tn_compartments a
     JOIN tn_ust.erg_compartment_counts z ON (((a."Tank Id" = z."Tank Id") AND (a."Facility Id Ust" = z."Facility Id Ust"))))
     JOIN ( SELECT DISTINCT erg_status."Facility Id Ust",
            erg_status."Tank Id",
            erg_status."Tank Number",
            erg_status.status_combined
           FROM tn_ust.erg_status
          WHERE ((erg_status."Facility Id Ust", erg_status."Tank Id", erg_status."Tank Number", erg_status.order_by) IN ( SELECT erg_status_1."Facility Id Ust",
                    erg_status_1."Tank Id",
                    erg_status_1."Tank Number",
                    min(erg_status_1.order_by) AS min
                   FROM tn_ust.erg_status erg_status_1
                  GROUP BY erg_status_1."Facility Id Ust", erg_status_1."Tank Id", erg_status_1."Tank Number"))) y ON (((a."Tank Id" = y."Tank Id") AND (a."Facility Id Ust" = y."Facility Id Ust"))))
     LEFT JOIN tn_ust.v_tank_material_description_xwalk c ON ((a."Tank Construction" = (c.organization_value)::text)))
     LEFT JOIN tn_ust.v_tank_status_xwalk d ON ((y.status_combined = (d.organization_value)::text)))
  WHERE ((a."Regulated Status" = 'Regulated'::text) AND (NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility Id Ust")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."Tank Id")::integer = unreg.tank_id))))))
UNION
 SELECT DISTINCT (a."Tank Id")::integer AS tank_id,
    (a."Tank Number")::character varying(50) AS tank_name,
    (a."Facility Id Ust")::character varying(50) AS facility_id,
    d.tank_status_id,
        CASE
            WHEN (a."Regulated Status" = 'Regulated'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN (a."Emergency Generator" = 'Emergency Generator'::text) THEN 'Yes'::text
            WHEN (a."Emergency Generator" = 'Not Emergency Generator'::text) THEN 'No'::text
            ELSE NULL::text
        END AS emergency_generator,
    (a."Date Tank Closed")::date AS tank_closure_date,
    (a."Date Tank Installed")::date AS tank_installation_date,
        CASE
            WHEN (z.compartment_count > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    (z.compartment_count)::integer AS number_of_compartments,
    c.tank_material_description_id,
        CASE
            WHEN (c.tank_material_description_id = ANY (ARRAY[5, 6])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode
   FROM ((((tn_ust.tn_compartments a
     JOIN tn_ust.erg_compartment_counts z ON (((a."Tank Id" = z."Tank Id") AND (a."Facility Id Ust" = z."Facility Id Ust"))))
     JOIN ( SELECT DISTINCT erg_status."Facility Id Ust",
            erg_status."Tank Id",
            erg_status."Tank Number",
            erg_status.status_combined
           FROM tn_ust.erg_status
          WHERE ((erg_status."Facility Id Ust", erg_status."Tank Id", erg_status."Tank Number", erg_status.order_by) IN ( SELECT erg_status_1."Facility Id Ust",
                    erg_status_1."Tank Id",
                    erg_status_1."Tank Number",
                    min(erg_status_1.order_by) AS min
                   FROM tn_ust.erg_status erg_status_1
                  GROUP BY erg_status_1."Facility Id Ust", erg_status_1."Tank Id", erg_status_1."Tank Number"))) y ON (((a."Tank Id" = y."Tank Id") AND (a."Facility Id Ust" = y."Facility Id Ust"))))
     LEFT JOIN tn_ust.v_tank_material_description_xwalk c ON ((a."Tank Construction" = (c.organization_value)::text)))
     LEFT JOIN tn_ust.v_tank_status_xwalk d ON ((y.status_combined = (d.organization_value)::text)))
  WHERE ((a."Regulated Status" IS NULL) AND (NOT (EXISTS ( SELECT 1
           FROM tn_ust.tn_compartments zz
          WHERE ((a."Tank Id" = zz."Tank Id") AND (a."Facility Id Ust" = zz."Facility Id Ust") AND (zz."Regulated Status" = 'Regulated'::text))))) AND (NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility Id Ust")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."Tank Id")::integer = unreg.tank_id))))));