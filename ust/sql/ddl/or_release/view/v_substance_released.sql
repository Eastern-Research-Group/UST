create or replace view "or_release"."v_substance_released" as
 SELECT y."LustId",
    y."AmountReleased",
    y."SubstanceReleased",
    y.rn
   FROM ( SELECT x."LustId",
            x."AmountReleased",
            x."SubstanceReleased",
            row_number() OVER (PARTITION BY x."LustId" ORDER BY x."SubstanceReleased") AS rn
           FROM ( SELECT a."LustId",
                    a."AmountReleased",
                    b."SubstanceReleased"
                   FROM (or_release."Assessment" a
                     LEFT JOIN ( SELECT "Assessment"."LustId",
                            'Diesel fuel (b-unknown)'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."DSContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Ethanol blend gasoline (e-unknown)'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."UGContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Gasoline (unknown type)'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."MGContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Heating/fuel oil # unknown'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."HOContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Lube/motor oil (new)'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."LBContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Other'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE (("Assessment"."OPContamInd" = true) OR ("Assessment"."CHContamInd" = true) OR ("Assessment"."MTBEContamInd" = true))
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Racing fuel/leaded gasoline'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."LGContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Solvent'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."SVContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Unknown'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."UNContamInd" = true)
                        UNION ALL
                         SELECT "Assessment"."LustId",
                            'Used oil/waste oil'::text AS "SubstanceReleased"
                           FROM or_release."Assessment"
                          WHERE ("Assessment"."WOContamInd" = true)) b ON ((a."LustId" = b."LustId")))) x) y
  WHERE (y.rn <= 5);