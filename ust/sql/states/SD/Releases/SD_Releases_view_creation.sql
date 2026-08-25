----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- No join metadata found for ust_piping; SQL will include placeholders and may need manual edits.
-- Missing mapping for required key release_id in ust_piping; using where 1=1 fallback.
-- No mapped elements found for EPA table ust_piping; generating required placeholders only.
-- Generated SQL failed validation for ust_piping: syntax error at or near "from"
LINE 4: from (select 1) a
        ^


create or replace view sd_release.v_ust_piping as
select distinct

from (select 1) a
where 1=1

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
