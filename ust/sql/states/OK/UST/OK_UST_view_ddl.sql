


/*********** v_ust_facility ***********/


--View definition for ok_ust.v_ust_facility:
 SELECT DISTINCT (a.facility_id)::character varying(50) AS facility_id,
    (a."Name")::character varying(100) AS facility_name,
    e.owner_type_id,
    d.facility_type_id AS facility_type1,
    (a."Address")::character varying(100) AS facility_address1,
    (a."Address2")::character varying(100) AS facility_address2,
    (a."City")::character varying(100) AS facility_city,
    (a."Zip")::character varying(10) AS facility_zip_code,
        CASE
            WHEN (a."Trust land" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS facility_tribal_site,
    (a."Tribe")::character varying(200) AS facility_tribe,
    a."Latitude" AS facility_latitude,
    a."Longitude" AS facility_longitude,
    (y."Name")::character varying(100) AS facility_owner_company_name,
    'OK'::text AS facility_state,
    6 AS facility_epa_region
   FROM ((((ok_ust."OK_UST_Facility_Data" a
     LEFT JOIN ok_ust.v_facility_type_xwalk d ON ((a."Type" = (d.organization_value)::text)))
     LEFT JOIN ok_ust."OK_UST_Owner_Data" y ON ((a."OwnerID" = y."Owner ID")))
     LEFT JOIN ok_ust.v_owner_type_xwalk e ON ((
        CASE
            WHEN ((y."Type" = 'State'::text) AND (a."Type" = 'Federal Military'::text)) THEN 'Military'::text
            ELSE a."Type"
        END = (e.organization_value)::text)))
     JOIN ok_ust.erg_compartments_deduplicated z ON ((a.facility_id = z."FacilityID")))
  WHERE (NOT (((a.facility_id)::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM ok_ust.erg_unregulated_facilities)));;




/*********** v_ust_tank ***********/


--View definition for ok_ust.v_ust_tank:
 SELECT DISTINCT (a.tank_name)::integer AS tank_id,
    (a."FacilityID")::character varying(50) AS facility_id,
    d.tank_status_id,
        CASE
            WHEN (a."Manifold" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS multiple_tanks,
        CASE
            WHEN (a."Status" = ANY (ARRAY['CIU'::text, 'Xfer'::text, 'TOU'::text])) THEN NULL::date
            ELSE (a."ClosedDate")::date
        END AS tank_closure_date,
    (a."InstalledDate")::date AS tank_installation_date,
        CASE
            WHEN (a."Compartments" <> ALL (ARRAY['0'::bigint, '1'::bigint])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    (a."Compartments")::integer AS number_of_compartments,
    b.tank_material_description_id,
    c.tank_secondary_containment_id
   FROM (((((ok_ust."OK_UST_Data" a
     LEFT JOIN ok_ust.v_tank_material_description_xwalk b ON ((a."Tank Material" = (b.organization_value)::text)))
     LEFT JOIN ok_ust.v_tank_secondary_containment_xwalk c ON ((a."Tank Construction" = (c.organization_value)::text)))
     LEFT JOIN ok_ust.v_tank_status_xwalk d ON ((a."Status" = (d.organization_value)::text)))
     JOIN ok_ust."OK_UST_Facility_Data" z ON ((z.facility_id = a."FacilityID")))
     JOIN ok_ust.erg_compartments_deduplicated y ON ((y."FacilityID" = a."FacilityID")))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a.tank_name)::integer = unreg.tank_id)))));;




/*********** v_ust_tank_substance ***********/


--View definition for ok_ust.v_ust_tank_substance:
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankNumber")::integer AS tank_id,
    c.substance_id
   FROM (ok_ust.erg_compartments_deduplicated a
     JOIN ok_ust.v_substance_xwalk c ON ((a."Substance" = (c.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankNumber")::integer = unreg.tank_id)))));;




/*********** v_ust_compartment ***********/


--View definition for ok_ust.v_ust_compartment:
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankNumber")::integer AS tank_id,
    (a."CompartmentNumber")::integer AS compartment_id,
    b.compartment_status_id,
    (a."Capacity")::integer AS compartment_capacity_gallons
   FROM (ok_ust.erg_compartments_deduplicated a
     LEFT JOIN ok_ust.v_compartment_status_xwalk b ON ((a."CompartmentStatus" = (b.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankNumber")::integer = unreg.tank_id)))));;




/*********** v_ust_compartment_substance ***********/


--View definition for ok_ust.v_ust_compartment_substance:
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankNumber")::integer AS tank_id,
    (a."CompartmentNumber")::integer AS compartment_id,
    b.substance_id
   FROM (ok_ust.erg_compartments_deduplicated a
     LEFT JOIN ok_ust.v_substance_xwalk b ON ((a."Substance" = (b.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankNumber")::integer = unreg.tank_id)))));;

