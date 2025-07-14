------------------------------------------------------------------------------------------------------------------------



/*********** v_ust_compartment_substance ***********/
--There are 2 rows in gu_ust.v_ust_compartment_substance that do not exist in public.v_ust_compartment_substance

select * from gu_ust.v_ust_compartment_substance a
where not exists
	(select 1 from public.v_ust_compartment_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.compartment_id,a.substance_id;

--View definition for gu_ust.v_ust_compartment_substance:
 SELECT DISTINCT TRIM(BOTH FROM x."FacilityID") AS facility_id,
    x."TankID" AS tank_id,
    c.compartment_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM ((gu_ust."Compartment" x
     LEFT JOIN gu_ust.erg_compartment_id c ON (((TRIM(BOTH FROM x."FacilityID") = TRIM(BOTH FROM c.facility_id)) AND ((x."TankID")::integer = c.tank_id))))
     LEFT JOIN gu_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));