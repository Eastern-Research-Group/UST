create or replace view "az_release"."v_substances" as
 SELECT DISTINCT x.release_id,
    x.substance,
    x.quantity_released,
    x.unit
   FROM ( SELECT DISTINCT ust_release."LUSTID" AS release_id,
            ust_release."SubstanceReleased1" AS substance,
            ust_release."QuantityReleased1" AS quantity_released,
            ust_release."Unit1" AS unit
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased1" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."LUSTID" AS release_id,
            ust_release."SubstanceReleased2" AS substance,
            ust_release."QuantityReleased2" AS quantity_released,
            ust_release."Unit2" AS unit
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased2" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."LUSTID" AS release_id,
            ust_release."SubstanceReleased3" AS substance,
            ust_release."QuantityReleased3" AS quantity_released,
            ust_release."Unit3" AS unit
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased3" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."LUSTID" AS release_id,
            ust_release."SubstanceReleased4" AS substance,
            ust_release."QuantityReleased4" AS quantity_released,
            ust_release."Unit4" AS unit
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased4" IS NOT NULL)) x;