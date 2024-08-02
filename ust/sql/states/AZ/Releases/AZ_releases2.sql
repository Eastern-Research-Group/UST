C:P/M broken	Tank damage
C:P/M delam	Tank damage
C:P/M puncture	Tank damage
C:P/M split/separa	Tank damage
C:P/M swelling	Tank damage

select distinct "Cause", "Source" from 
(select distinct "CauseOfRelease1" as "Cause", "SourceOfRelease1" as "Source" from az_release.ust_release union 
select distinct "CauseOfRelease2", "SourceOfRelease2" from az_release.ust_release union 
select distinct "CauseOfRelease3", "SourceOfRelease3" from az_release.ust_release union 
select distinct "CauseOfRelease4", "SourceOfRelease4" from az_release.ust_release ) x 
where "Cause" like '%P/M%'
order by 1, 2;


select * from substances order by 3, 2;

update substances set federally_regulated = 'N'
where substance_group = 'Heating'


select * from archive.v_ust where organization_id = 'CA' where "NumberOfCompartments" > 1
