create or replace view "tn_ust"."v_tank_status" as
 SELECT DISTINCT "TN_UST"."FACILITY_ID",
    "TN_UST"."TANK_ID",
    "TN_UST"."COMPARTMENT_ID",
        CASE
            WHEN ("TN_UST"."HOW_CLOSED" IS NOT NULL) THEN "TN_UST"."HOW_CLOSED"
            ELSE "TN_UST"."COMPARTMENT_STATUS"
        END AS "COMPARTMENT_STATUS"
   FROM tn_ust."TN_UST";