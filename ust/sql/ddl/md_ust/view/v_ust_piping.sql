create or replace view "md_ust"."v_ust_piping" as
 SELECT DISTINCT (c.piping_id)::character varying(50) AS piping_id,
    c.facility_id,
    c.tank_id,
    c.compartment_id,
        CASE x."PipeMatDesc"
            WHEN 'Fiberglass Reinforced Plastic'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_frp,
        CASE
            WHEN (x."PipeMatDesc" = ANY (ARRAY['Galvanized Steel'::text, 'Bare or Galvanized Steel'::text])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_gal_steel,
        CASE x."PipeMatDesc"
            WHEN 'Steel-slvd. in PVC, FRP or Plastic'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_steel,
        CASE
            WHEN (x."PipeMatDesc" = ANY (ARRAY['Copper (cathodically protected)'::text, 'Copper'::text, 'Copper sleeved in plastic'::text])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_copper,
        CASE x."PipeMatDesc"
            WHEN 'Flexible Plastic'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_flex,
        CASE x."PipeMatDesc"
            WHEN 'No Piping'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_no_piping,
        CASE x."PipeMatDesc"
            WHEN 'Other'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_other,
        CASE x."PipeMatDesc"
            WHEN 'Unknown'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_unknown
   FROM (md_ust.md_tanks_combined x
     JOIN md_ust.erg_piping_id c ON ((((x."FacilityID")::integer = (c.facility_id)::integer) AND ((x."TankID")::integer = c.tank_id) AND (x."tblCompartment_Compartment" = (c.compartment_name)::text))));