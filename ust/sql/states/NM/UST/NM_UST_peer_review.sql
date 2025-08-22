


/*********** v_ust_tank_substance ***********/
--There are 4 rows in nm_ust.v_ust_tank_substance that do not exist in public.v_ust_tank_substance

select * from nm_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;

--View definition for nm_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."FACILITY_ID")::character varying AS facility_id,
    (x."TANK_ID")::integer AS tank_id,
    s.substance_id
   FROM ((nm_ust."Info" x
     LEFT JOIN nm_ust.v_erg_contents c ON (((x."TANK_ID")::double precision = c."TANK_ID")))
     LEFT JOIN nm_ust.v_substance_xwalk s ON ((c."TANK_DETAIL_DESCRIPTION" = (s.organization_value)::text)))
  WHERE (s.substance_id IS NOT NULL);