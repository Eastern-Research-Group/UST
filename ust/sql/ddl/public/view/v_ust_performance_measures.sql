create or replace view "public"."v_ust_performance_measures" as
 SELECT a.organization_id,
    a.sort_order,
    a.total_type,
    a.total_ust
   FROM ( SELECT 1 AS sort_order,
            performance_measures_ust.organization_id,
            'Active UST'::text AS total_type,
            performance_measures_ust.total_active_ust AS total_ust
           FROM performance_measures_ust
        UNION ALL
         SELECT 2,
            performance_measures_ust.organization_id,
            'Closed UST'::text AS total_type,
            performance_measures_ust.total_closed_ust AS total_ust
           FROM performance_measures_ust
        UNION ALL
         SELECT 3,
            performance_measures_ust.organization_id,
            'Total UST'::text AS total_type,
            performance_measures_ust.total_ust
           FROM performance_measures_ust) a;