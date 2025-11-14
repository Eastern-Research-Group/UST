create or replace view "sc_ust"."v_release_num" as
 SELECT a.site_num,
    a.release_num
   FROM (sc_release.ustleak_20211013 a
     LEFT JOIN ( SELECT ustleak_20211013.site_num,
            max(ustleak_20211013.release_date) AS release_date
           FROM sc_release.ustleak_20211013
          GROUP BY ustleak_20211013.site_num) b ON (((a.site_num = b.site_num) AND (a.release_date = b.release_date))));