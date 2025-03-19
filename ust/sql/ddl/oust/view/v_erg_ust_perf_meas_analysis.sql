create or replace view "oust"."v_erg_ust_perf_meas_analysis" as
 SELECT a.organization_id,
    a."Active",
    c."Closed",
    o."Other",
    u."Unknown",
    t."Total"
   FROM ((((( SELECT aa.organization_id,
            count(*) AS "Active"
           FROM ( SELECT DISTINCT v_ust.organization_id,
                    v_ust.ust_facilities_id,
                    v_ust."TankID",
                    v_ust."CompartmentID"
                   FROM archive.v_ust
                  WHERE ((v_ust."TankStatus")::text = ANY ((ARRAY['Currently in use'::character varying, 'Temporarily out of service'::character varying, 'Abandoned'::character varying])::text[]))) aa
          GROUP BY aa.organization_id) a
     LEFT JOIN ( SELECT cc.organization_id,
            count(*) AS "Closed"
           FROM ( SELECT DISTINCT v_ust.organization_id,
                    v_ust.ust_facilities_id,
                    v_ust."TankID",
                    v_ust."CompartmentID"
                   FROM archive.v_ust
                  WHERE ((v_ust."TankStatus")::text ~~ 'Closed%'::text)) cc
          GROUP BY cc.organization_id) c ON (((a.organization_id)::text = (c.organization_id)::text)))
     LEFT JOIN ( SELECT oo.organization_id,
            count(*) AS "Other"
           FROM ( SELECT DISTINCT v_ust.organization_id,
                    v_ust.ust_facilities_id,
                    v_ust."TankID",
                    v_ust."CompartmentID"
                   FROM archive.v_ust
                  WHERE ((v_ust."TankStatus")::text = 'Other'::text)) oo
          GROUP BY oo.organization_id) o ON (((a.organization_id)::text = (o.organization_id)::text)))
     LEFT JOIN ( SELECT uu.organization_id,
            count(*) AS "Unknown"
           FROM ( SELECT DISTINCT v_ust.organization_id,
                    v_ust.ust_facilities_id,
                    v_ust."TankID",
                    v_ust."CompartmentID"
                   FROM archive.v_ust
                  WHERE ((v_ust."TankStatus")::text = 'Unknown'::text)) uu
          GROUP BY uu.organization_id) u ON (((a.organization_id)::text = (u.organization_id)::text)))
     LEFT JOIN ( SELECT tt.organization_id,
            count(*) AS "Total"
           FROM ( SELECT DISTINCT v_ust.organization_id,
                    v_ust.ust_facilities_id,
                    v_ust."TankID",
                    v_ust."CompartmentID"
                   FROM archive.v_ust) tt
          GROUP BY tt.organization_id) t ON (((a.organization_id)::text = (t.organization_id)::text)));