create view ia_release.v_cause as
select distinct "LUSTID", cause_id
from
(select "LUSTID",
		"CauseOfRelease1" as cause_id
from ia_release."Template"  
union all
select 	"LUSTID",
		"CauseOfRelease2" as cause_id
from ia_release."Template"
union all
select 	"LUSTID",
		"CauseOfRelease3" as cause_id
from ia_release."Template") x
where cause_id is not null;