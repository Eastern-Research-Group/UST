create or replace view "oust"."v_erg_lust_perf_meas_analysis" as
 SELECT total.organization_id,
    act."Active",
    nfa."NFA",
    o."Other",
    u."Unknown",
    total."Total"
   FROM ((((( SELECT v_erg_lust_perf_meas_lustids.organization_id,
            count(*) AS "Total"
           FROM oust.v_erg_lust_perf_meas_lustids
          GROUP BY v_erg_lust_perf_meas_lustids.organization_id) total
     LEFT JOIN ( SELECT v_erg_lust_perf_meas_lustids.organization_id,
            count(*) AS "Active"
           FROM oust.v_erg_lust_perf_meas_lustids
          WHERE ((v_erg_lust_perf_meas_lustids."LUSTStatus")::text ~~ 'Active%'::text)
          GROUP BY v_erg_lust_perf_meas_lustids.organization_id) act ON (((total.organization_id)::text = (act.organization_id)::text)))
     LEFT JOIN ( SELECT v_erg_lust_perf_meas_lustids.organization_id,
            count(*) AS "NFA"
           FROM oust.v_erg_lust_perf_meas_lustids
          WHERE ((v_erg_lust_perf_meas_lustids."LUSTStatus")::text = 'No further action'::text)
          GROUP BY v_erg_lust_perf_meas_lustids.organization_id) nfa ON (((total.organization_id)::text = (nfa.organization_id)::text)))
     LEFT JOIN ( SELECT v_erg_lust_perf_meas_lustids.organization_id,
            count(*) AS "Other"
           FROM oust.v_erg_lust_perf_meas_lustids
          WHERE ((v_erg_lust_perf_meas_lustids."LUSTStatus")::text = 'Other'::text)
          GROUP BY v_erg_lust_perf_meas_lustids.organization_id) o ON (((total.organization_id)::text = (o.organization_id)::text)))
     LEFT JOIN ( SELECT v_erg_lust_perf_meas_lustids.organization_id,
            count(*) AS "Unknown"
           FROM oust.v_erg_lust_perf_meas_lustids
          WHERE ((v_erg_lust_perf_meas_lustids."LUSTStatus")::text = 'Unknown'::text)
          GROUP BY v_erg_lust_perf_meas_lustids.organization_id) u ON (((total.organization_id)::text = (u.organization_id)::text)));