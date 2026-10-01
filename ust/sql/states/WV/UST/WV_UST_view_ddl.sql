


/*********** v_ust_facility ***********/


--View definition for wv_ust.v_ust_facility:
 SELECT DISTINCT (x."Facility Id")::character varying(50) AS facility_id,
    (x."Facility Name")::character varying(100) AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    (x."Address")::character varying(100) AS facility_address1,
    (x."City")::character varying(100) AS facility_city,
    (x."County")::character varying(100) AS facility_county,
    'WV'::text AS facility_state,
    x."Zip" AS facility_zip_code,
    l."Latitude" AS facility_latitude,
    l."Longitude" AS facility_longitude,
    x."Owner Name" AS facility_owner_company_name
   FROM (((wv_ust.v_erg_facility x
     LEFT JOIN wv_ust.v_owner_type_xwalk ot ON ((x."Owner Type" = (ot.organization_value)::text)))
     LEFT JOIN wv_ust.v_facility_type_xwalk ft ON ((x."Facility Type" = (ft.organization_value)::text)))
     LEFT JOIN wv_ust."USTLUSTLocations" l ON ((x."Facility Id" = l."Facility Id")))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((x."Facility Id")::character varying(50))::text = (unregparent.facility_id)::text))));;




/*********** v_ust_tank ***********/


--View definition for wv_ust.v_ust_tank:
 SELECT DISTINCT (x."Facility#")::character varying(50) AS facility_id,
    (x."Tank Id")::integer AS tank_id,
    ts.tank_status_id,
    x."Regulated" AS federally_regulated,
        CASE
            WHEN (mt.num_tanks > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS multiple_tanks,
    (x."Closed")::date AS tank_closure_date,
    (x."Installed")::date AS tank_installation_date,
        CASE
            WHEN (x."Compartments" > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    (x."Compartments")::integer AS number_of_compartments,
    tm.tank_material_description_id,
    sc.tank_secondary_containment_id
   FROM (((((wv_ust."USTTanksPublic" x
     LEFT JOIN wv_ust.v_tank_status_xwalk ts ON ((x."Tank Status" = (ts.organization_value)::text)))
     LEFT JOIN ( SELECT "USTTanksPublic"."Facility#",
            count(DISTINCT "USTTanksPublic"."Tank Id") AS num_tanks
           FROM wv_ust."USTTanksPublic"
          GROUP BY "USTTanksPublic"."Facility#") mt ON ((x."Facility#" = mt."Facility#")))
     LEFT JOIN wv_ust.v_tank_material_description_xwalk tm ON ((x."Material" = (tm.organization_value)::text)))
     LEFT JOIN wv_ust."AllFacilitiesDetails" f ON ((x."Facility#" = f."Facility Id")))
     LEFT JOIN wv_ust.v_tank_secondary_containment_xwalk sc ON ((f."Active Tanks Construction" = (sc.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((x."Facility#")::character varying(50))::text = (unregparent.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((x."Facility#")::character varying(50))::text = (unreg.facility_id)::text) AND (x."Tank Id" = unreg.tank_id))))));;




/*********** v_ust_tank_substance ***********/


--View definition for wv_ust.v_ust_tank_substance:
 SELECT DISTINCT (x.facility_id)::character varying(50) AS facility_id,
    x.tank_id,
    s.substance_id
   FROM (wv_ust.erg_comp_substances x
     LEFT JOIN wv_ust.v_substance_xwalk s ON (((x.substance)::text = (s.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((x.facility_id)::character varying(50))::text = (unregparent.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((x.facility_id)::character varying(50))::text = (unreg.facility_id)::text) AND (x.tank_id = unreg.tank_id))))) AND (s.substance_id IS NOT NULL));;




/*********** v_ust_compartment ***********/


--View definition for wv_ust.v_ust_compartment:
 SELECT DISTINCT (x."Facility#")::character varying(50) AS facility_id,
    (x."Tank Id")::integer AS tank_id,
    ci.compartment_id,
    cs.compartment_status_id,
    (x."Capacity")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (f."Active Overfill Protection" = 'Ball Float'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (f."Active Overfill Protection" = 'Fill Shut Off'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (f."Active Overfill Protection" = 'Overfill Alarm'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
    sp.spill_bucket_installed,
    sp.spill_prevention_not_required,
    sb.spill_bucket_wall_type_id
   FROM ((((((wv_ust."USTTanksPublic" x
     JOIN wv_ust.erg_compartment_id ci ON ((((x."Facility#")::text = (ci.facility_id)::text) AND (x."Tank Id" = ci.tank_id))))
     JOIN wv_ust.erg_comp_substances c ON (((x."Facility#" = c.facility_id) AND (x."Tank Id" = c.tank_id))))
     LEFT JOIN wv_ust.v_compartment_status_xwalk cs ON ((x."Tank Status" = (cs.organization_value)::text)))
     LEFT JOIN wv_ust."AllFacilitiesDetails" f ON ((x."Facility#" = f."Facility Id")))
     LEFT JOIN wv_ust.erg_spill_prevention sp ON ((f."Active Spill Prevention" = sp."Active Spill Prevention")))
     LEFT JOIN wv_ust.v_spill_bucket_wall_type_xwalk sb ON ((f."Active Spill Prevention" = (sb.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((x."Facility#")::character varying(50))::text = (unregparent.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((x."Facility#")::character varying(50))::text = (unreg.facility_id)::text) AND (x."Tank Id" = unreg.tank_id))))));;




/*********** v_ust_compartment_substance ***********/


--View definition for wv_ust.v_ust_compartment_substance:
 SELECT DISTINCT (x.facility_id)::character varying(50) AS facility_id,
    x.tank_id,
    x.compartment_id,
    s.substance_id
   FROM (wv_ust.erg_comp_substances x
     LEFT JOIN wv_ust.v_substance_xwalk s ON (((x.substance)::text = (s.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((x.facility_id)::character varying(50))::text = (unregparent.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((x.facility_id)::character varying(50))::text = (unreg.facility_id)::text) AND (x.tank_id = unreg.tank_id))))) AND (s.substance_id IS NOT NULL));;




/*********** v_ust_piping ***********/


--View definition for wv_ust.v_ust_piping:
 SELECT DISTINCT x.facility_id,
    x.tank_id,
    x.compartment_id,
    (x.piping_id)::text AS piping_id,
    ps.piping_style_id,
    pd.piping_material_frp,
    pd.piping_material_steel,
    pd.piping_material_flex,
    pd.piping_material_no_piping,
    wt.piping_wall_type_id
   FROM ((((((wv_ust.erg_piping_id x
     JOIN wv_ust.v_erg_facility p ON (((p."Facility Id")::text = (x.facility_id)::text)))
     LEFT JOIN wv_ust."AllFacilitiesDetails" f ON (((x.facility_id)::text = (f."Facility Id")::text)))
     LEFT JOIN wv_ust.erg_piping_data pd ON ((f."Active Pipes Construction" = pd."Active Pipes Construction")))
     LEFT JOIN wv_ust."USTTanksPublic" t ON (((x.facility_id)::text = (t."Facility#")::text)))
     LEFT JOIN wv_ust.v_piping_style_xwalk ps ON ((f."Active Pipes Construction" = (ps.organization_value)::text)))
     LEFT JOIN wv_ust.v_piping_wall_type_xwalk wt ON ((f."Active Pipes Construction" = (wt.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((p."Facility Id")::character varying(50))::text = (unregparent.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((p."Facility Id")::character varying(50))::text = (unreg.facility_id)::text) AND (x.tank_id = unreg.tank_id))))));;

