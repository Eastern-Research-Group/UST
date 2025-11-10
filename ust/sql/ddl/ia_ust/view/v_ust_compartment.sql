create or replace view "ia_ust"."v_ust_compartment" as
 SELECT DISTINCT (t."ustID")::text AS facility_id,
    (t."tankID")::integer AS tank_id,
    (c."tankCompartmentID")::integer AS compartment_id,
        CASE
            WHEN (csx.compartment_status_id IS NULL) THEN 8
            ELSE csx.compartment_status_id
        END AS compartment_status_id,
    (c.capacity)::integer AS compartment_capacity_gallons,
        CASE
            WHEN (flowshutoff."spillOverfillID" = 2) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (highlevel."spillOverfillID" = 3) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN ((overfillother."spillOverfillID" <> ALL (ARRAY[(2)::bigint, (3)::bigint])) AND (overfillother."spillOverfillID" IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN ((c."catchmentBasin" = (1)::double precision) OR (c."catchmentBasinSize" > (0)::double precision)) THEN 'Yes'::text
            WHEN (c."catchmentBasin" = (0)::double precision) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (c."spillProtection" = (1)::double precision) THEN 'No'::text
            WHEN (c."spillProtection" = (0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_prevention_not_required,
    sb.spill_bucket_wall_type_id,
        CASE
            WHEN (c."InterstitialMonitoring" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (continuousleak."leakProtectionID" = 11) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (manualgauge."leakProtectionID" = 9) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (statinventory."leakProtectionID" = 8) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (tightnesstest."leakProtectionID" = 7) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (inventorycont."leakProtectionID" = 12) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (groundwater."leakProtectionID" = 2) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (vapor."leakProtectionID" = 1) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN ((releaseother."leakProtectionID" <> ALL (ARRAY[(1)::bigint, (2)::bigint, (12)::bigint, (7)::bigint, (8)::bigint, (9)::bigint, (11)::bigint])) AND (releaseother."leakProtectionID" IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM (((((((((((((((ia_ust.tbltankcompartment c
     LEFT JOIN ia_ust.tbltank t ON ((t."tankID" = c."tankID")))
     LEFT JOIN ( SELECT tcs."tankCompartmentID",
            cs."statusDescription",
            tcs."statusStartDate"
           FROM (ia_ust.trelcomptostatus tcs
             JOIN ia_ust.tlkcompstatus cs ON ((tcs."compStatusID" = cs."compStatusID")))
          WHERE (tcs."statusEndDate" IS NULL)) sts ON ((sts."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ia_ust.v_compartment_status_xwalk csx ON ((sts."statusDescription" = (csx.organization_value)::text)))
     LEFT JOIN ( SELECT so."spillOverfillID",
            so."tankCompartmentID"
           FROM ia_ust.trelcomptospilloverfill so
          WHERE (so."spillOverfillID" = 2)) flowshutoff ON ((flowshutoff."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT so."spillOverfillID",
            so."tankCompartmentID"
           FROM ia_ust.trelcomptospilloverfill so
          WHERE (so."spillOverfillID" = 3)) highlevel ON ((highlevel."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT so."spillOverfillID",
            so."tankCompartmentID"
           FROM ia_ust.trelcomptospilloverfill so
          WHERE ((so."spillOverfillID" <> ALL (ARRAY[(2)::bigint, (3)::bigint])) AND (so."spillOverfillID" IS NOT NULL))) overfillother ON ((overfillother."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ia_ust.v_spill_bucket_wall_type_xwalk sb ON ((c."Wall" = (sb.organization_value)::text)))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE (cl."leakProtectionID" = 11)) continuousleak ON ((continuousleak."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE (cl."leakProtectionID" = 9)) manualgauge ON ((manualgauge."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE (cl."leakProtectionID" = 8)) statinventory ON ((statinventory."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE (cl."leakProtectionID" = 7)) tightnesstest ON ((tightnesstest."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE (cl."leakProtectionID" = 12)) inventorycont ON ((inventorycont."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE (cl."leakProtectionID" = 2)) groundwater ON ((groundwater."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE (cl."leakProtectionID" = 1)) vapor ON ((vapor."tankCompartmentID" = c."tankCompartmentID")))
     LEFT JOIN ( SELECT cl."leakProtectionID",
            cl."tankCompartmentID"
           FROM ia_ust.trelcomptoleakprotectio cl
          WHERE ((cl."leakProtectionID" <> ALL (ARRAY[(1)::bigint, (2)::bigint, (12)::bigint, (7)::bigint, (8)::bigint, (9)::bigint, (11)::bigint])) AND (cl."leakProtectionID" IS NOT NULL))) releaseother ON ((releaseother."tankCompartmentID" = c."tankCompartmentID")))
  WHERE (c."tankCompartmentID" IS NOT NULL);