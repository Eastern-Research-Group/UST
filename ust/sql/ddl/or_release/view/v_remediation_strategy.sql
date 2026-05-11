create or replace view "or_release"."v_remediation_strategy" as
 SELECT a."LustId",
    a."RemediationStrategyStartDate",
    a."RemediationStrategy",
    row_number() OVER (PARTITION BY a."LustId" ORDER BY a."RemediationStrategyStartDate") AS rn
   FROM ( SELECT b."LustId",
            min(b."RemediationStrategyStartDate") AS "RemediationStrategyStartDate",
            b."RemediationStrategy"
           FROM ( SELECT wr."LustId",
                    wr."WorkReportedDate" AS "RemediationStrategyStartDate",
                        CASE
                            WHEN (wrt."WorkTypeCode" = 'GWTRT'::text) THEN 'In-Situ Groundwater Remediation'::text
                            WHEN (wrt."WorkTypeCode" = 'SOILEX'::text) THEN 'Excavation and Hauling'::text
                            ELSE 'Other'::text
                        END AS "RemediationStrategy"
                   FROM (or_release."WorkReported" wr
                     JOIN or_release."WorkReportedType" wrt ON ((wr."WorkReportedTypeId" = wrt."WorkTypeId")))
                  WHERE (wrt."WorkTypeCode" = ANY (ARRAY['AS/VE'::text, 'GWTRT'::text, 'HOTG'::text, 'SLMAT'::text, 'SOILEX'::text, 'SOILTR'::text]))) b
          GROUP BY b."LustId", b."RemediationStrategy") a;