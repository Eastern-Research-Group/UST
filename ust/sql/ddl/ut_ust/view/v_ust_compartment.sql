create or replace view "ut_ust"."v_ust_compartment" as
 SELECT DISTINCT (y.facility_id)::character varying(50) AS facility_id,
    (x.tank_id)::integer AS tank_id,
    y.compartment_id,
    vtsx.compartment_status_id,
    (x."TANKCAPACI")::integer AS compartment_capacity_gallons
   FROM ((ut_ust.ut_tank x
     JOIN ut_ust.erg_compartment y ON (((y.facility_id = (x.facility_id)::integer) AND (y.tank_id = x.tank_id))))
     LEFT JOIN ut_ust.v_compartment_status_xwalk vtsx ON (((vtsx.organization_value)::text = TRIM(BOTH FROM ((x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text))))))
  WHERE ((x."FEDERALREG" = 'Yes'::text) AND (x."TANKSTATUS" <> 'Install in Process'::text) AND (x.facility_id IN ( SELECT y_1.facility_id
           FROM ut_ust.ut_facility y_1
          WHERE ((y_1."TANK" = 1) AND (y_1."OPENREGAST" = 0) AND (y_1."REGAST" = 0)))));