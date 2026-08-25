


/*********** v_ust_tank ***********/
--There are 0 rows in ma_ust.v_ust_tank that do not exist in public.v_ust_tank

select * from ma_ust.v_ust_tank a
where not exists
	(select 1 from public.v_ust_tank b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID")
order by a.facility_id,a.tank_id;

--View definition for ma_ust.v_ust_tank:
 SELECT DISTINCT (a."Facility ID#")::character varying(50) AS facility_id,
    (a."TANK ID#")::integer AS tank_id,
    d.tank_status_id,
        CASE
            WHEN (a."STATUS" = 'Tank Closure In-Place'::text) THEN (a."STATUS DATE")::date
            ELSE NULL::date
        END AS tank_closure_date,
    (a."INSTALL DATE")::date AS tank_installation_date,
        CASE
            WHEN (a."NUMBER OF COMPARTMENT" > (1)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    (a."NUMBER OF COMPARTMENT")::integer AS number_of_compartments,
    b.tank_material_description_id,
        CASE
            WHEN (a."TANK CORROSION TYPE" = ANY (ARRAY['Manufactured Sacrificial Anode (Galvanic) System'::text, 'Field Constructed Sacrificial Anode (Galvanic) System'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (a."TANK CORROSION TYPE" = 'Field Constructed Impressed Current System'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (a."TANK CONSTRUCT" ~~ '%cathodic protection not required%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_cathodic_not_required,
    c.tank_secondary_containment_id
   FROM (((ma_ust."Tank info" a
     LEFT JOIN ma_ust.v_tank_material_description_xwalk b ON ((a."TANK CONSTRUCT" = (b.organization_value)::text)))
     LEFT JOIN ma_ust.v_tank_secondary_containment_xwalk c ON ((a."TANK CONSTRUCT" = (c.organization_value)::text)))
     LEFT JOIN ma_ust.v_tank_status_xwalk d ON ((a."STATUS" = (d.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TANK ID#")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE (((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text)))));


/*********** v_ust_tank_substance ***********/
--There are 0 rows in ma_ust.v_ust_tank_substance that do not exist in public.v_ust_tank_substance

select * from ma_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;

--View definition for ma_ust.v_ust_tank_substance:
 SELECT DISTINCT (a."Facility ID#")::character varying(50) AS facility_id,
    (a."TANK ID#")::integer AS tank_id,
    b.substance_id
   FROM (ma_ust."Tank info" a
     JOIN ma_ust.v_substance_xwalk b ON ((a."CONTENT" = (b.organization_value)::text)))
  WHERE ((b.substance_id IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TANK ID#")::integer = unreg.tank_id))))) AND (EXISTS ( SELECT 1
           FROM ma_ust.erg_facility_final x
          WHERE (((a."Facility ID#")::character varying(50))::text = ((x."Facility ID#")::character varying(50))::text))) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE (((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text)))));


/*********** v_ust_tank_substance ***********/
--There are 0 rows in ma_ust.v_ust_tank_substance that do not exist in public.v_ust_tank_substance

select * from ma_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;

--View definition for ma_ust.v_ust_tank_substance:
 SELECT DISTINCT (a."Facility ID#")::character varying(50) AS facility_id,
    (a."TANK ID#")::integer AS tank_id,
    b.substance_id
   FROM (ma_ust."Tank info" a
     JOIN ma_ust.v_substance_xwalk b ON ((a."CONTENT" = (b.organization_value)::text)))
  WHERE ((b.substance_id IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TANK ID#")::integer = unreg.tank_id))))) AND (EXISTS ( SELECT 1
           FROM ma_ust.erg_facility_final x
          WHERE (((a."Facility ID#")::character varying(50))::text = ((x."Facility ID#")::character varying(50))::text))) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE (((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text)))));