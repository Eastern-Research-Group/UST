


/*********** v_ust_compartment_substance ***********/
--There are 80 rows in ok_ust.v_ust_compartment_substance that do not exist in public.v_ust_compartment_substance

select * from ok_ust.v_ust_compartment_substance a
where not exists
	(select 1 from public.v_ust_compartment_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.compartment_id,a.substance_id;

--View definition for ok_ust.v_ust_compartment_substance:
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankNumber")::integer AS tank_id,
    (a."CompartmentNumber")::integer AS compartment_id,
    b.substance_id
   FROM (ok_ust.erg_compartments_deduplicated a
     LEFT JOIN ok_ust.v_substance_xwalk b ON ((a."Substance" = (b.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankNumber")::integer = unreg.tank_id)))));