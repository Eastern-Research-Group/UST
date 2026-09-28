


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



          
select * from wv_ust.erg_unregulated_facilities

select * from wv_ust.v_ust_facility


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



          WHERE ((((x."Facility#")::character varying(50))::text = (unreg.facility_id)::text) AND (x."Tank Id" = unreg.tank_id))))));
          
select * from wv_ust.erg_unregulated_tanks;          

select federally_regulated, count(*)
from  wv_ust.v_ust_tank
group by federally_regulated

select * from ust_element_mapping where ust_element_mapping_id = 4294;
erg_compartment_id	compartment_id

select * from wv_ust.erg_compartment_id;


select * from ust_element_mapping 
where ust_control_id = 11
and epa_table_name = 'ust_compartment'

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
          WHERE ((((x.facility_id)::character varying(50))::text = (unreg.facility_id)::text) AND (x.tank_id = unreg.tank_id))))) 
          AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unregsub
          WHERE ((((x.facility_id)::character varying(50))::text = (unregsub.facility_id)::text) AND (x.tank_id = unregsub.tank_id) 
AND ((x.substance)::text = (unregsub.organization_substance)::text))))));;

select * from wv_ust.erg_comp_substances;


/*********** v_ust_compartment ***********/


--View definition for wv_ust.v_ust_compartment:
 SELECT DISTINCT (x."Facility#")::character varying(50) AS facility_id,
    (x."Tank Id")::integer AS tank_id,
    c.compartment_id,
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
        CASE
            WHEN (f."Active Spill Prevention" = ANY (ARRAY['Spill Basin'::text, 'Spill Bucket'::text, 'Spill BasinSpill Bucket'::text, 'Spill Containment'::text, 'Double Walled Spill Bucket'::text, 'Double Walled Spill BucketSpill Bucket'::text, 'Not RequiredSpill Bucket'::text, 'Spill BucketSpill Containment'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (f."Active Spill Prevention" = ANY (ARRAY['Not RequiredSpill Bucket'::text, 'Not Required'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_prevention_not_required,
    sb.spill_bucket_wall_type_id
   FROM ((((wv_ust."USTTanksPublic" x
     JOIN wv_ust.erg_comp_substances c ON (((x."Facility#" = c.facility_id) AND (x."Tank Id" = c.tank_id))))
     LEFT JOIN wv_ust.v_compartment_status_xwalk cs ON ((x."Tank Status" = (cs.organization_value)::text)))
     LEFT JOIN wv_ust."AllFacilitiesDetails" f ON ((x."Facility#" = f."Facility Id")))
     LEFT JOIN wv_ust.v_spill_bucket_wall_type_xwalk sb ON ((f."Active Spill Prevention" = (sb.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((x."Facility#")::character varying(50))::text = (unregparent.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((x."Facility#")::character varying(50))::text = (unreg.facility_id)::text) AND (x."Tank Id" = unreg.tank_id))))));;




/*********** v_ust_compartment_substance ***********/
select * from ust_control where ust_control_id = 11;
          


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
          WHERE ((((x.facility_id)::character varying(50))::text = (unreg.facility_id)::text) AND (x.tank_id = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unregsub
          WHERE ((((x.facility_id)::character varying(50))::text = (unregsub.facility_id)::text) AND (x.tank_id = unregsub.tank_id) AND ((x.substance)::text = (unregsub.organization_substance)::text))))));;




/*********** v_ust_piping ***********/


--View definition for wv_ust.v_ust_piping:
 SELECT DISTINCT x.facility_id,
    x.tank_id,
    x.compartment_id,
    (x.piping_id)::text AS piping_id,
        CASE
            WHEN (f."Active Pipes Construction" = ANY (ARRAY['Above Ground ExemptAbove Ground NoneFiberglass Reinforced Plastic Exempt'::text, 'Above Ground Exempt'::text, 'Above Ground None'::text, 'No Piping None'::text])) THEN ps.piping_style_id
            ELSE NULL::integer
        END AS piping_style_id,
        CASE
            WHEN (f."Active Pipes Construction" = ANY (ARRAY['Fiberglass Reinforced Plastic Double Walled'::text, 'Fiberglass Reinforced Plastic None'::text, 'Fiberglass Reinforced Plastic Double WalledFiberglass Reinforced Plastic None'::text, 'Fiberglass Reinforced Plastic NoneFiberglass Reinforced Plastic Secondary Containment'::text, 'Fiberglass Reinforced Plastic Double WalledFlexible Plastic -  Double Walled Double Walled'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double Walled'::text, 'Fiberglass Reinforced Plastic Secondary Containment'::text, 'Fiberglass Reinforced Plastic Double WalledFlexible Plastic Double Walled'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic None'::text, 'FRP -  Double Walled Double Walled, Flexible Plastic Double WalledFRP -  Double Walled Double Walled'::text, 'Fiberglass Reinforced Plastic Double WalledFiberglass Reinforced Plastic NoneFlexible Plastic Double Walled'::text, 'FRP -  Double Walled Secondary Containment, Fiberglass Reinforced Plastic Secondary ContainmentFlexible Plastic Double Walled'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic Double Walled'::text, 'Flexible Plastic -  Double Walled Double WalledFRP -  Double Walled Double Walled'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double WalledFlexible Plastic Double WalledFlexible Plastic NoneSteel None'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double WalledSteel Double Walled'::text, 'Fiberglass Reinforced Plastic Double WalledFiberglass Reinforced Plastic Secondary Containment'::text, 'Fiberglass Reinforced Plastic Double WalledSteel Double Walled'::text, 'Above Ground NoneFiberglass Reinforced Plastic Double WalledSteel Double Walled'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (f."Active Pipes Construction" = ANY (ARRAY['Steel None'::text, 'Steel Exempt'::text, 'Steel Double Walled'::text, 'Steel Secondary Containment'::text, 'Flexible Plastic Double WalledSteel Double Walled'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double WalledFlexible Plastic Double WalledFlexible Plastic NoneSteel None'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double WalledSteel Double Walled'::text, 'Steel Pipe within Chase Double Walled'::text, 'Fiberglass Reinforced Plastic Double WalledSteel Double Walled'::text, 'Above Ground NoneFiberglass Reinforced Plastic Double WalledSteel Double Walled'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (f."Active Pipes Construction" = ANY (ARRAY['Flexible Plastic Double Walled'::text, 'Flexible Plastic -  Double Walled Double Walled'::text, 'Flexible Plastic None'::text, 'Flexible Plastic Secondary Containment'::text, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double Walled'::text, 'Fiberglass Reinforced Plastic Double WalledFlexible Plastic -  Double Walled Double Walled'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double Walled'::text, 'Flexible Plastic Double WalledFlexible Plastic None'::text, 'Fiberglass Reinforced Plastic Double WalledFlexible Plastic Double Walled'::text, 'Flexible Plastic -  Double Walled Secondary Containment'::text, 'Flexible Plastic -  Double Walled NoneFlexible Plastic -  Double Walled Secondary Containment'::text, 'Flexible Plastic -  Double Walled NoneFlexible Plastic Double Walled'::text, 'Flexible Plastic -  Double Walled None'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic None'::text, 'Flexible Plastic Double WalledFRP -  Double Walled Double Walled'::text, 'Fiberglass Reinforced Plastic Double WalledFiberglass Reinforced Plastic NoneFlexible Plastic Double Walled'::text, 'Flexible Plastic - Single Walled Double Walled'::text, 'Flexible Plastic -  Double Walled NoneFlexible Plastic - Single Walled None'::text, 'Fiberglass Reinforced Plastic Secondary ContainmentFlexible Plastic Double Walled'::text, 'Flexible Plastic Double WalledSteel Double Walled'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic Double Walled'::text, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic - Single Walled Double Walled'::text, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled None'::text, 'Flexible Plastic -  Double Walled Double WalledFRP -  Double Walled Double Walled'::text, 'Flexible Plastic - Single Walled None'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double WalledFlexible Plastic Double WalledFlexible Plastic NoneSteel None'::text, 'Fiberglass Reinforced Plastic NoneFlexible Plastic -  Double Walled Double WalledSteel Double Walled'::text, 'Flexible Plastic - Single Walled Double WalledFlexible Plastic - Single Walled Secondary Containment'::text, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled Secondary Containment'::text, 'Flexible Plastic NoneFlexible Plastic Secondary Containment'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (f."Active Pipes Construction" = ANY (ARRAY['Above Ground ExemptAbove Ground NoneFiberglass Reinforced Plastic Exempt'::text, 'Above Ground Exempt'::text, 'Above Ground None'::text, 'No Piping None'::text, 'Above Ground NoneFiberglass Reinforced Plastic Double WalledSteel Double Walled'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
    wt.piping_wall_type_id
   FROM (((((wv_ust.erg_piping_id x
     JOIN wv_ust.v_erg_facility p ON (((p."Facility Id")::text = (x.facility_id)::text)))
     LEFT JOIN wv_ust."AllFacilitiesDetails" f ON (((x.facility_id)::text = (f."Facility Id")::text)))
     LEFT JOIN wv_ust."USTTanksPublic" t ON (((x.facility_id)::text = (t."Facility#")::text)))
     LEFT JOIN wv_ust.v_piping_style_xwalk ps ON ((f."Active Pipes Construction" = (ps.organization_value)::text)))
     LEFT JOIN wv_ust.v_piping_wall_type_xwalk wt ON ((f."Active Pipes Construction" = (wt.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_facilities unregparent
          WHERE (((p."Facility Id")::character varying(50))::text = (unregparent.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((p."Facility Id")::character varying(50))::text = (unreg.facility_id)::text) AND (x.tank_id = unreg.tank_id))))));;

