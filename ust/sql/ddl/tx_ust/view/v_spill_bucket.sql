create or replace view "tx_ust"."v_spill_bucket" as
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    c.compartment_id,
        CASE
            WHEN (((c.sp_tight_fill_container_bucket_sump)::text = 'Y'::text) OR ((c.sp_factory_container_bucket_sump)::text = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "SpillBucketInstalled"
   FROM tx_ust.compartments c;