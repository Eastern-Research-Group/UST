create or replace view "trustd_release"."v_lust_base" as
 SELECT DISTINCT (r.land_location_id)::text AS "FacilityID",
    ts.tank_name AS "TankIDAssociatedwithRelease",
    (r.release_id)::text AS "LUSTID",
    ll.location_name AS "SiteName",
    "left"(ll.address_1, 100) AS "SiteAddress",
    ll.address_2 AS "SiteAddress2",
    ll.city AS "SiteCity",
    (ll.zip)::text AS "Zipcode",
    ll.county AS "County",
    ll.state AS "State",
        CASE
            WHEN (rg.region_key ~~ 'R%'::text) THEN (replace(rg.region_key, 'R'::text, ''::text))::integer
            ELSE NULL::integer
        END AS "EPARegion",
        CASE
            WHEN ((ll.tribe_owned = ANY (ARRAY['True'::text, 'TRUE'::text, 'Y'::text])) OR (ll.tribe_id IS NOT NULL)) THEN 'Yes'::text
            WHEN (ll.tribe_owned = ANY (ARRAY['False'::text, 'FALSE'::text, 'N'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS "FacilityTribalSite",
        CASE
            WHEN ((ll.tribe IS NOT NULL) AND (t.current_name IS NULL)) THEN "left"(ll.tribe, 200)
            WHEN (t.current_name IS NOT NULL) THEN "left"(t.current_name, 200)
            ELSE NULL::text
        END AS "FacilityTribe",
    ll.latitude AS "Latitude",
    ll.longitude AS "Longitude",
    cs.epa_value AS "CoordinateSource",
    ls.epa_value AS "LUSTStatus",
    (reo.event_date)::date AS "ReportedDate",
        CASE
            WHEN ((ls.epa_value)::text = 'No further action'::text) THEN (re.event_date)::date
            ELSE NULL::date
        END AS "NFADate",
    mis.epa_value AS "MediaImpactedSoil",
    mig.epa_value AS "MediaImpactedGroundwater",
    misw.epa_value AS "MediaImpactedSurfaceWater",
    sr1.epa_value AS "SubstanceReleased1",
    sr1.epa_value AS "SubstanceReleased2",
    sr1.epa_value AS "SubstanceReleased3",
    cr1.epa_value AS "CauseOfRelease1",
    cr2.epa_value AS "CauseOfRelease2",
    cr3.epa_value AS "CauseOfRelease3",
    cwc.epa_value AS "ClosedWithContamination"
   FROM ((((((((((((((((((trustd_ust.ut_release r
     LEFT JOIN trustd_ust.ut_tank_system ts ON ((r.tank_system_id = (ts.tank_system_id)::double precision)))
     LEFT JOIN trustd_ust.ut_land_location ll ON ((r.land_location_id = ll.land_location_id)))
     LEFT JOIN trustd_ust.st_regions rg ON ((ll.region_id = rg.region_id)))
     LEFT JOIN trustd_ust.ut_tribes t ON ((ll.tribe_id = (t.tribe_id)::double precision)))
     LEFT JOIN trustd_release.v_ut_release_event re ON ((r.release_id = re.release_id)))
     LEFT JOIN trustd_release.v_ut_release_event_orig reo ON ((r.release_id = reo.release_id)))
     LEFT JOIN ( SELECT v_lust_element_mapping.state_value,
            v_lust_element_mapping.epa_value
           FROM archive.v_lust_element_mapping
          WHERE ((v_lust_element_mapping.control_id = 12) AND ((v_lust_element_mapping.element_name)::text = 'CoordinateSource'::text))) cs ON ((ll.lat_lon_source = (cs.state_value)::text)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_release_event_type b ON (((a.state_value)::text = b.release_event_desc)))
             JOIN trustd_release.v_ut_release_event c ON (((b.release_event_type_id)::double precision = c.release_event_type_id)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'LUSTStatus'::text))) ls ON ((r.release_id = ls.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_impacted_media_type b ON (((a.state_value)::text = b.ut_impacted_media_desc)))
             JOIN trustd_release.v_impacted_media c ON ((b.ut_impacted_media_type_id = (c.ut_impacted_media_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'MediaImpactedSoil'::text))) mis ON ((r.release_id = mis.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_impacted_media_type b ON (((a.state_value)::text = b.ut_impacted_media_desc)))
             JOIN trustd_release.v_impacted_media c ON ((b.ut_impacted_media_type_id = (c.ut_impacted_media_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'MediaImpactedGroundwater'::text))) mig ON ((r.release_id = mig.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_impacted_media_type b ON (((a.state_value)::text = b.ut_impacted_media_desc)))
             JOIN trustd_release.v_impacted_media c ON ((b.ut_impacted_media_type_id = (c.ut_impacted_media_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'MediaImpactedSurfaceWater'::text))) misw ON ((r.release_id = misw.release_id)))
     LEFT JOIN ( SELECT v_lust_element_mapping.state_value,
            v_lust_element_mapping.epa_value
           FROM archive.v_lust_element_mapping
          WHERE ((v_lust_element_mapping.control_id = 12) AND ((v_lust_element_mapping.element_name)::text = 'ClosedWithContamination'::text))) cwc ON ((r.closed_resid_contam = (cwc.state_value)::text)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_substance_type b ON (((a.state_value)::text = b.ut_substance_desc)))
             JOIN trustd_release.v_product_type_released c ON ((b.ut_substance_type_id = (c.ut_substance_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'SubstanceReleased1'::text) AND (c.rn = 1))) sr1 ON ((r.release_id = sr1.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_substance_type b ON (((a.state_value)::text = b.ut_substance_desc)))
             JOIN trustd_release.v_product_type_released c ON ((b.ut_substance_type_id = (c.ut_substance_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'SubstanceReleased2'::text) AND (c.rn = 2))) sr2 ON ((r.release_id = sr2.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_substance_type b ON (((a.state_value)::text = b.ut_substance_desc)))
             JOIN trustd_release.v_product_type_released c ON ((b.ut_substance_type_id = (c.ut_substance_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'SubstanceReleased3'::text) AND (c.rn = 3))) sr3 ON ((r.release_id = sr3.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_suspected_cause_type b ON (((a.state_value)::text = b.ut_suspected_cause_desc)))
             JOIN trustd_release.v_suspected_causes c ON ((b.ut_suspected_cause_type_id = (c.ut_suspected_cause_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'CauseOfRelease1'::text) AND (c.rn = 1))) cr1 ON ((r.release_id = cr1.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_suspected_cause_type b ON (((a.state_value)::text = b.ut_suspected_cause_desc)))
             JOIN trustd_release.v_suspected_causes c ON ((b.ut_suspected_cause_type_id = (c.ut_suspected_cause_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'CauseOfRelease2'::text) AND (c.rn = 2))) cr2 ON ((r.release_id = cr2.release_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.release_id
           FROM ((archive.v_lust_element_mapping a
             JOIN trustd_ust.ut_suspected_cause_type b ON (((a.state_value)::text = b.ut_suspected_cause_desc)))
             JOIN trustd_release.v_suspected_causes c ON ((b.ut_suspected_cause_type_id = (c.ut_suspected_cause_type_id)::integer)))
          WHERE ((a.control_id = 12) AND ((a.element_name)::text = 'CauseOfRelease3'::text) AND (c.rn = 3))) cr3 ON ((r.release_id = cr3.release_id)))
  WHERE ((EXISTS ( SELECT 1
           FROM trustd_ust.ut_release_event re_1
          WHERE ((r.release_id = re_1.release_id) AND (re_1.release_event_type_id = (2)::double precision)))) AND (NOT (EXISTS ( SELECT 1
           FROM trustd_ust.ut_release_event re_1
          WHERE ((r.release_id = re_1.release_id) AND (re_1.release_event_type_id = (6)::double precision))))));