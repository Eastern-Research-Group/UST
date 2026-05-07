create or replace view "ia_release"."v_substance_released" as
 SELECT DISTINCT x."LUSTID",
    x.substance_released,
    x.quantity_released,
    x.unit
   FROM ( SELECT "Template"."LUSTID",
            "Template"."SubstanceReleased1" AS substance_released,
            "Template"."QuantityReleased1" AS quantity_released,
            "Template"."Unit1" AS unit
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."SubstanceReleased2" AS substance_released,
            "Template"."QuantityReleased2" AS quantity_released,
            "Template"."Unit2" AS unit
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."SubstanceReleased3" AS substance_released,
            "Template"."AmountReleased3" AS quantity_released,
            "Template"."Unit3" AS unit
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."SubstanceReleased4" AS substance_released,
            "Template"."AmountReleased4" AS quantity_released,
            "Template"."Unit4" AS unit
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."SubstanceReleased5" AS substance_released,
            "Template"."AmountReleased5" AS quantity_released,
            "Template"."Unit5" AS unit
           FROM ia_release."Template") x
  WHERE (x.substance_released IS NOT NULL);