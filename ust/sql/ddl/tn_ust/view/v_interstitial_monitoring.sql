create or replace view "tn_ust"."v_interstitial_monitoring" as
 SELECT DISTINCT "TN_UST"."FACILITY_ID",
    "TN_UST"."TANK_ID",
    "TN_UST"."COMPARTMENT_ID",
    "TN_UST"."LARGE_LEAK_RD",
    "TN_UST"."COMPARTMENT_RD",
    'Interstitial Monitoring'::text AS interstitial_monitoring
   FROM tn_ust."TN_UST"
  WHERE (("TN_UST"."LARGE_LEAK_RD" = 'Interstitial Monitoring for Piping'::text) OR ("TN_UST"."COMPARTMENT_RD" = 'Interstitial Monitoring'::text));