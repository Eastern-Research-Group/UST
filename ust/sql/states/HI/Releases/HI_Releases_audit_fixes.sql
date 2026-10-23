-- SOURCE IDENTIFIER FIXES

-- ust_release.zipcode: organization_column_name mapped as "Zip Code" but schema has "ZIP Code"
update public.release_element_mapping
set organization_column_name = 'ZIP Code'
where release_element_mapping_id = 622;

select * from release_control where organization_id = 'HI'

Email on 3-5-2025 from HI with updated data (ustrac-data.mdb)

Exclude rows where "LUSTLatestStatus" = 'Case Transferred to HW (unregulated)'

select * from v_release_mapping 
where release_control_id = 24 
and epa_column_name = 'state';

select * from hi_release."tblLUSTSite"

select * from hi_release."tblFacility"

select * from hi_release."tlkpZIP" 
where "State" not in (select state from states)

select * from hi_release."tlkpZIP"
where "ZIP Code" = '57591'

select  "State", count(*) 
from v_ust_release where release_control_id = 24
group by "State"
	1362
SD	989

select * from v_ust_release where release_control_id = 24
and "State" = 'SD' 

select * from v_ust_release

-- VALUE MAPPING FIXES


select * from v_release_mapping 
where release_control_id = 24 
and epa_column_name = 'facility_type_id'
order by organization_value;


select * from hi_release.erg_unregulated_releases 

Case Transferred to HW (unregulated)


select * from v_release_element_mapping 
where release_control_id = 24 
and epa_column_name = 'release_status_id'
order by organization_value;

select "LUSTLatestStatus", count(*) 
from hi_release."tblLUSTSite"
group by "LUSTLatestStatus" order by 1;

update release_element_value_mapping set exclude_from_query = 'Y'
where release_element_value_mapping_id in (1491,1492,1505)

insert into hi_release.erg_unregulated_releases
select distinct "EventID", 'Release status = ''' ||"LUSTLatestStatus" || ''''
from hi_release."tblLUSTSite"
where "LUSTLatestStatus" in ('Disconfirmed Release','Disconfirmed Release - investigation ongoing')

insert into hi_release.erg_unregulated_releases
select distinct "EventID", 'Release status = ''' ||"LUSTLatestStatus" || ''''
from hi_release."tblLUSTSite"
where "LUSTLatestStatus" = 'Suspected release';

select * from hi_release."tblFacility" where "FacilityID" = 9100276;
57597.0

select * from hi_release."tlkpZIP" where "ZIP ID" = 57597


-- ust_release.state: unmapped value 'AB' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'AB', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'AB', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'AB', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'BC' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'BC', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'BC', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'BC', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'MB' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'MB', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'MB', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'MB', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'MH' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'MH', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'MH', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'MH', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'NB' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NB', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NB', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NB', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'NF' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NF', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NF', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NF', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'NS' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NS', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NS', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NS', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'NT' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NT', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NT', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'NT', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'ON' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'ON', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'ON', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'ON', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'PE' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PE', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PE', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PE', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'PQ' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PQ', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PQ', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PQ', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'PW' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PW', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PW', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'PW', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'SK' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'SK', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'SK', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'SK', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'XX' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'XX', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'XX', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'XX', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.state: unmapped value 'YT' from hi_release."tlkpZIP"."State"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'YT', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'YT', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (624, 'YT', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_release.release_status_id: unmapped value 'Case Transferred to HW (unregulated)' from hi_release."tblLUSTSite"."LUSTLatestStatus"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (629, 'Case Transferred to HW (unregulated)', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
 insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (629, 'Case Transferred to HW (unregulated)', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (629, 'Case Transferred to HW (unregulated)', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');

select * from release_element_value_mapping where release_element_mapping_id = 629
and organization_value

update release_element_value_mapping 
set programmer_comments = 'Exclude per state'
where release_element_value_mapping_id = 1536