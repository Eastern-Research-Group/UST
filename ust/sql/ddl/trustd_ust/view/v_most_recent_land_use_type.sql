create or replace view "trustd_ust"."v_most_recent_land_use_type" as
 SELECT b.land_location_id,
    b.land_use_type_id
   FROM (( SELECT ut_land_use_hist.land_location_id,
            max(COALESCE(ut_land_use_hist.date_observed, '2023-01-01'::text)) AS date_observed
           FROM trustd_ust.ut_land_use_hist
          WHERE (ut_land_use_hist.end_date IS NULL)
          GROUP BY ut_land_use_hist.land_location_id) a
     JOIN trustd_ust.ut_land_use_hist b ON (((a.land_location_id = b.land_location_id) AND (COALESCE(a.date_observed, '2023-01-01'::text) = COALESCE(b.date_observed, '2023-01-01'::text)) AND (b.end_date IS NULL))));