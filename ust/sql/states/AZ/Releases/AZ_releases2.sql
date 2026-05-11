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

create table 

select distinct "Cause" as cause, "Source" as source, 
	case when "Cause" = 'C: Corrosion' then 'Corrosion' 
	     when "Cause" = 'C: Spill' then 'Delivery problem' 
	     when "Cause" = 'C:Other' then 'Other' 
	     when "Cause" = 'C:Overfill' then 'Overfill (general)' 
	     when "Cause" = 'C:Unknown' then 'Unknown' 
	     when "Cause" = 'C:Vehicle damage' then 'Motor vehicle accident' end as epa_cause
into az_release.erg_cause_mapping 
from 
(select distinct "CauseOfRelease1" as "Cause", "SourceOfRelease1" as "Source" from az_release.ust_release union 
select distinct "CauseOfRelease2", "SourceOfRelease2" from az_release.ust_release union 
select distinct "CauseOfRelease3", "SourceOfRelease3" from az_release.ust_release union 
select distinct "CauseOfRelease4", "SourceOfRelease4" from az_release.ust_release ) x 
where "Cause" not like '%P/M%'
order by 1, 2;

insert into az_release.erg_cause_mapping values ('C:P/M broken','Dispenser','Damage to dispenser');
insert into az_release.erg_cause_mapping values ('C:P/M broken','Other','Other');
insert into az_release.erg_cause_mapping values ('C:P/M broken','Piping','Piping failure');
insert into az_release.erg_cause_mapping values ('C:P/M broken','Tank','Tank damage');
insert into az_release.erg_cause_mapping values ('C:P/M delam','Tank','Tank damage');
insert into az_release.erg_cause_mapping values ('C:P/M puncture','Piping','Piping failure');
insert into az_release.erg_cause_mapping values ('C:P/M puncture','Tank','Tank damage');
insert into az_release.erg_cause_mapping values ('C:P/M puncture','Unknown','Unknown');
insert into az_release.erg_cause_mapping values ('C:P/M split/separa','Other','Other');
insert into az_release.erg_cause_mapping values ('C:P/M split/separa','Piping','Piping failure');
insert into az_release.erg_cause_mapping values ('C:P/M split/separa','Submersible turbine pump','Other');
insert into az_release.erg_cause_mapping values ('C:P/M split/separa','Tank','Tank damage');
insert into az_release.erg_cause_mapping values ('C:P/M swelling','Dispenser','Damage to dispenser');


create view az_release.v_cause_mapping as 
select distinct "LUSTID", cause_comment, epa_cause 
from 
	(select distinct "LUSTID", "CauseOfRelease1" as cause_comment, epa_cause
	from az_release.ust_release a join  az_release.erg_cause_mapping b on a."CauseOfRelease1" = b.cause and a."SourceOfRelease1" = b.source
	where a."CauseOfRelease1" is not null 
	union all
	select distinct "LUSTID", "CauseOfRelease2" as cause_comment, epa_cause
	from az_release.ust_release a join  az_release.erg_cause_mapping b on a."CauseOfRelease2" = b.cause and a."SourceOfRelease2" = b.source
	where a."CauseOfRelease2" is not null 
	union all
	select distinct "LUSTID", "CauseOfRelease3" as cause_comment, epa_cause
	from az_release.ust_release a join  az_release.erg_cause_mapping b on a."CauseOfRelease3" = b.cause and a."SourceOfRelease3" = b.source
	where a."CauseOfRelease3" is not null 
	union all
	select distinct "LUSTID", "CauseOfRelease4" as cause_comment, epa_cause
	from az_release.ust_release a join  az_release.erg_cause_mapping b on a."CauseOfRelease4" = b.cause and a."SourceOfRelease4" = b.source
	where a."CauseOfRelease4" is not null ) x;

select * from  az_release.v_cause_mapping 


select * from release_control 
6


select * from v_release_element_mapping 
where release_control_id = 6
and release_element_mapping_id = 145
;

select * from release_element_mapping where release_element_mapping_id = 143;

update release_element_mapping
set organization_table_name = 'v_cause_mapping', organization_column_name = 'epa_cause',
	programmer_comments = 'Damage-related causes must be mapped to EPA causes by looking at the source; created a crosswalk that was approved by the state, unable to map one-to-one causes'
where release_element_mapping_id = 143;

select * from release_element_value_mapping where release_element_mapping_id = 143;

select * from v_release_element_mapping 
where release_control_id = 6
and release_element_mapping_id = 143

