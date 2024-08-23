create or replace view "public"."v_release_performance_measures" as
 SELECT a.organization_id,
    a.sort_order,
    a.total_type,
    a.total_cumulative_releases
   FROM ( SELECT 1 AS sort_order,
            performance_measures_release.organization_id,
            'Cumulative Initiated Cleanups'::text AS total_type,
            performance_measures_release.num_cumulative_releases AS total_cumulative_releases
           FROM performance_measures_release
        UNION ALL
         SELECT 2 AS sort_order,
            performance_measures_release.organization_id,
            'Cumulative Completed Cleanups'::text AS total_type,
            performance_measures_release.num_cumulative_initiated_cleanups
           FROM performance_measures_release
        UNION ALL
         SELECT 3 AS sort_order,
            performance_measures_release.organization_id,
            'Cumulative Releases'::text AS total_type,
            performance_measures_release.num_cumulative_completed_cleanups
           FROM performance_measures_release) a;