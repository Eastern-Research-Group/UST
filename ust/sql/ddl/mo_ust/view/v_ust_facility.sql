create or replace view "mo_ust"."v_ust_facility" as
 SELECT DISTINCT a.facilityid AS facility_id,
    b."NAME" AS facility_name,
    b.address AS facility_address1,
    b.address2 AS facility_address2,
    b.city AS facility_city,
    c.countyname AS facility_county,
    'MO'::text AS facility_state,
    b.zip AS facility_zip_code,
    d.converted_lat AS facility_latitude,
    d.converted_long AS facility_longitude,
    f."NAME" AS facility_owner_company_name,
        CASE
            WHEN (g.facilityid IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    g.remid AS associated_ust_release_id,
    i.owner_type_id
   FROM ((((((((mo_ust.tblfacility a
     LEFT JOIN mo_ust.tblgeosite b ON (((a.facilityid)::text = (b.facilityid)::text)))
     LEFT JOIN mo_ust.tblcounty c ON ((b.county = c.countycode)))
     LEFT JOIN mo_ust.tblgeosite_latlong d ON (((a.facilityid)::text = (d.facilityid)::text)))
     LEFT JOIN mo_ust.tblfacilitylookup e ON (((a.facilityid)::text = (e.facilityid)::text)))
     LEFT JOIN mo_ust.tblowner f ON (((e.ownerid)::text = (f.ownerid)::text)))
     LEFT JOIN ( SELECT tblremediation.facilityid,
            max((tblremediation.remid)::text) AS remid
           FROM mo_ust.tblremediation
          GROUP BY tblremediation.facilityid) g ON (((a.facilityid)::text = (g.facilityid)::text)))
     LEFT JOIN ( SELECT z.ownerid,
            y.epa_value,
            y.organization_value
           FROM ((mo_ust.tblownerclass x
             JOIN ( SELECT b_1.epa_value,
                    b_1.organization_value
                   FROM (ust_element_mapping a_1
                     JOIN ust_element_value_mapping b_1 ON ((a_1.ust_element_mapping_id = b_1.ust_element_mapping_id)))
                  WHERE ((a_1.ust_control_id = 7) AND ((a_1.epa_table_name)::text = 'owner_types'::text) AND (b_1.epa_value IS NOT NULL))) y ON (((x.ownerdescription)::text = (y.organization_value)::text)))
             JOIN mo_ust.tblownertype z ON (((x.ownercode)::text = (z.ownerclass)::text)))) h ON (((e.ownerid)::text = (h.ownerid)::text)))
     LEFT JOIN owner_types i ON (((h.epa_value)::text = (i.owner_type)::text)));