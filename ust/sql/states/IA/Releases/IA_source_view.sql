create view ia_release.v_source as
select distinct "LUSTID", source_id
from
(select "LUSTID",
		"SourceOfRelease1" as source_id
from ia_release."Template"  
union all
select 	"LUSTID",
		"SourceOfRelease2" as source_id
from ia_release."Template"
union all
select 	"LUSTID",
		"SourceOfRelease3" as source_id
from ia_release."Template") x
where source_id is not null;